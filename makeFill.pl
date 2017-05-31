use v5.24;


my $out = "FILL.sql";

open OUT, '>', $out or die "$out: $!";

sub write_file {
	my $filename = shift;
	open FILE, '<', $filename or die "$filename: $!";

	while(<FILE>) {
		print OUT $_;
	}

	close FILE;
}

sub write_TSV {
	my $filename = shift;
	open FILE, '<', $filename or die "$filename: $!";

	my $table = substr($filename, 5, -4);

	my $f_str = <FILE>;
	$f_str =~ s/\n//g;
	my @fields = split '\t', $f_str;

	say OUT "  -- таблица $table";
	while(<FILE>) {
		$_ =~ s/\n//g;
		my @vars = split '\t', $_;
		warn "ALARM!: $filename" if @vars != @fields;
		say OUT '  INSERT INTO '.$table.' ('.(join ', ', @fields).') VALUES ('.(join ', ', @vars).');';
	}
	close FILE;
}

write_file('FILL/TIMETABLE.sql');
write_TSV('FILL/ORGANIZATIONS.tsv');
write_TSV('FILL/SUBDIVISIONS.tsv');
write_TSV('FILL/POSITIONS.tsv');
write_TSV('FILL/EMPLOYEES.tsv');
write_TSV('FILL/ABSENCE.tsv');
write_TSV('FILL/POSITIONS_EMPLOYEES.tsv');

say OUT "END;";
close OUT;
