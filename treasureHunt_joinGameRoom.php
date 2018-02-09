<?PHP

	require_once("db.php");


	if(isset($_REQUEST["name"]) && isset($_REQUEST["code"]) && isset($_REQUEST["userID"]) && isset($_REQUEST["hashkey"])) {

		$db = new DB("localhost", "root", "", "treasurehunt");

		$gameName = $_REQUEST["name"];
		$gameCode = $_REQUEST["code"];
		$userID = $_REQUEST["userID"];
		$hashkey = $_REQUEST["hashkey"];

		$SQL = "SELECT hashID FROM hash WHERE userID = ? AND hashkey = ?";
		$types = "is";
		$params = [$userID, $hashkey];

		$matrix = $db->getData($SQL, $types, $params);

		if(count($matrix) == 1) {

			$SQL = "SELECT roomID, startLat, startLong FROM gameroom WHERE roomname = ? AND roomcode = ? AND gameOver = ?";
			$types = "ssi";
			$params = [$gameName, $gameCode, 0];

			$matrix = $db->getData($SQL, $types, $params);

			if(count($matrix) == 1) {
				
				$roomID = $matrix[0][0];
				$startLat = $matrix[1][0];
				$startLong = $matrix[2][0];
				
				$SQL = "SELECT userRoomID FROM user_room WHERE roomID = ? AND userID = ?";
				$types = "ii";
				$params = [$roomID, $userID];

				$matrix = $db->getData($SQL, $types, $params);

				if(count($matrix) == 0) {

					$SQL = "SELECT locationID FROM gameroom_location WHERE gameroomID = ?";
					$types  = "i";
					$params = $roomID;

					$matrix = $db->getData($SQL, $types, $params);

					if(count($matrix)>0) {

						$locations = array();

						for($i = 0; $i<count($matrix); $i++) {

							$SQL = "SELECT locationID, latitude, longitude FROM location WHERE locationID = ?";
							$types = "i";
							$params = $matrix[$i][0];

							$temp = $db->getData($SQL, $types, $params);
							$locations[$i] = $temp[0];

						}

						if(count($locations)>0) {


							$SQL = "SELECT challengeID FROM gameroom_challenge WHERE roomID = ?";
							$types = "i";
							$params = $roomID;

							$matrix = $db->getData($SQL, $types, $params);

							if(count($matrix) > 0 ){

								$challenges = array();

								for($i = 0; $i<count($matrix); $i++) {


									$SQL = "SELECT challengeID, name, description, answer FROM challenge WHERE challengeID = ?";
									$types = "i";
									$params = $matrix[$i][0];

									$temp = $db->getData($SQL, $types, $params);

									$challenges[$i] = $temp[0];
									echo($challenges[$i][3]);
								}

								if(count($challenges) > 0) {

									$SQL = "INSERT INTO user_room(userID, roomID) VALUES(?, ?)";
									$types = "ii";
									$params = [$userID, $roomID];

									$db->execute($SQL, $types, $params);

									$startLocation = [$startLat, $startLong];

									$json = [$roomID, 1, $locations, $challenges, $startLocation];
									$json = json_encode($json, JSON_FORCE_OBJECT);
									echo($json);

								} else {

									echo("Challenges were corrupt");
								}

							} else {

								echo("No challenges found!");
							}

						} else {

							echo("Locations were corrupt");
						}

					} else {

						echo("No locations found");
					}
				
				} else {

					echo("User already joined");

				}
				
			} else {

				echo("No gameroom found!");
			}

		} else {

			echo("No user found");

		}

	} else {

		echo("Missing arguments");

	}



?>