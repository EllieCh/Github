<?php

include 'main.php';

session_start();
$var = $value = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$var = test_input($_POST['a']);
	$value = test_input($_POST['b']);
}

$_SESSION[$var] = $value;

echo $_SESSION[$var];

?>