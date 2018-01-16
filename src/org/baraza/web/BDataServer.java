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
import java.io.OutputStream;
import java.io.InputStream;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.baraza.utils.BWebUtils;
import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;

public class BDataServer extends HttpServlet {
	Logger log = Logger.getLogger(BDataServer.class.getName());

	BDB db = null;

	public void doPost(HttpServletRequest request, HttpServletResponse response)  {
		doGet(request, response);
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) {
		String dbconfig = "java:/comp/env/jdbc/database";
		db = new BDB(dbconfig);

		log.info("Start Data Server");
		
		String auth = request.getHeader("authorization");
		System.out.println("BASE 2010 : " + auth);

		BWebUtils.showHeaders(request);
		BWebUtils.showParameters(request);
		
		String token = BWebUtils.createToken("15");
		System.out.println("BASE 3010 : " + token);
		System.out.println("BASE 3030 : " + BWebUtils.decodeToken(token));

		log.info("Start Data Server");

		db.close();
	}
	


}
