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

	return unless -e $folder;

	opendir D, $folder or die "opendir $folder : $!";
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

sub compare_cats{
	my ($file1, $file2) = @_;

	my %map;
	my %rmap;

	# first load the master into memory

	open F, $file1 or die $!;
	while(my $line = <F>){
		chomp $line;
		my ($path, $spec) = split /\s/, $line;
		$map{$path} = $spec;
	}
	close F;


	# now load the slave and remove duplicates

	open F, $file2 or die $!;
	while(my $line = <F>){
		chomp $line;
		my ($path, $spec) = split /\s/, $line;

		if (defined $map{$path}){
			if ($map{$path} eq $spec){
				delete $map{$path};
			}
		}else{
			$rmap{$path} = $spec;
		}
	}
	close F;


	# dump results

	return (keys %map, keys %rmap);

#	for my $line(keys %map){
#		print "$line\n";
#	}
#	for my $line(keys %rmap){
#		print "$line\n";
#	}
}

1;

