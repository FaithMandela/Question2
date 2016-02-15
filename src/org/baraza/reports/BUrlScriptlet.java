/**
 * @author      Haron Korir
 * @version     2016.0215
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.reports;

import javaQuery.j2ee.tinyURL;
import net.sf.jasperreports.engine.JRDefaultScriptlet;

public class BUrlScriptlet extends JRDefaultScriptlet {

    public static String getUrl(String url) {
        tinyURL tU = new tinyURL();
        String getLink = tU.getTinyURL(url);
        return getLink;
    }
    
}
