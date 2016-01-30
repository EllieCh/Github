<?php
session_start();
$name = $email = $username = $password = "";

$err = "User already exists";

//username password name email privilege

include 'main.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$name = test_input($_POST["name"]);
	$email = test_input($_POST["email"]);
	$username = test_input($_POST["username"]);
	$password = test_input($_POST['password']);
}

$query = 'SELECT * FROM `user` WHERE `username`="' . $username . '"';
$result = $conn -> query($query);
if (mysqli_num_rows($result) == 0) {
	$query = 'INSERT INTO `user`(`username`, `password`, `name`, `email`) VALUES ("' . $username . '","' . $password . '","' . $name . '","' . $email . '")';
	$result = $conn -> query($query);
	$_SESSION['username'] = $username;
	$_SESSION['name'] = $name;
	$_SESSION['privileges'] = "";
	echo "success";
} else {
	echo $err;
}
?>