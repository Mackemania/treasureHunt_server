<?PHP
	require_once("db.php");

	$db = new DB("localhost", "root", "", "treasurehunt");
	
	if(isset($_REQUEST["userID"]) && isset($_REQUEST["hashkey"])) {

		$userID  =$_REQUEST["userID"];
		$hashkey = $_REQUEST["hashkey"];

		$SQL = "SELECT hashID FROM hash WHERE userID = ? AND hashkey = ?";
		$types = "is";
		$params = [$userID, $hashkey];

		$matrix = $db->getData($SQL, $types, $params);

		if(count($matrix == 1)) {

			$SQL = "DELETE FROM hash WHERE userID = ?";
			$types = "i";
			$params = $userID;

			$db->execute($SQL, $types, $params);

		}
		

	} else {

		echo("Missing arguments");
	}


?>