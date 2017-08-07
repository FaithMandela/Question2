import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;

public class verifyQRCode extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) {
		String mycode = request.getParameter("mycode");
		String ans = "The code is not found, clylinder is unverified";

		BDB db = new BDB("java:/comp/env/jdbc/database");
		String mysql = "SELECT cylinder_id, cylinder_batch_id, org_id, cylinder_number, "
			+ "cylinder_code, certification_date, review_date, checked, org_name "
			+ "FROM	vw_cylinders "
			+ "WHERE cylinder_id = " + mycode;
		BQuery rs = new BQuery(db, mysql);
		if(rs.moveNext()) {
			ans = "Cylinder is verified, filled by : " + rs.getString("org_name");
			System.out.println(ans);

			mysql = "INSERT INTO check_logs (verified, org_id, cylinder_code, remote_ip) "
			+ "VALUES (true, " + rs.getString("org_id") + ", '" + mycode + "', '" + request.getRemoteAddr() + "')";
			db.executeQuery(mysql);
		} else {
			System.out.println(ans);

			mysql = "INSERT INTO check_logs (verified, org_id, cylinder_code, remote_ip) "
			+ "VALUES (false, " + rs.getString("org_id") + ", '" + mycode + "', '" + request.getRemoteAddr() + "')";
			db.executeQuery(mysql);
		}

	
		// Close resultset and DB
		rs.close();
		db.close();

        response.setContentType("text/html");
		String resp = "<html>"
        + "<head>"
        + "<title>lpmanager</title>"
        + "</head>"
        + "<body>"
        + "<h1>lpmanager</h1>"
		+ "<h2>" + ans + "</h2>"
        + "</body>"
        + "</html>";

		try {
			PrintWriter out = response.getWriter();
			out.println(resp);
		} catch (IOException ex) { System.out.println("IO Error"); }
		
    }

}
