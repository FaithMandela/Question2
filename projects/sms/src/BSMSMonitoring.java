import java.util.Calendar;
import java.util.Date;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class BSMSMonitoring {


	public static void main(String[] args) {
		BSMSMonitoring sms_mon = new BSMSMonitoring();
		sms_mon.monitor();
		
	}
	
	public void monitor() {
		Connection monDB = getConnection("jdbc:postgresql://localhost:5432/hr", "postgres", "");
		if(monDB == null) return;
		
		Connection smsDB = getConnection("jdbc:postgresql://localhost:5432/sms", "postgres", "");
		if(smsDB == null) {
			addEMail(monDB, "Cannot connect to SMS database");
			closeDB(monDB);
			return;
		} else {
			String smsError = execute(smsDB);
			if(smsError != null) addEMail(monDB, "SMS sending error : " + smsError);
		}
		
		closeDB(monDB);
		closeDB(smsDB);
	}
		
    public Connection getConnection(String dbPath, String dbUser, String dbPassword){
		Connection conn = null;
		
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(dbPath, dbUser, dbPassword);
		} catch (ClassNotFoundException ex) {
			System.err.println("Error Getting Connection : CNF > " + ex.getMessage());
		} catch (SQLException ex) {
			System.err.println("Error Getting Connection SQE > " + ex.getMessage());
		}
	
		return conn;
	}

	public void addEMail(Connection monDB, String narrative) {
		try {
			String insEmail = "INSERT INTO sys_emailed(org_id, sys_email_id, table_name, email_type, narrative)
			insEmail = "VALUES (0, 10, 'SMS error', 10, '" + narrative + "');";        
		
			Statement st = monDB.createStatement();
			st.execute(insEmail);
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeQuery error : " + ex);
		}
	}
	
	public String execute(Connection smsDB) {
		String smsError = null;
		try{
			String sql = "SELECT last_sent, send_error, error_email, email_time, narrative "
			sql += "FROM sms_configs WHERE sms_config = 0;";
			Statement st = smsDB.createStatement();
			ResultSet rs= st.executeQuery(sql);
			
			if(rs.next()) {
	  			Timestamp emailTime = rs.getTimestamp("email_time");
	   			boolean emailError = rs.getBoolean("error_email");
				boolean sendError = rs.getBoolean("send_error");
				
				//Check table timestamp
				long currentTime = System.currentTimeMillis();
	  			long difference=compareTwoTimeStamps(currentTime,emailTime);

				if(difference>1){
				System.out.println("Error in updating timestamps\n");
				System.out.print(""+emailTime);}
			
				//Check email
				if(emailError==true){
				System.out.println("\n");
				System.out.print(""+emailError);
				}

			}
		} catch(SQLException ex){
			System.out.println("Error: " +ex);
		}
		
		smsError = true;
	}

    public void closeDB(Connection db) {
		try {
			if(db != null) db.close();
		} catch (SQLException ex) {
			System.err.println("Error Getting Connection SQE > " + ex.getMessage());
		}
	}


}
