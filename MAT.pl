use Win32::GUI();
use Win32::GUI::DropFiles;
use LWP::Simple;
Win32::SetChildShowWindow(0) if defined &Win32::SetChildShowWindow; #this command avoids windows to pop up during the stanford tagging
require 'Tagger_MAT.pl';
require 'count_only.pl';
require 'concordancer.pl';

$current_version = "1.3.2";


#{----------list of windows
$W1 = Win32::GUI::Window->new(
			-name  => "W1",
			-title => "Multidimensional analysis tagger v $current_version",
			-dialogui => 1,
			-pos   => [ 700, 100 ],
			-size  => [ 450, 270 ],
			-resizable => 0,
			-maximizebox => 0,
	);

$prompt_window = Win32::GUI::Window->new(
			-name  => "W2",
			-dialogui => 1,
			-title => "Multidimensional analysis tagger v $current_version",
			-pos   => [ 500, 250 ],
			-size  => [ 300, 100 ],
			-resizable => 0,
	);


$concordance_window = Win32::GUI::Window->new(
			-name  => "W3",
			-dialogui => 1,
			-title => "Choose the Dimensions to display",
			-pos   => [ 500, 250 ],
			-size  => [ 500, 200 ],
			-resizable => 0,
			-parent => $W1,
	);


$dimensions_window = Win32::GUI::Window->new(
			-name  => "W4",
			-dialogui => 1,
			-title => "Choose Dimension graphs",
			-pos   => [ 500, 250 ],
			-size  => [ 500, 200 ],
			-resizable => 0,
			-parent => $W1,
	);
#}


#{--------- prompt window for TTR
$textfield = $prompt_window->AddTextfield(
    -name   => "prompt",
	-text => "400",
	-number => 1,
    -left   => 150,
    -top    => 20,
    -width  => 40,
    -height => 20,
	-prompt => "Tokens for type/token ratio",
  );

$prompt_window->AddButton(
		-name => "OK",
		-text => "OK",
		-ok => 1,
		-pos  => [ 200, 20 ],
		-size  => [ 40, 20 ],
		-onClick => sub {
							$tokens_for_ttr = $prompt_window->prompt->Text();
							return -1;
						},

	);

#}


#{--------- prompt window for concordancer

$concordance_window->AddLabel (
				-text => "Dimension 1",
				-pos => [85, 42],
				-size => [200, 15],
				);

$cb_dim1 = $concordance_window->AddCheckbox(
					-pos => [55, 40],
					-size  => [ 30, 20 ],
				);



$concordance_window->AddLabel (
				-text => "Dimension 2",
				-pos => [225, 42],
				-size => [200, 15],
				);

$cb_dim2 = $concordance_window->AddCheckbox(
					-pos => [195, 40],
					-size  => [ 30, 20 ],
				);



$concordance_window->AddLabel (
				-text => "Dimension 3",
				-pos => [370, 42],
				-size => [200, 15],
				);

$cb_dim3 = $concordance_window->AddCheckbox(
					-pos => [340, 40],
					-size  => [ 30, 20 ],
				);



$concordance_window->AddLabel (
				-text => "Dimension 4",
				-pos => [85, 82],
				-size => [200, 15],
				);

$cb_dim4 = $concordance_window->AddCheckbox(
					-pos => [55, 80],
					-size  => [ 30, 20 ],
				);



$concordance_window->AddLabel (
				-text => "Dimension 5",
				-pos => [225, 82],
				-size => [200, 15],
				);

$cb_dim5 = $concordance_window->AddCheckbox(
					-pos => [195, 80],
					-size  => [ 30, 20 ],
				);



$concordance_window->AddLabel (
				-text => "Dimension 6",
				-pos => [370, 82],
				-size => [200, 15],
				);

$cb_dim6 = $concordance_window->AddCheckbox(
					-pos => [340, 80],
					-size  => [ 30, 20 ],
				);



