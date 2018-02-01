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
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Enumeration;
import java.util.Base64;
import java.io.OutputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.IOException;

import org.json.JSONObject;
import org.json.JSONArray;

import javax.servlet.ServletContext;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import org.baraza.utils.BWebUtils;
import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;
import org.baraza.DB.BUser;
import org.baraza.xml.BXML;
import org.baraza.xml.BElement;

public class BDataServer extends HttpServlet {
	Logger log = Logger.getLogger(BDataServer.class.getName());

	BDB db = null;
	BElement root = null;
	Map<String, BUser> users;
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		
		ServletContext context = config.getServletContext();
		String xmlfile = config.getInitParameter("xmlfile");
		String ps = System.getProperty("file.separator");
		xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlfile;
		BXML xml = new BXML(xmlfile, false);
		
		if(xml.getDocument() != null) {
			root = xml.getRoot();
		
			String dbconfig = "java:/comp/env/jdbc/database";
			db = new BDB(dbconfig);
			db.setOrgID(root.getAttribute("org"));
			
			users = new HashMap<String, BUser>();
		}
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
		
		String remoteAddr = request.getRemoteAddr();
		String action = request.getHeader("action");
		if(action == null) return;
System.out.println("BASE 2010 : " + action);
System.out.println("BASE 2020 Body : " + body);

		
		JSONObject jResp = new JSONObject();
		if(action.equals("authorization")) {
			String authUser = request.getHeader("authUser");
			String authPass = request.getHeader("authPass");
			if(authUser == null || authPass == null) return;

			authUser = new String(Base64.getDecoder().decode(authUser));
			authPass = new String(Base64.getDecoder().decode(authPass));
			
			String authFunction = root.getAttribute("authentication", "password_validate");
			
			String userId = db.executeFunction("SELECT " + authFunction + "('" + authUser + "', '" + authPass + "')");
System.out.println("BASE 2010 : " + authUser + " : " + authPass + " : " + userId);

			if(userId.equals("-1")) {
				jResp.put("ResultCode", 1);
				jResp.put("ResultDesc", "Wrong username or password");
			} else {
				String token = BWebUtils.createToken(userId);
System.out.println("BASE 3010 : " + token);

				users.put(userId, new BUser(db, remoteAddr, authUser, userId));
				
				jResp.put("ResultCode", 0);
				jResp.put("access_token", token);
				jResp.put("expires_in", "15");
			}
		} else if(action.equals("udata")) {
			JSONObject jParams = new JSONObject(body);
			
			String viewKey = request.getParameter("view");
			BElement view = getView(viewKey);
			
			if(view.getAttribute("secured", "true").equals("false")) {
				String saveMsg = postData(view, remoteAddr, jParams);
				if(saveMsg.equals("")) {
					jResp.put("ResultCode", 0);
					jResp.put("ResultDesc", "Okay");
				} else {
					jResp.put("ResultCode", 2);
					jResp.put("ResultDesc", saveMsg);
				}
			} else {
				jResp.put("ResultCode", 1);
				jResp.put("ResultDesc", "Security issue");
			}
		} else if(action.equals("data")) {
			String token = request.getHeader("authorization");
			String userId = BWebUtils.decodeToken(token);
System.out.println("BASE 3030 : " + userId);
			
			if(userId == null) {
				jResp.put("ResultCode", 1);
				jResp.put("access_error", "Wrong token");
			} else {
				String viewKey = request.getParameter("view");
				BElement view = getView(viewKey);
				BUser user = users.get(userId);
				
				JSONObject jParams = new JSONObject(body);
				String saveMsg = postData(view, remoteAddr, jParams);
				if(saveMsg.equals("")) {
					jResp.put("ResultCode", 0);
					jResp.put("ResultDesc", "Okay");
				} else {
					jResp.put("ResultCode", 2);
					jResp.put("ResultDesc", saveMsg);
				}
			}
		} else if(action.equals("read")) {
			String token = request.getHeader("authorization");
			String userId = BWebUtils.decodeToken(token);
System.out.println("BASE 3030 : " + userId);
			
			if(userId == null) {
				jResp.put("ResultCode", 1);
				jResp.put("access_error", "Wrong token");
			} else {
				String viewKey = request.getParameter("view");
				BElement view = getView(viewKey);
				BUser user = users.get(userId);
				
				BQuery rs = new BQuery(db, view, null, null, user, false);
				if(rs.moveNext()) {
					JSONArray jTable = new JSONArray(rs.getJSON());
					jResp.put("data", jTable);
				}
				rs.close();
			}
		} 

		// Send feedback
		resp = jResp.toString();
		response.setContentType("application/json;charset=\"utf-8\"");
		PrintWriter out = null;
		try { out = response.getWriter(); } catch(IOException ex) {}
		out.println(resp);

		log.info("End Data Server");
	}
	
	public BElement getView(String viewKey) {
		System.out.println("BASE 4040 : " + viewKey);
		
		List<BElement> views = new ArrayList<BElement>();
		List<String> viewKeys = new ArrayList<String>();
		String sv[] = viewKey.split(":");
		for(String svs : sv) viewKeys.add(svs);
		views.add(root.getElementByKey(sv[0]));
		
		for(int i = 1; i < sv.length; i++) {
			int subno = Integer.valueOf(sv[i]);
			views.add(views.get(i-1).getElement(subno));
		}
		BElement view = views.get(views.size() - 1);
		
System.out.println("BASE 4070 : " + view.toString());
		
		return view;
	}
	
	public String postData(BElement view, String remoteAddr, JSONObject jParams) {
		String fWhere = view.getAttribute("keyfield") + " = null";
		BQuery rs = new BQuery(db, view, fWhere, null);
		
		List<String> viewData = new ArrayList<String>();
		Map<String, String[]> newParams = new HashMap<String, String[]>();
		for(String paramName : jParams.keySet()) {
			String[] pArray = new String[1];
			pArray[0] = jParams.getString(paramName);
			newParams.put(paramName, pArray);
		}
		
		rs.recAdd();
		String saveMsg = rs.updateFields(newParams, viewData, remoteAddr, null);
		rs.close();
		
System.out.println("BASE 4070 : " + saveMsg);
		return saveMsg;
	}
	
	public void destroy() {
		db.close();
	}

}
