/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.com;

import java.util.Map;
import java.util.UUID;
import java.io.PrintWriter;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;
import org.baraza.xml.BElement;
import org.baraza.utils.BNetwork;

public class BLicenseRegister extends HttpServlet {

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
		String orgName = "";
		
		// Get MAC address and save on database
		BNetwork net = new BNetwork();
		String macAddr = net.getMACAddress(remoteAddr);
		if(macAddr == null) return;
		db.executeQuery("UPDATE orgs SET MAC_address = '" + macAddr + "' WHERE org_id = 0");
		
		// Get the database ID
		String dbName = db.getCatalogName();
		String dbID = db.executeFunction("SELECT datid FROM pg_stat_database WHERE datname = '" + dbName + "'");

		// Get the organisation name and system identifier
		Map<String, String> orgField = db.readFields("org_name, system_key, system_identifier", "orgs WHERE org_id = 0");
		String sysName = orgField.get("org_name");
		String sysID = orgField.get("system_identifier");
		if(sysID == null) {
			sysID = UUID.randomUUID().toString();
			db.executeQuery("UPDATE orgs SET system_identifier = '" + sysID + "' WHERE org_id = 0");
		}

		// Create the license
		BLicense license = new BLicense();
		byte[] lic = license.createLicense(sysName, sysID, macAddr, dbID);
		
		// Save the data
		BQuery rs = new BQuery(db, "SELECT org_id, public_key, license FROM orgs WHERE org_id = 0");
		rs.moveFirst();
		rs.recEdit();
		rs.updateBytes("public_key", license.getPublicKey());
		rs.updateBytes("license", lic);
		rs.recSave();
		rs.close();
		
		
	}
	

}
