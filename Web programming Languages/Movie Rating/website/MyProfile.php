<!doctype html>
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

		<title>My Profile!</title>
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
						<a class="cd-signin" onclick="goBack()">Go Back</a>
						<script>
							function goBack() {
								window.history.back();
							}
							</script>
					</li>
					<li>
						<a class="cd-signup" id="btnLogout" href="#0">Logout</a>
					</li>
				</ul>
			</nav>
		</header>
		<div class="bcgrnd">
			<br><h2 class="bold-red">My Profile</h2>
			<br>
			<table border="1" style="width:100%">
				<tr>
					<th>Title</th>
					<th>Genre</th>
					<th>Rating</th>
					<th>Review</th>
				</tr>
				<?php include 'php/myProfile.php'; ?>
			</table>
		</div>
	</body>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="js/main.js"></script>
	<script src="js/validate.js"></script>
	<!-- jQuery -->
	<script>
		$('table').on('click','.title',function(){
			var value = $(this).attr('id');
			dataString = "a=id&b=" + value;
			$.ajax({
				type : "POST",
				dataType : "text",
				url : "php/createID.php",
				data : dataString,
				cache : false,
				success : function(result) {
					window.location.href = "ViewReview.php";
				}
			});		
		});
	</script>
	</body>
</html>