##CODE FROM PERLMONKS THAT ELIMINATES THE ANNOYING MICROSOFT WORD CURLY APOSTROPHE##
sub curly_correct {

	{
		#Slurps only the text and not the rest of the commands
		local $/ = undef ;

		open(FILE, "$dir//$files[$i]") or die ("file not found");		

		$text = <FILE> ;
	}


	#   Map incompatible CP-1252 characters
  $text =~ s/\x82/,/g;
  $text =~ s-\x83-<em>f</em>-g;
  $text =~ s/\x84/,,/g;
  $text =~ s/\x85/.../g;

  $text =~ s/\x88/^/g;
  $text =~ s-\x89- �/��-g;

  $text =~ s/\x8B/</g;
  $text =~ s/\x8C/Oe/g;

  $text =~ s/\x91/'/g;
  $text =~ s/\x92/'/g;
  $text =~ s/\x93/"/g;
  $text =~ s/\x94/"/g;
  $text =~ s/\x95/*/g;
  $text =~ s/\x96/-/g;
  $text =~ s/\x97/--/g;
  $text =~ s-\x98-<sup>~</sup>-g;
  $text =~ s-\x99-<sup>TM</sup>-g;

  $text =~ s/\x9B/>/g;
  $text =~ s/\x9C/oe/g;


	open (OUT2, ">$dir//$files[$i]") or die;

	print OUT2 "$text";

	close (OUT2);



}

1;
