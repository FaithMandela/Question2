/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.web;

import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Enumeration;

import java.io.PrintWriter;
import java.io.OutputStream;
import java.io.InputStream;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Bajax extends HttpServlet {

	BWeb web = null;

	public void doPost(HttpServletRequest request, HttpServletResponse response)  {
		doGet(request, response);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) { 
		ServletContext context = getServletContext();
		HttpSession session = request.getSession(true);
		String xmlcnf = (String)session.getAttribute("xmlcnf");
		String ps = System.getProperty("file.separator");
		String xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlcnf;
		String dbconfig = "java:/comp/env/jdbc/database";

        response.setContentType("text/html");
		PrintWriter out = null;
		try { out = response.getWriter(); } catch(IOException ex) {}
		String resp = "";

		String userIP = request.getRemoteAddr();
		String userName = request.getRemoteUser();

		web = new BWeb(dbconfig, xmlfile);
		web.init(request);
		web.setUser(userIP, userName);

		System.out.println("AJAX Reached");

		String function = request.getParameter("ajaxfunction");			// function to execute
		String params = request.getParameter("ajaxparams");				// function params
		String from = request.getParameter("from");						// from function
		if((function != null) && (params != null)) resp = executeSQLFxn(function, params, from);

		String fnct = request.getParameter("fnct");
		String id = request.getParameter("id");
		String ids = request.getParameter("ids");
		String startDate = request.getParameter("startdate");
		String startTime = request.getParameter("starttime");
		String endDate = request.getParameter("enddate");
		String endTime = request.getParameter("endtime");

		if("calresize".equals(fnct)) resp = calResize(id, endDate, endTime);
		if("calmove".equals(fnct)) resp = calMove(id, startDate, startTime, endDate, endTime);
		if("operation".equals(fnct)) resp = calOperation(id, ids, request);

		web.close();	// close DB commections
		out.println(resp);
	}

	public String calResize(String id, String endDate, String endTime) {
		String resp = "";

		String sql = "UPDATE case_activity SET finish_time = '" + endTime + "' ";
		sql += "WHERE case_activity_id = " + id;
		System.out.println(sql);

		web.executeQuery(sql);

		return resp;
	}

	public String calMove(String id, String startDate, String startTime, String endDate, String endTime) {
		String resp = "";

		if("".equals(endDate)) {
			resp = calResize(id, endDate, endTime);
		} else {
			String sql = "UPDATE case_activity SET activity_date = '"  + endDate + "', activity_time = '" + startTime;
			sql += "', finish_time = '" + endTime + "' ";
			sql += "WHERE case_activity_id = " + id;
			System.out.println(sql);

			web.executeQuery(sql);
		}

		return resp;
	}

	public String executeSQLFxn(String fxn, String prms, String from) {
		String query = "";

		if(from == null) query = "SELECT " + fxn + "('" + prms + "')";
		else query = "SELECT " + fxn + "('" + prms + "') from " + from;
		System.out.println("SQL function = " + query);

		String str = "";
		if(!prms.trim().equals("")) str = web.executeFunction(query);

		return str;
	}

	public String escapeSQL(String str){				
		String escaped = str.replaceAll("'","\'");						
		return escaped;
	}
	
	public String calOperation(String id, String ids, HttpServletRequest request) {
		String resp = web.setOperations(id, ids, request);
		
		return resp;
	}
 
}