<?php
	ini_set("display_errors", 1);
	
	require_once 'exception.php';
	require_once 'configuration.php';
	require_once 'db.php';
	
	// Extract variables from request
	$disease = var_from_post(POST_DISEASE);
	$onset_date = var_from_post(POST_ONSET_DATE);
	$admit_date = var_from_post(POST_ADMIT_DATE, false);
	$age = to_int(var_from_post(POST_AGE), POST_AGE);
	$house_number = var_from_post(POST_HOUSE_NUMBER);
	$lat = to_float(var_from_post(POST_LAT), POST_LAT);
	$lon = to_float(var_from_post(POST_LON), POST_LON);
	$sender = var_from_post(POST_SENDER);
	
	// Get disease code based on disease name
	$disease_code = get_disease_code($disease);
	
	// Get location based on latitude and longitude
	$location = get_location($lat, $lon);
	
	// Build dates based on reported days
	$onset_date = day_to_date($onset_date);
	if (isset($admit_date))
	{
		$admit_date = day_to_date($admit_date);
	}
	
	// Insert report
	insert_report($disease_code, $onset_date, $admit_date, $age, $location, $house_number, $sender);
	
	// ======= AUX =======
	function var_from_post($name,$required = true)
	{
		if (isset($_POST[$name]))
			return $_POST[$name];
		if ($required)
			throw new Exception("Variable {$name} missing in POST data");
		
		return NULL;
	}
	
	function day_to_date($day)
	{
		$date = mktime(0, 0, 0, date("m") - (date("d") < $day ? 1 : 0), $day, date("y"));
		$date = date('Ymd', $date);
		
		return $date;
	}
	
	function to_int($val, $field_name)
	{
		if (is_numeric($val))
			return intval($val);
		else
			throw new Exception("Could not parse {$field_name} as integer");
	}
	
	function to_float($val, $field_name)
	{
		if (is_numeric($val))
			return floatval($val);
		else
			throw new Exception("Could not parse {$field_name} as float");
	}
?>