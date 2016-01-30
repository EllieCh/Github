<?php

	$paramsName = $_POST["userName"];
	$paramsEmail = $_POST["email"];
	$paramsPhone = $_POST["Phone"];
	$paramstextData = $_POST["textData"];
	$paramstextProduct = $_POST["textProduct"];

	$mailto="md@rayssolartechnologies.com,gm@rayssolartechnologies.com,info@rayssolartechnologies.com";  //Enter recipient email address here
    $subject = "Ray Solar Webmaster - Customer product or service interest";
	   
    $from="info@rayssolartechnologies.com";    
	$headers = "From: " .  $from . "\r\n";
	$headers .= "MIME-Version: 1.0\r\n";
	$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
	   
	$headers .= "MIME-Version: 1.0\r\n";
	$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";	 
	$message = '<html><body style="padding: 5px;" >';
	$message .= '<img src="http://rayssolartechnologies.com/img/logo11.png" style="padding: 5px;"  alt="Webmaster" />';
	$message .= "<p><strong>Hello admin,</strong></p>";
	$message .= "<p>Following are the details of the customer who shown interest in our product</p>";
	$message .= '<table rules="all" style="border:1px solid;" cellpadding="5">';
	$message .= "<tr style='background: #eee;'><td><strong>Name:</strong> </td><td>" . $paramsName . "</td></tr>";
	$message .= "<tr><td><strong>Email:</strong> </td><td>" . $paramsEmail . "</td></tr>";
	$message .= "<tr><td><strong>Phone:</strong> </td><td>" . $paramsPhone . "</td></tr>";
	$message .= "<tr><td><strong>Message:</strong> </td><td>" . $paramstextData . "</td></tr>";
	$message .= "<tr><td><strong>Interested In:</strong> </td><td>" . $paramstextProduct . "</td></tr>";
	$message .= "</table>";
	$message .= "</body></html>";		

    mail($mailto,$subject,$message,$headers);
    echo "Thank You , your email has been sent successfully";
?>