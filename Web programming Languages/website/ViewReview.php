<html lang="en">
	<?php
	session_start();
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

		<title>Update Review!</title>
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
						<a class="cd-signin" id="btnProfile" href="MyProfile.php">My Profile</a>
					</li>
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
		<div class="bcgrnd" id="update">
			<br>
			<h2 class="bold-red">Movie Review</h2>
			<?php
				include 'php/updateReview.php';
			?>
		</div>
	</body>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
	<script src="js/main.js"></script>
	<!-- jQuery -->
	<script>
		$('#update').on('click', ':submit', function() {
			var rating = $('#rating').val();
			var review = $('#review').val();
			if (review == "" | review == null) {
				alert("Review is empty");
			} else {
				dataString = "review=" + review + "&rating=" + rating;
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "php/addReview.php",
					data : dataString,
					cache : false,
					success : function(result) {
						//alert(strip(result));
						window.location.href="MyProfile.php";
					}
				});
			}
		});
	</script>
	</body>
</html>