<?
	require_once 'configuration.php';
	
	function open_db()
	{
		$conn = mysql_connect(DB_HOST . ':' . DB_PORT,DB_USERNAME,DB_PASSWORD) or die('Could not connect to database');
		mysql_select_db(DB_SCHEMA, $conn);
		return $conn;
	}
	
	function close_db($conn)
	{
		mysql_close($conn);
	}

	function insert_log($desc)
	{
		$conn = open_db();
		mysql_query("INSERT INTO `" . DB_TABLE_LOG . "`(date,description) VALUES (now(), '{$desc}')", $conn);
		close_db($conn);
	}
	
	function get_disease_code($disease)
	{
		$conn = open_db();
		
		$result = mysql_query("SELECT * FROM " . DB_TABLE_DISEASE, $conn);
		$code = NULL;

		while($row = mysql_fetch_array($result))
		{
			if (strcmp(strtolower(trim($disease)), strtolower(trim($row['Diseases']))) == 0) {
				$code = $row['ds_code'];
			}
		}
		
		if ($code == NULL)
			throw new Exception("Could not get disease code for disease {$disease}");
		
		close_db($conn);
		
		return $code;
	}
	
	function get_location($lat, $lon)
	{
		if ($lat == NULL || $lon == NULL) return NULL;
		
		$minimum_distance = 100000;
		
		$conn = open_db();
		
		$result = mysql_query("SELECT * FROM " . DB_TABLE_LOCATION, $conn);	
		$code = NULL;

		while($row = mysql_fetch_array($result))
		{
			$lat_diff = $lat - floatval($row['lat']);
			$lon_diff = $lon - floatval($row['long_']);

			$distance = $lat_diff * $lat_diff + $lon_diff * $lon_diff;

			if ($distance < $minimum_distance)
			{
				$code = $row['vill_code'];
				$minimum_distance = $distance;
			}
		}
		
		close_db($conn);
		
		if ($code == NULL)
			throw new Exception("Could not get location for lat {$lat} and lon {$lon}");
		
		return $code;
	}
	
	function insert_report($disease_code, $onset_date, $admit_date, $age, $location, $house_number, $sender)
	{
		$onset_date = isset($onset_date) ? "'{$onset_date}'" : "NULL";
		$admit_date = isset($admit_date) ? "'{$admit_date}'" : "NULL";
		$age = isset($age) ? "{$age}" : "NULL";
		$location = isset($location) ? "'{$location}'" : "NULL";
		$house_number = isset($house_number) ? "'{$house_number}'" : "NULL";
		$sender = isset($sender) ? "'{$sender}'" : "NULL";
		
		$query = "INSERT INTO " . DB_TABLE_REPORT . "(disease_code, report_date, onset_date, admit_date, age, location, house_number, sender) VALUES ({$disease_code}, NOW(), {$onset_date}, {$admit_date}, {$age}, {$location}, {$house_number}, {$sender})";
		echo $query;
		
		$conn = open_db();
		$result = mysql_query($query, $conn);
		close_db($conn);
		
		if (!$result)
			throw new Exception("Could not insert report into db: " . mysql_error());
	}
?>