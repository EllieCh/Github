<?php
include 'main.php';

$query = 'SELECT m.name as title, r.rating as rating, r.review as review FROM `movierating` r, `movies` m 
		WHERE r.movieID = ' . $_SESSION['id'] . ' and r.user = "' . $_SESSION['username'] . '" and m.id = r.movieID';
$result = $conn -> query($query);

if ($row = mysqli_fetch_assoc($result)) {

	echo '<br>Movie Title: ' . $row['title'] . '<br>
		<form>Rating:
			<select name="rating" id = "rating">
				<option value="1"';
	if ($row['rating'] == 1) {echo ' selected';
	}
	echo '>1</option><option value="2"';
	if ($row['rating'] == 2) {echo ' selected';
	}
	echo '>2</option><option value="3"';
	if ($row['rating'] == 3) {echo ' selected';
	}
	echo '>3</option><option value="4"';
	if ($row['rating'] == 4) {echo ' selected';
	}
	echo '>4</option><option value="5"';
	if ($row['rating'] == 5) {echo ' selected';
	}
	echo 		'>5</option>
			</select><br>
		Movie Review:
		<br>
		<textarea id="review" name="review" rows="4" cols="50">'.$row['review'].'</textarea>
		<br>
		<input type="submit" value="Update" id="btnSubmit">
		</form>';
}
?>