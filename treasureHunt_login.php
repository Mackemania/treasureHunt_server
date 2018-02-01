<?PHP
	require_once("db.php");
	$db = new DB("localhost", "root", "", "treasurehunt");

	$hashLength = 32;

	if(isset($_REQUEST["username"]) && isset($_REQUEST["password"])) {

		$user = $_REQUEST["username"];
		$password = $_REQUEST["password"];

		$SQL = "SELECT userID FROM users WHERE username=? AND BINARY password=?";
		$types= "ss";
		$params= [$user, $password];
		$matrix = $db->getData($SQL, $types, $params);

		if(count($matrix)==1) {

			$hashkey= "";
			while(strlen($hashkey)<($hashLength*2)) {

				$hashkey= "";
				for($i=0; $i<$hashLength; $i++) {

					$int = random_int(1, 255);
					$temp = dechex($int);

					if(strlen($temp)<2) {
						$temp = "0".$temp;
					}
					$hashkey = $hashkey.$temp;
				}
			}

			$userID = $matrix[0][0];
			$SQL = "INSERT INTO hash(userID, hashkey) VALUES(?, ?)";
			$types= "is";
			$params= [$userID, $hashkey];
			$db->execute($SQL, $types, $params);

			$userHash= [$userID, $hashkey];
			$userHash= json_encode($userHash, JSON_FORCE_OBJECT);
			echo($userHash);
		
		} else {

			echo "Something is wrong";
		}

	} else {

		echo "Missing argument";
	}

?>