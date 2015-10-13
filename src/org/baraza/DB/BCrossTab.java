/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.DB;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.baraza.xml.BElement;

public class BCrossTab {

	List<String> titles;
	List<String> fieldNames;
	List<String> keyFieldData;
	Vector<Vector<Object>> dataTable;
	
	BQuery baseRs;
	List<BCrossSet> crosstabRs;
	BElement view;
	
	public BCrossTab(BDB db, BElement view, String wheresql, String sortby) {
		this.view = view;

		System.out.println("BASE : " + wheresql);
		System.out.println("BASE : " + view.toString());
	
		baseRs = new BQuery(db, view, wheresql, null);
		
		dataTable = new Vector<Vector<Object>>(); 
		titles = new ArrayList<String>();
		fieldNames = new ArrayList<String>();
		crosstabRs = new ArrayList<BQuery>();
		for(BElement el : view.getElements()) {
			if(el.getName().equals("CROSSTAB")) {
				BQuery ctq = new BQuery(db, el, wheresql, null);
				ctq.readData();
				BCrossSet cs = new BCrossSet(ctq.getData());
				crosstabRs.add(cs);
				
				for(String csc : getColumns().keySet()) titles.add(csc);
			} else {
				titles.add(el.getAttribute("title", ""));
				fieldNames.add(el.getValue());
			}
		}
	}
	
	public String getGrid(List<String> viewKeys, List<String> viewData, boolean addJSc, String viewKey, boolean sfield) {
		StringBuffer myhtml = new StringBuffer();
		
		baseRs.readData();
		int btSize = baseRs.getData().size();
		System.out.println("BASE : size " + btSize);
		
		myhtml.append("<table>");
		for(Vector<Object> data : baseRs.getData()) {
			Vector<Object> dataRow = new Vector<Object>();
			int j = 0;
			myhtml.append("<tr>");
			for(BElement el : view.getElements()) {
				if(el.getName().equals("CROSSTAB")) {
					
				} else {
					if(data.get(j) == null) {
						myhtml.append("<td></td>");
					} else {
						String dv = data.get(j).toString();
						myhtml.append("<td>" + dv + "</td>");
					}
					j++;
				}
			}
			myhtml.append("</tr>");
			dataTable.add(data);//dataRow);
		}
		myhtml.append("</table>");
	
		return myhtml.toString();
	}
	
	// Close record sets
	public void close() {
		baseRs.close();
		for(BQuery crosstabR : crosstabRs) crosstabR.close();
	}
}
