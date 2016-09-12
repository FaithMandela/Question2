import java.sql.*;
import java.util.Calendar;
import java.util.Date;

public class BSMSMonitoring {

Statement st=null;
ResultSet rs=null;
Connection conn = null;

public Connection getConnection(String type){
		final String username="postgres";
		final String password="";
		final String url="jdbc:postgresql://localhost:5432/sms_config";
		
		try {
			if(type.equals("pg")){
				Class.forName("org.postgresql.Driver");
				conn=DriverManager.getConnection(url,username,password);

			}
		}catch (ClassNotFoundException e) {
			System.err.println("Error Getting Connection  > " + e.getMessage());}
		catch(SQLException ex){
			System.out.println("Error: "+ ex.getMessage());
		}
	
		return conn;
	}

public static long compareTwoTimeStamps(long currTime, java.sql.Timestamp oldTime){
		long milliseconds1 = oldTime.getTime();
		long milliseconds2 = currTime;

		long diff = milliseconds2 - milliseconds1;
		long diffHours = diff / (60 * 60 * 1000);

		return diffHours;
	}

public void execute(){
	try{
		Connection pgconn=getConnection("pg");
		if(conn==null){
			System.out.println("Failed to connect...");
		}
		else {
			System.out.println("Connected successfully...");
			st=conn.createStatement();
			String sql="SELECT * from sms_config";
			
			rs= st.executeQuery(sql);
			
			while(rs.next()){
				int smsConfig=rs.getInt("sms_config");
	  			Timestamp emailTime=rs.getTimestamp("email_time");
	   			boolean emailError=rs.getBoolean("error_email");
				boolean sendError=rs.getBoolean("send_error");

				
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
				//Clear off error
				if(sendError==true){
				String sql1="INSERT INTO sms_config " + "VALUES (, , ,FALSE,,)";
				}
				
			}
		}

	}
	catch(SQLException ex){
		System.out.println("Error: " +ex);
	}

}

public static void main(String [] args){
	Config configure = new Config();
	configure.execute();
}


}
