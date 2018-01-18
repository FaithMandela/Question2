/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.web;

import java.util.logging.Logger;
import java.util.Map;
import java.util.HashMap;
import java.util.Enumeration;
import java.util.Base64;
import java.io.OutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.IOException;

import org.json.JSONObject;

import javax.servlet.ServletContext;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import org.baraza.utils.BWebUtils;
import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;

public class BDataServer extends HttpServlet {
	Logger log = Logger.getLogger(BDataServer.class.getName());

	BDB db = null;
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		
		String dbconfig = "java:/comp/env/jdbc/database";
		db = new BDB(dbconfig);
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)  {
		doGet(request, response);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) {
		String resp = "";

		log.info("Start Data Server");
		
		BWebUtils.showHeaders(request);
		BWebUtils.showParameters(request);
		String body = BWebUtils.requestBody(request);
		
		String action = request.getHeader("action");
		if(action == null) return;
System.out.println("BASE 2010 : " + action);

		
		if(action.equals("authorization")) {
			String authUser = request.getHeader("authUser");
			String authPass = request.getHeader("authPass");
			if(authUser == null || authPass == null) return;

			authUser = new String(Base64.getDecoder().decode(authUser));
			authPass = new String(Base64.getDecoder().decode(authPass));
			
			String userId = db.executeFunction("SELECT password_validate('" + authUser + "', '" + authPass + "')");
System.out.println("BASE 2010 : " + authUser + " : " + authPass + " : " + userId);

			String token = BWebUtils.createToken(userId);
System.out.println("BASE 3010 : " + token);
			
			JSONObject jResp = new JSONObject();
			jResp.put("access_token", token);
			jResp.put("expires_in", "15");
			resp = jResp.toString();
		} if(action.equals("data")) {
			String token = request.getHeader("authorization");
			String userId = BWebUtils.decodeToken(token);
		
			System.out.println("BASE 3030 : " + userId);
			
			JSONObject jResp = new JSONObject();
			if(userId == null) {
				jResp.put("access_error", "Wrong token");
			} else {
				System.out.println("BASE Body : " + body);
			}
		}

		// Send feedback
		response.setContentType("application/json;charset=\"utf-8\"");
		PrintWriter out = null;
		try { out = response.getWriter(); } catch(IOException ex) {}
		out.println(resp);

		log.info("End Data Server");
	}
	
	public void destroy() {
		db.close();
	}

}
