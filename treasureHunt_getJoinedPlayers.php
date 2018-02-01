<?PHP

	require_once("db.php");


	if(isset($_REQUEST["roomID"]) && isset($_REQUEST["userID"]) && isset($_REQUEST["hashkey"])) {

		$db = new DB("localhost", "root", "", "treasurehunt");

		$roomID = $_REQUEST["roomID"];
		$userID = $_REQUEST["userID"];
		$hashkey = $_REQUEST["hashkey"];

		$SQL = "SELECT hashID FROM hash WHERE userID = ? AND hashkey = ?";
		$types = "is";
		$params = [$userID, $hashkey];

		$matrix = $db->getData($SQL, $types, $params);

		if(count($matrix) == 1) {

			$SQL = "SELECT userID FROM user_room WHERE roomID = ?";
			$types = "i";
			$params = $roomID;

			$matrix = $db->getData($SQL, $types, $params);
			$usernames = array();

			for($i = 0; $i<count($matrix); $i++) {

				$SQL = "SELECT username FROM users WHERE userID = ?";
				$types = "i";
				$params = $matrix[$i][0];

				$temp = $db->getData($SQL, $types, $params);

				$usernames[$i] = $temp[0][0];

			}
			
			$usernames = json_encode($usernames, JSON_FORCE_OBJECT);
			echo($usernames);

		} else {

			echo("No user found");

		}


	} else {

		echo("Missing arguments");

	}



?>