$concordance_window->AddButton(
		-name => "Ok",
		-text => "Ok",
		-ok => 1,
		-pos  => [ 400, 120 ],
		-size  => [ 40, 20 ],
		-onClick => sub {
							$concordance_window->Hide();
							return -1;
						},

	);

#}

#{--------- prompt window for dimension graphs

$dimensions_window->AddLabel (
				-text => "Dimension 1",
				-pos => [85, 42],
				-size => [200, 15],
				);

$db_dim1 = $dimensions_window->AddCheckbox(
					-pos => [55, 40],
					-size  => [ 30, 20 ],
				);



$dimensions_window->AddLabel (
				-text => "Dimension 2",
				-pos => [225, 42],
				-size => [200, 15],
				);

$db_dim2 = $dimensions_window->AddCheckbox(
					-pos => [195, 40],
					-size  => [ 30, 20 ],
				);



$dimensions_window->AddLabel (
				-text => "Dimension 3",
				-pos => [370, 42],
				-size => [200, 15],
				);

$db_dim3 = $dimensions_window->AddCheckbox(
					-pos => [340, 40],
					-size  => [ 30, 20 ],
				);



$dimensions_window->AddLabel (
				-text => "Dimension 4",
				-pos => [85, 82],
				-size => [200, 15],
				);

$db_dim4 = $dimensions_window->AddCheckbox(
					-pos => [55, 80],
					-size  => [ 30, 20 ],
				);



$dimensions_window->AddLabel (
				-text => "Dimension 5",
				-pos => [225, 82],
				-size => [200, 15],
				);

$db_dim5 = $dimensions_window->AddCheckbox(
					-pos => [195, 80],
					-size  => [ 30, 20 ],
				);



$dimensions_window->AddLabel (
				-text => "Dimension 6",
				-pos => [370, 82],
				-size => [200, 15],
				);

$db_dim6 = $dimensions_window->AddCheckbox(
					-pos => [340, 80],
					-size  => [ 30, 20 ],
				);



$dimensions_window->AddButton(
		-name => "OK",
		-text => "OK",
		-ok => 1,
		-pos  => [ 400, 120 ],
		-size  => [ 40, 20 ],
		-onClick => sub {
							$dimensions_window->Hide();
							return -1;
						},

	);

#}

#{-----------icons
$icon = new Win32::GUI::Icon('icon.ico');
$W1->SetIcon($icon);
$prompt_window->SetIcon($icon);
$concordance_window->SetIcon($icon);
$dimensions_window->SetIcon($icon);
#}


