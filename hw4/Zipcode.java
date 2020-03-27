package jdbc;


import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;




public class Zipcode {

	public static void main(String[] args) throws SQLException, FileNotFoundException, IOException  {

		//String fileName = "src/jdbc/Chlzipcode.csv";
		//String fileName = "Chlzipcode.cs

		String path = Zipcode.class.getResource("ChIzipcode.csv").getFile();
		//System.out.println(path);

		Connection connection;

		String url = "jdbc:oracle:thin:@acadoradbprd01.dpu.depaul.edu:1521:ACADPRD0";

		//"jdbc:oracle:@acadoradbprd01.dpu.depaul.edu:1521:ACADPRD0"

		BufferedReader reader = null;
		String line = "";
		String splitWith = ",";

		try { 
			
			Class.forName("oracle.jdbc.driver.OracleDriver");
			connection = DriverManager.getConnection(url, "syang62", "cdm1910806");
			Statement statement = connection.createStatement();

			try {

				reader = new BufferedReader(new FileReader(path));
				line = reader.readLine();

				while((line = reader.readLine()) != null) {

					String[] spot = line.split(splitWith);
					String input = "INSERT INTO Zipcode VALUES (" + spot[0].replace("\"", "\'") +","
							+ spot[1].replace("\"", "\'") +"," + spot[2].replace("\"", "\'") +","
							+ spot[3].replace("\"", "") + "," + spot[4].replace("\"", "") + ","
							+ spot[5].replace("\"", "") + "," + spot[6].replace("\"", "") + ")";

					System.out.println("Inserting to table ZIPCODE");

					statement.execute(input);
				}

			} finally {

				if( reader != null) {
					reader.close();
				}
			}

			String toQuery = 
					"SELECT restaurant.name , restaurant_locations.ZIPCODE, zipcode.LATITUDE, zipcode.LONGITUDE " 
					+ "from restaurant , restaurant_locations , zipcode                  "
					+ " where restaurant.rid = restaurant_locations.rid and restaurant_locations.ZIPCODE = zipcode.zip";

			ResultSet res = statement.executeQuery(toQuery);

			while (res.next()) {
				String col = "";
				for(int i = 1; i < 4; i++) {
					col = col + res.getString(i)+ ", ";
				}
				col = col + res.getString(4);
				System.out.println("");
				System.out.println(col);
			}

			connection.close();
		
		} catch (ClassNotFoundException e) {
			e.printStackTrace();;
		} catch (SQLException se ) {
			se.printStackTrace();
		}

	}
}
