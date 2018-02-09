<?PHP

	require_once("db.php");


	if(isset($_REQUEST["name"]) && isset($_REQUEST["code"]) && isset($_REQUEST["location"]) && isset($_REQUEST["userID"]) && isset($_REQUEST["hashkey"])) {

		$numberOfchallenges = 10;

		$db = new DB("localhost", "root", "", "treasurehunt");

		$gameName = $_REQUEST["name"];
		$gameCode = $_REQUEST["code"];
		$location = $_REQUEST["location"];
		
		$location = json_decode($location, TRUE);
		$latitude = $location["latitude"];
		$longitude = $location["longitude"];

		$userID = $_REQUEST["userID"];
		$hashkey = $_REQUEST["hashkey"];

		$SQL = "SELECT hashID FROM hash WHERE userID = ? AND hashkey = ?";
		$types = "is";
		$params = [$userID, $hashkey];

		$matrix = $db->getData($SQL, $types, $params);

		if(count($matrix) == 1) {

			// 2/(cos(lat)*111.32) = 2km/ longgrad
			// 2/(cos(long)*111.19) = 2km / latgrad

			$SQL = "INSERT INTO gameroom(roomcode, roomname, creatorID, gameOver, startLat, startLong) VALUES(?, ?, ?, ?, ?, ?)";
			$types = "ssiidd";
			$params = [$gameCode, $gameName, $userID, 0, $latitude, $longitude];

			$db->execute($SQL, $types, $params);

			$SQL = "SELECT roomID FROM gameroom WHERE roomcode = ? AND roomname = ? AND gameOver = ?";
			$types = "ssi";
			$params = [$gameCode, $gameName, 0];

			$matrix = $db->getData($SQL, $types, $params);

			//var_dump($matrix);
			
			if(count($matrix) == 1) {

				$roomID = $matrix[0][0];

				$SQL = "INSERT INTO user_room(userID, roomID) VALUES(?, ?)";
				$types = "ii";
				$params = [$userID, $roomID];

				$db->execute($SQL, $types, $params);

				$longdifference = abs(2/((cos($latitude*(pi()/180)))*111.32));
				$latdifference = abs(2/((cos($longitude*(pi()/180)))*111.19));

				$longmin = $longitude-$longdifference;
				$longmax = $longitude+$longdifference;
				$latmin = $latitude-$latdifference;
				$latmax = $latitude+$latdifference;

				//echo($longmin." ".$longmax." ".$latmin." ".$latmax);

				$SQL = "SELECT locationID, latitude, longitude FROM location WHERE latitude > ? AND latitude < ? AND longitude> ? AND longitude < ?";
				$types = "dddd";
				$params = [$latmin, $latmax, $longmin, $longmax];

				$matrix = $db->getData($SQL, $types, $params);
				
				if(count($matrix) > 0) {

					$locations = $matrix;

					$SQL = "SELECT challengeID, name, description, answer FROM challenge WHERE challengeID <> ?";
					$types = "i";
					$params = 0;

					$matrix = $db->getData($SQL, $types, $params);

					
					//echo(count($matrix)."\n");
					
					if(count($matrix)>0) {

						$challenges = $matrix;
						
						shuffle($challenges);
						shuffle($locations);
						
						$locationsLength = count($locations);
						$challengesLength = count($challenges);

						if($locationsLength>$challengesLength) {

							for($i = ($locationsLength-1); $i>=$challengesLength; $i--) {
								
								//echo("Removing ".$i."\n");
								unset($locations[$i]);
							
							}

						} else if($locationsLength<$challengesLength) {

							for($i = ($challengesLength-1); $i>=$locationsLength; $i--) {
								
								unset($challenges[$i]);
							
							}

						}

						//var_dump($locations);

						for($i = 0; $i<count($locations); $i++) {
							
							if($i<$numberOfchallenges) {
								$locationID = $locations[$i][0];

								//echo($locationID);

								$SQL = "INSERT INTO gameroom_location(gameroomID, locationID) VALUES(?, ?)";
								$types = "ii";
								$params = [$roomID, $locationID];

								$db->execute($SQL, $types, $params);
							
							} else {

								unset($locations[$i]);

							}
						}

						for($i = 0; $i<count($challenges); $i++) {

							if($i<$numberOfchallenges) {
								$challengeID = $challenges[$i][0];

								//echo($locationID);

								$SQL = "INSERT INTO gameroom_challenge(roomID, challengeID) VALUES(?, ?)";
								$types = "ii";
								$params = [$roomID, $challengeID];

								$db->execute($SQL, $types, $params);
							
							} else {

								unset($locations[$i]);

							}
						}
					

						$json = [$roomID, 1, $locations, $challenges];
						$json = json_encode($json, JSON_FORCE_OBJECT);

						echo($json);


					} else {

						echo("No challenges found");
					}

				} else {

					echo("No locations found");

				}

			} else {

				echo("No gameroom created");

			}
			

		} else {

			echo("No user found");

		}


	} else {

		echo("Missing arguments");

	}

?>