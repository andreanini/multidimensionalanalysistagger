#subroutine to calculate the dimension scores
sub calc_dimensions {

	require 'dimensions_graph.pl';
	require 'texttype_graph.pl';

	$max_bar_size = @files-2; #Options for the progress bar; -2 for the two windows folders "." and ".."
	$progress_bar->SetRange(0, $max_bar_size);

	%biber_means = ( "VBD" => 4.01, "[PEAS]" => 0.86, "VPRT" => 7.77, "PLACE" => 0.31, "TIME" => 0.52, "FPP1" => 2.72, "SPP2" => 0.99, "TPP3" => 2.99, "PIT" => 1.03, "DEMP" => 0.46, "INPR" => 0.14, "[PROD]" => 0.30, "[WHQU]" => 0.02, "NOMZ" => 1.99, "GER" => 0.7, "NN" => 18.05, "[PASS]" => 0.96, "[BYPA]" => 0.08, "[BEMA]" => 2.83, "EX" => 0.22, "THVC" => 0.33, "THAC" => 0.03, "[WHCL]" => 0.06, "TO" => 1.49, "[PRESP]" => 0.1, "[PASTP]" => 0.01, "[WZPAST]" => 0.25, "[WZPRES]" => 0.16, "TSUB" => 0.04, "TOBJ" => 0.08, "[WHSUB]" => 0.21, "[WHOBJ]" => 0.14, "[PIRE]" => 0.07, "[SERE]" => 0.01, "CAUS" => 0.11, "CONC" => 0.05, "COND" => 0.25, "OSUB" => 0.1, "PIN" => 11.05, "JJ" => 6.07, "PRED" => 0.47, "RB" => 6.56, "TTR" => 51.1, "AWL" => 4.5, "CONJ" => 0.12, "DWNT" => 0.2, "HDG" => 0.06, "AMP" => 0.27, "EMPH" => 0.63, "DPAR" => 0.12, "DEMO" => 0.99, "POMD" => 0.58, "NEMD" => 0.21, "PRMD" => 0.56, "[PUBV]" => 0.77, "[PRIV]" => 1.80, "[SUAV]" => 0.29, "[SMP]" => 0.08, "[CONT]" => 1.35, "[THATD]" => 0.31, "[STPR]" => 0.2, "[SPIN]" => 0, "[SPAU]" => 0.55, "PHC" => 0.34, "ANDC" => 0.45, "SYNE" => 0.17, "XX0" => 0.85,);
	%biber_sds = ( "VBD" => 3.04, "[PEAS]" => 0.52, "VPRT" => 3.43, "PLACE" => 0.34, "TIME" => 0.35, "FPP1" => 2.61, "SPP2" => 1.38, "TPP3" => 2.25, "PIT" => 0.71, "DEMP" => 0.48, "INPR" => 0.20, "[PROD]" => 0.35, "[WHQU]" => 0.06, "NOMZ" => 1.44, "GER" => 0.38, "NN" => 3.56, "[PASS]" => 0.66, "[BYPA]" => 0.13, "[BEMA]" => 0.95, "EX" => 0.18, "THVC" => 0.29, "THAC" => 0.06, "[WHCL]" => 0.1, "TO" => 0.56, "[PRESP]" => 0.17, "[PASTP]" => 0.04, "[WZPAST]" => 0.31, "[WZPRES]" => 0.18, "TSUB" => 0.08, "TOBJ" => 0.11, "[WHSUB]" => 0.20, "[WHOBJ]" => 0.17, "[PIRE]" => 0.11, "[SERE]" => 0.04, "CAUS" => 0.17, "CONC" => 0.08, "COND" => 0.22, "OSUB" => 0.11, "PIN" => 2.54, "JJ" => 1.88, "PRED" => 0.26, "RB" => 1.76, "TTR" => 5.2, "AWL" => 0.4, "CONJ" => 0.16, "DWNT" => 0.16, "HDG" => 0.13, "AMP" => 0.26, "EMPH" => 0.42, "DPAR" => 0.23, "DEMO" => 0.42, "POMD" => 0.35, "NEMD" => 0.21, "PRMD" => 0.42, "[PUBV]" => 0.54, "[PRIV]" => 1.04, "[SUAV]" => 0.31, "[SMP]" => 0.1, "[CONT]" => 1.86, "[THATD]" => 0.41, "[STPR]" => 0.27, "[SPIN]" => 0.00001, "[SPAU]" => 0.25, "PHC" => 0.27, "ANDC" => 0.48, "SYNE" => 0.16, "XX0" => 0.61,);


	open (OUT2, ">$dir/Statistics/Zscores_$folders[$#folders].csv") or die;

	for ($i=2; $i<@files; $i++) { #calculate zscores

		$string_for_textfield = 'Calculating zscores for x';
		$string_for_textfield =~ s/x/$files[$i]/;
		$status->Change(-text => $string_for_textfield);

		if ($i == 2) { #only the first time it prints the heading

			print OUT2 "Filename,";

			foreach $x (sort keys %biber_means) { #first loop to create the heading

				print OUT2 "$x,";

			}

			print OUT2 "Underused_variables,Overused_variables,";

		}

		$zscore{"AWL"}{$files[$i]} = sprintf "%.2f", ($average_wl{$files[$i]} - $biber_means{"AWL"})/$biber_sds{"AWL"}; #zscore for word length
		$corpus_counter{"AWL"} = $corpus_counter{"AWL"} + $zscore{"AWL"}{$files[$i]}; #variable to count the average for the corpus

		if ($tokens_for_ttr == 400) { #I need to add this condition for TTR because if it is shorter than 400 then it's not comparable

			$zscore{"TTR"}{$files[$i]} = sprintf "%.2f", (($ttr_h{$files[$i]}/4) - $biber_means{"TTR"})/$biber_sds{"TTR"};
			$corpus_counter{"TTR"} = $corpus_counter{"TTR"} + $zscore{"TTR"}{$files[$i]}; #variable to count the average for the corpus

		} else {

			$zscore{"TTR"}{$files[$i]} = 0;
			$corpus_counter{"TTR"} = 0;

		}

		print OUT2 "\n$files[$i],";

		foreach $x (sort keys %biber_means) { #second loop to calculate and print the zscores

			if ($x !~ /AWL/ && $x !~ /TTR/){

				$zscore{$x}{$files[$i]} = sprintf "%.2f", ($counts{$x}{$files[$i]} - $biber_means{$x})/$biber_sds{$x};
				$corpus_counter{$x} = sprintf "%.2f", $corpus_counter{$x} + $zscore{$x}{$files[$i]}; #variable to count the average for the corpus

			}

			print OUT2 "$zscore{$x}{$files[$i]},";

		}


		foreach $x (sort keys %zscore) { #third loop to find the underused variables

			if ($zscore{$x}{$files[$i]} < -2) {

				print OUT2 "$x ";

			}

		}

		print OUT2 ",";

		foreach $x (sort keys %zscore) { #fourth loop to find the overused variables

			if ($zscore{$x}{$files[$i]} > 2) {

				print OUT2 "$x ";

			}

		}

		$progress_bar->DeltaPos(1);

	}

	if (@files > 3) { #this avoids to count and print corpus counts if the users selects only one file

		$string_for_textfield = 'Calculating zscores for x';
		$string_for_textfield =~ s/x/$files[$i]/;
		$status->Change(-text => $string_for_textfield);

		print OUT2 "\n$corpus_name,";

		foreach $x (sort keys %biber_means) { #prints all the averages

			$corpus_counter{$x} = sprintf "%.2f", $corpus_counter{$x} / (@files-2);

			print OUT2 "$corpus_counter{$x},";

		}


		foreach $x (sort keys %corpus_counter) { #underused variables for the corpus

			if ($corpus_counter{$x} < -2) {

				print OUT2 "$x ";

			}

		}

		print OUT2 ",";

		foreach $x (sort keys %corpus_counter) { #overused variables for the corpus

			if ($corpus_counter{$x} > 2) {

				print OUT2 "$x ";

			}

		}

		$progress_bar->DeltaPos(1);

	}

	$max_bar_size = @files-2; #Options for the progress bar; -2 for the two windows folders "." and ".." but -1 because of the plotting
	$progress_bar->SetRange(0, $max_bar_size);

	open (OUT3, ">$dir/Statistics/Dimensions_$folders[$#folders].csv") or die;

	print OUT3 "Filename,Dimension1,Dimension2,Dimension3,Dimension4,Dimension5,Dimension6,Closest Text Type";

	#this block applies if the user selects to have the zscore correction
	if ($zscore_correction_check = $correction_yes->GetCheck() == 1) {

		for ($i=2; $i<@files; $i++) {

			foreach $x (sort keys %zscore) {

				if ($zscore{$x}{$files[$i]} > 5) {

					$zscore{$x}{$files[$i]} = 5;


				}

				if ($zscore{$x}{$files[$i]} < -5) {

					$zscore{$x}{$files[$i]} = -5;

				}

			}

		}

	}

	for ($i=2; $i<@files; $i++) { #calculate dimension scores

		$string_for_textfield = 'Calculating Dimensions for x';
		$string_for_textfield =~ s/x/$files[$i]/;
		$status->Change(-text => $string_for_textfield);

		if ($zscore{"TTR"}{$files[$i]} eq "N/A") { #transform the TTR back into numeric if necessary

			$zscore{"TTR"}{$files[$i]} = 0;

		}


		##THIS IS THE DIMENSION COUNTING FOR ONLY FEATURES WITH MEAN HIGHER THAN 1

		$dimension{"1"}{$files[$i]} = ($zscore{"[PRIV]"}{$files[$i]} + $zscore{"[THATD]"}{$files[$i]} + $zscore{"[CONT]"}{$files[$i]} + $zscore{"VPRT"}{$files[$i]} + $zscore{"SPP2"}{$files[$i]} + $zscore{"[PROD]"}{$files[$i]} + $zscore{"XX0"}{$files[$i]} + $zscore{"DEMP"}{$files[$i]} + $zscore{"EMPH"}{$files[$i]} + $zscore{"FPP1"}{$files[$i]} + $zscore{"PIT"}{$files[$i]} + $zscore{"[BEMA]"}{$files[$i]} + $zscore{"CAUS"}{$files[$i]} + $zscore{"DPAR"}{$files[$i]} + $zscore{"INPR"}{$files[$i]} + $zscore{"AMP"}{$files[$i]} + $zscore{"POMD"}{$files[$i]} + $zscore{"ANDC"}{$files[$i]} + $zscore{"[STPR]"}{$files[$i]}) - ($zscore{"NN"}{$files[$i]} + $zscore{"AWL"}{$files[$i]} + $zscore{"PIN"}{$files[$i]} + $zscore{"TTR"}{$files[$i]} + $zscore{"JJ"}{$files[$i]});
		$dimension_corpus{"1"} = $dimension_corpus{"1"} + $dimension{"1"}{$files[$i]};


		$dimension{"2"}{$files[$i]} = $zscore{"VBD"}{$files[$i]} + $zscore{"TPP3"}{$files[$i]} + $zscore{"[PEAS]"}{$files[$i]} + $zscore{"[PUBV]"}{$files[$i]} + $zscore{"SYNE"}{$files[$i]} + $zscore{"[PRESP]"}{$files[$i]};
		$dimension_corpus{"2"} = $dimension_corpus{"2"} + $dimension{"2"}{$files[$i]};


		$dimension{"3"}{$files[$i]} = ($zscore{"[WHOBJ]"}{$files[$i]} + $zscore{"[WHSUB]"}{$files[$i]} + $zscore{"PHC"}{$files[$i]} + $zscore{"NOMZ"}{$files[$i]}) - ($zscore{"TIME"}{$files[$i]} + $zscore{"PLACE"}{$files[$i]} + $zscore{"RB"}{$files[$i]});
		$dimension_corpus{"3"} = $dimension_corpus{"3"} + $dimension{"3"}{$files[$i]};


		$dimension{"4"}{$files[$i]} = $zscore{"TO"}{$files[$i]} + $zscore{"PRMD"}{$files[$i]} + $zscore{"[SUAV]"}{$files[$i]} + $zscore{"COND"}{$files[$i]} + $zscore{"NEMD"}{$files[$i]} + $zscore{"[SPAU]"}{$files[$i]};
		$dimension_corpus{"4"} = $dimension_corpus{"4"} + $dimension{"4"}{$files[$i]};


		$dimension{"5"}{$files[$i]} = $zscore{"CONJ"}{$files[$i]} + $zscore{"[PASS]"}{$files[$i]} + $zscore{"[WZPAST]"}{$files[$i]} + $zscore{"OSUB"}{$files[$i]};
		$dimension_corpus{"5"} = $dimension_corpus{"5"} + $dimension{"5"}{$files[$i]};


		$dimension{"6"}{$files[$i]} = $zscore{"THVC"}{$files[$i]} + $zscore{"DEMO"}{$files[$i]};
		$dimension_corpus{"6"} = $dimension_corpus{"6"} + $dimension{"6"}{$files[$i]};

		print OUT3 "\n$files[$i],$dimension{\"1\"}{$files[$i]},$dimension{\"2\"}{$files[$i]},$dimension{\"3\"}{$files[$i]},$dimension{\"4\"}{$files[$i]},$dimension{\"5\"}{$files[$i]},$dimension{\"6\"}{$files[$i]},";


		##DETERMINATION OF TEXT TYPE USING EUCLIDEAN DISTANCE##

		%texttype_finder = ( #this hash calculates the differences between the input and Biber's text types

						"Intimate interpersonal interaction" => sqrt((($dimension{"1"}{$files[$i]} - 45) ** 2) + (($dimension{"2"}{$files[$i]} - -1) ** 2) + (($dimension{"3"}{$files[$i]} - -6) ** 2) + (($dimension{"4"}{$files[$i]} - 1) ** 2) + (($dimension{"5"}{$files[$i]} - -4) ** 2)),
						"Informational interaction" => sqrt((($dimension{"1"}{$files[$i]} - 30) ** 2) + (($dimension{"2"}{$files[$i]} - -1) ** 2) + (($dimension{"3"}{$files[$i]} - -4) ** 2) + (($dimension{"4"}{$files[$i]} - 1) ** 2) + (($dimension{"5"}{$files[$i]} - -3) ** 2)),
						"Scientific exposition" => sqrt((($dimension{"1"}{$files[$i]} - -15) ** 2) + (($dimension{"2"}{$files[$i]} - -2.5) ** 2) + (($dimension{"3"}{$files[$i]} - 4) ** 2) + (($dimension{"4"}{$files[$i]} - -2) ** 2) + (($dimension{"5"}{$files[$i]} - 9) ** 2)),
						"Learned exposition" => sqrt((($dimension{"1"}{$files[$i]} - -20) ** 2) + (($dimension{"2"}{$files[$i]} - -2) ** 2) + (($dimension{"3"}{$files[$i]} - 5) ** 2) + (($dimension{"4"}{$files[$i]} - -3) ** 2) + (($dimension{"5"}{$files[$i]} - 2) ** 2)),
						"Imaginative narrative" => sqrt((($dimension{"1"}{$files[$i]} - 5) ** 2) + (($dimension{"2"}{$files[$i]} - 7) ** 2) + (($dimension{"3"}{$files[$i]} - -4) ** 2) + (($dimension{"4"}{$files[$i]} - 1) ** 2) + (($dimension{"5"}{$files[$i]} - -2) ** 2)),
						"General narrative exposition" => sqrt((($dimension{"1"}{$files[$i]} - -10) ** 2) + (($dimension{"2"}{$files[$i]} - 2) ** 2) + (($dimension{"3"}{$files[$i]} - 0) ** 2) + (($dimension{"4"}{$files[$i]} - -1) ** 2) + (($dimension{"5"}{$files[$i]} - 0) ** 2)),
						"Situated reportage" => sqrt((($dimension{"1"}{$files[$i]} - 0) ** 2) + (($dimension{"2"}{$files[$i]} - -3) ** 2) + (($dimension{"3"}{$files[$i]} - -13) ** 2) + (($dimension{"4"}{$files[$i]} - -4.5) ** 2) + (($dimension{"5"}{$files[$i]} - -3) ** 2)),
						"Involved persuasion" => sqrt((($dimension{"1"}{$files[$i]} - 5) ** 2) + (($dimension{"2"}{$files[$i]} - -2) ** 2) + (($dimension{"3"}{$files[$i]} - 2) ** 2) + (($dimension{"4"}{$files[$i]} - 4) ** 2) + (($dimension{"5"}{$files[$i]} - -1) ** 2)),
			);

		@closest_texttype = sort { $texttype_finder{$a} <=> $texttype_finder{$b} } keys %texttype_finder; #new array ordered by values of the hash

		$text_type = $closest_texttype[0]; #this assigns the closest text type to the variable used later on

		print OUT3 "$text_type";

		$progress_bar->DeltaPos(1);

	}

	if (@files > 3) { #this avoids to count and print corpus counts if the users selects only one file

		$string_for_textfield = 'Calculating Dimensions for x';
		$string_for_textfield =~ s/x/$files[$i]/;
		$status->Change(-text => $string_for_textfield);

		print OUT3 "\n$corpus_name,";

		foreach $x (sort keys %dimension) { #prints all the averages

			$dimension_corpus{$x} = sprintf "%.2f", $dimension_corpus{$x} / (@files-2);

			print OUT3 "$dimension_corpus{$x},";

		}


		##DETERMINATION OF TEXT TYPE USING EUCLIDEAN DISTANCE##

		%corpus_texttype_finder = ( #this hash calculates the differences between the input and Biber's text types

						"Intimate interpersonal interaction" => sqrt((($dimension_corpus{"1"} - 45) ** 2) + (($dimension_corpus{"2"} - -1) ** 2) + (($dimension_corpus{"3"} - -6) ** 2) + (($dimension_corpus{"4"} - 1) ** 2) + (($dimension_corpus{"5"} - -4) ** 2)),
						"Informational interaction" => sqrt((($dimension_corpus{"1"} - 30) ** 2) + (($dimension_corpus{"2"} - -1) ** 2) + (($dimension_corpus{"3"} - -4) ** 2) + (($dimension_corpus{"4"} - 1) ** 2) + (($dimension_corpus{"5"} - -3) ** 2)),
						"Scientific exposition" => sqrt((($dimension_corpus{"1"} - -15) ** 2) + (($dimension_corpus{"2"} - -2.5) ** 2) + (($dimension_corpus{"3"} - 4) ** 2) + (($dimension_corpus{"4"} - -2) ** 2) + (($dimension_corpus{"5"} - 9) ** 2)),
						"Learned exposition" => sqrt((($dimension_corpus{"1"} - -20) ** 2) + (($dimension_corpus{"2"} - -2) ** 2) + (($dimension_corpus{"3"} - 5) ** 2) + (($dimension_corpus{"4"} - -3) ** 2) + (($dimension_corpus{"5"} - 2) ** 2)),
						"Imaginative narrative" => sqrt((($dimension_corpus{"1"} - 5) ** 2) + (($dimension_corpus{"2"} - 7) ** 2) + (($dimension_corpus{"3"} - -4) ** 2) + (($dimension_corpus{"4"} - 1) ** 2) + (($dimension_corpus{"5"} - -2) ** 2)),
						"General narrative exposition" => sqrt((($dimension_corpus{"1"} - -10) ** 2) + (($dimension_corpus{"2"} - 2) ** 2) + (($dimension_corpus{"3"} - 0) ** 2) + (($dimension_corpus{"4"} - -1) ** 2) + (($dimension_corpus{"5"} - 0) ** 2)),
						"Situated reportage" => sqrt((($dimension_corpus{"1"} - 0) ** 2) + (($dimension_corpus{"2"} - -3) ** 2) + (($dimension_corpus{"3"} - -13) ** 2) + (($dimension_corpus{"4"} - -4.5) ** 2) + (($dimension_corpus{"5"} - -3) ** 2)),
						"Involved persuasion" => sqrt((($dimension_corpus{"1"} - 5) ** 2) + (($dimension_corpus{"2"} - -2) ** 2) + (($dimension_corpus{"3"} - 2) ** 2) + (($dimension_corpus{"4"} - 4) ** 2) + (($dimension_corpus{"5"} - -1) ** 2)),
			);

		@closest_corpus_texttype = sort { $corpus_texttype_finder{$a} <=> $corpus_texttype_finder{$b} } keys %corpus_texttype_finder; #new array ordered by values of the hash

		$text_type = $closest_corpus_texttype[0]; #this assigns the closest text type to the variable used later on
		print OUT3 "$text_type";

		$progress_bar->DeltaPos(1);

	}

	$string_for_textfield = 'Creating plots';
	$string_for_textfield =~ s/x/$files[$i]/;
	$status->Change(-text => $string_for_textfield);

	&dimensions_graph;
	&texttype_graph;

	$progress_bar->DeltaPos(1);

	close (OUT2); #close everything
	close (OUT3);
	undef %dimension_corpus;
	undef %dimension;
	undef %zscore;
	undef %corpus_counter;
	undef %texttype_finder;
	undef %corpus_texttype_finder;
	@closest_texttype = ();
	@closest_corpus_texttype = ();



}

1;
