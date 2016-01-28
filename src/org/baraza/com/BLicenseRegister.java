/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.com;

import java.io.PrintWriter;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.baraza.DB.BDB;
import org.baraza.xml.BElement;

public class BLicenseRegister {

	BDB db = null;

	public void doPost(HttpServletRequest request, HttpServletResponse response)  {
		doGet(request, response);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) { 
		response.setContentType("text/html");
		PrintWriter out = null;
		try { out = response.getWriter(); } catch(IOException ex) {}
		String resp = "";

		String dbconfig = "java:/comp/env/jdbc/database";
		db = new BDB(dbconfig);
		// If there is no DB connection
		if(db == null) {
			resp = "DB access error";
			out.println(resp);
			return;
		}
		
		getLicense(request.getRemoteAddr(), request.getRemoteUser());
		
		 
		out.println(resp);
		db.close();
	}
	
	private void getLicense(String remoteAddr, String remoteUser) {
		String dbID = "";
		String macAddr = "";
		String orgName = "";

	
	}
	

}
