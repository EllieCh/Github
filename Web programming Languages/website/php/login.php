<?php
session_start();
include 'main.php';
$username = $password = "";

$err = "Enter correct username and password";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$username = test_input($_POST['username']);
	$password = test_input($_POST['password']);
}

$query = 'SELECT * FROM `user` where (`username` = "' . $username . '" or `email` = "' . $username . '") and `password` = "' . $password . '"';
$result = $conn -> query($query);

if ($row = mysqli_fetch_assoc($result)) {
	$_SESSION['username'] = $username;
	$_SESSION['name'] = $row['name'];
	$_SESSION['privileges'] = $row['privileges'];

	if ($row['privileges'] == 'a') {
		echo $row['privileges'];
	} else {
		echo $row['privileges'];
	}
} else {
	echo $err;
}
?>