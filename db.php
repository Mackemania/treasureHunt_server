<?PHP
	class DB {
		var $db;

		function __construct($host,$user,$password,$database) {
			
			$this->db = new mysqli($host,$user,$password,$database);
			
			if ($this->db->connect_error) {
				die('Connect Error (' . $this->db.connect_errno . ') '. $this>db.connect_error);
			} else {
				
				$this->db->query("SET NAMES 'utf8'") or die(mysql_error());
				$this->db->query("SET CHARACTER SET 'utf8'") or die(mysql_error());
			}
		}
		
	
		/*
			En funktion som preparear ett sql-uttryck och hämntar data från databasen
				inputs:	
					string $SQL, sql-uttryck
					string $types, med typer av variablerna som ska till databasen 
						(s = string, i = int, d = double, b = blob) ex. "si" är då en string och en int
					array, $values, värdena som ska in i databasen av olika typ, i ordningen som anges av type

		*/
		function getData($SQL, $types, $values) {
			//echo($types." ".$values);
			
			if($types == "" && $values == "") {
				
				$result = $this->db->query($SQL);
				$retval= array();

				while($row = $result->fetch_row()) {

					array_push($retval,$row);
				}
				return $retval;

			} else {
				
				//preparear sql-uttrycket
				$statement = $this->db->prepare($SQL);
				//echo("</br>".count($values));

				//konverterar ett värde till en array
				if(count($values)<2) {
					//echo("if");
					$params = array();
					$params[0] = $values;

				} else {
					//echo("else");
					$params = array();
					$params = $values;

				}
				//echo(count($params));

				/*
					Skapar ett antal variabler som ska in i databasen
					$$ innebär att man skapar en vaiabel där namnet är innehållet i den variabel som anges
					ex. $a =hello, $$a = world innebär då att $hello = world.
				*/
				$bind_names[] = $types;
				for($i = 0; $i<count($params); $i++) {
					//echo("</br>".$i);
					$bind_name = 'bind'.$i;
					$$bind_name = $params[$i];
					$bind_names[] = &$$bind_name;
				}

				//kallar på en funktion som finns hos en variabel och bryter ut en array till enskilda variabler.
				call_user_func_array(array($statement, "bind_param"), $bind_names);
				
				$statement->execute();

				$meta = $statement->result_metadata();

				$lengthCounter = 0;
				$parameters = array();
				while($field = $meta->fetch_field()) {
					
					$var = $field->name;
					//echo($var."</br>");
					$$var = null;
					
					$parameters[$lengthCounter] = &$$var;
					//echo("$=".$$var."</br>");

					$fields[$lengthCounter] = $var;
					$lengthCounter++;
				}

				call_user_func_array(array($statement, "bind_result"), $parameters);
				
				$retval = array();
				$row = array();
				while($statement->fetch()) {
					
					for($i = 0; $i<count($fields); $i++) {
						$temp = $fields[$i];
						//var_dump($$temp);
						$row[$i] = $$temp;
						//echo("</br>");
					}

					array_push($retval, $row);
					//echo($retval[0][0]."</br>");

				}
				//echo("</br>");
				//var_dump($retval);
				//echo("</br>".$retval[0][0]);
				//echo("</br>".$retval[1][0]);
				$statement->close();

				return $retval;
			}
			
			function getOneColumn($SQL)	{
				
				$result = $this->db->query($SQL);
				$retval = array();
				
				while($row = $result->fetch_row()) {

					array_push($retval,$row[0]);

				}

				return$retval;
			}
		}
		
		/*Tar ett sql-uttryck med frågetecken och preparar det för att skicka in data till databasen
			inputs: 
				string $SQL, sql-uttryck
				string $types, med typer av variablerna som ska till databasen 
					(s = string, i = int, d = double, b = blob) ex. "si" är då en string och en int
				array, $values, värdena som ska in i databasen av olika typ, i ordningen som anges av type

			outputs:
		*/
		function execute($SQL, $types, $values) {
			
			//preparear sql-uttrycket
			$statement = $this->db->prepare($SQL);
			//echo("</br>".count($values));
			
			//konverterar ett värde till en array
			if(count($values)<2) {
				//echo("if");
				$params = array();
				$params[0] = $values;

			} else {
				//echo("else");
				$params= array();
				$params = $values;

			}
			
			//echo(count($params));

			/*
				Skapar ett antal variabler som ska in i databasen
				$$ innebär att man skapar en vaiabel där namnet är innehållet i den variabel som anges
				ex. $a =hello, $$a = world innebär då att $hello = world.
			*/
			$bind_names[] = $types;
			//echo(count($params)."</br>");
			for($i = 0; $i<count($params); $i++) {
				//echo("</br>".$i);
				$bind_name = 'bind'.$i;
				$$bind_name = $params[$i];
				$bind_names[] = &$$bind_name;
			}
			//var_dump($bind_names);
			//echo($bind_names[2][5]);
			//echo($bind_names);

			//kallar på en funktion som finns hos en variabel och bryter ut en array till enskilda variabler.
			
			call_user_func_array(array($statement, "bind_param"), $bind_names);
			
			//Exekverar sql-uttrycket.
			$statement->execute();
			$statement->close();
			
		}
	}
?>