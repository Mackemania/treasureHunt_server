<?PHP

	require_once("db.php");
	$db = new DB("localhost", "root", "", "treasurehunt");

	if(isset($_REQUEST["username"]) && isset($_REQUEST["password"]) && isset($_REQUEST["firstName"]) && isset($_REQUEST["lastName"])) {

		$username = $_REQUEST["username"];
		$password = $_REQUEST["password"];
		$firstName = $_REQUEST["firstName"];
		$lastName = $_REQUEST["lastName"];

		$SQL = "SELECT username FROM users WHERE username = ?";
		$types = "s";
		$values = $username;
		$matrix = $db->getData($SQL, $types, $values);

		if(count($matrix) == 0) {

			$SQL = "INSERT INTO users(username, password, firstName, lastName) VALUES(?, ?, ?, ?)";
			$types = "ssss";
			$values = [$username, $password, $firstName, $lastName];
			$db->execute($SQL, $types, $values);

			echo("1");

		} else {

			echo("Username already in use");
		}

	} else {

		echo("Missing arguments");

	}

?>