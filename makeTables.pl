use v5.24;

binmode(STDIN, ":encoding(utf8)");
binmode(STDOUT, ":encoding(utf8)");
binmode(STDERR, ":encoding(utf8)");

say <<HEAD;
\\documentclass[a4paper,12pt]{article}

\\usepackage[T2A]{fontenc}
\\usepackage[utf8]{inputenc}
\\usepackage[english,russian]{babel}

\\usepackage[
    left=15mm,
    top=10mm,
]{geometry}
\\usepackage{caption}% http://ctan.org/pkg/caption
\\captionsetup[table]{justification=raggedright,singlelinecheck=off}

\\begin{document}

HEAD

while (<>) {
  $_ =~ s/_/\\_/g;
  $_ =~ s/&/\\&/g;

  if(m/CREATE TABLE ([A-Z\_\\]+) \( -- (.*)/) {
    say <<BEGIN_TABLE;
  \\begin{table}[ht]
    \\caption{$2\\ ($1)}

    \\begin{tabular}{|p{0.25\\linewidth}|p{0.2\\linewidth}|p{0.07\\linewidth}|p{0.08\\linewidth}|p{0.4\\linewidth}|}
      \\hline
      Field & Type & Null & Default & Comment \\\\ \\hline
BEGIN_TABLE
    next;
  }

  if(m/^\s+CONSTRAINT/) {
    next;
  }

  if(m/([A-Z\\_]+)(\s[A-Z0-9]+\s?[CHAR0-9\(\)]*)(?:\sDEFAULT (?<default>\d+))?(\sNOT NULL)?,(?: -- (.*))?/) {
    say "$1 & $2 & $4 & $+{default} & $5 \\\\ \\hline";
    next;
  }


  if(m/\);$/) {
    say <<END_TABLE;
    \\end{tabular}
  \\end{table}
END_TABLE
    next;
  }
  warn "ALARM!!!: $_";
}

say <<TAIL;
\\end{document}
TAIL