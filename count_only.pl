#This soubroutine is the counter that return frequency of features
sub count_only {

	require 'calc_dimensions.pl';

	@biber_tags = ('AMP', 'ANDC', '[BEMA]', '[BYPA]', 'CAUS', 'CONC', 'COND', 'CONJ', '[CONT]', 'DEMO', 'DEMP', 'DPAR', 'DWNT', 'EMPH', 'EX', 'FPP1', 'GER', 'HDG', 'INPR', 'JJ', 'NEMD', 'NN', 'NOMZ', 'OSUB', '[PASS]', '[PASTP]', '[PEAS]', 'PHC', 'PIN', '[PIRE]', 'PIT', 'PLACE', 'POMD', 'PRED', '[PRESP]', '[PRIV]', 'PRMD', '[PROD]', '[PUBV]', 'RB', '[SERE]', '[SMP]', '[SPAU]', '[SPIN]', 'SPP2', '[STPR]', '[SUAV]', 'SYNE', 'THAC', '[THATD]', 'THVC', 'TIME', 'TO', 'TOBJ', 'TPP3', 'TSUB', 'VBD', 'VPRT', '[WHCL]', '[WHOBJ]', '[WHQU]', '[WHSUB]', '[WZPAST]', '[WZPRES]', 'XX0');

	opendir (DR, "$dir") || die ("Cannot open directory");

	@files = readdir(DR);

	$max_bar_size = @files-2; #Options for the progress bar; -2 for the two windows folders "." and ".."
	$progress_bar->SetRange(0, $max_bar_size);


	for ($i=2; $i<@files; $i++) { #Check that the folder is ok

		if ($files[$i] !~ /_MAT.txt/) {

			die ("The folder selected contains other folders or files other than MAT tagged texts. Please select a folder containing only MAT tagged texts\n");

		}

	}

	$prompt_window->Show();
	$prompt_window->DoModal(1);

	for ($i=2; $i<@files; $i++) { #Loop for each file in the folder

		{
			#Slurps only the text and not the rest of the commands
			local $/ = undef ;

			open(FILE, "$dir//$files[$i]") or die ("file not found");
			$files[$i] =~ s/_MAT//; #removes the tag from previous script
			$files[$i] =~ s/.txt//; #removes the extension of the file

			$text = <FILE> ;
		}

		$text =~ s/\n/ /g;  #converts end of line in space

		$string_for_textfield = 'Counting tags of x'; #Trick to display the name of the file
		$string_for_textfield =~ s/x/$files[$i]/;
		$status->Change(-text => $string_for_textfield);

		@word = split (/\s+/, $text);

		foreach $x (@word) {

			$tokens[$i]++;

			if ($x =~ /(_\W)|(\[\w+\])|_POS/) { #counts the tokens ignoring punctuation

				$tokens[$i]--;
			}

			if ($x !~ /(\[\w+\])/ && $x !~ /_\W/ && $x !~ /_POS/) { #condition to avoid the tags of the <> kind and punctuation in order to calculate wordlength and prepare for TTR

				my($wordl, $tag) = split (/_/, $x, 2); #divides the word in tag and word

				@char = split (//, $wordl); #to calculate wordlength
				$wordlength = @char;
				$totalchar{$files[$i]} = $totalchar{$files[$i]} + $wordlength;

				push @types, $wordl; #prepares array for TTR

			}

			if ($rb_biber_check = $rb_biber->GetCheck() == 1) { #Check if the user has selected only Biber's tags

				if ($x !~ /_\W/ && $x !~ /_NULL|_CC|_CD|_DT|_FW|_IN$|_LS|_NNP|_NNPS|_PDT|_POS|_PRP|_QUAN|_QUPR|_RP|_SYM|_UH|_WDT|_WRB|_MD|_VB$|_VBN|_VBG|_WP|_WPS/) { #removing unnecessary tags for a replication of Biber's study

					$x =~ s/.+_//; #removes the word and leaves just the tag

					$counts{$x}{$files[$i]}++; #creates and then fills a hash: POStag => number of occurrences for the file considered

				}

			}

			if ($rb_all_check = $rb_all->GetCheck() == 1) { #Check if the user has selected all tags

				if ($x !~ /_NULL|_MD/) {

					$x =~ s/.+_//; #removes the word and leaves just the tag
					
					$x =~ s/,/COMMA/; #fixing comma

					$counts{$x}{$files[$i]}++; #creates and then fills a hash: POStag => number of occurrences for the file considered

				}
			}
		}


		$corpus_counts{'Tokens'} = $corpus_counts{'Tokens'} + $tokens[$i]; #average tokens for corpus

		$average_wl{$files[$i]} = sprintf "%.2f", $totalchar{$files[$i]}/$tokens[$i]; #average wordlength

		$corpus_counts{'AWL'} = $corpus_counts{'AWL'} + $average_wl{$files[$i]}; #average awl for corpus

		for ($j=0; $j<$tokens_for_ttr; $j++) { #counts TTR

			$ttr_h{$files[$i]}++;

			if (exists ($ttr{lc($types[$j])}{$files[$i]})) {

				$ttr_h{$files[$i]}--;

			} else {

				$ttr{lc($types[$j])}{$files[$i]}++;

			}

		}

		$corpus_counts{'TTR'} = $corpus_counts{'TTR'} + $ttr_h{$files[$i]}; #average awl for corpus

		@types = (); #cleans the array for the new types for the next file

		$progress_bar->DeltaPos(1);

	}


	$directory_stats = "$dir/Statistics";
	mkdir $directory_stats; #creates stats directories

	open (OUT1, ">$dir/Statistics/Statistics_$folders[$#folders].csv") or die;

	if ($rb_biber_check = $rb_biber->GetCheck() == 1) { #Check if the user has selected only Biber's tags

		for ($i=2; $i<@files; $i++) {  #loops again for the files, as the first loops creates the Master tag set heading

			if ($i == 2) { #only the first time it prints the heading

				print OUT1 "Filename,Tokens,AWL,TTR,";

				foreach $x (@biber_tags) {

					print OUT1 "$x,";

				}
			}

			print OUT1 "\n$files[$i],$tokens[$i],$average_wl{$files[$i]},$ttr_h{$files[$i]},";		#prints file name and tokens for each file


			foreach $x (@biber_tags) { #prints the frequencies for each of biber's tags only

				if (exists ($counts{$x}{$files[$i]})) {

					$counts{$x}{$files[$i]} = sprintf "%.2f", $counts{$x}{$files[$i]}/$tokens[$i]*100; #normalisation and round to 2 decimals
					print OUT1 "$counts{$x}{$files[$i]},";

					$corpus_counts{$x} = $corpus_counts{$x} + $counts{$x}{$files[$i]};

				} else { #if there are no instances of that tag in this file it prints zero

					$counts{$x}{$files[$i]} = 0;
					print OUT1 "$counts{$x}{$files[$i]},";

					$corpus_counts{$x} = $corpus_counts{$x} + $counts{$x}{$files[$i]};

				}
			}

		}

		if (@files > 3) { #this avoids to count and print corpus counts if the users selects only one file

				$corpus_counts{'Tokens'} = sprintf "%.2f", $corpus_counts{'Tokens'} / (@files-2);
				$corpus_counts{'AWL'} = sprintf "%.2f", $corpus_counts{'AWL'} / (@files-2);
				$corpus_counts{'TTR'} = sprintf "%.2f", $corpus_counts{'TTR'} / (@files-2);

				print OUT1 "\n$corpus_name,$corpus_counts{'Tokens'},$corpus_counts{'AWL'},$corpus_counts{'TTR'},";

				foreach $x (@biber_tags) { #prints all the averages

					$corpus_counts{$x} = sprintf "%.2f", $corpus_counts{$x} / (@files-2);

					print OUT1 "$corpus_counts{$x},";

				}

			}

	}else{

			for ($i=2; $i<@files; $i++) {  #loops again for the files, as the first loops creates the Master tag set heading


			if ($i == 2) { #only the first time it prints the heading

				print OUT1 "Filename,Tokens,AWL,TTR,";

				foreach $x (sort keys %counts) {

					print OUT1 "$x,";

				}
			}

			print OUT1 "\n$files[$i],$tokens[$i],$average_wl{$files[$i]},$ttr_h{$files[$i]},";		#prints file name and tokens for each file

			foreach $x (sort keys %counts) { #prints the frequencies for each tag

				if (exists ($counts{$x}{$files[$i]})) {

					$counts{$x}{$files[$i]} = sprintf "%.2f", $counts{$x}{$files[$i]}/$tokens[$i]*100; #normalisation and round to 2 decimals
					print OUT1 "$counts{$x}{$files[$i]},";

					$corpus_counts{$x} = $corpus_counts{$x} + $counts{$x}{$files[$i]};

				} else { #if there are no instances of that tag in this file it prints zero

					$counts{$x}{$files[$i]} = 0;
					print OUT1 "$counts{$x}{$files[$i]},";

					$corpus_counts{$x} = $corpus_counts{$x} + $counts{$x}{$files[$i]};

				}
			}

		}

	if (@files > 3) { #this avoids to count and print corpus counts if the users selects only one file

			$corpus_counts{'Tokens'} = sprintf "%.2f", $corpus_counts{'Tokens'} / (@files-2);
			$corpus_counts{'AWL'} = sprintf "%.2f", $corpus_counts{'AWL'} / (@files-2);
			$corpus_counts{'TTR'} = sprintf "%.2f", $corpus_counts{'TTR'} / (@files-2);

			print OUT1 "\n$corpus_name,$corpus_counts{'Tokens'},$corpus_counts{'AWL'},$corpus_counts{'TTR'},";

			foreach $x (sort keys %counts) { #prints all the averages

				$corpus_counts{$x} = sprintf "%.2f", $corpus_counts{$x} / (@files-2);

				print OUT1 "$corpus_counts{$x},";

			}

		}

	}


	#calling subroutine to calculate dimension scores
	&calc_dimensions;

	undef %totalchar; #clean everything
	undef %counts;
	undef %corpus_counts;
	undef %average_wl;
	undef %ttr_h;
	undef %ttr;
	@tokens = ();
	@char = ();

	close (OUT1); #close everything
	close (DR);
	close (FILE);

	$status->Change(-text => 'Analysis completed');
	$progress_bar->SetPos(0);

}


1;
