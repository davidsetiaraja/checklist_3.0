<?php

require"../config/connect.php";

if ($_SERVER['REQUEST_METHOD']=="POST"){
	// code..
	$response = array();
	$nik = $_POST['nik'];
	$password = $_POST['password'];	
	$nama_lengkap = $_POST['nama_lengkap'];
	$handphone = $_POST['handphone'];
	$email = $_POST['email'];

	$cek = "SELECT * FROM karyawan WHERE nik='$nik'"
	$result = mysqli_fetch_array(mysqli_query($con, $cek));

	if (isset($result)) {
		// code...
		$response['value']=2;
		$response['message']="NIK teleah digunakan";
		echo json_encode($response);
	} else {
		// code...
		$insert = "INSERT INTO users VALUE(NULL, '$nik', '$password', '$nama_lengkap', '$handphone','$email')";
		if (mysqli_query($con, $insert)){
		// code...
			$response['value']=1;
			$response['message']="Berhasil didaftarkan";
			echo json_encode($response);
		} else {
	 	// code...
		$response['value']=0;
		$response['message']="Gagal didaftarkan";
		echo json_encode($response);
	}
}

?>