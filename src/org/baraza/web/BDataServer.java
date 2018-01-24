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

import javax.servlet.ServletContext;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import org.baraza.utils.BWebUtils;
import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;
import org.baraza.xml.BXML;
import org.baraza.xml.BElement;

public class BDataServer extends HttpServlet {
	Logger log = Logger.getLogger(BDataServer.class.getName());

	BDB db = null;
	BElement root = null;
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		
		ServletContext context = config.getServletContext();
		String xmlfile = config.getInitParameter("xmlfile");
		String ps = System.getProperty("file.separator");
		xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlfile;
		BXML xml = new BXML(xmlfile, false);
		
		if(xml.getDocument() != null) {
			String dbconfig = "java:/comp/env/jdbc/database";
			db = new BDB(dbconfig);
			
			root = xml.getRoot();
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
		} else if(action.equals("data")) {
			String token = request.getHeader("authorization");
			String userId = BWebUtils.decodeToken(token);
		
			System.out.println("BASE 3030 : " + userId);
			
			JSONObject jResp = new JSONObject();
			if(userId == null) {
				jResp.put("access_error", "Wrong token");
			} else {
				System.out.println("BASE Body : " + body);
			}
		} else if(action.equals("udata")) {
			System.out.println("BASE 4040 : ");
			
			JSONObject jParams = new JSONObject(body);
			System.out.println("BASE Body : " + body);
			
			String viewKey = request.getParameter("view");
			BElement view = getView(viewKey);
			
			if(view.getAttribute("secured", "true").equals("false")) {
				postData(view, remoteAddr, jParams);
			}
			
			JSONObject jResp = new JSONObject();
			jResp.put("okay", "okay");
		}

		// Send feedback
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
		
		return view;
	}
	
	public void postData(BElement view, String remoteAddr, JSONObject jParams) {
		
		String fWhere = view.getAttribute("keyfield") + " = null";
		BQuery rs = new BQuery(db, view, fWhere, null);
		
		List<String> viewData = new ArrayList<String>();
		Map<String, String[]> newParams = new HashMap<String, String[]>();
		for(String paramName : jParams.keySet()) {
			String[] pArray = new String[1];
			pArray[0] = jParams.getString(paramName);
			newParams.put(paramName, pArray);
		}
		
		System.out.println("BASE 4070 : " + view.toString());
	}
	
	public void destroy() {
		db.close();
	}

}
