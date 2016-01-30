<?php
$q = intval($_GET['q']);
$g = $_GET['g'];
$con = mysqli_connect('localhost','root','','babies');

if(!$con){
	die('Could not connect: ' . mysqli_error($con));
}
$sql = "SELECT name,rank from babynames where year = '".$q."'" . "and gender='".$g."'";
$result = mysqli_query($con,$sql);
echo "<ul>";
while($row = mysqli_fetch_array($result)){
  echo "<li>". $row['name'] ." - ". $row['rank'] ."</li>";
  }
echo "</ul>";
mysqli_close($con);

?>