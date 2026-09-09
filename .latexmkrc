$pdf_mode = 1;
$do_cd = 1;        # build relative to the .tex file, not the cwd
$out_dir = '.';
$aux_dir = 'build';
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 %O %S';
$lualatex = 'lualatex -interaction=nonstopmode -synctex=1 %O %S';
$xelatex = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';
