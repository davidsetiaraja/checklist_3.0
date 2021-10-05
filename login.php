<?php

require"../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
	// code..
	$response = array();
	$nik = $_POST['nik'];
	$password = $_POST['password'];	


	$cek = "SELECT * FROM karyawan WHERE nik='$nik' and password='$password'";
	$result = mysqli_fetch_array(mysqli_query($con, $cek));

	if (isset($result)) {
		// code...
		$response['value']=1;
		$response['message']="Login Berhasil";
		echo json_encode($response);
	} else {
		// code...
		$response['value']=0;
		$response['message']="Login Gagal";
		echo json_encode($response);
	}
}

?>