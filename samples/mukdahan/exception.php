<?php
	require_once 'db.php';

	function exception_handler($e)
	{
			$desc = "Error: " . $e->getMessage();
			$desc = $desc . " -- Post Data: ";
			foreach($_POST as $key => $value)
			{
				$desc = $desc . "{$key} => {$value} , ";
			}
			insert_log($desc);
			echo $desc;
	        exit();
	}

	set_exception_handler('exception_handler');
?>