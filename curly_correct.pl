##CODE FROM PERLMONKS THAT ELIMINATES THE ANNOYING MICROSOFT WORD CURLY APOSTROPHE##
sub curly_correct {

	{
		#Slurps only the text and not the rest of the commands
		local $/ = undef ;

		open(FILE, "$dir//$files[$i]") or die ("file not found");		

		$text = <FILE> ;
	}


  $text =~ s/‘/'/g;
  $text =~ s/’/'/g;
  $text =~ s/“/"/g;
  $text =~ s/”/"/g;


	open (OUT2, ">$dir//$files[$i]") or die;

	print OUT2 "$text";

	close (OUT2);



}

1;
