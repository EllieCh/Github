<?php
include 'main.php';

$query = "";

if (!isset($_SESSION['id'])) {
	echo "error loading Session ID";
} else {

	$query = 'SELECT `name` FROM `movies` where `id`=' . $_SESSION['id'];
	$result = $conn -> query($query);
	if ($row = mysqli_fetch_assoc($result)) {
		echo '<br>Movie Title: ' . $row['name'] . '<br>';
	}

	$query = 'SELECT m.review as review, u.name as name, m.rating as rating FROM `movierating` m, `user` u 
	where m.movieID=' . $_SESSION['id'] . ' AND u.username=m.user ';

	$result = $conn -> query($query);

	while ($row = mysqli_fetch_assoc($result)) {
		echo $row['name'] . ' says:<br>';
		echo '"' . $row['review'] . '"<br>';
		echo "<hr/>";
	}
}
?>