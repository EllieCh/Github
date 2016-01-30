<?php
$title = $year = $genre = $description = "";

//username password name email privilege
include 'main.php';

$query = 'SELECT * FROM `movies` where `id`=' . $_SESSION['id'];
$result = $conn -> query($query);
if ($row = mysqli_fetch_assoc($result)) {
	echo '<label class="bold-red">Movie Title:</label><br>';
	echo '<input id="title" type="text" name="title" value="' . $row['name'] . '"><br><br>';
	echo '<label class="bold-red">Year:</label><br>';
	echo '<input id="year" type="text" name="year" value="' . $row['year'] . '"><br><br>';
	echo '<label class="bold-red">Genre: (Use | to add multiple genres. For Example "chidren|play")</label><br>';
	echo '<input size="50" id="genre" type="text" name="genre" value="' . $row['genre'] . '"><br><br>';
}
?>