<?php
$output = NULL;

if (isset($_POST['Submit'])){
	//Connect to the datatbase
	$mysqli = NEW MySQLi("localhost", "root", "", "babies");
	
	$year = $mysqli->real_escape_string($_POST['year']);
	$gender = $mysqli->real_escape_string($_POST['gender']);
	
	//Query the database
	$resultSet = $mysqli->query("SELECT * FROM babynames WHERE year='$year' AND gender='$gender'");
	
	if($resultSet->num_rows > 0){
		while($rows = $resultSet->fetch_assoc())
		{
			$name = $rows['name'];
						
			$output = "Most popular baby name: $name";
		}
	}
	else{
		$output = "Enter the correct details!";
	}
}

?>

<?php echo $output; ?>