#{-------------- main window
$tag_button = $W1->AddButton(
		-name => "Button1",
		-tip => "Tag a text or a folder of texts",
		-pos  => [ 55, 30 ],
		-bitmap  => new Win32::GUI::Bitmap('tag_img.bmp'),
		-size  => [ 60, 47 ],
		-acceptfiles => 1,
		-onMouseMove => sub {

							$tag_button -> SetImage(new Win32::GUI::Bitmap('tag_img2.bmp'));

						},
		-onMouseOut => sub {

							$tag_button -> SetImage(new Win32::GUI::Bitmap('tag_img.bmp'));

						},
		-onDropFiles => sub {

							($self, $dropObj) = @_;

							$input_dir  = $dropObj->GetDroppedFile(0);

							if ($input_dir !~ /.:/) { die ("Please select a folder or file\n"); } #fixes the error when the user closes the browsefolder window

							if ($input_dir =~ /\.txt/i) { #this is needed to allow the user to select files too

								@folders = split (/\\/, $input_dir); #the split can identify the name of the file thanks to the $#array variable

								$input_dir =~ s{(.:\\(.+\\)*).+(\.txt|\.TXT)}{$1};

								$dir = "$input_dir"."Results_$folders[$#folders]";

								if ( -d "$dir") { #Check if the analysis already exists

									$string_for_textfield = ' '; #Reset status
									$status->Change(-text => $string_for_textfield);
									die ("You have analysed this file already. To run a new analysis, move the old results in another folder\n");


								}

								mkdir $dir;

								system ("copy \"$input_dir$folders[$#folders]\" \"$dir\"");

								$folders[$#folders] =~ s{(\.txt|\.TXT)}{}; #this is needed to remove the .txt from the folder names when these are created


							} else { #this is if the user DOES select a folder

								$dir = $input_dir;

								@folders = split (/\\/, $input_dir); #the split can identify the name of the folder thanks to the $#array variable

								$corpus_name = "$folders[$#folders]";

								if ( -d "$dir/ST_$folders[$#folders]") { #Check if the analysis already exists

									$string_for_textfield = ' '; #Reset status
									$status->Change(-text => $string_for_textfield);
									die ("You have analysed this corpus already. To run a new analysis, move the old results in another folder\n");

								}

								$string_for_textfield = 'Loading...'; #Reset status
								$status->Change(-text => $string_for_textfield);

							}

							&Tagger_MAT;

					},
		-onClick => sub {
						$input_dir = Win32::GUI::BrowseForFolder(
							-includefiles => 1,
							-editbox => 1,
							-directory => $path,
							-title => "Choose a single plain text file OR a folder of only plain text files",
							);

						$path = $input_dir; #command to remember folder

						if ($input_dir !~ /.:/) { die ("Please select a folder or file\n"); } #fixes the error when the user closes the browsefolder window

						if ($input_dir =~ /\.txt/i) { #this is needed to allow the user to select files too

							@folders = split (/\\/, $input_dir); #the split can identify the name of the file thanks to the $#array variable

							$input_dir =~ s{(.:\\(.+\\)*).+(\.txt|\.TXT)}{$1};

							$dir = "$input_dir"."Results_$folders[$#folders]";

							if ( -d "$dir") { #Check if the analysis already exists

								$string_for_textfield = ' '; #Reset status
								$status->Change(-text => $string_for_textfield);
								die ("You have analysed this file already. To run a new analysis, move the old results in another folder\n");


							}

							mkdir $dir;

							system ("copy \"$input_dir$folders[$#folders]\" \"$dir\"");

							$folders[$#folders] =~ s{(\.txt|\.TXT)}{}; #this is needed to remove the .txt from the folder names when these are created


						} else { #this is if the user DOES select a folder

							$dir = $input_dir;

							@folders = split (/\\/, $input_dir); #the split can identify the name of the folder thanks to the $#array variable

							$corpus_name = "$folders[$#folders]";

							if ( -d "$dir/ST_$folders[$#folders]") { #Check if the analysis already exists

								$string_for_textfield = ' '; #Reset status
								$status->Change(-text => $string_for_textfield);
								die ("You have analysed this corpus already. To run a new analysis, move the old results in another folder\n");

							}

							$string_for_textfield = 'Loading...'; #Reset status
							$status->Change(-text => $string_for_textfield);

						}

						&Tagger_MAT;

						},
	);


$count_button = $W1->AddButton(
		-name => "Analyze",
		-tip => "Analyze a MAT text or a folder of MAT tagged texts",
		-pos  => [ 145, 30 ],
		-bitmap  => new Win32::GUI::Bitmap('count_img.bmp'),
		-size => [60, 46],
		-acceptfiles => 1,
		-onMouseMove => sub {

							$count_button -> SetImage(new Win32::GUI::Bitmap('count_img2.bmp'));

						},
		-onMouseOut => sub {

							$count_button -> SetImage(new Win32::GUI::Bitmap('count_img.bmp'));

						},
		-onDropFiles => sub {

							($self, $dropObj) = @_;

							$input_dir  = $dropObj->GetDroppedFile(0);

							if ($input_dir !~ /.:/) { die ("Please select a folder or file\n"); } #fixes the error when the user closes the browsefolder window

							if ($input_dir =~ /\.txt/i) { #this is needed to allow the user to select files too

								@folders = split (/\\/, $input_dir); #the split can identify the name of the file thanks to the $#array variable

								$input_dir =~ s{(.:\\(.+\\)*).+(\.txt|\.TXT)}{$1};

								$dir = "$input_dir"."Results_$folders[$#folders]";

								if ( -d "$dir") { #Check if the analysis already exists

									$string_for_textfield = ' '; #Reset status
									$status->Change(-text => $string_for_textfield);
									die ("You have analysed this file already. To run a new analysis, move the old results in another folder\n");


								}

								mkdir $dir;

								system ("copy \"$input_dir$folders[$#folders]\" \"$dir\"");

								$folders[$#folders] =~ s{(\.txt|\.TXT)}{}; #this is needed to remove the .txt from the folder names when these are created

							} else { #this is if the user DOES select a folder

								$dir = $input_dir;

								@folders = split (/\\/, $input_dir); #the split can identify the name of the folder thanks to the $#array variable

								$corpus_name = "$folders[$#folders]";

								if ( -d "$dir/Statistics") { #Check if the analysis already exists

									$string_for_textfield = ' '; #Reset status
									$status->Change(-text => $string_for_textfield);
									die ("You have analysed this corpus already. To run a new analysis, move the old results in another folder\n");

								}

								$string_for_textfield = 'Loading...'; #Reset status
								$status->Change(-text => $string_for_textfield);

							}

								&count_only;
								return 1;

						},
		-onClick => sub { $input_dir = Win32::GUI::BrowseForFolder(
							-includefiles => 1,
							-editbox => 1,
							-directory => $path,
							-title => "Choose a single MAT tagged text OR a folder of MAT tagged texts",
							);

						$path = $input_dir; #command to remember folder

						if ($input_dir !~ /.:/) { die ("Please select a folder or file\n"); } #fixes the error when the user closes the browsefolder window

						if ($input_dir =~ /\.txt/i) { #this is needed to allow the user to select files too

							@folders = split (/\\/, $input_dir); #the split can identify the name of the file thanks to the $#array variable

							$input_dir =~ s{(.:\\(.+\\)*).+(\.txt|\.TXT)}{$1};

							$dir = "$input_dir"."Results_$folders[$#folders]";

							if ( -d "$dir") { #Check if the analysis already exists

								$string_for_textfield = ' '; #Reset status
								$status->Change(-text => $string_for_textfield);
								die ("You have analysed this file already. To run a new analysis, move the old results in another folder\n");


							}

							mkdir $dir;

							system ("copy \"$input_dir$folders[$#folders]\" \"$dir\"");

							$folders[$#folders] =~ s{(\.txt|\.TXT)}{}; #this is needed to remove the .txt from the folder names when these are created

						} else { #this is if the user DOES select a folder

							$dir = $input_dir;

							@folders = split (/\\/, $input_dir); #the split can identify the name of the folder thanks to the $#array variable

							$corpus_name = "$folders[$#folders]";

							if ( -d "$dir/Statistics") { #Check if the analysis already exists

								$string_for_textfield = ' '; #Reset status
								$status->Change(-text => $string_for_textfield);
								die ("You have analysed this corpus already. To run a new analysis, move the old results in another folder\n");

							}

							$string_for_textfield = 'Loading...'; #Reset status
							$status->Change(-text => $string_for_textfield);

						}

							&count_only;
							return 1;
						},
	);

$tagcount_button = $W1->AddButton(
		-name => "Tag and analyze",
		-tip => "Tag and analyze a text or a folder of texts",
		-ok => 1,
		-default => 1,
		-pos  => [ 235, 30 ],
		-bitmap  => new Win32::GUI::Bitmap('tagcount_img.bmp'),
		-size  => [ 60, 47 ],
		-acceptfiles => 1,
		-onMouseMove => sub {

							$tagcount_button -> SetImage(new Win32::GUI::Bitmap('tagcount_img2.bmp'));

						},
		-onMouseOut => sub {

							$tagcount_button -> SetImage(new Win32::GUI::Bitmap('tagcount_img.bmp'));

						},
		-onDropFiles => sub {

							($self, $dropObj) = @_;

							$input_dir  = $dropObj->GetDroppedFile(0);

							if ($input_dir !~ /.:/) { die ("Please select a folder or file\n"); } #fixes the error when the user closes the browsefolder window

							if ($input_dir =~ /\.txt/i) { #this is needed to allow the user to select files too

							@folders = split (/\\/, $input_dir); #the split can identify the name of the file thanks to the $#array variable


							$input_dir =~ s{(.:\\(.+\\)*).+(\.txt|\.TXT)}{$1};


							$dir = "$input_dir"."Results_$folders[$#folders]";

							if ( -d "$dir") { #Check if the analysis already exists

								$string_for_textfield = ' '; #Reset status
								$status->Change(-text => $string_for_textfield);
								die ("You have analysed this file already. To run a new analysis, move the old results in another folder\n");

							}

							mkdir $dir;

							system ("copy \"$input_dir$folders[$#folders]\" \"$dir\"");

							$folders[$#folders] =~ s{(\.txt|\.TXT)}{}; #this is needed to remove the .txt from the folder names when these are created

						} else { #this is if the user DOES select a folder

							$dir = $input_dir;

							@folders = split (/\\/, $input_dir); #the split can identify the name of the folder thanks to the $#array variable

							$corpus_name = "$folders[$#folders]";

							if ( -d "$dir/ST_$folders[$#folders]") { #Check if the analysis already exists

								$string_for_textfield = ' '; #Reset status
								$status->Change(-text => $string_for_textfield);
								die ("You have analysed this corpus already. To run a new analysis, move the old results in another folder\n");

							}

							$string_for_textfield = 'Loading...'; #Reset status
							$status->Change(-text => $string_for_textfield);
						}

							&Tagger_MAT;
							&count_only;


						},
		-onClick => sub { $input_dir = Win32::GUI::BrowseForFolder(
							-includefiles => 1,
							-editbox => 1,
							-directory => $path,
							-title => "Choose a single plain text file OR a folder of only plain text files",
							);

							$path = $input_dir; #command to remember folder

							if ($input_dir !~ /.:/) { die ("Please select a folder or file\n"); } #fixes the error when the user closes the browsefolder window

							if ($input_dir =~ /\.txt/i) { #this is needed to allow the user to select files too

							@folders = split (/\\/, $input_dir); #the split can identify the name of the file thanks to the $#array variable


							$input_dir =~ s{(.:\\(.+\\)*).+(\.txt|\.TXT)}{$1};


							$dir = "$input_dir"."Results_$folders[$#folders]";

							if ( -d "$dir") { #Check if the analysis already exists

								$string_for_textfield = ' '; #Reset status
								$status->Change(-text => $string_for_textfield);
								die ("You have analysed this file already. To run a new analysis, move the old results in another folder\n");

							}

							mkdir $dir;

							system ("copy \"$input_dir$folders[$#folders]\" \"$dir\"");

							$folders[$#folders] =~ s{(\.txt|\.TXT)}{}; #this is needed to remove the .txt from the folder names when these are created

						} else { #this is if the user DOES select a folder

							$dir = $input_dir;

							@folders = split (/\\/, $input_dir); #the split can identify the name of the folder thanks to the $#array variable

							$corpus_name = "$folders[$#folders]";

							if ( -d "$dir/ST_$folders[$#folders]") { #Check if the analysis already exists

								$string_for_textfield = ' '; #Reset status
								$status->Change(-text => $string_for_textfield);
								die ("You have analysed this corpus already. To run a new analysis, move the old results in another folder\n");

							}

							$string_for_textfield = 'Loading...'; #Reset status
							$status->Change(-text => $string_for_textfield);

						}

							&Tagger_MAT;
							&count_only;

						},
	);


$src_button = $W1->AddButton(
		-name => "Concordance",
		-bitmap  => new Win32::GUI::Bitmap('src_img.bmp'),
		-tip => "Inspect a text for Dimensions features",
		-pos  => [ 325, 30],
		-size  => [ 60, 47 ],
		-acceptfiles => 1,
		-onMouseMove => sub {

							$src_button -> SetImage(new Win32::GUI::Bitmap('src_img2.bmp'));

						},
		-onMouseOut => sub {

							$src_button -> SetImage(new Win32::GUI::Bitmap('src_img.bmp'));

						},
		-onDropFiles => sub {

							($self, $dropObj) = @_;

							$dir  = $dropObj->GetDroppedFile(0);

							if ($dir !~ /.:/) { die ("Please select a folder or file\n"); } #fixes the error when the user closes the browsefolder window

							$input_dir = $dir;
							$file_name = $dir;

							@folders = split (/\\/, $input_dir); #the split can identify the name of the file thanks to the $#array variable

							$input_dir =~ s{(.:\\(.+\\)*).+(\.txt|\.TXT)}{$1};
							$file_name =~ s{(.:\\(.+\\)*)(.+)(\.txt|\.TXT)}{$3};

							&Concordancer;
						},
		-onClick => sub {
							$dir = Win32::GUI::BrowseForFolder(
							-includefiles => 1,
							-editbox => 1,
							-directory => $path,
							-title => "Choose a single MAT tagged text",
							);

							$path = $input_dir; #command to remember folder

							if ($dir !~ /.:/) { die ("Please select a folder or file\n"); } #fixes the error when the user closes the browsefolder window

							$input_dir = $dir;
							$file_name = $dir;

							@folders = split (/\\/, $input_dir); #the split can identify the name of the file thanks to the $#array variable

							$input_dir =~ s{(.:\\(.+\\)*).+(\.txt|\.TXT)}{$1};
							$file_name =~ s{(.:\\(.+\\)*)(.+)(\.txt|\.TXT)}{$3};

							&Concordancer;

						},
	);

$status = $W1->AddLabel(
				-text => " ",
				-pos  => [90, 210],
				-width  => 500,
				-height => 20,
				);

$progress_bar = $W1->AddProgressBar(
						-pos => [90, 180],
						-background => [0,255,85],
						-size => [250,20],
					);



#{ first setting: what to count
$W1->AddLabel (
				-text => "Count:",
				-pos => [90, 142],
				-size => [200, 15],
				);


$rb_biber = $W1->AddRadioButton(
					-pos => [135, 140],
					-size  => [ 30, 20 ],
					-group => 1,
					-checked => 1,
				);

$W1->AddLabel (
				-text => "Only VASW tags",
				-pos => [165, 142],
				-size => [200, 15],
				);

$rb_all = $W1->AddRadioButton(
					-pos => [270, 140],
					-size  => [ 30, 20 ],
				);
$W1->AddLabel (
				-text => "All tags",
				-pos => [300, 142],
				-size => [200, 15],
				);

#}


#{second settings: apply the correction
$W1->AddLabel (
				-text => "Zscore correction:",
				-pos => [90, 110],
				-size => [200, 15],
				);


$correction_yes = $W1->AddRadioButton(
					-pos => [185, 108],
					-size  => [ 30, 20 ],
					-group => 1,
				);

$W1->AddLabel (
				-text => "Yes",
				-pos => [215, 110],
				-size => [200, 15],
				);

$correction_no = $W1->AddRadioButton(
					-pos => [250, 108],
					-size  => [ 30, 20 ],
					-checked => 1,

				);
$W1->AddLabel (
				-text => "No",
				-pos => [280, 110],
				-size => [200, 15],
				);

#}

#}


$W1->Show();

#{-------------- checks for updates

$url = "https://sites.google.com/site/multidimensionaltagger/versions/current";

$status->Change(-text => "Checking for updates");

my $update_check = get($url);

if ($update_check !~ /$current_version<\/div>/ && $update_check ne "") {

	$status->Change(-text => "A new version of MAT is available");

	system ("start https://sites.google.com/site/multidimensionaltagger/versions");

} else {

	$status->Change(-text => "No updates available");

}

#}

Win32::GUI::Dialog();
