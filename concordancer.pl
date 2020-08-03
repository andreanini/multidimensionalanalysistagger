#Subroutine that launches the tool to visualise the dimension features in MAT tagged texts
sub Concordancer {

	$concordance_window->Show();
	$concordance_window->DoModal(1);

	if ($dir !~ /_MAT.txt/) {

		$string_for_textfield = 'Only MAT tagged text files can be selected!';
		$status->Change(-text => $string_for_textfield);

	} else {

		$string_for_textfield = ' '; 
		$status->Change(-text => $string_for_textfield);

		{
			#Slurps only the text and not the rest of the commands
			local $/ = undef ;

			open(FILE, "$dir") or die ("file not found");


			$text = <FILE> ;
		}

		$text =~ s/\n/ /g;

		@word = split (/\s/, $text);

		for ($i=0; $i<@word; $i++) { #first loop to colour the features THE FEATURES HIGHLIGHTED ARE ALL THE ONES FOR THE DIMENSIONS, NOT JUST THE ONES COUNTED

			#Dimension 1 features
			if ($cb_dimension_check = $cb_dim1->GetCheck() == 1) {

				#Involved features
				if ($word[$i] =~ /\[PRIV\]|\[THATD\]|\[CONT\]|_VPRT|_SPP2|\[PROD\]|_XX0|_DEMP|_EMPH|_FPP1|_PIT|\[BEMA\]|_CAUS|_DPAR|_INPR|_HDG|_AMP|\[SERE\]|\[WHQU\]|_POMD|_ANDC|\[WHCL\]|\[STPR\]/) {

					$word[$i] =~ s{(.+)}{<font color=\"red\">$1</font>};

				}

				#Informational features
				if ($word[$i] =~ /_NN$|_PIN|_JJ/) {

					$word[$i] =~ s{(.+)}{<font color=\"blue\">$1</font>};

				}

			}

			#Dimension 2 features
			if ($cb_dimension_check = $cb_dim2->GetCheck() == 1) {

				#narrative features
				if ($word[$i] =~ /_VBD|_TPP3|\[PEAS\]|\[PUBV\]|_SYNE|\[PRESP\]/) {

					$word[$i] =~ s{(.+)}{<font color=\"goldenrod\">$1</font>};

				}

			}


			#Dimension 3 features
			if ($cb_dimension_check = $cb_dim3->GetCheck() == 1) {

				#nominal elaboration features
				if ($word[$i] =~ /\[WHOBJ\]|\[PIRE\]|\[WHSUB\]|_PHC|_NOMZ/) {

					$word[$i] =~ s{(.+)}{<font color=\"lightsalmon\">$1</font>};

				}

				#context-depedent features
				if ($word[$i] =~ /_TIME|_PLACE|_RB/) {

					$word[$i] =~ s{(.+)}{<font color=\"olive\">$1</font>};

				}

			}


			#Dimension 4 features
			if ($cb_dimension_check = $cb_dim4->GetCheck() == 1) {

				#persuasion features
				if ($word[$i] =~ /_TO$|_PRMD|\[SUAV\]|_COND|_NEMD|\[SPAU\]/) {

					$word[$i] =~ s{(.+)}{<font color=\"magenta\">$1</font>};

				}
			}


			#Dimension 5 features
			if ($cb_dimension_check = $cb_dim5->GetCheck() == 1) {

				#abstract features
				if ($word[$i] =~ /_CONJ|\[PASS\]|\[PASTP\]|\[BYPA\]|\[WZPAST\]|_OSUB/) {

					$word[$i] =~ s{(.+)}{<font color=\"limegreen\">$1</font>};

				}

			}


			#Dimension 6 features
			if ($cb_dimension_check = $cb_dim6->GetCheck() == 1) {

				#On-line informational elaboration features
				if ($word[$i] =~ /_THVC|_DEMO|_TOBJ|_THAC/) {

					$word[$i] =~ s{(.+)}{<font color=\"darkorchid\">$1</font>};

				}

			}


		}

		for ($i=0; $i<@word; $i++) { #second loop to remove the tags and leave just the words and join the words in the new text

			$word[$i] =~ s/(_\w+)|(_.)//;
			$output_text = "$output_text"." $word[$i]";

		}

		$path_logo = $0;
		$path_logo =~ s/MAT.exe/logo.png/;

		open (OUT4, ">$input_dir//$file_name"."_features.html") or die;

		print OUT4 "

		<!DOCTYPE html>
		<html>

		<head>

			<title>MAT</title>
			<style type=\"text/css\">
				div#wrap {margin: 0 auto; width: 500px;}
				input[type=submit] {width: 10em; height: 1.7em;}
				input[type=reset] {width: 10em; height: 1.7em;}
				input[type=text] {width: 25em; height: 1.2em;}
				form {font-size: 1.0em;}
			</style>

		</head>
		<body bgcolor = \"#F2F2F2\">

				<table align=\"center\" style=\" width: 100%;\">
				<tr>
					<td colspan=\"2\">
						<div style=\"background-color: #2B547E; border-radius: 5px; text-align:center;\">
							<font color=\"#2B547E\">
								a
							</font>
						</div>
					</td>
				<tr>
				<tr>
					<td>
						<img src=\"$path_logo\">
					</td>
					<td>
						<h1>
							<font face=\"arial\" color=\"#2B547E\">
								MAT - Multidimensional Analysis Tagger
							</font>
						</h1>
					</td>
				</tr>
				<tr>
					<td colspan=\"2\">
						<hr>
					</td>
				</tr>
				<tr>
					<td colspan=\"2\">
						$output_text
					</td>
				</tr>
				<tr>
					<td align=\"center\" colspan=\"2\">
					</td>
				</tr>
				<tr>
					<td colspan=\"2\">
						<hr>
					</td>
				</tr>";

				if ($cb_dimension_check = $cb_dim1->GetCheck() == 1) {

				print OUT4 "

				<tr>
					<td colspan=\"2\">
						<font color=\"red\">
							Involved features
						</font>
						<br>
						<font color=\"blue\">
							Informational features
						</font>
					</td>
				</tr>";

				}

				if ($cb_dimension_check = $cb_dim2->GetCheck() == 1) {

				print OUT4 "

				<tr>
					<td colspan=\"2\">
						<font color=\"goldenrod\">
							Narrative features
						</font>
					</td>
				</tr>";

				}

				if ($cb_dimension_check = $cb_dim3->GetCheck() == 1) {

				print OUT4 "

				<tr>
					<td colspan=\"2\">
						<font color=\"olive\">
							Context-dependent features
						</font>
						<br>
						<font color=\"lightsalmon\">
							Nominal elaboration features
						</font>
					</td>
				</tr>";

				}

				if ($cb_dimension_check = $cb_dim4->GetCheck() == 1) {

				print OUT4 "

				<tr>
					<td colspan=\"2\">
						<font color=\"magenta\">
							Persuasion features
						</font>
					</td>
				</tr>";

				}

				if ($cb_dimension_check = $cb_dim5->GetCheck() == 1) {

				print OUT4 "

				<tr>
					<td colspan=\"2\">
						<font color=\"limegreen\">
							Abstract features
						</font>
					</td>
				</tr>";

				}

				if ($cb_dimension_check = $cb_dim6->GetCheck() == 1) {

				print OUT4 "

				<tr>
					<td colspan=\"2\">
						<font color=\"darkorchid\">
							On-line informational elaboration features
						</font>
					</td>
				</tr>";

				}

				print OUT4 "

				<tr>
					<td colspan=\"2\">
						<div style=\"background-color: #2B547E; border-radius: 5px; text-align:center;\">
							<font color=\"#2B547E\">
								a
							</font>
						</div>
					</td>
				</tr>
			</table>
		</body>
		</html>
		";


	}

	close (OUT4);

	system ("$input_dir//$file_name"."_features.html");

	#close everything
	@word = ();
	$output_text = "";

}

1;
