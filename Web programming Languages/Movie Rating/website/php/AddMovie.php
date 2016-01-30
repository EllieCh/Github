<?php
session_start();
$title = $year = $genre = $description = "";

//username password name email privilege
include 'main.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$title = test_input($_POST["title"]);
	$year = test_input($_POST["year"]);
	$genre = test_input($_POST["genre"]);
	$description = test_input($_POST['description']);
}
$query = 'SELECT * FROM `movies` where `name`="' . $title . '" and `year`=' . $year;
$result = $conn -> query($query);
if (!($row = mysqli_fetch_assoc($result))) {
	$query = 'SELECT max(id) as id FROM `movies`';
	$result = $conn -> query($query);
	$row = mysqli_fetch_assoc($result);
	$id = intval($row['id']) + 1;
	$query = 'INSERT INTO `movies`(`id`, `name`, `year`, `genre`, `description`) VALUES (' . $id . ',"' . $title . '","' . $year . '","' . $genre . '","' . $description . '")';
	$result = $conn -> query($query);
	echo "a";
} else {
	$_SESSION['id'] = $row['id'];
	echo "u";
}
?>