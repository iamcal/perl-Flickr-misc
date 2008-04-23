package Flickr::Storage;

sub fetch_folder_list {
	my ($min, $max) = @_;

	my %paths;

	my $current = $min;
	while($current <= $max){

		my @parts = ("$current" =~ m/.../g);
		my $path = join '/', @parts;

		my $extra = substr "$current", scalar(@parts)*3;
		my $next = 1 + ((join '', @parts).('9'x length $extra));

		$paths{$path}++;

		$current = $next;
	}

	return sort keys %paths;
}

sub cat_folder {
	my ($folder, $rx) = @_;

	opendir D, $folder or die $!;
	my @files = readdir D;
	closedir D;

	my $img_count = 0;
	my $img_size = 0;

	for my $file(@files){

		if ($file =~ $rx){

			$img_count++;
			$img_size += -s "$folder/$file";
		}
	}

	if ($img_count){
		print "$folder $img_count:$img_size\n";
	}
}

1;

