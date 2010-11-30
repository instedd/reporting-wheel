This is a third-party application that uses the pushing feature of the Reporting Wheel combined with Seentags and GeoChat.
The application expects the following data:

	* OnsetDate: a number between 1-31 that serves as a date
	* AdmitDate: a number between 1-31 that serves as a date
	* Disease: a string representing the name of a disease
	* Age: integer number
	* House: a string representing the number of the house of the 
	* lat: latitude of the geolocation of the report
	* lon: longitude of the geolocation of the report
	* sender: login name of GeoChat user that is reporting the case
	
Lat/Long is used to identify a code for a location. Disease name is used to find the proper code for the disease.

Requires:
	* PHP
	* MySQL

Usage:
	* Import the schema to your DB using "db.sql"
	* Configure parameters in "configuration.php"
	* Create a new report set in Seentags, point the callback to the location of "insert.php"
	* Create a Wheel and point the URL Callback to the report set URL given in Seentags
	* Configure your GeoChat group to use structured data services, and point it to the Reporting Wheel decode URL ("/decode/wheel")
	
	