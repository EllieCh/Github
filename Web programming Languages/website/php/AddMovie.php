<?php
	session_start();
	$title = $year = $genre = $description = "";
	
	//username password name email privilege
	
	$conn = new mysqli('localhost', 'root', '', 'imdb');
	
	if($_SERVER["REQUEST_METHOD"] == "POST"){
		$title = test_input($_POST["title"]);
		$year = test_input($_POST["year"]);
		$genre = test_input($_POST["genre"]);
		$description = test_input($_POST['description']);
	}
	
	$query = 'SELECT max(id) as id FROM `movies`';
	$result = $conn->query($query);	
	$row = mysqli_fetch_assoc($result);
	$id = intval($row['id']) + 1;
	$query = 'INSERT INTO `movies`(`id`, `name`, `year`, `genre`, `description`) VALUES ('.$id.',"'.$title.'","'.$year.'","'.$genre.'","'.$description.'")';
	$result = $conn->query($query);
	echo "added";
	function test_input($data)
	{
 		$data = trim($data);
  		$data = stripslashes($data);
  		$data = htmlspecialchars($data);
  		return $data;
	}
?>