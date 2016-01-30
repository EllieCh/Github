<?php

session_start();

	if(isset($_POST['Submit'])){

		$username = mysql_real_escape_string($_POST['username']);
		$fullname = mysql_real_escape_string($_POST['name']);
		$email = mysql_real_escape_string($_POST['email']);

		setcookie('username',$username);

		$_SESSION['username'] = $username;
		$_SESSION['fullname'] = $fullname;
		$_SESSION['email'] = $email;


		header('location:welcome.php');

	}



?>