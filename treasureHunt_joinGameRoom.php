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

            $SQL = "SELECT roomID FROM gameroom WHERE roomname = ? AND roomcode = ? AND gameOver = ?";
            $types = "ssi";
            $params = [$gameName, $gameCode, 0];

            $matrix = $db->getData($SQL, $types, $params);

            if(count($matrix) == 1) {
                
                $roomID = $matrix[0][0];
                $SQL = "INSERT INTO user_room(userID, roomID) VALUES(?, ?)";
                $types = "ii";
                $params = [$userID, $roomID];

                $db->execute($SQL, $types, $params);

                $json = [$roomID, 1];
                $json = json_encode($json, JSON_FORCE_OBJECT);
                echo($json);
                
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