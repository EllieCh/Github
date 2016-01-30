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
	$query = 'UPDATE `movies` SET `name`="'.$title.'",`year`='.$year.',`genre`="'.$genre.'" WHERE `id`=' . $_SESSION['id'];	
	$result = $conn -> query($query);
	echo "u";
?>