<?php
include 'main.php';

session_start();

$query = $rating = $review = "";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$rating = test_input($_POST['rating']);
	$review = test_input($_POST['review']);
}

$query = 'Select * from `movierating` where `user`="' . $_SESSION['username'] . '" and `movieID`=' . $_SESSION['id'];
$result = $conn -> query($query);

if ($row = mysqli_fetch_assoc($result)) {
	$query = 'UPDATE `movierating` SET `review`="' . $review . '",`rating`=' . $rating . '
				WHERE `user`="' . $_SESSION['username'] . '" and `movieID`=' . $_SESSION['id'];
} else {
	$query = 'INSERT INTO `movierating`(`movieID`, `user`, `review`, `rating`) 
				VALUES (' . $_SESSION['id'] . ',"' . $_SESSION['username'] . '","' . $review . '",' . $rating . ')';
}
	$result = $conn -> query($query);
?>