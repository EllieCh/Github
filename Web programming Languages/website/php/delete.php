<?php
include 'main.php';
session_start();
header("Location: ../UserLogin.php");
if($_SESSION['privileges'] == "a"){
	$query = 'DELETE FROM `movies` WHERE `id`='.$_SESSION['id'];
	$result = $conn->query($query);
	$query = 'DELETE FROM `movieRating` WHERE `movieID`='.$_SESSION['id'];
	$result = $conn->query($query);
}
?>
