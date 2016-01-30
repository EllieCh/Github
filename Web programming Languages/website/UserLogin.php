<html lang="en">
	<?php session_start();
	if (!isset($_SESSION['username'])) {
		header("Location: index.php");
	}
	?>
	<head>
		<meta charset="UTF-8">
		<meta name="moviebox" content="movie ratings, movie lists, genre">
		<link href="img/favicon.png" rel="shortcut icon">
		<link href='http://fonts.googleapis.com/css?family=PT+Sans:400,700' rel='stylesheet' type='text/css'>

		<link rel="stylesheet" href="css/reset.css">
		<!-- CSS reset -->
		<link rel="stylesheet" href="css/style.css">
		<!-- CSS style -->

		<title>Movie List</title>
	</head>
	<body>
		<header role="banner">
			<div id="cd-logo">
				<a href="#0"><img src="img/logo.png" alt="Logo"></a>
			</div>

			<nav class="main-nav">
				<ul>
					<!-- inser more links here -->
					<?php
					if ($_SESSION['privileges'] == "a") {
						echo '<li>
<a class="cd-signin" id="btnProfile" href="AddMovie.php">Add Movie</a>
</li>';
					}
					?>
					<li>
						<a class="cd-signin" id="btnProfile" href="MyProfile.php">My Profile</a>
					</li>
					<li>
					<a class="cd-signup" id="btnLogout" href="#0">Logout</a>
					</li>
				</ul>
			</nav>
		</header>
		<div class="bcgrnd">
			&nbsp;
			&nbsp;
			<h2 class="bold-red">Welcome <?php echo $_SESSION['name']; ?></h2>
			<br>
			<label for="searchType" id="lblSearchType" class="bold-red">Search Type:</label>
			&nbsp;
			&nbsp;
			<select id="search">
				<option value="title" selected>Title</option>
				<option value="genre">Genre</option>
			</select>
			&nbsp;
			&nbsp;
			&nbsp;
			&nbsp;
			<label for="searchVal" id="lblSearchVal" class="bold-red">Search Value:</label>
			&nbsp;
			&nbsp;
			<input id="searchVal" type="text" name="Search Value">
			&nbsp;
			&nbsp;
			&nbsp;
			&nbsp;
			<button type="button" id="btnSearch" class="bold-red">Search</button>
			<br>
			<table border="1" style="width:100%" id='movieList'>
				<tr>
					<th>Title</th>
					<th>Genre</th>
					<th>Year</th>
					<th>Rating</th>
					<th <?php
					if (!$_SESSION['privileges'] == "a") {echo 'style="visibility: hidden; display: none;"';
					}
					?>>
						Delete</th>
				</tr>
			</table>
		</div>
	</body>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="js/main.js"></script>
	<script src="js/validate.js"></script>
	<!-- jQuery -->
	<script type="text/javascript">
		$(document).ready(function() {
			$('table').on('click', '.btnAdd', function() {
				window.location.href = "AddReview.php";
			});
			$('table').on('click', '.btnView', function() {
				window.location.href = "ViewReview.php";
			});
			dataString = "search=&value=";
			$.ajax({
				type : "POST",
				dataType : "text",
				url : "php/movieList.php",
				data : dataString,
				cache : false,
				success : function(result) {
					$('table').append(result);
				}
			});
		});
		$('#btnSearch').click(function() {
			var search = $('#search').val();
			var value = $('#searchVal').val();
			$('.rows').remove();
			dataString = "search=" + search + "&value=" + value;
			$.ajax({
				type : "POST",
				dataType : "text",
				url : "php/movieList.php",
				data : dataString,
				cache : false,
				success : function(result) {
					$('table').append(result);
				}
			});
		});
		$('table').on('click', '.title', function() {
			var value = $(this).attr('id');
			dataString = "a=id&b=" + value;
			$.ajax({
				type : "POST",
				dataType : "text",
				url : "php/createID.php",
				data : dataString,
				cache : false,
				success : function(result) {
					window.location.href = "AddReview.php";
				}
			});
		});
		$('table').on('click', '.btnDelete', function() {
			var value = $('td:first-child', $(this).parents('tr')).attr('id');
			dataString = "a=id&b=" + value;
			$.ajax({
				type : "POST",
				dataType : "text",
				url : "php/createID.php",
				data : dataString,
				cache : false,
				success : function(result) {
					window.location.href = "php/delete.php";
				}
			});
		});
	</script>
	</body>
</html>