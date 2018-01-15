/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.utils;

import java.util.Enumeration;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;

public class BWebUtils {
	Logger log = Logger.getLogger(BWebUtils.class.getName());

	public static void showHeaders(HttpServletRequest request) {
		System.out.println("HEADERS ------- ");
		Enumeration<String> headerNames = request.getHeaderNames();
		while (headerNames.hasMoreElements()) {
			String headerName = headerNames.nextElement();
			System.out.println(headerName);
			request.getHeader(headerName);
			Enumeration<String> headers = request.getHeaders(headerName);
			while (headers.hasMoreElements()) {
				String headerValue = headers.nextElement();
				System.out.println("\t" + headerValue);
			}
		}
		System.out.print("\n");
	}

	public static void showParameters(HttpServletRequest request) {
		System.out.println("PARAMETERS ------- ");
		Enumeration en = request.getParameterNames();
        while (en.hasMoreElements()) {
			String paramName = (String)en.nextElement();
			System.out.println(paramName + " : " + request.getParameter(paramName));
		}
		System.out.print("\n");
	}

}
