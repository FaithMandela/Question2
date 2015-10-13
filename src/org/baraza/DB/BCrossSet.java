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
import java.util.Map;
import java.util.HashMap;
import java.util.Vector;

import org.baraza.xml.BElement;

public class BCrossSet {

	Map<String, Integer> columns;
	Map<String, Integer> rows;
	Map<String, Object> setTable;
	
	public BCrossSet(Vector<Vector<Object>> dataTable) {
		columns = new HashMap<String, Integer>();
		rows = new HashMap<String, Integer>();
		setTable = new HashMap<String, Object>();
		
		for(Vector<Object> data : dataTable) {
			Sting col0 = "";
			if(data.get(0) == 
			
			Integer column = columns.size();
			if(!columns.contains(data.get(0))) columns.put(data.get(0), column);
			column = columns.get(data.get(0));
			
			Integer row = rows.size();
			if(!rows.contains(data.get(2))) rows.put(data.get(2), row);
			row = rows.get(data.get(2));
			
			setTable.put(column.toString() + ":" + row.toString(), data.get(1));
		}
	}
	
	public Map<String, Integer> getColumns() {
		return columns;
	}
	
	public Map<String, Integer> getRows() {
		return rows;
	}

	
}
