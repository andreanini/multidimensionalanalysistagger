#Subroutine to create the text type graph
sub texttype_graph {

	use Data::Dump 'pp';
	use Chart::Composite;
	use Chart::Points;
	use Chart::LinesPoints;

	#Add the arrays elements for Biber's text types

	@C1 = (47*0.1, -1, -5.8, 1, -4);
	@C2 = (32*0.1, -0.5, -4, 1, -3);
	@C3 = (-17*0.1, -2.7, 3.7, -2, 9.3);
	@C4 = (-20*0.1, -2, 4.5, -3, 2);
	@C5 = (5*0.1, 6.7, -3.7, 1, -2.8);
	@C6 = (-12*0.1, 1.8, 0, -1, -0.5);
	@C7 = (0*0.1, -3, -13.5, -4.5, -3.9);
	@C8 = (4.8*0.1, -2, 2, 4, -1);

	#CHART BUILDING

	my $chart2 = new Chart::Points(2100, 1000); #the size of the window of the graph is given here
	$chart2->{'imagemap'} = 1;

	if (@files <= 3){

		for ($i=2; $i<@files; $i++) {

			foreach $x (sort keys %dimension) {

				if ($x ne "6") { #Dimension6 is not present in the text type calculation

					if ($x eq "1") {

						$dimension{$x}{$files[$i]} = $dimension{$x}{$files[$i]} * 0.1;

					}

					push @values2, $dimension{$x}{$files[$i]};
				}
			}

			@labels2 = ("Dimension1 - Involved vs Informational Discourse", "Dimension2 - Narrative vs Non-Narrative Concerns", "Dimension3 - Explicit vs Situation-Dependent Reference", "Dimension4 - Overt Expression of Persuasion", "Dimension5 - Abstract vs Non-Abstract Information");

			$chart2->add_dataset(@labels2); #feed the data in Chart
			$chart2->add_dataset(@values2);
			$chart2->add_dataset(@C1);
			$chart2->add_dataset(@C2);
			$chart2->add_dataset(@C3);
			$chart2->add_dataset(@C4);
			$chart2->add_dataset(@C5);
			$chart2->add_dataset(@C6);
			$chart2->add_dataset(@C7);
			$chart2->add_dataset(@C8);


			my %property2; #hash used to feed the properties of the graph

			$property2{'title'} = "Text types - Closest text type: $text_type";
			$property2{'x_label'} = "Text types";
			$property2{'y_label'} = "Score";
			$property2{'legend'} = "none";
			$property2{'colors'} = {'dataset0' => [0, 170, 255]};
			$chart2->set(%property2);

			## PIECE OF CODE GIVEN BY PERLMONK FOR ADDING LABELS##
			# create GD image
			my $img = GD::Image->new($chart2->scalar_png);
			my $imagemap_data = $chart2->imagemap_dump();

			# add labels
			my $black = $img->colorAllocate(0,0,0);
			@legend = ("$files[$i]", "Intimate interpersonal interaction", "Informational interaction", "Scientific exposition", "Learned exposition", "Imaginative narrative", "General narrative exposition", "Situated reportage", "Involved persuasion");

			for my $v (1..9){

				for my $j (0..10){

					my $text = $legend[$v-1];
					my ($x,$y)  = @{$imagemap_data->[$v][$j]};
					$img->string(gdSmallFont,$x-10,$y-10,$text,$black);

				}
			}

			open (PNG, ">$dir/Statistics/Types_$folders[$#folders].png") or die;
			binmode PNG;
			print PNG $img->png;
			close PNG;

		}

	} else {

		foreach $x (sort keys %dimension_corpus) {

			if ($x ne "6") {

				if ($x eq "1") {

					$dimension_corpus{$x} = $dimension_corpus{$x} * 0.1;

				}

				push @values2, $dimension_corpus{$x};
			}
		}

		@labels2 = ("Dimension1 - Involved vs Informational Discourse", "Dimension2 - Narrative vs Non-Narrative Concerns", "Dimension3 - Explicit vs Situation-Dependent Reference", "Dimension4 - Overt Expression of Persuasion", "Dimension5 - Abstract vs Non-Abstract Information");

		$chart2->add_dataset(@labels2); #feed the data in Chart
		$chart2->add_dataset(@values2);
		$chart2->add_dataset(@C1);
		$chart2->add_dataset(@C2);
		$chart2->add_dataset(@C3);
		$chart2->add_dataset(@C4);
		$chart2->add_dataset(@C5);
		$chart2->add_dataset(@C6);
		$chart2->add_dataset(@C7);
		$chart2->add_dataset(@C8);

		my %property2; #hash used to feed the properties of the graph

		$property2{'title'} = "Text types - Closest text type: $text_type";
		$property2{'x_label'} = "Text types";
		$property2{'y_label'} = "Score";
		$property2{'legend'} = "none";
		$property2{'colors'} = {'dataset0' => [0, 170, 255]};
		$chart2->set(%property2);

		## PIECE OF CODE GIVEN BY PERLMONK FOR ADDING LABELS##
			# create GD image
			my $img = GD::Image->new($chart2->scalar_png);
			my $imagemap_data = $chart2->imagemap_dump();

			# add labels
			my $black = $img->colorAllocate(0,0,0);
			@legend = ("$corpus_name", "Intimate interpersonal interaction", "Informational interaction", "Scientific exposition", "Learned exposition", "Imaginative narrative", "General narrative exposition", "Situated reportage", "Involved persuasion");

			for my $v (1..9){

				for my $j (0..10){

					my $text = $legend[$v-1];
					my ($x,$y)  = @{$imagemap_data->[$v][$j]};
					$img->string(gdSmallFont,$x-10,$y-10,$text,$black);

				}
			}

			open (PNG, ">$dir/Statistics/Types_$folders[$#folders].png") or die;
			binmode PNG;
			print PNG $img->png;
			close PNG;

	}

	#close everything
	@values2 = ();
}

1;
