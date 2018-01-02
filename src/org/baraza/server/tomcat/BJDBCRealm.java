/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.server.tomcat;


import java.util.logging.Logger;
import java.util.Map;
import java.util.HashMap;
import java.security.Principal;

import org.apache.catalina.realm.JDBCRealm;
import org.apache.catalina.connector.Request;
import org.apache.catalina.Context;
import org.apache.tomcat.util.descriptor.web.SecurityConstraint;

import org.baraza.utils.BLogHandle;

public class BJDBCRealm extends JDBCRealm {
	Logger log = Logger.getLogger(BJDBCRealm.class.getName());
	
	public int counter = 0;
	public Map<String, String> userList;
	
	public BJDBCRealm() {
        super();

        userList = new HashMap<String, String>();
System.out.println("BASE 4010 : authenticating class starting");

        
	}
	
	public Principal authenticate(String username, String credentials) {
		Principal principal = super.authenticate(username, credentials);

System.out.println("BASE 4110 : authenticating " + username);
		
		if(principal != null) {
System.out.println("BASE 4120 : authenticating " + principal.getName());
System.out.println("BASE 4130 : " + counter);
			userList.put(username, "login");
			counter++;
		}
		
		return principal;
	}
	
	public SecurityConstraint[] findSecurityConstraints(Request request, Context context) {
		SecurityConstraint[] sc = super.findSecurityConstraints(request, context);
		
System.out.println("BASE 4240 : findSecurityConstraints " + request.getRemoteAddr() + " : " + request.getRemoteUser());
System.out.println("BASE 4250 : " + counter);

		return sc;
	}
	
}

