<?php

session_start();

if(isset($_COOKIE['username'])&&isset($_SESSION['username'])&&isset($_SESSION['fullname'])&&isset($_SESSION['email'])){

echo "<br/> Hello ".$_COOKIE['username']."!!";

echo "<br/><br/> Your Details are:<br/> Username : ".$_SESSION['username'].",<br/> Full Name : ".$_SESSION['fullname'].",<br/> Email Id : ".$_SESSION['email'];

}
?>