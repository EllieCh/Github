<html lang="en">
	<?php
	session_start();
	if(!isset($_SESSION['username'])){
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

		<title>Admin Login!</title>
	</head>
	<body>
		<header role="banner">
			<div id="cd-logo">
				<a href="#0"><img src="img/logo.png" alt="Logo"></a>
			</div>

			<nav class="main-nav">
				<ul>
					<!-- inser more links here -->
					<li>
						<a class="cd-signin" id="btnProfile" href="AddMovie.html">Add Movie</a>
					</li>
					<li>
						<a class="cd-signup" id="btnLogout" href="#0">Logout</a>
					</li>
				</ul>
			</nav>
		</header>
		<div class="bcgrnd">
			<h2 class="bold-red">Admin Login</h2>
			<br>
			<table border="1" style="width:100%">
				<tr>
					<th>Title</th>
					<th>Genre</th>
					<th>Rating</th>
					<th>Edit</th>
					<th>Delete</th>
				</tr>
				<tr>
					<td>Notebook</td>
					<td>Romance</td>
					<td>
					<div class="rating">
						<span>☆</span><span>☆</span><span>☆</span><span>☆</span><span>☆</span>
					</div></td>
					<td>
					<button class="btnEdit" id="EditMovie">
						Edit
					</button></td>
					<td>
					<button class="btnDelete">
						Delete
					</button></td>
				</tr>
				<tr>
					<td>Avengers</td>
					<td>Action</td>
					<td>
					<div class="rating">
						<span>☆</span><span>☆</span><span>☆</span><span>☆</span><span>☆</span>
					</div></td>
					<td>
					<button class="btnEdit" id="EditMovie1">
						Edit
					</button></td>
					<td>
					<button class="btnDelete">
						Delete
					</button></td>
				</tr>
			</table>
		</div>
	</body>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="js/main.js"></script>
	<script src="js/validate.js"></script>
	<!-- jQuery -->
	<script type="text/javascript">
		document.getElementById("EditMovie").onclick = function() {
			location.href = "AddMovie.html";
		};
		document.getElementById("EditMovie1").onclick = function() {
			location.href = "AddMovie.html";
		};
	</script>
	</body>
</html>