<?php

/*
Expected parameters:

Disease: string representing a disease. Use table "diseases_code" to get the corresponding code for this string.
sender: a Geochat username.
Quantity: number of cases or deaths. May be: "1 case", "N cases", "1 death", "N deaths", where 1 < N <= 8.
Day: day number of the reported case/death. A number from 1 to 31.
*/

function exception_handler($e) {
        echo $e->getMessage();
        exit();
}

set_exception_handler('exception_handler');

require 'api.php';

$con = mysql_connect("localhost","root","root");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }

mysql_select_db("db_geochat", $con);

$result = mysql_query("SELECT * FROM diseases_code");

while($row = mysql_fetch_array($result))
  {
	if (strcmp(strtolower(trim($Disease)), strtolower(trim($row['Diseases']))) == 0)
		$disease_code = $row['ds_code'];
  }

$rss = get_user_messages($sender);
if (sizeof($rss->items) == 0)
	die('User sent no messages. Aborting report');
	
$item = $rss->items[0];

$lat = floatval($item['geo']['lat']);
$lon = floatval($item['geo']['long']);

$result = mysql_query("SELECT * FROM gis_village_thai");
		
$minimum_distance = 100000;		

while($row = mysql_fetch_array($result)){
	$lat_diff = $lat - floatval($row['lat']);
	$lon_diff = $lon - floatval($row['long_']);
	
	$distance = $lat_diff * $lat_diff + $lon_diff * $lon_diff;
	
	echo $distance."\n";
	
	if ($distance < $minimum_distance){
		$code = $row['vill_code'];
		$minimum_distance = $distance;
	}
}

$plain_quantity = substr($Quantity, 0, 1);

$is_death = strpos($Quantity, "death");

$date_of_disease = mktime(0, 0, 0, date("m") - (date("d") < $Day ? 1 : 0), $Day, date("y"));

$date_of_disease_for_db = date('Ymd', $date_of_disease);

if ($is_death){
	$query = "INSERT INTO geochat ( disease, date_report, location, cases, deaths, date_of_desease, sender ) VALUES (".$disease_code.", NOW(), '".$code."', 0, ".$plain_quantity.", '".$date_of_disease_for_db."', '".$sender."')";
} else {
	$query = "INSERT INTO geochat ( disease, date_report, location, cases, deaths, date_of_desease, sender ) VALUES (".$disease_code.", NOW(), '".$code."', ".$plain_quantity.", 0, '".$date_of_disease_for_db."', '".$sender."')";
}

echo $query;

if (!mysql_query($query, $con)) {
	die('Error: ' . mysql_error());
}
echo "1 record added";

mysql_close($con);

?>
