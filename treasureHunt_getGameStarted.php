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

			$SQL = "SELECT gameOver FROM gameroom WHERE roomID = ?";
			$types = "i";
			$params = $roomID;

			$matrix = $db->getData($SQL, $types, $params);

            if(count($matrix) == 1) {
				
                if($matrix[0][0] == 1) {
                    
                    echo("1");

                } else {

					echo("Game not started");
				}
                
            } else {

				echo("Too many rooms");
			}
            

		} else {

			echo("No user found");
		}

	} else {

		echo("Missing arguments");
	}

?>