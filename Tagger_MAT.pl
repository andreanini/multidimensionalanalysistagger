#this subroutine contains the MAT tagger
sub Tagger_MAT {

	use Encode::Guess;
	require 'curly_correct.pl';




#-------------CHECK THAT THE FOLDER IS READY-----------------------------------------------

	opendir (DR, $dir) || die ("Cannot open directory\n");

	@files = readdir(DR);

	for ($i=2; $i<@files; $i++) { #Check that the folder is ok & Check that the folder does not contain Unicode files

		if ($files[$i] =~ /Results_/ && $files[$i] =~ /\.txt/i) { #this solves the bug of program not dying if the folder selected contains another Result folder

			die ("The folder selected contains other folders or files other than plain text. Please select a folder containing only plain texts (.txt) files\n");

		}

		if ($files[$i] !~ /\.txt/i && $files[$i] !~ /ST_$folders[$#folders]/ && $files[$i] !~ /MAT_$folders[$#folders]/) { #If even one of the elements of @files is not a .txt file then it dies

			die ("The folder selected contains other folders or files other than plain text. Please select a folder containing only plain texts (.txt) files\n");

		}

		if ($files[$i] =~ /\.txt/i) {

			open(FILE, "$dir/$files[$i]") or die ("file not found");

			$data = <FILE> ;

			$enc{$files[$i]} = guess_encoding($data, qw/euc-jp shiftjis 7bit-jis/);

		}
	}


	$enc_error = " "; #resets message in case the user has done an encoding check already in the same session

	foreach $x (sort keys %enc) { #This creates the message of error in case any of the file is in Unicode

		if ($enc{$x} =~ /Unicode/) {

			$enc_error = " $x "."$enc_error";
			$alarm_enc = "yes";
		}

	}
	if ($alarm_enc eq "yes") {

		$enc_error = "The following file(s) were saved in Unicode:"."$enc_error"."\nPlease save the file(s) as ANSI or UTF-8";

		$alarm_enc = "no";

		undef %enc; #cleans the hash for next use if the user doesnt shut the program

		die ("$enc_error\n");

	}

	@files = (); #clears up array of files so that the creation of folders does not messes up the progression bar







#-------------- STANFORD TAGGER LAUNCHER---------------------


	#Folder creation
	$directory_ST = "$dir/ST_$folders[$#folders]";
	$directory_MAT = "$dir/MAT_$folders[$#folders]";

	mkdir $directory_ST;
	mkdir $directory_MAT;


	opendir (DR, $dir) || die ("Cannot open directory\n");

	@files = readdir(DR);

	$max_bar_size = (@files-4)*2; #Options for the progress bar; -2 for the two windows folders "." and "..", -2 the two folders I create
	$progress_bar->SetRange(0, $max_bar_size);

	$status->Change(-text => "Starting Stanford Tagger");

	for ($i=2; $i<@files; $i++) {

		$string_for_textfield = 'Stanford Tagger tagging x';
		$string_for_textfield =~ s/x/$files[$i]/;
		$status->Change(-text => $string_for_textfield);

		if ($files[$i] =~ /\.txt/i) {

			&curly_correct;

			$command = "java -mx300m -classpath stanford-postagger.jar edu.stanford.nlp.tagger.maxent.MaxentTagger -model wsj-0-18-left3words.tagger -textFile \"$dir\\$files[$i]\" >  \"$dir\\ST_$folders[$#folders]\\ST_$files[$i]\"";

			system("$command");

		}

		$progress_bar->DeltaPos(1);

	}

	$status->Change(-text => 'Stanford Tagger tagging ended');


	#--------------------------- MAT TAGGER STARTS ------------------


	$status->Change(-text => 'Starting MAT');

	opendir (DR, "$dir/ST_$folders[$#folders]") || die ("Cannot open directory");

	@files = readdir(DR);

	for ($i=2; $i<@files; $i++) { #Loop for each file in the folder



		{
			#Slurps only the text and not the rest of the commands
			local $/ = undef ;

			open(FILE, "$dir/ST_$folders[$#folders]//$files[$i]") or die ("file not found");
			$files[$i] =~ s/ST_//; #removes the tag from previous script
			$files[$i] =~ s/(\.txt|\.TXT)//; #removes the extension of the file

			$text = <FILE> ;
		}

		$string_for_textfield = 'MAT tagging x';
		$string_for_textfield =~ s/x/$files[$i]/;
		$status->Change(-text => $string_for_textfield);

		@word = split (/\s+/, $text);

		#SHORTCUTS
		$have = "have_|has_|'ve_|had_|having_|hath_";
		$do ="do_|does_|did_|doing_|done_";
		$be = "be_|am_|is_|are_|was_|were_|been_|being_|s_VBZ|m_|re_";
		$who = "what_|where_|when_|how_|whether_|why_|whoever_|whomever_|whichever_|wherever_|whenever_|whatever_|however_";
		$wp = "who_|whom_|whose_|which_";
		$preposition = "against_|amid_|amidst_|among_|amongst_|at_|besides_|between_|by_|despite_|during_|except_|for_|from_|in_|into_|minus_|notwithstanding_|of_|off_|on_|onto_|opposite_|out_|per_|plus_|pro_|than_|through_|throughout_|thru_|toward_|towards_|upon_|versus_|via_|with_|within_|without_";
		$public = "acknowledge_V|acknowledged_V|acknowledges_V|acknowledging_V|add_V|adds_V|adding_V|added_V|admit_V|admits_V|admitting_V|admitted_V|affirm_V|affirms_V|affirming_V|affirmed_V|agree_V|agrees_V|agreeing_V|agreed_V|allege_V|alleges_V|alleging_V|alleged_V|announce_V|announces_V|announcing_V|announced_V|argue_V|argues_V|arguing_V|argued_V|assert_V|asserts_V|asserting_V|asserted_V|bet_V|bets_V|betting_V|boast_V|boasts_V|boasting_V|boasted_V|certify_V|certifies_V|certifying_V|certified_V|claim_V|claims_V|claiming_V|claimed_V|comment_V|comments_V|commenting_V|commented_V|complain_V|complains_V|complaining_V|complained_V|concede_V|concedes_V|conceding_V|conceded_V|confess_V|confesses_V|confessing_V|confessed_V|confide_V|confides_V|confiding_V|confided_V|confirm_V|confirms_V|confirming_V|confirmed_V|contend_V|contends_V|contending_V|contended_V|convey_V|conveys_V|conveying_V|conveyed_V|declare_V|declares_V|declaring_V|declared_V|deny_V|denies_V|denying_V|denied_V|disclose_V|discloses_V|disclosing_V|disclosed_V|exclaim_V|exclaims_V|exclaiming_V|exclaimed_V|explain_V|explains_V|explaining_V|explained_V|forecast_V|forecasts_V|forecasting_V|forecasted_V|foretell_V|foretells_V|foretelling_V|foretold_V|guarantee_V|guarantees_V|guaranteeing_V|guaranteed_V|hint_V|hints_V|hinting_V|hinted_V|insist_V|insists_V|insisting_V|insisted_V|maintain_V|maintains_V|maintaining_V|maintained_V|mention_V|mentions_V|mentioning_V|mentioned_V|object_V|objects_V|objecting_V|objected_V|predict_V|predicts_V|predicting_V|predicted_V|proclaim_V|proclaims_V|proclaiming_V|proclaimed_V|promise_V|promises_V|promising_V|promised_V|pronounce_V|pronounces_V|pronouncing_V|pronounced_V|prophesy_V|prophesies_V|prophesying_V|prophesied_V|protest_V|protests_V|protesting_V|protested_V|remark_V|remarks_V|remarking_V|remarked_V|repeat_V|repeats_V|repeating_V|repeated_V|reply_V|replies_V|replying_V|replied_V|report_V|reports_V|reporting_V|reported_V|say_V|says_V|saying_V|said_V|state_V|states_V|stating_V|stated_V|submit_V|submits_V|submitting_V|submitted_V|suggest_V|suggests_V|suggesting_V|suggested_V|swear_V|swears_V|swearing_V|swore_V|sworn_V|testify_V|testifies_V|testifying_V|testified_V|vow_V|vows_V|vowing_V|vowed_V|warn_V|warns_V|warning_V|warned_V|write_V|writes_V|writing_V|wrote_V|written_V";
		$private = "accept_V|accepts_V|accepting_V|accepted_V|anticipate_V|anticipates_V|anticipating_V|anticipated_V|ascertain_V|ascertains_V|ascertaining_V|ascertained_V|assume_V|assumes_V|assuming_V|assumed_V|believe_V|believes_V|believing_V|believed_V|calculate_V|calculates_V|calculating_V|calculated_V|check_V|checks_V|checking_V|checked_V|conclude_V|concludes_V|concluding_V|concluded_V|conjecture_V|conjectures_V|conjecturing_V|conjectured_V|consider_V|considers_V|considering_V|considered_V|decide_V|decides_V|deciding_V|decided_V|deduce_V|deduces_V|deducing_V|deduced_V|deem_V|deems_V|deeming_V|deemed_V|demonstrate_V|demonstrates_V|demonstrating_V|demonstrated_V|determine_V|determines_V|determining_V|determined_V|discern_V|discerns_V|discerning_V|discerned_V|discover_V|discovers_V|discovering_V|discovered_V|doubt_V|doubts_V|doubting_V|doubted_V|dream_V|dreams_V|dreaming_V|dreamt_V|dreamed_V|ensure_V|ensures_V|ensuring_V|ensured_V|establish_V|establishes_V|establishing_V|established_V|estimate_V|estimates_V|estimating_V|estimated_V|expect_V|expects_V|expecting_V|expected_V|fancy_V|fancies_V|fancying_V|fancied_V|fear_V|fears_V|fearing_V|feared_V|feel_V|feels_V|feeling_V|felt_V|find_V|finds_V|finding_V|found_V|foresee_V|foresees_V|foreseeing_V|foresaw_V|forget_V|forgets_V|forgetting_V|forgot_V|forgotten_V|gather_V|gathers_V|gathering_V|gathered_V|guess_V|guesses_V|guessing_V|guessed_V|hear_V|hears_V|hearing_V|heard_V|hold_V|holds_V|holding_V|held_V|hope_V|hopes_V|hoping_V|hoped_V|imagine_V|imagines_V|imagining_V|imagined_V|imply_V|implies_V|implying_V|implied_V|indicate_V|indicates_V|indicating_V|indicated_V|infer_V|infers_V|inferring_V|inferred_V|insure_V|insures_V|insuring_V|insured_V|judge_V|judges_V|judging_V|judged_V|know_V|knows_V|knowing_V|knew_V|known_V|learn_V|learns_V|learning_V|learnt_V|learned_V|mean_V|means_V|meaning_V|meant_V|note_V|notes_V|noting_V|noted_V|notice_V|notices_V|noticing_V|noticed_V|observe_V|observes_V|observing_V|observed_V|perceive_V|perceives_V|perceiving_V|perceived_V|presume_V|presumes_V|presuming_V|presumed_V|presuppose_V|presupposes_V|presupposing_V|presupposed_V|pretend_V|pretend_V|pretending_V|pretended_V|prove_V|proves_V|proving_V|proved_V|realize_V|realise_V|realising_V|realizing_V|realises_V|realizes_V|realised_V|realized_V|reason_V|reasons_V|reasoning_V|reasoned_V|recall_V|recalls_V|recalling_V|recalled_V|reckon_V|reckons_V|reckoning_V|reckoned_V|recognize_V|recognise_V|recognizes_V|recognises_V|recognizing_V|recognising_V|recognized_V|recognised_V|reflect_V|reflects_V|reflecting_V|reflected_V|remember_V|remembers_V|remembering_V|remembered_V|reveal_V|reveals_V|revealing_V|revealed_V|see_V|sees_V|seeing_V|saw_V|seen_V|sense_V|senses_V|sensing_V|sensed_V|show_V|shows_V|showing_V|showed_V|shown_V|signify_V|signifies_V|signifying_V|signified_V|suppose_V|supposes_V|supposing_V|supposed_V|suspect_V|suspects_V|suspecting_V|suspected_V|think_V|thinks_V|thinking_V|thought_V|understand_V|understands_V|understanding_V|understood_V";
		$suasive = "agree_V|agrees_V|agreeing_V|agreed_V|allow_V|allows_V|allowing_V|allowed_V|arrange_V|arranges_V|arranging_V|arranged_V|ask_V|asks_V|asking_V|asked_V|beg_V|begs_V|begging_V|begged_V|command_V|commands_V|commanding_V|commanded_V|concede_V|concedes_V|conceding_V|conceded_V|decide_V|decides_V|deciding_V|decided_V|decree_V|decrees_V|decreeing_V|decreed_V|demand_V|demands_V|demanding_V|demanded_V|desire_V|desires_V|desiring_V|desired_V|determine_V|determines_V|determining_V|determined_V|enjoin_V|enjoins_V|enjoining_V|enjoined_V|ensure_V|ensures_V|ensuring_V|ensured_V|entreat_V|entreats_V|entreating_V|entreated_V|grant_V|grants_V|granting_V|granted_V|insist_V|insists_V|insisting_V|insisted_V|instruct_V|instructs_V|instructing_V|instructed_V|intend_V|intends_V|intending_V|intended_V|move_V|moves_V|moving_V|moved_V|ordain_V|ordains_V|ordaining_V|ordained_V|order_V|orders_V|ordering_V|ordered_V|pledge_V|pledges_V|pledging_V|pledged_V|pray_V|prays_V|praying_V|prayed_V|prefer_V|prefers_V|preferring_V|preferred_V|pronounce_V|pronounces_V|pronouncing_V|pronounced_V|propose_V|proposes_V|proposing_V|proposed_V|recommend_V|recommends_V|recommending_V|recommended_V|request_V|requests_V|requesting_V|requested_V|require_V|requires_V|requiring_V|required_V|resolve_V|resolves_V|resolving_V|resolved_V|rule_V|rules_V|ruling_V|ruled_V|stipulate_V|stipulates_V|stipulating_V|stipulated_V|suggest_V|suggests_V|suggesting_V|suggested_V|urge_V|urges_V|urging_V|urged_V|vote_V|votes_V|voting_V|voted_V";


		#CORRECTION OF SYMBOLS
		foreach $x (@word) {

			#changes the two tags that have a problematic "$" symbol
			if ($x =~ /PRP./) { $x =~ s/PRP./PRPS/; }
			if ($x =~ /WP./) { $x =~ s/WP./WPS/; }

		}

		#CORRECTION OF "TO" AS PREPOSITION
		for ($j=0; $j<@word; $j++) {

			if ($word[$j] =~ /\bto_/i && $word[$j+1] =~ /_IN|_CD|_DT|_JJ|_PRPS|_WPS|_NN|_NNP|_PDT|_PRP|_WDT|(\b($wp))|_WRB/i) {
				$word[$j] =~ s/_\w+/_PIN/;
			}

		}

		#BASIC TAGS NEEDED FOR COMPLEX TAGS
		foreach $x (@word) {

			#negation
			if ($x =~ /\bnot_RB|\bn't_RB/i) {

				$x =~ s/_\w+/_XX0/;
			}

			#prepositions
			if ($x =~ /\b($preposition)/i) {

				$x =~ s/_\w+/_PIN/;
			}

			#tags indefinite pronouns
			if ($x =~ /\banybody_|\banyone_|\banything_|\beverybody_|\beveryone_|\beverything_|\bnobody_|\bnone_|\bnothing_|\bnowhere_|\bsomebody_|\bsomeone_|\bsomething_/i) {
				$x =~ s/_\w+/_INPR/;
			}

			#tags quantifiers
			if ($x =~ /\beach_|\ball_|\bevery_|\bmany_|\bmuch_|\bfew_|\bseveral_|\bsome_|\bany_/i) {
				$x =~ s/_\w+/_QUAN/;
			}

			#tags quantifier pronouns
			if ($x =~ /\beverybody_|\bsomebody_|\banybody_|\beveryone_|\bsomeone_|\banyone_|\beverything_|\bsomething_|\banything_/i) {
				$x =~ s/_\w+/_QUPR/;
			}

		}


		#COMPLEX TAGS
		for ($j=0; $j<@word; $j++) {

			#tags adverbial subordinators
			if ($word[$j] =~ /\bsince_|\bwhile_|\bwhilst_|\bwhereupon_|\bwhereas_|\bwhereby_/i) {
				$word[$j] =~ s/_\w+/_OSUB/;
			}
			if(($word[$j] =~ /\bsuch_/i && $word[$j+1] =~ /\bthat_/i) ||
				($word[$j] =~ /\binasmuch_/i && $word[$j+1] =~ /\bas_/i) ||
				($word[$j] =~ /\bforasmuch_/i && $word[$j+1] =~ /\bas_/i) ||
				($word[$j] =~ /\binsofar_/i && $word[$j+1] =~ /\bas_/i) ||
				($word[$j] =~ /\binsomuch_/i && $word[$j+1] =~ /\bas_/i) ||
				($word[$j] =~ /\bso_/i && $word[$j+1] =~ /\bthat_/i && $word[$j+2] !~ /_NN|_NNP|_JJ/)) {
				$word[$j] =~ s/_\w+/_OSUB/;
				$word[$j+1] =~ s/_\w+/_NULL/;
			}
			if (($word[$j] =~ /\bas_/i && $word[$j+1] =~ /\blong_/i && $word[$j+2] =~ /\bas_/i) ||
				($word[$j] =~ /\bas_/i && $word[$j+1] =~ /\bsoon_/i && $word[$j+2] =~ /\bas_/i)){
				$word[$j] =~ s/_\w+/_OSUB/;
				$word[$j+1] =~ s/_\w+/_NULL/;
				$word[$j+2] =~ s/_\w+/_NULL/;
			}

			#--------------------------------------------------

			#tags predicative adjectives
			if ($word[$j] =~ /\b($be)/i && $word[$j+1] =~ /_JJ/ && $word[$j+2] !~ /_JJ|_RB|_NN|_NNP/){
					$word[$j+1] =~ s/_\w+/_PRED/;
			}
			if ($word[$j] =~ /\b($be)/i && $word[$j+1] =~ /_RB/ && $word[$j+2] =~ /_JJ/ && $word[$j+3] !~ /_JJ|_RB|_NN|_NNP/){
					$word[$j+2] =~ s/_\w+/_PRED/;
			}
			if ($word[$j] =~ /\b($be)/i && $word[$j+1] =~ /_XX0/ && $word[$j+2] =~ /_JJ/ && $word[$j+3] !~ /_JJ|_RB|_NN|_NNP/){
					$word[$j+2] =~ s/_\w+/_PRED/;
			}
			if ($word[$j] =~ /\b($be)/i && $word[$j+1] =~ /_XX0/ && $word[$j+2] =~ /_RB/ && $word[$j+3] =~ /_JJ/ && $word[$j+4] !~ /_JJ|_RB|_NN|_NNP/){
					$word[$j+3] =~ s/_\w+/_PRED/;
			}
			if ($word[$j-2] =~ /_PRED/ && $word[$j-1] =~ /_PHC/ && $word[$j] =~ /_JJ/){
					$word[$j] =~ s/_\w+/_PRED/;
			}

			#---------------------------------------------------

			#tags conjuncts
			if (($word[$j] =~ /_\W/ && $word[$j+1] =~ /\belse_/i) ||
				($word[$j] =~ /_\W/ && $word[$j+1] =~ /\baltogether_/i) ||
				($word[$j] =~ /_\W/ && $word[$j+1] =~ /\brather_/i)) {
					$word[$j+1] =~ s/_\w+/_CONJ/;
			}
			if (($word[$j] =~ /\balternatively_|\bconsequently_|\bconversely_|\beg_|\be\.g\._|\bfurthermore_|\bhence_|\bhowever_|\bi\.e\._|\binstead_|\blikewise_|\bmoreover_|\bnamely_|\bnevertheless_|\bnonetheless_|\bnotwithstanding_|\botherwise_|\bsimilarly_|\btherefore_|\bthus_|\bviz\._/i)){
					$word[$j] =~ s/_\w+/_CONJ/;
			}
			if (($word[$j] =~ /\bin_/i && $word[$j+1] =~ /\bcomparison_|\bcontrast_|\bparticular_|\baddition_|\bconclusion_|\bconsequence_|\bsum_|\bsummary_/i) ||
				($word[$j] =~ /\bfor_/i && $word[$j+1] =~ /\bexample_|\binstance_/i) ||
				($word[$j] =~ /\binstead_/i && $word[$j+1] =~ /\bof_/i) ||
				($word[$j] =~ /\bby_/i && $word[$j+1] =~ /\bcontrast_|\bcomparison_/i)){
					$word[$j] =~ s/_\w+/_CONJ/;
					$word[$j+1] =~ s/_\w+/_NULL/;
			}
			if (($word[$j] =~ /\bin_/i && $word[$j+1] =~ /\bany_/i && $word[$j+2] =~ /\bevent_|\bcase_/i) ||
				($word[$j] =~ /\bin_/i && $word[$j+1] =~ /\bother_/i && $word[$j+2] =~ /\bwords_/i) ||
				($word[$j] =~ /\bas_/i && $word[$j+1] =~ /\ba_/i && $word[$j+2] =~ /\bresult_|\bconsequence_/i) ||
				($word[$j] =~ /\bon_/i && $word[$j+1] =~ /\bthe_/i && $word[$j+2] =~ /\bcontrary_/i)){
					$word[$j] =~ s/_\w+/_CONJ/;
					$word[$j+1] =~ s/_\w+/_NULL/;
					$word[$j+2] =~ s/_\w+/_NULL/;
			}
			if (($word[$j] =~ /\bon_/i && $word[$j+1] =~ /\bthe_/i && $word[$j+2] =~ /\bother_/i && $word[$j+3] =~ /\bhand_/i)){
					$word[$j] =~ s/_\w+/_CONJ/;
					$word[$j+1] =~ s/_\w+/_NULL/;
					$word[$j+2] =~ s/_\w+/_NULL/;
					$word[$j+3] =~ s/_\w+/_NULL/;
			}

			#---------------------------------------------------

			#tags emphatics
			if ($word[$j] =~ /\bjust_|\breally_|\bmost_|\bmore_/i){
					$word[$j] =~ s/_\w+/_EMPH/;
			}
			if (($word[$j] =~ /\breal_/i && $word[$j+1] =~ /_JJ|_PRED/) ||
				($word[$j] =~ /\bso_/i && $word[$j+1] =~ /_JJ|_PRED/) ||
				($word[$j] =~ /\b($do)/i && $word[$j+1] =~ /_V/)){
					$word[$j] =~ s/_\w+/_EMPH/;
			}
			if (($word[$j] =~ /\bfor_/i && $word[$j+1] =~ /\bsure_/i) ||
				($word[$j] =~ /\ba_/i && $word[$j+1] =~ /\blot_/i) ||
				($word[$j] =~ /\bsuch_/i && $word[$j+1] =~ /\ba_/i)){
					$word[$j] =~ s/_\w+/_EMPH/;
					$word[$j+1] =~ s/_\w+/_NULL/;
			}

			#---------------------------------------------------

			#tags phrasal "and" coordination
			if (($word[$j] =~ /\band_/i) &&
				(($word[$j-1] =~ /_RB/ && $word[$j+1] =~ /_RB/) ||
				($word[$j-1] =~ /_JJ|_PRED/ && $word[$j+1] =~ /_JJ|_PRED/) ||
				($word[$j-1] =~ /_V/ && $word[$j+1] =~ /_V/) ||
				($word[$j-1] =~ /_NN/ && $word[$j+1] =~ /_NN/))) {
						$word[$j] =~ s/_\w+/_PHC/;
			}

			#---------------------------------------------------

			#tags pro-verb do
			if ($word[$j] =~ /\b($do)/i) {

				if (($word[$j+1] !~ /_V/) &&
					($word[$j+1] !~ /_XX0/) &&
					($word[$j+1] !~ /_RB|_XX0/ && $word[$j+2] !~ /_V/) &&
					($word[$j+1] !~ /_RB|_XX0/ && $word[$j+2] !~ /_RB/ && $word[$j+3] !~ /_V/) &&
					($word[$j-1] !~ /(_\W)/) &&
					($word[$j-1] !~ /(\b($wp))|(\b$who)/i)) {
						$word[$j] =~ s/_(\w+)/_$1 [PROD]/;
				}
			}

			#---------------------------------------------------

			#tags WH questions
			if (($word[$j] =~ /_\W/ && $word[$j] !~ /,/ && $word[$j+1] =~ /\b$who/i && $word[$j+1] !~ /\bhowever_|\bwhatever_/i && $word[$j+2] =~ /_MD/) ||
				($word[$j] =~ /_\W/ && $word[$j] !~ /,/ && $word[$j+1] =~ /\b$who/i && $word[$j+1] !~ /\bhowever_|\bwhatever_/i && $word[$j+2] =~ /\b($do)/i) ||
				($word[$j] =~ /_\W/ && $word[$j] !~ /,/ && $word[$j+1] =~ /\b$who/i && $word[$j+1] !~ /\bhowever_|\bwhatever_/i && $word[$j+2] =~ /\b($have)/i) ||
				($word[$j] =~ /_\W/ && $word[$j] !~ /,/ && $word[$j+1] =~ /\b$who/i && $word[$j+1] !~ /\bhowever_|\bwhatever_/i && $word[$j+2] =~ /\b($be)/i) ||
				($word[$j] =~ /_\W/ && $word[$j] !~ /,/ && $word[$j+2] =~ /\b$who/i && $word[$j+2] !~ /\bhowever_|\bwhatever_/i && $word[$j+3] =~ /\b($be)/i)){
				$word[$j+1] =~ s/_(\w+)/_$1 [WHQU]/;
			}

			#---------------------------------------------------

			#tags sentence relatives
			if ($word[$j] =~ /_\W/ && $word[$j+1] =~ /\bwhich_/i) {
				$word[$j+1] =~ s/_(\w+)/_$1 [SERE]/;
			}

			#---------------------------------------------------

			#tags perfect aspects
			if ($word[$j] =~ /\b($have)/i) {
				if (($word[$j+1] =~ /_VBD|_VBN/) ||
					($word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_VBD|_VBN/) ||
					($word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_RB|_XX0/ && $word[$j+3] =~ /_VBD|_VBN/) ||
					($word[$j+1] =~ /_NN|_NNP|_PRP/ && $word[$j+2] =~ /_VBD|_VBN/) ||
					($word[$j+1] =~ /_XX0/ && $word[$j+2] =~ /_NN|_NNP|_PRP/ && $word[$j+3] =~ /_VBD|_VBN/)) {
							$word[$j] =~ s/_(\w+)/_$1 [PEAS]/;
				}
			}

			#---------------------------------------------------

			#tags passives
			if ($word[$j] =~ /\b($be)/i) {
				if (($word[$j+1] =~ /_VBD|_VBN/ && $word[$j+2] !~ /\bby_/i) ||
					($word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_VBD|_VBN/ && $word[$j+3] !~ /\bby_/i) ||
					($word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_RB|_XX0/ && $word[$j+3] =~ /_VBD|_VBN/ && $word[$j+4] !~ /\bby_/i) ||
					($word[$j+1] =~ /_NN|_NNP|_PRP/ && $word[$j+2] =~ /_VBD|_VBN/ && $word[$j+3] !~ /\bby_/i) ||
					($word[$j+1] =~ /_XX0/ && $word[$j+2] =~ /_NN|_NNP|_PRP/ && $word[$j+3] =~ /_VBD|_VBN/ && $word[$j+4] !~ /\bby_/i)) {
							$word[$j] =~ s/_(\w+)/_$1 [PASS]/;
				}
			}

			#---------------------------------------------------

			#tags "by passives"
			if ($word[$j] =~ /\b($be)/i) {
				if (($word[$j+1] =~ /_VBD|_VBN/ && $word[$j+2] =~ /\bby_/i) ||
					($word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_VBD|_VBN/ && $word[$j+3] =~ /\bby_/i) ||
					($word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_RB|_XX0/ && $word[$j+3] =~ /_VBD|_VBN/ && $word[$j+4] =~ /\bby_/i) ||
					($word[$j+1] =~ /_NN|_NNP|_PRP/ && $word[$j+2] =~ /_VBD|_VBN/ && $word[$j+3] =~ /\bby_/i) ||
					($word[$j+1] =~ /_XX0/ && $word[$j+2] =~ /_NN|_NNP|_PRP/ && $word[$j+3] =~ /_VBD|_VBN/ && $word[$j+4] =~ /\bby_/i)) {
							$word[$j] =~ s/_(\w+)/_$1 [BYPA]/;
				}
			}

			#---------------------------------------------------

			#tags be as main verb
			if (($word[$j-2] !~ /_EX/ && $word[$j-1] !~ /_EX/ && $word[$j] =~ /\b($be)/i && $word[$j+1] =~ /_CD|_DT|_PDT|_PRPS|_PRP|_JJ|_PRED|_PIN|_QUAN/) ||
				($word[$j-2] !~ /_EX/ && $word[$j-1] !~ /_EX/ && $word[$j] =~ /\b($be)/i && $word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_CD|_DT|_PDT|_PRPS|_PRP|_JJ|_PRED|_PIN|_QUAN/)) {
					$word[$j] =~ s/_(\w+)/_$1 [BEMA]/;

			}

			#---------------------------------------------------

			#tags wh clauses
			if ($word[$j] =~ /\b($public|$private|$suasive)/i && $word[$j+1] =~ /(\b($wp))|(\b($who))/i && $word[$j+2] !~ /_MD|(\b($do))|(\b($have))|(\b($be))/i) {
					$word[$j+1] =~ s/_(\w+)/_$1 [WHCL]/;
			}

			#---------------------------------------------------

			#tags pied-piping relative clauses
			if ($word[$j] =~ /_PIN/ && $word[$j+1] =~ /\bwho_|\bwhom_|\bwhose_|\bwhich_/) {
					$word[$j+1] =~ s/_(\w+)/_$1 [PIRE]/;
			}

			#---------------------------------------------------

			#tags stranded prepositions - CORRECTED FOR PROBLEM WITH "BESIDES" AS CONJUNCTIVE ADJUNCT
			if ($word[$j] =~ /_PIN/ && $word[$j] !~ /\bbesides/i && $word[$j+1] =~ /_\.|_,/){
				$word[$j] =~ s/_(\w+)/_$1 [STPR]/;
			}

			#---------------------------------------------------

			#tags split infinitives
			if (($word[$j] =~ /\bto_/i && $word[$j+1] =~ /_RB|_AMPLIF|_DOWNTON|\bjust_|\breally_|\bmost_|\bmore_/i && $word[$j+2] =~ /_V/) ||
				($word[$j] =~ /\bto_/i && $word[$j+1] =~ /_RB|_AMPLIF|_DOWNTON|\bjust_|\breally_|\bmost_|\bmore_/i && $word[$j+2] =~ /_RB|_AMPLIF|_DOWNTON/ && $word[$j+3] =~ /_V/)){
					$word[$j] =~ s/_(\w+)/_$1 [SPIN]/;
			}

			#---------------------------------------------------

			#tags split auxiliaries
			if (($word[$j] =~ /_MD|(\b($do))|(\b($have))|(\b($be))/i && $word[$j+1] =~ /_RB|_AMPLIF|_DOWNTON|\bjust_|\breally_|\bmost_|\bmore_/i && $word[$j+2] =~ /_V/) ||
				($word[$j] =~ /_MD|(\b($do))|(\b($have))|(\b($be))/i && $word[$j+1] =~ /_RB|_AMPLIF|_DOWNTON|\bjust_|\breally_|\bmost_|\bmore_/i && $word[$j+2] =~ /_RB/ && $word[$j+3] =~ /_V/)){
					$word[$j] =~ s/_(\w+)/_$1 [SPAU]/;
			}

			#---------------------------------------------------

			#tags synthetic negation
			if (($word[$j] =~ /\bno_/i && $word[$j+1] =~ /_JJ|_PRED|_NN|_NNP/) ||
				($word[$j] =~ /\bneither_/i) ||
				($word[$j] =~ /\bnor_/i)){
					$word[$j] =~ s/_(\w+)/_SYNE/;
			}

			#---------------------------------------------------

			#tags time adverbials
			if ($word[$j] =~ /\bafterwards_|\bagain_|\bearlier_|\bearly_|\beventually_|\bformerly_|\bimmediately_|\binitially_|\binstantly_|\blate_|\blately_|\blater_|\bmomentarily_|\bnow_|\bnowadays_|\bonce_|\boriginally_|\bpresently_|\bpreviously_|\brecently_|\bshortly_|\bsimultaneously_|\bsubsequently_|\btoday_|\bto-day_|\btomorrow_|\bto-morrow_|\btonight_|\bto-night_|\byesterday_/i) {
				$word[$j] =~ s/_\w+/_TIME/;
			}
			if(($word[$j] =~ /\bsoon_/i) && ($word[$j+1] !~ /\bas_/i)) {
				$word[$j] =~ s/_\w+/_TIME/;
			}

			#---------------------------------------------------

			#tags place adverbials
			if ($word[$j] =~ /\baboard_|\babove_|\babroad_|\bacross_|\bahead_|\balongside_|\baround_|\bashore_|\bastern_|\baway_|\bbehind_|\bbelow_|\bbeneath_|\bbeside_|\bdownhill_|\bdownstairs_|\bdownstream_|\beast_|\bfar_|\bhereabouts_|\bindoors_|\binland_|\binshore_|\binside_|\blocally_|\bnear_|\bnearby_|\bnorth_|\bnowhere_|\boutdoors_|\boutside_|\boverboard_|\boverland_|\boverseas_|\bsouth_|\bunderfoot_|\bunderground_|\bunderneath_|\buphill_|\bupstairs_|\bupstream_|\bwest_/i
				&& $word[$j] !~ /_NNP/) {
				$word[$j] =~ s/_\w+/_PLACE/;
			}

			#---------------------------------------------------

			#tags 'that' verb complements
			if ($word[$j-1] =~ /\band_|\bnor_|\bbut_|\bor_|\balso_|_\W/i && $word[$j] =~ /\bthat_/i && $word[$j+1] =~ /_DT|_QUAN|_CD|_PRP|there_|_NNS|_NNP/i) {
				$word[$j] =~ s/_\w+/_THVC/;
			}
			if ($word[$j-1] =~ /\b($public|$private|$suasive)|\bseem_V|\bseems_V|\bseemed_V|\bseeming_V|\bappear_V|\bappears_V|\bappeared_V|\bappearing_V/i && $word[$j] =~ /\bthat_/i && $word[$j+1] !~ /_V|_MD|(\b($do))|(\b($have))|(\b($be))|\band_|_\W/i) {
				$word[$j] =~ s/_\w+/_THVC/;
			}
			if ($word[$j-4] =~ /\b($public|$private|$suasive)/i && $word[$j-3] =~ /_PIN/ && $word[$j-2] !~ /_N/ && $word[$j-1] =~ /_N/ && $word[$j] =~ /\bthat_/i) {
				$word[$j] =~ s/_\w+/_THVC/;
			}
			if ($word[$j-5] =~ /\b($public|$private|$suasive)/i && $word[$j-4] =~ /_PIN/ && $word[$j-3] !~ /_N/ && $word[$j-2] !~ /_N/ && $word[$j-1] =~ /_N/ && $word[$j] =~ /\bthat_/i) {
				$word[$j] =~ s/_\w+/_THVC/;
			}
			if ($word[$j-6] =~ /\b($public|$private|$suasive)/i && $word[$j-5] =~ /_PIN/ && $word[$j-4] !~ /_N/ && $word[$j-3] !~ /_N/ && $word[$j-2] !~ /_N/ && $word[$j-1] =~ /_N/ && $word[$j] =~ /\bthat_/i) {
				$word[$j] =~ s/_\w+/_THVC/;
			}

			#---------------------------------------------------

			#tags 'that' adjective complements
			if ($word[$j-1] =~ /_JJ|_PRED/ && $word[$j] =~ /\bthat_/i) {
				$word[$j] =~ s/_\w+/_THAC/;
			}

			#---------------------------------------------------

			#tags present participial clauses
			if ($word[$j-1] =~ /_\W/ && $word[$j] =~ /_VBG/ && $word[$j+1] =~ /_PIN|_DT|_QUAN|_CD|(\b($wp))|_WPS|(\b$who)|_PRP|_RB/i) {
				$word[$j] =~ s/_(\w+)/_$1 [PRESP]/;
			}

			#---------------------------------------------------

			#tags past participial clauses
			if ($word[$j-1] =~ /_\W/ && $word[$j] =~ /_VBN/ && $word[$j+1] =~ /_PIN|_RB/) {
				$word[$j] =~ s/_(\w+)/_$1 [PASTP]/;
			}

			#---------------------------------------------------

			#tags past participial WHIZ deletion relatives
			if ($word[$j-1] =~ /_N|_QUPR/ && $word[$j] =~ /_VBN/ && $word[$j+1] =~ /_PIN|_RB|\b($be)/i) {
				$word[$j] =~ s/_(\w+)/_$1 [WZPAST]/;
			}

			#---------------------------------------------------

			#tags present participial WHIZ deletion relatives
			if ($word[$j-1] =~ /_N/ && $word[$j] =~ /_VBG/) {
				$word[$j] =~ s/_(\w+)/_$1 [WZPRES]/;
			}

			#---------------------------------------------------

			#tags "that" relative clauses on subject position
			if ($word[$j-1] =~ /_N/ && $word[$j] =~ /\bthat_/i && $word[$j+1] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) {
				$word[$j] =~ s/_\w+/_TSUB/;
			}
			if ($word[$j-1] =~ /_N/ && $word[$j] =~ /\bthat_/i && $word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) {
				$word[$j] =~ s/_\w+/_TSUB/;
			}
			if ($word[$j-1] =~ /_N/ && $word[$j] =~ /\bthat_/i && $word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_RB|_XX0/ && $word[$j+3] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) {
				$word[$j] =~ s/_\w+/_TSUB/;
			}

			#---------------------------------------------------

			#tags "that" relative clauses on object position
			if ($word[$j-1] =~ /_N/ && $word[$j] =~ /\bthat_/i && $word[$j+1] =~ /_DT|_QUAN|_CD|\bit_|_JJ|_NNS|_NNP|_PRPS|\bi_|\bwe_|\bhe_|\bshe_|\bthey_/i) {
				$word[$j] =~ s/_\w+/_TOBJ/;
			}
			if ($word[$j-1] =~ /_N/ && $word[$j] =~ /\bthat_/i && $word[$j+1] =~ /_N/ && $word[$j+2] =~ /_POS/) {
				$word[$j] =~ s/_\w+/_TOBJ/;
			}

			#---------------------------------------------------

			#tags WH relative clauses on subject position
			if ($word[$j-3] !~ /\bask_|\basks_|\basked_|\basking_|\btell_|\btells_|\btold_|\btelling_/i && $word[$j-1] =~ /_N/ && $word[$j] =~ /\b($wp)/i && $word[$j+1] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) {
				$word[$j] =~ s/_(\w+)/_$1 [WHSUB]/;
			}
			if ($word[$j-3] !~ /\bask_|\basks_|\basked_|\basking_|\btell_|\btells_|\btold_|\btelling_/i && $word[$j-1] =~ /_N/ && $word[$j] =~ /\b($wp)/i && $word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) {
				$word[$j] =~ s/_(\w+)/_$1 [WHSUB]/;
			}
			if ($word[$j-3] !~ /\bask_|\basks_|\basked_|\basking_|\btell_|\btells_|\btold_|\btelling_/i && $word[$j-1] =~ /_N/ && $word[$j] =~ /\b($wp)/i && $word[$j+1] =~ /_RB|_XX0/ && $word[$j+2] =~ /_RB|_XX0/ && $word[$j+3] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) {
				$word[$j] =~ s/_(\w+)/_$1 [WHSUB]/;
			}

			#---------------------------------------------------

			#tags WH relative clauses on object position
			if ($word[$j-3] !~ /\bask_|\basks_|\basked_|\basking_|\btell_|\btells_|\btold_|\btelling_/i && $word[$j-1] =~ /_N/ && $word[$j] =~ /\b($wp)/i && $word[$j+1] !~ /_RB|_XX0|_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) {
				$word[$j] =~ s/_(\w+)/_$1 [WHOBJ]/;
			}

			#---------------------------------------------------

			#tags hedges
			if ($word[$j] =~ /\bmaybe_/i) {
				$word[$j] =~ s/_\w+/_HDG/;
			}
			if (($word[$j] =~ /\bat_/i && $word[$j+1] =~ /\babout_/i) ||
				($word[$j] =~ /\bsomething_/i && $word[$j+1] =~ /\blike_/i)) {
				$word[$j] =~ s/_\w+/_HDG/;
				$word[$j+1] =~ s/_\w+/_NULL/;
			}
			if ($word[$j] =~ /\bmore_/i && $word[$j+1] =~ /\bor_/i && $word[$j+2] =~ /\bless_/i) {
				$word[$j] =~ s/_\w+/_HDG/;
				$word[$j+1] =~ s/_\w+/_NULL/;
				$word[$j+2] =~ s/_\w+/_NULL/;
			}
			if (($word[$j-2] !~ /_DT|_QUAN|_CD|_JJ|_PRED|_PRPS|(\b$who)/i && $word[$j-1] =~ /\bsort_/i && $word[$j] =~ /\bof_/i) ||
				($word[$j-2] !~ /_DT|_QUAN|_CD|_JJ|_PRED|_PRPS|(\b$who)/i && $word[$j-1] =~ /\bkind_/i && $word[$j] =~ /\bof_/i)) {
				$word[$j] =~ s/_\w+/_HDG/;
				$word[$j-1] =~ s/_\w+/_NULL/;
			}

			#---------------------------------------------------

			#tags discourse particles
			if ($word[$j-1] =~ /_\W/ && $word[$j] =~ /\bwell_|\bnow_|\banyhow_|\banyways_/i) {
				$word[$j] =~ s/_\w+/_DPAR/;
			}

		}

		#EVEN MORE COMPLEX TAGS

		#---------------------------------------------------
		#tags demonstrative pronouns

		for ($j=0; $j<@word; $j++) {

			if ($word[$j] =~ /\bthat_|\bthis_|\bthese_|\bthose_/i && $word[$j] !~ /_NULL/ && $word[$j+1] =~ /_V|_MD|(\b($do))|(\b($have))|(\b($be))|_\W|(\b($wp))|\band_/i && $word[$j] !~ /_TOBJ|_TSUB|_THAC|_THVC/) {
				$word[$j] =~ s/_\w+/_DEMP/;
			}
			if ($word[$j] =~ /\bthat_/i && $word[$j+1] =~ /'s_/ ||
				$word[$j] =~ /\bthat_/i && $word[$j+1] =~ /is_/) {
				$word[$j] =~ s/_\w+/_DEMP/;
			}
		}

		#---------------------------------------------------
		#tags demonstratives

		for ($j=0; $j<@word; $j++) {

			if ($word[$j] =~ /\bthat_|\bthis_|\bthese_|\bthose_/i && $word[$j] !~ /_DEMP|_TOBJ|_TSUB|_THAC|_THVC|_NULL/) {
				$word[$j] =~ s/_\w+/_DEMO/;
			}
		}

		#---------------------------------------------------
		#tags subordinator-that deletion

		for ($j=0; $j<@word; $j++) {

			if (($word[$j] =~ /\b($public|$private|$suasive)/i && $word[$j+1] =~ /_DEMP|\bi_|\bwe_|\bhe_|\bshe_|\bthey_/i) ||
				($word[$j] =~ /\b($public|$private|$suasive)/i && $word[$j+1] =~ /_PRP|_N/ && $word[$j+2] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) ||
				($word[$j] =~ /\b($public|$private|$suasive)/i && $word[$j+1] =~ /_JJ|_PRED|_RB|_DT|_QUAN|_CD|_PRPS/ && $word[$j+2] =~ /_N/ && $word[$j+3] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i) ||
				($word[$j] =~ /\b($public|$private|$suasive)/i && $word[$j+1] =~ /_JJ|_PRED|_RB|_DT|_QUAN|_CD|_PRPS/ && $word[$j+2] =~ /_JJ|_PRED/ && $word[$j+3] =~ /_N/ && $word[$j+4] =~ /_MD|(\b($do))|(\b($have))|(\b($be))|_V/i)) {
				$word[$j] =~ s/_(\w+)/_$1 [THATD]/;
			}
		}

		#---------------------------------------------------
		#tags independent clause coordination

		for ($j=0; $j<@word; $j++) {

			if ($word[$j-1] =~ /_,/ && $word[$j] =~ /\band_/i && $word[$j+1] =~ /\bit_|\bso_|\bthen_|\byou_|_DEMP|\bi_|\bwe_|\bhe_|\bshe_|\bthey_/i) {
				$word[$j] =~ s/_\w+/_ANDC/;
			}
			if ($word[$j-1] =~ /_,/ && $word[$j] =~ /\band_/i && $word[$j+1] =~ /\bthere_/i && $word[$j+2] =~ /(\b($be))/i) {
				$word[$j] =~ s/_\w+/_ANDC/;
			}
			if ($word[$j-1] =~ /_\W/ && $word[$j] =~ /\band_/i) {
				$word[$j] =~ s/_\w+/_ANDC/;
			}
			if ($word[$j] =~ /\band_/i && $word[$j+1] =~ /(\b($wp))|(\b$who)|\bbecause_|\balthough_|\nthough|\btho_|\bif_|\bunless_|_OSUB|_DPAR|_CONJ/i) {
				$word[$j] =~ s/_\w+/_ANDC/;
			}
		}



		#OTHER BASIC TAGS THAT HAVE TO BE TAGGED AT THE END

		foreach $x (@word) {

			#tags amplifiers
			if ($x =~ /\babsolutely_|\baltogether_|\bcompletely_|\benormously_|\bentirely_|\bextremely_|\bfully_|\bgreatly_|\bhighly_|\bintensely_|\bperfectly_|\bstrongly_|\bthoroughly_|\btotally_|\butterly_|\bvery_/i) {

				$x =~ s/_\w+/_AMP/;
			}

			#tags downtoners
			if ($x =~ /\balmost_|\bbarely_|\bhardly_|\bmerely_|\bmildly_|\bnearly_|\bonly_|\bpartially_|\bpartly_|\bpractically_|\bscarcely_|\bslightly_|\bsomewhat_/i) {
				$x =~ s/_\w+/_DWNT/;
			}

			#tags nominalisations
			if ($x =~ /tions?_NN|ments?_NN|ness_NN|nesses_NN|ity_NN|ities_NN/i) {
				$x =~ s/_\w+/_NOMZ/;
			}

			#tags gerunds
			if (($x =~ /ing_NN/i && $x =~ /\w{10,}/) ||
				($x =~ /ings_NN/i && $x =~ /\w{11,}/)) {
				$x =~ s/_\w+/_GER/;
			}

			#tags total other nouns by joining plurals together with singulars together with proper nouns
			if ($x =~ /_NNS|_NNP/) {
				$x =~ s/_\w+/_NN/;
			}

			#tags attributive adjectives by joining all kinds of JJ
			if ($x =~ /_JJS|_JJR/) {
				$x =~ s/_\w+/_JJ/;
			}

			#tags total adverbs by joining all kinds of RB
			if ($x =~ /_RBS|_RBR|_WRB/) {
				$x =~ s/_\w+/_RB/;
			}

			#tags present tenses
			if ($x =~ /_VBP|_VBZ/i) {
				$x =~ s/_\w+/_VPRT/;
			}

			#tags first person pronouns
			if ($x =~ /\bI_|\bme_|\bwe_|\bus_|\bmy_|\bour_|\bmyself_|\bourselves_/i) {
				$x =~ s/_\w+/_FPP1/;
			}

			#tags second person pronouns - ADDED "THOU","THY", "THEE", "THYSELF"
			if ($x =~ /\byou_|\byour_|\byourself_|\byourselves_|\bthy_|\bthee_|\bthyself_|\bthou_/i) {
				$x =~ s/_\w+/_SPP2/;
			}

			#tags third person pronouns
			if ($x =~ /\bshe_|\bhe_|\bthey_|\bher_|\bhim_|\bthem_|\bhis_|\btheir_|\bhimself_|\bherself_|\bthemselves_/i) {
				$x =~ s/_\w+/_TPP3/;
			}

			#tags pronoun it
			if ($x =~ /\bit_|\bits_|\bitself_/i) {
				$x =~ s/_\w+/_PIT/;
			}

			#tags causative because
			if ($x =~ /\bbecause_/i) {
				$x =~ s/_\w+/_CAUS/;
			}

			#tags concessive subordinators - ADDED "THO"
			if ($x =~ /\balthough_|\bthough_|\btho_/i) {
				$x =~ s/_\w+/_CONC/;
			}

			#tags conditional subordinators
			if ($x =~ /\bif_|\bunless_/i) {
				$x =~ s/_\w+/_COND/;
			}

			#tags possibility modals
			if ($x =~ /\bcan_|\bmay_|\bmight_|\bcould_|\bca_MD/i) {
				$x =~ s/_\w+/_POMD/;
			}

			#tags necessity modals
			if ($x =~ /\bought_|\bshould_|\bmust_/i) {
				$x =~ s/_\w+/_NEMD/;
			}

			#tags predictive modals
			if ($x =~ /\bwill_MD|ll_MD|\bwo_MD|\bwould_|\bshall_|\bsha_MD|\'d_MD/i) {
				$x =~ s/_\w+/_PRMD/;
			}

			#tags public verbs
			if ($x =~ /\b($public)/i) {
				$x =~ s/_(\w+)/_$1 [PUBV]/;
			}

			#tags private verbs
			if ($x =~ /\b($private)/i) {
				$x =~ s/_(\w+)/_$1 [PRIV]/;
			}

			#tags suasive verbs
			if ($x =~ /\b($suasive)/i) {
				$x =~ s/_(\w+)/_$1 [SUAV]/;
			}

			#tags seem/appear
			if ($x =~ /\bseem_V|\bseems_V|\bseemed_V|\bseeming_V|\bappear_V|\bappears_V|\bappeared_V|\bappearing_V/i) {
				$x =~ s/_(\w+)/_$1 [SMP]/;
			}

			#tags contractions
			if ($x =~ /'\w+_V|\bn't_XX0|'ll|'d/i) {
				$x =~ s/_(\w+)/_$1 [CONT]/;
			}

		}

		#printing the tagged output
		open (OUT1, ">$dir/MAT_$folders[$#folders]//$files[$i]_MAT.txt") or die;

		foreach (@word) {

			print OUT1 "$_\n";

		}

		close (OUT1);

		@word = (); #clean everything

		$progress_bar->DeltaPos(1);

		$string_for_textfield = 'Completed tagging for x';
		$string_for_textfield =~ s/x/$files[$i]/;
		$status->Change(-text => $string_for_textfield);


	}

	$status->Change(-text => 'Tagging completed');
	$progress_bar->SetPos(0);
	
	$dir = "$dir"."/MAT_$folders[$#folders]"; #change the dir in case the counter has to start immediately after

}



1;
