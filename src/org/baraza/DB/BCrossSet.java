/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.DB;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Vector;

import org.baraza.xml.BElement;

public class BCrossSet {

	Map<String, Integer> columns;
	Map<String, Integer> rows;
	Map<Integer, Object> setTable;
	
	public BCrossSet(Vector<Vector<Object>> dataTable) {
		columns = new HashMap<String, Integer>();
		rows = new HashMap<String, Integer>();
		setTable = new HashMap<Integer, Object>();
		
		for(Vector<Object> data : dataTable) {
			String col0 = ""; if(data.get(0) != null) col0 = data.get(0).toString();
			String col1 = ""; if(data.get(1) != null) col1 = data.get(1).toString();
			String col2 = ""; if(data.get(2) != null) col2 = data.get(2).toString();
			
			Integer column = columns.size();
			if(!columns.containsKey(col0)) columns.put(col0, column);
			column = columns.get(col0);
			
			Integer row = rows.size();
			if(!rows.containsKey(col2)) rows.put(col2, row);
			row = rows.get(col2);
			
			setTable.put((row * 64) + column, data.get(1));
		}
	}
	
	public Vector<Object> getRowData(String key) {
		Vector<Object> data = new Vector<Object>();
		Integer column = columns.get(key);
		for(String rowKey : rows.keySet()) {
			Integer row = rows.get(rowKey);
			Object cellData = setTable.get((row * 64) + column);
			data.add(cellData);
		}
		return data;
	}
	
	public String getRowHtml(Object key) {
		StringBuffer myhtml = new StringBuffer();
		String sKey = "";
		if(key != null) sKey = key.toString();
		Integer column = columns.get(sKey);
		for(String rowKey : rows.keySet()) {
			Integer row = rows.get(rowKey);
			Object cellData = setTable.get((row * 64) + column);
			
			if(cellData == null) myhtml.append("<td></td>");
			else myhtml.append("<td>" + cellData.toString() + "</td>");
		}
		return myhtml.toString();
	}
	
	public Map<String, Integer> getColumns() {
		return columns;
	}
	
	public Map<String, Integer> getRows() {
		return rows;
	}

	
}
