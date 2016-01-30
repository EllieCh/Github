<!doctype html>
<html lang="en">
	<?php
	session_start();	
	if(isset($_SESSION['username'])){
		header("Location: http://localhost/website/UserLogin.php");
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

		<title>Movie Box!</title>
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
						<a class="cd-signin" href="#0">Sign in</a>
					</li>
					<li>
						<a class="cd-signup" href="#0">Sign up</a>
					</li>
				</ul>
			</nav>
		</header>

		<div class="cd-user-modal">
			<!-- this is the entire modal form, including the background -->
			<div class="cd-user-modal-container">
				<!-- this is the container wrapper -->
				<ul class="cd-switcher">
					<li>
						<a href="#0">Sign in</a>
					</li>
					<li>
						<a href="#0">New account</a>
					</li>
				</ul>

				<div id="cd-login">
					<!-- log in form -->
					<form class="cd-form">
						<p>
							<span class="cd-error-message" id="login-error-message">Enter a valid Username and password!</span>
						</p>
						<p class="fieldset">
							<label class="image-replace cd-username" for="signin-username">Username</label>
							<input class="full-width has-padding has-border" id="signin-email" type="text" placeholder="Username" onfocus="javascript:hidesignin();">
						</p>
						<span id="userspan" style="display:none;color:red;"></span>

						<p class="fieldset">
							<label class="image-replace cd-password" for="signin-password">Password</label>
							<input class="full-width has-padding has-border" id="signin-password" type="password"  placeholder="Password" onfocus="javascript:hidesignin();">
							<a href="#0" class="hide-password">Show</a>
						</p>
						<span id="passspan" style="display:none;color:red;"></span>

						<p class="fieldset">
							<input class="full-width" type="submit" value="Login">
						</p>
						<span id="errormsg" style="display:none;color:red;"></span>
					</form>

				</div>

				<div id="cd-signup">
					<!-- sign up form -->
					<form class="cd-form">
						<p class="fieldset">
							<label class="image-replace cd-username" for="signup-fullname">Full Name</label>
							<input class="full-width has-padding has-border" id="signup-fullname" type="text" placeholder="Full Name" onfocus="javascript:hidesignup();">
						</p>
						<span id="error-name" style="display:none;color:red;"></span>

						<p class="fieldset">
							<label class="image-replace cd-username" for="signup-username">Username</label>
							<input class="full-width has-padding has-border" id="signup-username" type="text" placeholder="Username" onfocus="javascript:hidesignup();">
							<span class="cd-error-message" id="cd-error-message">Username already exists</span>
						</p>
						<span id="error-username" style="display:none;color:red;"></span>

						<p class="fieldset">
							<label class="image-replace cd-email" for="signup-email">E-mail</label>
							<input class="full-width has-padding has-border" id="signup-email" type="email" placeholder="E-mail" onfocus="javascript:hidesignup();">
						</p>
						<span id="error-email" style="display:none;color:red;"></span>

						<p class="fieldset">
							<label class="image-replace cd-password" for="password">Password</label>
							<input class="full-width has-padding has-border" id="password" type="password" placeholder="Password" onkeyup="passwordStrength(this.value)" onfocus="javascript:hidesignup();">
							<a href="#0" class="hide-password">Show</a>
						</p>
						<span id="error-pass" style="display:none;color:red;"></span>

						<p class="fieldset">
							<label for="accept-terms"><h2>Password Strength</h2></label>
							<div id="passwordStrength" class="strength0"></div>
							<div id="passwordDescription">
								Password not entered
							</div>
						</p>

						<p class="fieldset">
							<input class="full-width has-padding" type="submit" value="Create account">
						</p>
						<span id="error-signup" style="display:none;color:red;"></span>
					</form>

				</div>

				<a href="#0" class="cd-close-form">Close</a>
			</div>
		</div>
		<div class="container">
			<div class="slider_wrapper">
				<ul id="image_slider">
					<li><img id="1" src="img/11.jpg" alt="terminator">
					</li>
					<li><img id="2" src="img/12.jpg" alt="indiana" style="display:none;">
					</li>
					<li><img id="3" src="img/10.jpg" alt="everest" style="display:none;">
					</li>
					<li><img id="4" src="img/13.jpg" alt="terminator" style="display:none;">
					</li>
					<li><img id="5" src="img/2.jpg" alt="jurassic" style="display:none;">
					</li>
					<li><img id="6" src="img/7.jpg" alt="bean" style="display:none;">
					</li>
				</ul>
			</div>
		</div>
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
		<script src="js/main.js"></script>
		<!-- jQuery -->
		<script src="js/index.js"></script>
		
		<!-- jQuery -->
	</body>
</html>