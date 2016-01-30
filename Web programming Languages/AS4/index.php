<?php
error_reporting(E_ERROR | E_PARSE);
	
	$con = mysqli_connect('localhost','root','','book');
	header('Content-type: application/json');
	
	$qs=explode('/',$_SERVER['REQUEST_URI']);
	$l = sizeof($qs);
	
	$author_names='';
	$book_id = $qs[$l-1];
	
	$query = mysqli_query($con,"select author_id from book_authors where book_id='$book_id'");
	if(mysqli_num_rows($query)>0){
		while($row1 = mysqli_fetch_array($query)){
			$author_id = $row1['author_id'];
			$query1 = mysqli_query($con,"select author_name from authors where author_id='$author_id'");
			if(mysqli_num_rows($query1)>0){
				while($row2 = mysqli_fetch_array($query1)){
					$author_names.=$row2['author_name'].", ";
				}
			}
		}
	}	
	
	if($qs[$l-1]!=""){
		$book_id = $qs[$l-1];
		$sql = "SELECT * from book where book_id = '$book_id'";
		$result = mysqli_query($con,$sql);
		if(mysqli_num_rows($result)>0){
		while($row = mysqli_fetch_array($result)){
			$msg[] =  array("title"=>$row['title'], "price"=>$row['price'], "year"=>$row['year'], "category"=>$row['category'],"author"=>substr($author_names, 0, -2));
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
			echo $row['title']. PHP_EOL;
		}
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