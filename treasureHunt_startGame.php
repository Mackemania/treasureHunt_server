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

			$SQL = "UPDATE gameroom SET gameOver = ? WHERE roomID = ?";
			$types = "ii";
			$params = [1, $roomID];

			$db->execute($SQL, $types, $params);

			echo("1");

		} else {

			echo("No user found");
		}

	} else {

		echo("Missing arguments");
	}

?>