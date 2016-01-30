<?php
include 'main.php';
session_start();
$query = $search = $text = $rating = "";
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$search = test_input($_POST['search']);
	$text = test_input($_POST['value']);
}
if ($text == "" || $text == null) {
	$query = 'SELECT * FROM `movies` limit 0,100';
} else {
	if ($search == "title") {
		$query = 'SELECT * FROM `movies` where name like "%' . $text . '%"';
	} else {
		$query = 'SELECT * FROM `movies` where genre like "%' . $text . '%"';
	}
}
$result = $conn -> query($query);

while ($row = mysqli_fetch_assoc($result)) {
	$query = 'SELECT AVG(rating) as rating FROM `movierating` WHERE movieID=' . $row['id'];
	$newResult = $conn -> query($query);
	$r = mysqli_fetch_assoc($newResult);
	if ($r['rating'] != null || $r['rating'] == "null" || $r['rating'] == "0") {
		$rating = round($r['rating'], 1);
	} else {
		$rating = rand(1,5);
	}
	echo '<tr class="rows">
	<td class ="title" id="' . $row['id'] . '" style="cursor: pointer">' . $row['name'] . '</td>
	<td>' . str_replace("|", ", ", $row['genre']) . '</td>
	<td>' . $row['year'] . '</td>
	<td>' . $rating . '</td>';
	if ($_SESSION['privileges'] == 'a') {
		echo '<td><button class="btnDelete">Delete Movie</button></td>';
	}
	echo '</tr>';
}
?>