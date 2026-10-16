// "Open in sioyek": the app macOS hands PDFs to, instead of sioyek itself.
//
// Why it exists (2026-10-16): sioyek runs as a fullscreen window, which on
// macOS lives in its own Space. When Finder, a Dock stack, `open x.pdf` or
// nvim hands sioyek a file, LaunchServices marks sioyek active but does not
// switch to that Space, so the PDF opens out of sight. sioyek does nothing
// about it (pdf_viewer/main.cpp: the QFileOpenEvent path never calls
// focus_on_widget) and since macOS 14 a background app cannot pull itself
// forward anyway. An AppleScript `activate` sent to sioyek does switch, so
// this shim passes the files on and then sends exactly that.
//
// Measured 2026-10-16 from inside this (LaunchServices-launched) app:
// NSWorkspace.open ~15-33 ms (a spawned `/usr/bin/open` was ~65);
// AppleScript activate ~20 ms once the OSA runtime is warm. Every
// NSRunningApplication.activate variant (plain, from:, yieldActivation) and a
// bare `actv` Apple Event mark sioyek active in ~1 ms but do NOT switch the
// Space, so they are not used. The process stays resident after the first
// PDF so later ones skip the ~110 ms app launch; it has no window or Dock
// icon and sits at ~35 MB RSS (AppKit baseline).
//
// Built by build.sh into ~/Applications; `--set-default` registers it as the
// handler for com.adobe.pdf (the Finder "Change All..." equivalent).

import AppKit
import UniformTypeIdentifiers

let viewerApp = URL(fileURLWithPath: "/Applications/sioyek.app")
/// false = quit after each PDF (pays the launch cost every time).
let stayResident = true
/// Compiled once; executing it is the ~20 ms part.
let activateViewer = NSAppleScript(source: "tell application \"sioyek\" to activate")!

func handOff(_ urls: [URL]) {
    let config = NSWorkspace.OpenConfiguration()
    let finish: (NSRunningApplication?, Error?) -> Void = { app, error in
        if let error {
            FileHandle.standardError.write("open-in-sioyek: \(error)\n".data(using: .utf8)!)
        }
        // The one activation that makes macOS switch to the fullscreen Space.
        activateViewer.executeAndReturnError(nil)
        if !stayResident { DispatchQueue.main.async { NSApp.terminate(nil) } }
    }
    if urls.isEmpty {
        NSWorkspace.shared.openApplication(at: viewerApp, configuration: config, completionHandler: finish)
    } else {
        NSWorkspace.shared.open(urls, withApplicationAt: viewerApp, configuration: config, completionHandler: finish)
    }
}

if CommandLine.arguments.contains("--set-default") {
    var failure: Error?
    var done = false
    NSWorkspace.shared.setDefaultApplication(at: Bundle.main.bundleURL, toOpen: .pdf) { e in
        failure = e
        done = true
    }
    while !done { RunLoop.current.run(until: Date().addingTimeInterval(0.05)) }
    if let e = failure {
        FileHandle.standardError.write("could not become the PDF handler: \(e)\n".data(using: .utf8)!)
        exit(1)
    }
    print("PDFs now open through \(Bundle.main.bundleURL.path)")
    exit(0)
}

final class Delegate: NSObject, NSApplicationDelegate {
    var gotFiles = false

    func application(_ app: NSApplication, open urls: [URL]) {
        gotFiles = true
        handOff(urls)
    }

    // Already resident and launched again with no file (Hyper-3 runs
    // `open -a "Open in sioyek"`): just bring sioyek forward.
    func applicationShouldHandleReopen(_: NSApplication, hasVisibleWindows: Bool) -> Bool {
        handOff([])
        return false
    }

    // First launch with no file: open: never arrives, so treat it as a reopen.
    // The delay leaves room for open: to come in first when there is a file.
    func applicationDidFinishLaunching(_: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !self.gotFiles { handOff([]) }
        }
    }
}

let app = NSApplication.shared
let delegate = Delegate()
app.delegate = delegate
app.run()
