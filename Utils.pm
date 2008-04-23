package Flickr::Utils;

sub load_deploy_list {
	my ($filename) = @_;

	my $list = [];

	open F, $filename or die $!;

	while(<F>){
		chomp;

		next if /^#/;
		next unless length;

		my ($ip, $name) = split /:/;
		push @{$list}, {'ip' => $ip, 'name' => $name};
	}

	close F;

	return $list;
}

sub replace_in_file{
        my ($file, $x, $y) = @_;

        my $buffer;

        open F, $file;
        $buffer .= $_ while <F>;
        close F;

        $x = quotemeta $x;

        $buffer =~ s/$x/$y/g;

        open F, ">$file";
        print F $buffer;
        close F;
}

sub gen_deploy_time {

	my @t = localtime();
	$t[4]++;
	$t[5] += 1900;
	return "$t[2]:$t[1], $t[3]/$t[4]/$t[5]";
}

sub gen_deploy_tag {

	my @t = localtime();
	$t[4]++;
	$t[5] += 1900;
	return "deploy_$t[5]_$t[4]_$t[3]_$t[2]_$t[1]";
}

1;
__END__

