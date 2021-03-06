<html>
	<head>
		<!DOCTYPE html>
		<script src="{{base_url}}static/jquery/jquery-latest.min.js"></script>
		<script src="{{base_url}}static/semantic/semantic.min.js"></script>
		<script src="{{base_url}}static/jquery/tablesort.js"></script>
		<link rel="stylesheet" href="{{base_url}}static/semantic/semantic.min.css">
		
		<link rel="apple-touch-icon" sizes="120x120" href="{{base_url}}static/apple-touch-icon.png">
		<link rel="icon" type="image/png" sizes="32x32" href="{{base_url}}static/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="16x16" href="{{base_url}}static/favicon-16x16.png">
		<link rel="manifest" href="{{base_url}}static/manifest.json">
		<link rel="mask-icon" href="{{base_url}}static/safari-pinned-tab.svg" color="#5bbad5">
		<link rel="shortcut icon" href="{{base_url}}static/favicon.ico">
		<meta name="msapplication-config" content="{{base_url}}static/browserconfig.xml">
		<meta name="theme-color" content="#ffffff">
		
		<title>History - Bazarr</title>
		
		<style>
			body {
				background-color: #272727;
			}
			#fondblanc {
				background-color: #ffffff;
				border-radius: 0px;
				box-shadow: 0px 0px 5px 5px #ffffff;
				margin-top: 32px;
				margin-bottom: 3em;
				padding: 1em;
			}
			#logs {
				margin-top: 4em;
			}
			.fast.backward, .backward, .forward, .fast.forward {
    			cursor: pointer;
			}
			.fast.backward, .backward, .forward, .fast.forward { pointer-events: auto; }
			.fast.backward.disabled, .backward.disabled, .forward.disabled, .fast.forward.disabled { pointer-events: none; }
            .ui.tabular.menu > .disabled.item {
                opacity: 0.45 !important;
                pointer-events: none !important;
            }
		</style>
	</head>
	<body>
		<div id='loader' class="ui page dimmer">
		   	<div class="ui indeterminate text loader">Loading...</div>
		</div>
		% include('menu.tpl')

        % import os
		% import sqlite3

		% conn = sqlite3.connect(os.path.join(os.path.dirname(__file__), 'data/db/bazarr.db'), timeout=30)
    	% c = conn.cursor()

		% integration = c.execute("SELECT use_sonarr, use_radarr FROM table_settings_general").fetchone()

        % c.close()
		<div id="fondblanc" class="ui container">
			<div class="ui top attached tabular menu">
				<a id="series_tab" class="tabs item active" data-enabled="{{integration[0]}}" data-tab="series">Series</a>
				<a id="movies_tab" class="tabs item" data-enabled="{{integration[1]}}" data-tab="movies">Movies</a>
			</div>
			<div class="ui bottom attached tab segment" data-tab="series">
				<div class="content">
					<div id="content_series"></div>
				</div>
			</div>
			<div class="ui bottom attached tab segment" data-tab="movies">
				<div class="content">
					<div id="content_movies"></div>
				</div>
			</div>
		</div>
		% include('footer.tpl')
	</body>
</html>


<script>
	$('.menu .item')
		.tab()
	;

	$('#series_tab').click(function() {
	    loadURLseries(1);
	})

	$('#movies_tab').click(function() {
	    loadURLmovies(1);
	})

	function loadURLseries(page) {
		$.ajax({
	        url: "{{base_url}}historyseries?page=" + page,
	        beforeSend: function() { $('#loader').addClass('active'); },
        	complete: function() { $('#loader').removeClass('active'); },
	        cache: false
	    }).done(function(data) {
	    	$("#content_series").html(data);
	    });
	}

	function loadURLmovies(page) {
		$.ajax({
	        url: "{{base_url}}historymovies?page=" + page,
	        beforeSend: function() { $('#loader').addClass('active'); },
        	complete: function() { $('#loader').removeClass('active'); },
	        cache: false
	    }).done(function(data) {
	    	$("#content_movies").html(data);
	    });
	}

	$('a:not(.tabs), button:not(.cancel, #download_log)').click(function(){
		$('#loader').addClass('active');
	})

	if ($('#series_tab').data("enabled") == "True") {
        $("#series_tab").removeClass('disabled');
    } else {
        $("#series_tab").addClass('disabled');
    }

    if ($('#movies_tab').data("enabled") == "True") {
        $("#movies_tab").removeClass('disabled');
    } else {
        $("#movies_tab").addClass('disabled');
    }
	if ($('#series_tab').data("enabled") == "True") {
        $( "#series_tab" ).trigger( "click" );
    }
    if ($('#series_tab').data("enabled") == "False" && $('#movies_tab').data("enabled") == "True") {
        $( "#movies_tab" ).trigger( "click" );
    }
</script>