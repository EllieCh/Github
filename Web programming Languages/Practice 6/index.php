<?php
error_reporting(E_ERROR | E_PARSE);
	
	$con = mysqli_connect('localhost','root','','book');
	header('Content-type: application/json');
	
	if(!empty($_GET['book_id'])){
		$book_id = $_GET['book_id'];
		$sql = "SELECT * from book where book_id = '$book_id'";
		$result = mysqli_query($con,$sql);
		if(mysqli_num_rows($result)>0){
		while($row = mysqli_fetch_array($result)){
			$msg[] =  array("title"=>$row['title'], "price"=>$row['price'], "year"=>$row['year'], "category"=>$row['category']);
		}
		$json = $msg;
		deliver_response(200, "Book Found", $json);
		}
		else{
		deliver_response(404, "Invalid Request", NULL);
		}
		mysqli_close($con);
	}
	else{
		$sql = "SELECT title from book";
		$result = mysqli_query($con,$sql);
		while($row = mysqli_fetch_array($result)){
			$msg[] = $row['title'];
		}
		$json = $msg;
		deliver_response(200, "List of Books", $json);
		mysqli_close($con);
	}
	@mysql_close($conn);
	function deliver_response($status, $status_message, $data){
		header("HTTP/1.1 $status $status_message");
		$response['status'] = $status;
		$response['status_message'] = $status_message;
		$response['data'] = $data;
		$json_response = json_encode($response);
		echo $json_response;
	}
?>