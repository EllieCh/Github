<?php

include 'main.php';

$query = 'select r.review as review, m.name as name, m.genre as genre, m.id as id, r.rating as rating from movies m, movierating r 
			where m.id = r.movieID and r.user = "' . $_SESSION['username'] . '" ';
$result = $conn -> query($query);

while ($row = mysqli_fetch_assoc($result)) {
	echo '<tr><td id="' . $row['id'] . '" style="cursor: pointer" class="title">' . $row['name'] . '</td>
		<td>' . str_replace("|", ", ", $row['genre']) . '</td>
		<td>' . $row['rating'] . '</td>
		<td>' . $row['review'] . '</td></tr>';
}
?>