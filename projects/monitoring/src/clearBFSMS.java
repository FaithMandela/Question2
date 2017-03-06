import java.sql.*;

public class clearBFSMS {

	public static void main(String args[]) {
		clearSMS("jdbc:sqlserver://192.168.0.14:1433;databaseName=GIDS_BTS;selectMethod=cursor;user=sa;password=galileo");
		clearSMS("jdbc:sqlserver://192.168.0.14:1433;databaseName=GIDS_FCM;selectMethod=cursor;user=sa;password=galileo");
	}

	public static void clearSMS(String DBPath) {

		try {
			Connection db = DriverManager.getConnection(DBPath, "sa", "galileo");

			String mysql = "UPDATE sms SET is_sent = '1' WHERE is_sent = '0';";
			Statement stUpd = db.createStatement();
			stUpd.execute(mysql, Statement.RETURN_GENERATED_KEYS);
			stUpd.close();

System.out.println("BASE 400");
			
			db.close();
		} catch (SQLException ex) {
			System.out.println("Database connection error : " + ex);
		}
	}
}
