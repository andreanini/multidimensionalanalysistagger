#This soubroutine creates the graphs that visualise the dimensions
sub dimensions_graph {

	use GD;
	use Chart::Base;
	use Chart::ErrorBars;

	$dimensions_window->Show();
	$dimensions_window->DoModal(1);

	#{-----------------------------------------DIMENSION 1 GRAPH

	if ($db_dimension_check = $db_dim1->GetCheck() == 1) {

		#Add the arrays elements for Biber's genres

		@dim1 = (35.3, -4.3, 2.2, 19.5, -0.8, -15.1, -14.9, -18.1);
		@dim1_max = (18.8, (16.9 - $dim1[1]), 12.6, 7.5, -23.1, (-3.1 - $dim1[5]), 22, (-9.1 - $dim1[7]));
		@dim1_min = (17.6, ($dim1[1] - -19.6), -9.5, 5.7, -18.8, ($dim1[5] - -24.1), -11.6, ($dim1[7] - -26.3));


		#CHART BUILDING

		my $chart = new Chart::ErrorBars(1200, 1000); #the size of the window of the graph is given here

		if (@files <= 3){ #graph for one file only

			for ($i=2; $i<@files; $i++) {


				push @dim1, $dimension{"1"}{$files[$i]};
				push @dim1_min, 0;
				push @dim1_max, 0;


				@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$files[$i]");

				$chart->add_dataset(@labels); #feed the data in Chart

				$chart->add_dataset(@dim1);
				$chart->add_dataset(@dim1_max);
				$chart->add_dataset(@dim1_min);

				%genre_finder = ( #this hash calculates the differences between the input and Biber's genres

							"Conversations" => sqrt(($dimension{"1"}{$files[$i]} - $dim1[0])**2),
							"Broadcasts" => sqrt(($dimension{"1"}{$files[$i]} - $dim1[1])**2),
							"Prepared speeches" => sqrt(($dimension{"1"}{$files[$i]} - $dim1[2])**2),
							"Personal letters" => sqrt(($dimension{"1"}{$files[$i]} - $dim1[3])**2),
							"General fiction" => sqrt(($dimension{"1"}{$files[$i]} - $dim1[4])**2),
							"Press reportage" => sqrt(($dimension{"1"}{$files[$i]} - $dim1[5])**2),
							"Academic prose" => sqrt(($dimension{"1"}{$files[$i]} - $dim1[6])**2),
							"Official documents" => sqrt(($dimension{"1"}{$files[$i]} - $dim1[7])**2),
				);


				@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

				my %property; #hash used to feed the properties of the graph

				$property{'title'} = "Dimension 1 - Involved vs Informational Production - Closest genre: $closest_genre[0]";
				$property{'max_val'} = 60;
				$property{'x_label'} = "Genres";
				$property{'y_label'} = "Score";
				$property{'colors'} = {'dataset0' => [0, 170, 255]};
				$property{'legend_labels'} = ["Dimension 1"];
				$chart->set(%property);

				$chart->png("$dir/Statistics/Dimension1_$folders[$#folders].png");


			}

		} else { #graph for one whole corpus

			for ($i=2; $i<@files; $i++) { #this loop is needed only to push everything to an array in order to find min and max

				push @min_max, $dimension{"1"}{$files[$i]};

			}

			@min_max = sort { $a <=> $b } @min_max; #sort the array of dimension 1

			push @dim1, $dimension_corpus{"1"};
			push @dim1_max, $min_max[-1] - $dimension_corpus{"1"};
			push @dim1_min, $dimension_corpus{"1"} - $min_max[0];

			@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$corpus_name");

			$chart->add_dataset(@labels); #feed the data in Chart

			$chart->add_dataset(@dim1);
			$chart->add_dataset(@dim1_max);
			$chart->add_dataset(@dim1_min);

			%genre_finder = ( #this hash calculates the differences between the input and Biber's genres
						"Conversations" => sqrt(($dimension_corpus{"1"} - $dim1[0])**2),
						"Broadcasts" => sqrt(($dimension_corpus{"1"} - $dim1[1])**2),
						"Prepared speeches" => sqrt(($dimension_corpus{"1"} - $dim1[2])**2),
						"Personal letters" => sqrt(($dimension_corpus{"1"} - $dim1[3])**2),
						"General fiction" => sqrt(($dimension_corpus{"1"} - $dim1[4])**2),
						"Press reportage" => sqrt(($dimension_corpus{"1"} - $dim1[5])**2),
						"Academic prose" => sqrt(($dimension_corpus{"1"} - $dim1[6])**2),
						"Official documents" => sqrt(($dimension_corpus{"1"} - $dim1[7])**2),

			);


			@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

			my %property; #hash used to feed the properties of the graph

			$property{'title'} = "Dimension 1 - Involved vs Informational Production - Closest genre: $closest_genre[0]";
			$property{'max_val'} = 60;
			$property{'x_label'} = "Genres";
			$property{'y_label'} = "Score";
			$property{'colors'} = {'dataset0' => [0, 170, 255]};
			$property{'legend_labels'} = ["Dimension 1"];
			$chart->set(%property);

			$chart->png("$dir/Statistics/Dimension1_$folders[$#folders].png");


		}



		#close everything
		@values = ();
		@min_max = ();
		@closest_genre = ();
		undef %genre_finder;

	}
	#}


	#{-----------------------------------------DIMENSION 2 GRAPH

	if ($db_dimension_check = $db_dim2->GetCheck() == 1) {

		#Add the arrays elements for Biber's genres

		@dim2 = (-0.6, -3.3, 0.7, 0.3, 5.9, 0.4, -2.6, -2.9);
		@dim2_max = ((4 - $dim2[0]), (-0.6 - $dim2[1]), (6.1 - $dim2[2]), (1.7 - $dim2[3]), (15.6 - $dim2[4]), (7.7 - $dim2[5]), (5.3 - $dim2[6]), (-1.5 - $dim2[7]));
		@dim2_min = (($dim2[0] - -4.4), ($dim2[1] - -5.2), ($dim2[2] - -4.9), ($dim2[3] - -0.9), ($dim2[4] - 1.2), ($dim2[5] - -3.2), ($dim2[6] - -6.2), ($dim2[7] - -5.4));


		#CHART BUILDING

		my $chart = new Chart::ErrorBars(1200, 1000); #the size of the window of the graph is given here

		if (@files <= 3){ #graph for one file only

			for ($i=2; $i<@files; $i++) {


				push @dim2, $dimension{"2"}{$files[$i]};
				push @dim2_min, 0;
				push @dim2_max, 0;


				@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$files[$i]");

				$chart->add_dataset(@labels); #feed the data in Chart

				$chart->add_dataset(@dim2);
				$chart->add_dataset(@dim2_max);
				$chart->add_dataset(@dim2_min);

				%genre_finder = ( #this hash calculates the differences between the input and Biber's genres

							"Conversations" => sqrt(($dimension{"2"}{$files[$i]} - $dim2[0])**2),
							"Broadcasts" => sqrt(($dimension{"2"}{$files[$i]} - $dim2[1])**2),
							"Prepared speeches" => sqrt(($dimension{"2"}{$files[$i]} - $dim2[2])**2),
							"Personal letters" => sqrt(($dimension{"2"}{$files[$i]} - $dim2[3])**2),
							"General fiction" => sqrt(($dimension{"2"}{$files[$i]} - $dim2[4])**2),
							"Press reportage" => sqrt(($dimension{"2"}{$files[$i]} - $dim2[5])**2),
							"Academic prose" => sqrt(($dimension{"2"}{$files[$i]} - $dim2[6])**2),
							"Official documents" => sqrt(($dimension{"2"}{$files[$i]} - $dim2[7])**2),
				);


				@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

				my %property; #hash used to feed the properties of the graph

				$property{'title'} = "Dimension 2 - Narrative vs Non-Narrative Concerns - Closest genre: $closest_genre[0]";
				$property{'x_label'} = "Genres";
				$property{'y_label'} = "Score";
				$property{'colors'} = {'dataset0' => [153, 153, 0]};
				$property{'legend_labels'} = ["Dimension 2"];
				$chart->set(%property);

				$chart->png("$dir/Statistics/Dimension2_$folders[$#folders].png");


			}

		} else { #graph for one whole corpus

			for ($i=2; $i<@files; $i++) { #this loop is needed only to push everything to an array in order to find min and max

				push @min_max, $dimension{"2"}{$files[$i]};

			}

			@min_max = sort { $a <=> $b } @min_max; #sort the array of dimension 2

			push @dim2, $dimension_corpus{"2"};
			push @dim2_max, $min_max[-1] - $dimension_corpus{"2"};
			push @dim2_min, $dimension_corpus{"2"} - $min_max[0];

			@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$corpus_name");

			$chart->add_dataset(@labels); #feed the data in Chart

			$chart->add_dataset(@dim2);
			$chart->add_dataset(@dim2_max);
			$chart->add_dataset(@dim2_min);

			%genre_finder = ( #this hash calculates the differences between the input and Biber's genres
						"Conversations" => sqrt(($dimension_corpus{"2"} - $dim2[0])**2),
						"Broadcasts" => sqrt(($dimension_corpus{"2"} - $dim2[1])**2),
						"Prepared speeches" => sqrt(($dimension_corpus{"2"} - $dim2[2])**2),
						"Personal letters" => sqrt(($dimension_corpus{"2"} - $dim2[3])**2),
						"General fiction" => sqrt(($dimension_corpus{"2"} - $dim2[4])**2),
						"Press reportage" => sqrt(($dimension_corpus{"2"} - $dim2[5])**2),
						"Academic prose" => sqrt(($dimension_corpus{"2"} - $dim2[6])**2),
						"Official documents" => sqrt(($dimension_corpus{"2"} - $dim2[7])**2),

			);


			@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

			my %property; #hash used to feed the properties of the graph

			$property{'title'} = "Dimension 2 - Narrative vs Non-Narrative Concerns - Closest genre: $closest_genre[0]";
			$property{'x_label'} = "Genres";
			$property{'y_label'} = "Score";
			$property{'colors'} = {'dataset0' => [153, 153, 0]};
			$property{'legend_labels'} = ["Dimension 2"];
			$chart->set(%property);

			$chart->png("$dir/Statistics/Dimension2_$folders[$#folders].png");


		}



		#close everything
		@values = ();
		@min_max = ();
		@closest_genre = ();
		undef %genre_finder;

	}

	#}


	#{-----------------------------------------DIMENSION 3 GRAPH

	if ($db_dimension_check = $db_dim3->GetCheck() == 1) {

		#Add the arrays elements for Biber's genres

		@dim3 = (-3.9, -9, 0.3, -3.6, -3.1, -0.3, 4.2, 7.3);
		@dim3_max = ((1.6 - $dim3[0]), (-2.2 - $dim3[1]), (6.1 - $dim3[2]), (-1.3 - $dim3[3]), (1 - $dim3[4]), (6.5 - $dim3[5]), (18.6 - $dim3[6]), (13.4 - $dim3[7]));
		@dim3_min = (($dim3[0] - -10.5), ($dim3[1] - -15.8), ($dim3[2] - -5.6), ($dim3[3] - -6.6), ($dim3[4] - -8.2), ($dim3[5] - -6.2), ($dim3[6] - -5.8), ($dim3[7] - 2.1));


		#CHART BUILDING

		my $chart = new Chart::ErrorBars(1200, 1000); #the size of the window of the graph is given here

		if (@files <= 3){ #graph for one file only

			for ($i=2; $i<@files; $i++) {


				push @dim3, $dimension{"3"}{$files[$i]};
				push @dim3_min, 0;
				push @dim3_max, 0;


				@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$files[$i]");

				$chart->add_dataset(@labels); #feed the data in Chart

				$chart->add_dataset(@dim3);
				$chart->add_dataset(@dim3_max);
				$chart->add_dataset(@dim3_min);

				%genre_finder = ( #this hash calculates the differences between the input and Biber's genres

							"Conversations" => sqrt(($dimension{"3"}{$files[$i]} - $dim3[0])**2),
							"Broadcasts" => sqrt(($dimension{"3"}{$files[$i]} - $dim3[1])**2),
							"Prepared speeches" => sqrt(($dimension{"3"}{$files[$i]} - $dim3[2])**2),
							"Personal letters" => sqrt(($dimension{"3"}{$files[$i]} - $dim3[3])**2),
							"General fiction" => sqrt(($dimension{"3"}{$files[$i]} - $dim3[4])**2),
							"Press reportage" => sqrt(($dimension{"3"}{$files[$i]} - $dim3[5])**2),
							"Academic prose" => sqrt(($dimension{"3"}{$files[$i]} - $dim3[6])**2),
							"Official documents" => sqrt(($dimension{"3"}{$files[$i]} - $dim3[7])**2),
				);


				@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

				my %property; #hash used to feed the properties of the graph

				$property{'title'} = "Dimension 3 - Explicit vs Situation-Dependent Reference - Closest genre: $closest_genre[0]";
				$property{'x_label'} = "Genres";
				$property{'y_label'} = "Score";
				$property{'colors'} = {'dataset0' => [255, 160, 122]};
				$property{'legend_labels'} = ["Dimension 3"];
				$chart->set(%property);

				$chart->png("$dir/Statistics/Dimension3_$folders[$#folders].png");


			}

		} else { #graph for one whole corpus

			for ($i=2; $i<@files; $i++) { #this loop is needed only to push everything to an array in order to find min and max

				push @min_max, $dimension{"3"}{$files[$i]};

			}

			@min_max = sort { $a <=> $b } @min_max; #sort the array of dimension 3

			push @dim3, $dimension_corpus{"3"};
			push @dim3_max, $min_max[-1] - $dimension_corpus{"3"};
			push @dim3_min, $dimension_corpus{"3"} - $min_max[0];

			@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$corpus_name");

			$chart->add_dataset(@labels); #feed the data in Chart

			$chart->add_dataset(@dim3);
			$chart->add_dataset(@dim3_max);
			$chart->add_dataset(@dim3_min);

			%genre_finder = ( #this hash calculates the differences between the input and Biber's genres
						"Conversations" => sqrt(($dimension_corpus{"3"} - $dim3[0])**2),
						"Broadcasts" => sqrt(($dimension_corpus{"3"} - $dim3[1])**2),
						"Prepared speeches" => sqrt(($dimension_corpus{"3"} - $dim3[2])**2),
						"Personal letters" => sqrt(($dimension_corpus{"3"} - $dim3[3])**2),
						"General fiction" => sqrt(($dimension_corpus{"3"} - $dim3[4])**2),
						"Press reportage" => sqrt(($dimension_corpus{"3"} - $dim3[5])**2),
						"Academic prose" => sqrt(($dimension_corpus{"3"} - $dim3[6])**2),
						"Official documents" => sqrt(($dimension_corpus{"3"} - $dim3[7])**2),

			);


			@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

			my %property; #hash used to feed the properties of the graph

			$property{'title'} = "Dimension 3 - Explicit vs Situation-Dependent Reference - Closest genre: $closest_genre[0]";
			$property{'x_label'} = "Genres";
			$property{'y_label'} = "Score";
			$property{'colors'} = {'dataset0' => [255, 160, 122]};
			$property{'legend_labels'} = ["Dimension 3"];
			$chart->set(%property);

			$chart->png("$dir/Statistics/Dimension3_$folders[$#folders].png");


		}



		#close everything
		@values = ();
		@min_max = ();
		@closest_genre = ();
		undef %genre_finder;

	}

	#}


	#{-----------------------------------------DIMENSION 4 GRAPH

	if ($db_dimension_check = $db_dim4->GetCheck() == 1) {

		#Add the arrays elements for Biber's genres

		@dim4 = (-0.3, -4.4, 0.4, 1.5, 0.9, -0.7, -0.5, -0.2);
		@dim4_max = ((6.5 - $dim4[0]), (-0.3 - $dim4[1]), (11.2 - $dim4[2]), (6.4 - $dim4[3]), (7.2 - $dim4[4]), (5.7 - $dim4[5]), (17.5 - $dim4[6]), (8.7 - $dim4[7]));
		@dim4_min = (($dim4[0] - -5.2), ($dim4[1] - -6.9), ($dim4[2] - -4.4), ($dim4[3] - -1.6), ($dim4[4] - -3.2), ($dim4[5] - -6), ($dim4[6] - -7.1), ($dim4[7] - -8.4));


		#CHART BUILDING

		my $chart = new Chart::ErrorBars(1200, 1000); #the size of the window of the graph is given here

		if (@files <= 3){ #graph for one file only

			for ($i=2; $i<@files; $i++) {


				push @dim4, $dimension{"4"}{$files[$i]};
				push @dim4_min, 0;
				push @dim4_max, 0;


				@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$files[$i]");

				$chart->add_dataset(@labels); #feed the data in Chart

				$chart->add_dataset(@dim4);
				$chart->add_dataset(@dim4_max);
				$chart->add_dataset(@dim4_min);

				%genre_finder = ( #this hash calculates the differences between the input and Biber's genres

							"Conversations" => sqrt(($dimension{"4"}{$files[$i]} - $dim4[0])**2),
							"Broadcasts" => sqrt(($dimension{"4"}{$files[$i]} - $dim4[1])**2),
							"Prepared speeches" => sqrt(($dimension{"4"}{$files[$i]} - $dim4[2])**2),
							"Personal letters" => sqrt(($dimension{"4"}{$files[$i]} - $dim4[3])**2),
							"General fiction" => sqrt(($dimension{"4"}{$files[$i]} - $dim4[4])**2),
							"Press reportage" => sqrt(($dimension{"4"}{$files[$i]} - $dim4[5])**2),
							"Academic prose" => sqrt(($dimension{"4"}{$files[$i]} - $dim4[6])**2),
							"Official documents" => sqrt(($dimension{"4"}{$files[$i]} - $dim4[7])**2),
				);


				@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

				my %property; #hash used to feed the properties of the graph

				$property{'title'} = "Dimension 4 - Overt Expression of Persuasion - Closest genre: $closest_genre[0]";
				$property{'x_label'} = "Genres";
				$property{'y_label'} = "Score";
				$property{'colors'} = {'dataset0' => [255, 0, 255]};
				$property{'legend_labels'} = ["Dimension 4"];
				$chart->set(%property);

				$chart->png("$dir/Statistics/Dimension4_$folders[$#folders].png");


			}

		} else { #graph for one whole corpus

			for ($i=2; $i<@files; $i++) { #this loop is needed only to push everything to an array in order to find min and max

				push @min_max, $dimension{"4"}{$files[$i]};

			}

			@min_max = sort { $a <=> $b } @min_max; #sort the array of dimension 4

			push @dim4, $dimension_corpus{"4"};
			push @dim4_max, $min_max[-1] - $dimension_corpus{"4"};
			push @dim4_min, $dimension_corpus{"4"} - $min_max[0];

			@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$corpus_name");

			$chart->add_dataset(@labels); #feed the data in Chart

			$chart->add_dataset(@dim4);
			$chart->add_dataset(@dim4_max);
			$chart->add_dataset(@dim4_min);

			%genre_finder = ( #this hash calculates the differences between the input and Biber's genres
						"Conversations" => sqrt(($dimension_corpus{"4"} - $dim4[0])**2),
						"Broadcasts" => sqrt(($dimension_corpus{"4"} - $dim4[1])**2),
						"Prepared speeches" => sqrt(($dimension_corpus{"4"} - $dim4[2])**2),
						"Personal letters" => sqrt(($dimension_corpus{"4"} - $dim4[3])**2),
						"General fiction" => sqrt(($dimension_corpus{"4"} - $dim4[4])**2),
						"Press reportage" => sqrt(($dimension_corpus{"4"} - $dim4[5])**2),
						"Academic prose" => sqrt(($dimension_corpus{"4"} - $dim4[6])**2),
						"Official documents" => sqrt(($dimension_corpus{"4"} - $dim4[7])**2),

			);


			@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

			my %property; #hash used to feed the properties of the graph

			$property{'title'} = "Dimension 4 - Overt Expression of Persuasion - Closest genre: $closest_genre[0]";
			$property{'x_label'} = "Genres";
			$property{'y_label'} = "Score";
			$property{'colors'} = {'dataset0' => [255, 0, 255]};
			$property{'legend_labels'} = ["Dimension 4"];
			$chart->set(%property);

			$chart->png("$dir/Statistics/Dimension4_$folders[$#folders].png");


		}



		#close everything
		@values = ();
		@min_max = ();
		@closest_genre = ();
		undef %genre_finder;

	}

	#}


	#{-----------------------------------------DIMENSION 5 GRAPH

	if ($db_dimension_check = $db_dim5->GetCheck() == 1) {

		#Add the arrays elements for Biber's genres

		@dim5 = (-3.2, -1.7, -1.9, -2.8, -2.5, 0.6, 5.5, 4.7);
		@dim5_max = ((0.1 - $dim5[0]), (5.4 - $dim5[1]), (1 - $dim5[2]), (0.5 - $dim5[3]), (1.5 - $dim5[4]), (5.5 - $dim5[5]), (16.8 - $dim5[6]), (8.7 - $dim5[7]));
		@dim5_min = (($dim5[0] - -4.5), ($dim5[1] - -4.7), ($dim5[2] - -3.9), ($dim5[3] - -4.8), ($dim5[4] - -4.8), ($dim5[5] - -4.4), ($dim5[6] - -2.4), ($dim5[7] - 0.6));


		#CHART BUILDING

		my $chart = new Chart::ErrorBars(1200, 1000); #the size of the window of the graph is given here

		if (@files <= 3){ #graph for one file only

			for ($i=2; $i<@files; $i++) {


				push @dim5, $dimension{"5"}{$files[$i]};
				push @dim5_min, 0;
				push @dim5_max, 0;


				@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$files[$i]");

				$chart->add_dataset(@labels); #feed the data in Chart

				$chart->add_dataset(@dim5);
				$chart->add_dataset(@dim5_max);
				$chart->add_dataset(@dim5_min);

				%genre_finder = ( #this hash calculates the differences between the input and Biber's genres

							"Conversations" => sqrt(($dimension{"5"}{$files[$i]} - $dim5[0])**2),
							"Broadcasts" => sqrt(($dimension{"5"}{$files[$i]} - $dim5[1])**2),
							"Prepared speeches" => sqrt(($dimension{"5"}{$files[$i]} - $dim5[2])**2),
							"Personal letters" => sqrt(($dimension{"5"}{$files[$i]} - $dim5[3])**2),
							"General fiction" => sqrt(($dimension{"5"}{$files[$i]} - $dim5[4])**2),
							"Press reportage" => sqrt(($dimension{"5"}{$files[$i]} - $dim5[5])**2),
							"Academic prose" => sqrt(($dimension{"5"}{$files[$i]} - $dim5[6])**2),
							"Official documents" => sqrt(($dimension{"5"}{$files[$i]} - $dim5[7])**2),
				);


				@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

				my %property; #hash used to feed the properties of the graph

				$property{'title'} = "Dimension 5 - Abstract vs Non-Abstract Information - Closest genre: $closest_genre[0]";
				$property{'x_label'} = "Genres";
				$property{'y_label'} = "Score";
				$property{'colors'} = {'dataset0' => [50, 205, 50]};
				$property{'legend_labels'} = ["Dimension 5"];
				$chart->set(%property);

				$chart->png("$dir/Statistics/Dimension5_$folders[$#folders].png");


			}

		} else { #graph for one whole corpus

			for ($i=2; $i<@files; $i++) { #this loop is needed only to push everything to an array in order to find min and max

				push @min_max, $dimension{"5"}{$files[$i]};

			}

			@min_max = sort { $a <=> $b } @min_max; #sort the array of dimension 5

			push @dim5, $dimension_corpus{"5"};
			push @dim5_max, $min_max[-1] - $dimension_corpus{"5"};
			push @dim5_min, $dimension_corpus{"5"} - $min_max[0];

			@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$corpus_name");

			$chart->add_dataset(@labels); #feed the data in Chart

			$chart->add_dataset(@dim5);
			$chart->add_dataset(@dim5_max);
			$chart->add_dataset(@dim5_min);

			%genre_finder = ( #this hash calculates the differences between the input and Biber's genres
						"Conversations" => sqrt(($dimension_corpus{"5"} - $dim5[0])**2),
						"Broadcasts" => sqrt(($dimension_corpus{"5"} - $dim5[1])**2),
						"Prepared speeches" => sqrt(($dimension_corpus{"5"} - $dim5[2])**2),
						"Personal letters" => sqrt(($dimension_corpus{"5"} - $dim5[3])**2),
						"General fiction" => sqrt(($dimension_corpus{"5"} - $dim5[4])**2),
						"Press reportage" => sqrt(($dimension_corpus{"5"} - $dim5[5])**2),
						"Academic prose" => sqrt(($dimension_corpus{"5"} - $dim5[6])**2),
						"Official documents" => sqrt(($dimension_corpus{"5"} - $dim5[7])**2),

			);


			@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

			my %property; #hash used to feed the properties of the graph

			$property{'title'} = "Dimension 5 - Abstract vs Non-Abstract Information - Closest genre: $closest_genre[0]";
			$property{'x_label'} = "Genres";
			$property{'y_label'} = "Score";
			$property{'colors'} = {'dataset0' => [50, 205, 50]};
			$property{'legend_labels'} = ["Dimension 5"];
			$chart->set(%property);

			$chart->png("$dir/Statistics/Dimension5_$folders[$#folders].png");


		}



		#close everything
		@values = ();
		@min_max = ();
		@closest_genre = ();
		undef %genre_finder;

	}

	#}


	#{-----------------------------------------DIMENSION 6 GRAPH

	if ($db_dimension_check = $db_dim6->GetCheck() == 1) {

		#Add the arrays elements for Biber's genres

		@dim6 = (0.3, -1.3, 3.4, -1.4, -1.6, -0.9, 0.5, -0.9);
		@dim6_max = ((6.5 - $dim6[0]), (1.7 - $dim6[1]), (7.5 - $dim6[2]), (0.3 - $dim6[3]), (2.7 - $dim6[4]), (3.9 - $dim6[5]), (9.2 - $dim6[6]), (2.7 - $dim6[7]));
		@dim6_min = (($dim6[0] - -3.6), ($dim6[1] - -3.6), ($dim6[2] - -0.8), ($dim6[3] - -3.7), ($dim6[4] - -4.3), ($dim6[5] - -4), ($dim6[6] - -3.3), ($dim6[7] - -3.8));


		#CHART BUILDING

		my $chart = new Chart::ErrorBars(1200, 1000); #the size of the window of the graph is given here

		if (@files <= 3){ #graph for one file only

			for ($i=2; $i<@files; $i++) {


				push @dim6, $dimension{"6"}{$files[$i]};
				push @dim6_min, 0;
				push @dim6_max, 0;


				@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$files[$i]");

				$chart->add_dataset(@labels); #feed the data in Chart

				$chart->add_dataset(@dim6);
				$chart->add_dataset(@dim6_max);
				$chart->add_dataset(@dim6_min);

				%genre_finder = ( #this hash calculates the differences between the input and Biber's genres

							"Conversations" => sqrt(($dimension{"6"}{$files[$i]} - $dim6[0])**2),
							"Broadcasts" => sqrt(($dimension{"6"}{$files[$i]} - $dim6[1])**2),
							"Prepared speeches" => sqrt(($dimension{"6"}{$files[$i]} - $dim6[2])**2),
							"Personal letters" => sqrt(($dimension{"6"}{$files[$i]} - $dim6[3])**2),
							"General fiction" => sqrt(($dimension{"6"}{$files[$i]} - $dim6[4])**2),
							"Press reportage" => sqrt(($dimension{"6"}{$files[$i]} - $dim6[5])**2),
							"Academic prose" => sqrt(($dimension{"6"}{$files[$i]} - $dim6[6])**2),
							"Official documents" => sqrt(($dimension{"6"}{$files[$i]} - $dim6[7])**2),
				);


				@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

				my %property; #hash used to feed the properties of the graph

				$property{'title'} = "Dimension 6 - On-Line Informational Elaboration - Closest genre: $closest_genre[0]";
				$property{'x_label'} = "Genres";
				$property{'y_label'} = "Score";
				$property{'colors'} = {'dataset0' => [153, 50, 204]};
				$property{'legend_labels'} = ["Dimension 6"];
				$chart->set(%property);

				$chart->png("$dir/Statistics/Dimension6_$folders[$#folders].png");


			}

		} else { #graph for one whole corpus

			for ($i=2; $i<@files; $i++) { #this loop is needed only to push everything to an array in order to find min and max

				push @min_max, $dimension{"6"}{$files[$i]};

			}

			@min_max = sort { $a <=> $b } @min_max; #sort the array of dimension 6

			push @dim6, $dimension_corpus{"6"};
			push @dim6_max, $min_max[-1] - $dimension_corpus{"6"};
			push @dim6_min, $dimension_corpus{"6"} - $min_max[0];

			@labels = ("Conversations", "Broadcasts", "Prepared speeches", "Personal letters", "General fiction", "Press reportage", "Academic prose", "Official documents", "$corpus_name");

			$chart->add_dataset(@labels); #feed the data in Chart

			$chart->add_dataset(@dim6);
			$chart->add_dataset(@dim6_max);
			$chart->add_dataset(@dim6_min);

			%genre_finder = ( #this hash calculates the differences between the input and Biber's genres
						"Conversations" => sqrt(($dimension_corpus{"6"} - $dim6[0])**2),
						"Broadcasts" => sqrt(($dimension_corpus{"6"} - $dim6[1])**2),
						"Prepared speeches" => sqrt(($dimension_corpus{"6"} - $dim6[2])**2),
						"Personal letters" => sqrt(($dimension_corpus{"6"} - $dim6[3])**2),
						"General fiction" => sqrt(($dimension_corpus{"6"} - $dim6[4])**2),
						"Press reportage" => sqrt(($dimension_corpus{"6"} - $dim6[5])**2),
						"Academic prose" => sqrt(($dimension_corpus{"6"} - $dim6[6])**2),
						"Official documents" => sqrt(($dimension_corpus{"6"} - $dim6[7])**2),

			);


			@closest_genre = sort { $genre_finder{$a} <=> $genre_finder{$b} } keys %genre_finder; #new array ordered by values of the hash

			my %property; #hash used to feed the properties of the graph

			$property{'title'} = "Dimension 6 - On-Line Informational Elaboration - Closest genre: $closest_genre[0]";
			$property{'x_label'} = "Genres";
			$property{'y_label'} = "Score";
			$property{'colors'} = {'dataset0' => [153, 50, 204]};
			$property{'legend_labels'} = ["Dimension 6"];
			$chart->set(%property);

			$chart->png("$dir/Statistics/Dimension6_$folders[$#folders].png");


		}



		#close everything
		@values = ();
		@min_max = ();
		@closest_genre = ();
		undef %genre_finder;

	}

	#}

}

1;
