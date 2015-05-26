/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.DB;

import javax.servlet.http.HttpServletRequest;

import java.util.Date;
import java.util.List;
import java.sql.Types;
import java.sql.Clob;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

import org.baraza.xml.BXML;
import org.baraza.xml.BElement;

public class BWebBody extends BQuery {

	boolean selectAll = false;

	public BWebBody(BDB db, BElement view, String wheresql, String orderby) {
		super(db, view, wheresql, orderby, false);
	}

	public String getGrid(List<String> viewKeys, List<String> viewData, boolean addJSc, String viewKey, boolean sfield) {
		StringBuffer myhtml = new StringBuffer();

		String viewTab = viewKeys.get(1);
		String dispStr = "";
		String colWidths = null;
		String groupTable = null;

		boolean hasAction = false;
		boolean hasSubs = false;
		boolean hasTitle = false;
		boolean hasFilter = false;
		int colNums = 0;

		String filterName = view.getAttribute("filter", "filterid");

		for(BElement el : view.getElements()) {
			if(el.getName().equals("ACTIONS")) hasAction = true;
			if(el.getName().equals("GRID") || el.getName().equals("FORM") || el.getName().equals("JASPER")) hasSubs = true;
			if(el.getName().equals("FILES") || el.getName().equals("DIARY")) hasSubs = true;
			if(el.getName().equals("COLFIELD") || el.getName().equals("TITLEFIELD")) hasTitle = true;
			if(el.getName().equals("FILTERGRID")) hasFilter = true;
		}

		if(view.getAttribute("display", "grid").equals("form")) {
			myhtml.append("<div class='gridtable'>\n");
			myhtml.append("<table id='formtable'>\n");
			myhtml.append("\n<thead>\n<tr>");

			myhtml.append("\n<th width='150'></th>");
			myhtml.append("\n<th width='350'></th>");
			addJSc = false;
		} else {
			myhtml.append("<div id='gridtable'>\n");
			myhtml.append("<table class='datagrid'>\n");
			myhtml.append("\n<thead>\n<tr>");
			if(hasAction && (keyField != null)) {
				myhtml.append("\n<th data-field='ID'>ID</th>");
				colWidths = ",\ncolumns: [ { field: 'ID', width: '50px', sortable: false, filterable: false }";
			}

			for(BElement el : view.getElements()) {
				if(el.getName().equals("BROWSER")) {
					myhtml.append("\n<th data-field='BROWSER'");
					myhtml.append(">" + el.getAttribute("title") + "</th>");
					colNums++;

					if(colWidths == null) colWidths = ",\ncolumns: [ ";
					else colWidths += ", \n";
					colWidths += "{ field: 'BROWSER', width: '75px', sortable: false, filterable: false }";
				} else if(!el.getValue().equals("")) {
					String colw = el.getAttribute("w", "100");
					myhtml.append("\n<th data-field='" + el.getValue() + "'");
					myhtml.append(">" + el.getAttribute("title") + "</th>");
					colNums++;

					if (el.getName().equals("COLFIELD") || el.getName().equals("TITLEFIELD")) {
						if(groupTable == null) groupTable = " group: {field: '" + el.getValue() + "'";
						else groupTable += ", field: '" + el.getValue() + "' ";
					} 

					if(colWidths == null) colWidths = ",\ncolumns: [ ";
					else colWidths += ", \n";
					colWidths += "{ field: '" + el.getValue() + "', width: '" + colw + "px'";

					colWidths += ", title: '" +  el.getAttribute("title") + "', sortable: true, filterable: true}";
				}
			}
			boolean hasGo = false;
			if(sfield) hasGo = true;
			if(hasSubs && (keyField != null)) hasGo = true;
			if(view.getName().equals("FILTERGRID") && (keyField != null)) {
				hasGo = true;
				if(hasFilter) hasSubs = true;
			}

			if(hasGo) {
				myhtml.append("\n<th data-field='GO'>Go</th>");
				colWidths += ", \n{ field: 'GO', width: '75px', sortable: false, filterable: false }";
			}

			if(view.getName().equals("FILES")) {
				if((view.getAttribute("edit", "true").equals("true"))) { 
					myhtml.append("\n<th data-field='DELETE'>Delete</th>");
					colWidths += ", \n{ field: 'DELETE', width: '75px', sortable: false, filterable: false }";
				}	

				// View addition
				myhtml.append("\n<th data-field='VIEW'>View</th>");					
				colWidths += ", \n{ field: 'VIEW', width: '75px', sortable: false, filterable: false }";
			}

			myhtml.append("\n</tr>");
			myhtml.append("\n</thead>");
		}

		myhtml.append("\n<tbody>");

		if(rs == null) {
			myhtml.append("\n</tbody>");
			myhtml.append("\n<tr><td colspan='" + Integer.toString(colNums) + "'>Data error</td></tr>");
			myhtml.append("\n</table>");
			return myhtml.toString();
		}

		try {
			rs.beforeFirst();
			int row = 0;
			boolean plain = false;
			String titlefield = "";

			String[] colspanfield = new String[colNums];
			for(int k=0; k<colNums; k++) colspanfield[k] = "";

			while (rs.next()) {
				if(view.getAttribute("display", "grid").equals("form") && (row != 0)) {
					myhtml.append("\n<tr bgcolor='#000077'><td></td><td></td></tr>");
				} else {
					myhtml.append("\n<tr>");
				}

				row++;
				if((!hasTitle) && hasAction && (keyField != null)) {
					myhtml.append("\n<td>");
					myhtml.append("<input type='checkbox' name='keyfield' ");
					if(selectAll) myhtml.append("checked ");
					myhtml.append("size='10' value='" + rs.getString(keyField) + "'/>");
					myhtml.append("</td>");
				}

				int col = 0;
				dispStr = "";
				for(BElement el : view.getElements()) {
					if(view.getAttribute("display", "grid").equals("form") && !el.getValue().equals("")) {
						if(col != 0) myhtml.append("\n<tr>");
						myhtml.append("<td>" + el.getAttribute("title") + "</td>");
					}
					if(hasTitle && (col == 1) && hasAction && (keyField != null)) {
						myhtml.append("\n<td>");
						myhtml.append("<input type='checkbox' name='keyfield' ");
						if(selectAll) myhtml.append("checked ");
						myhtml.append("size='10' value='" + rs.getString(keyField) + "'>");
						myhtml.append("</td>");
					}
					if(!el.getValue().equals(""))  {
						String cellData = formatData(el);
						if(sfield) dispStr += ", " + cellData;
						if (el.getName().equals("COLFIELD")) {
							myhtml.append("<td>" + cellData);
						} else if(el.getName().equals("TITLEFIELD")) {
							myhtml.append("<td>" + cellData);
						} else if(el.getName().equals("EDITFIELD")) {
							String editkey = el.getAttribute("editkey");
							if(editkey == null) editkey = view.getAttribute("keyfield");
							myhtml.append("\n<td><input type='text' name='" + el.getValue() + ":" + rs.getString(editkey) + "'");
							myhtml.append(" value='" + cellData + "'");
							myhtml.append(" class='w_50' size='" + el.getAttribute("w", "25") + "'>");
						} else if(el.getName().equals("ACTION")) {
							String myAction = el.getAttribute("action");
							if(myAction == null) myAction = el.getAttribute("title");

							myhtml.append("\n<td>");
							myhtml.append("<input type='hidden' name='actionkey' value='" + cellData + "'/>\n");
							myhtml.append("<button type='submit' name='actionprocess' value='" + cellData + "' class='i_cog icon small'/>\n");
							myhtml.append(myAction + "</button>");
						} else if(el.getName().equals("SEARCH")) {
							String js = el.getAttribute("js", "updateForm");

							myhtml.append("<td><input type='button' VALUE='Select' ");
							myhtml.append("onClick=\"" + js + "('" + getString(keyField) + "', '");
							myhtml.append(cellData + "')\">");
						} else if(el.getName().equals("WEBDAV")) {
							myhtml.append("\n<td><a href='webdavfiles?view=" + viewKey + "&filename=" + cellData);
							myhtml.append("' target='_blank'>View</a>");
						} else if(el.getName().equals("PICTURE")) {
							String mypic = getString(el.getValue());
							myhtml.append("\n<td>");
							if(mypic != null) {
								myhtml.append("<div style='width:" + el.getAttribute("w") + "px; height:" + el.getAttribute("h") + "px;'>");
								myhtml.append("<img style='width:100%; height:100%' src='");
								myhtml.append(el.getAttribute("pictures") + "?access=" + el.getAttribute("access"));
								myhtml.append("&picture=" + mypic + "'></div>\n");
							}
						} else if(el.getAttribute("details", "false").equals("true")){
							myhtml.append("\n<td>");
							myhtml.append("<a href='?view=" + viewKey + ":" + getSelectKey() + "&data=" + rs.getString(keyField) + "' ");

							if(el.getAttribute("hint") != null) myhtml.append(" title='" + el.getAttribute("hint") +  "'"); 

							myhtml.append(">" + cellData + "</a>");
						} else if(el.getName().equals("BROWSER")) {
							myhtml.append("\n<td>");
							if(el.getAttribute("path") != null) myhtml.append("<a href='" + el.getAttribute("path"));
							else myhtml.append("<a href='form.jsp");
							myhtml.append("?action=" +  el.getAttribute("action"));
							myhtml.append("&actionvalue=" + cellData);

							if(el.getAttribute("disabled") != null) myhtml.append("&disabled=yes"); 
							if(el.getAttribute("blankpage") != null) myhtml.append("&blankpage=yes' target='_blank'"); 
							else myhtml.append("'");

							if(el.getAttribute("hint") != null) myhtml.append(" title='" + getString(el.getAttribute("hint")) +  "'"); 
							myhtml.append("><img src='resources/images/form.png'></a>");
							myhtml.append("</td>");

							if(view.getAttribute("display", "grid").equals("form")) {
								if(col != 0) myhtml.append("\n<tr>");
							}
							col++;
						} else {
							myhtml.append("\n<td>");
							myhtml.append(cellData);
						}
						myhtml.append("</td>");

						if(view.getAttribute("display", "grid").equals("form")) {
							if(col != 0) myhtml.append("\n<tr>");
						}
						col++;
					}
				}

				if(view.getName().equals("FILES")) {
					if((view.getAttribute("edit", "true").equals("true"))) {
						myhtml.append("\n<td><a href='delbarazafiles?view=" + viewKey + "&fileid=" + getString(keyField));
						myhtml.append("' onclick=\"return confirm('Are you sure you want delete the file?');\"");
						myhtml.append(" target='_blank'>Delete</a></td>");
					}
					myhtml.append("\n<td><a href='barazafiles?view=" + viewKey + "&fileid=" + getString(keyField));
					myhtml.append("' target='_blank'>View</a></td>");
				}

				if(hasSubs && (keyField != null)) {
					if(view.getAttribute("display", "grid").equals("form")) {
						if(view.getAttribute("gohint") != null) myhtml.append("\n<td>" + view.getAttribute("gohint") +  "</td>"); 
						else myhtml.append("\n<td>GO</td>");
					}
					
					myhtml.append("\n<td>");
					String sk = getSelectKey();
					if(sk != null) {
						myhtml.append("<a href='?view=" + viewKey + ":" + sk + "&data=" + rs.getString(keyField));
						if(hasFilter) myhtml.append("&gridfilter=true");
						myhtml.append("'");
						
						if(view.getAttribute("gohint") != null) myhtml.append(" title='" + view.getAttribute("gohint") +  "'"); 
						
						myhtml.append("><img src='resources/images/go.png'></a>");
					}
					myhtml.append("</td>");
				}

				if(view.getName().equals("FILTERGRID") && (keyField != null) && !hasFilter) {
					myhtml.append("\n<td><a href='#' OnClick=\"updateField('");
					myhtml.append(filterName + "', '" + getString(keyField) + "')\">");
					myhtml.append("<img src='resources/images/go.png'></a></td>");
				}

				if(sfield) {
					myhtml.append("\n<td><input type='button' VALUE='Select' ");
					myhtml.append("onClick=\"updateForm('" + getString(keyField) + "', '");
					myhtml.append(dispStr + "')\"></td>");
				}

				myhtml.append("\n</tr>");

				if((tableLimit > 0) && (tableLimit < row)) break;
			}
		} catch(SQLException ex) {
			log.severe("Web data body reading error : " + ex);
		}
		myhtml.append("\n</tbody>");
		myhtml.append("\n</table>");
		myhtml.append("</div>\n");


		String htmlBody = "";
		if(view.getName().equals("FILTERGRID"))
			htmlBody += "\n<input type='hidden' name='" + filterName + "' id='" + filterName + "' value='0'/>";

		htmlBody += "\n<script>";
		htmlBody += "\n\t$(document).ready(function() {";
		htmlBody += "\n\t\t$(\".datagrid\").kendoGrid({";
		if(groupTable != null) htmlBody += "dataSource: {" + groupTable + "}},";
		htmlBody += "\n\t\t\theight: 380, scrollable: true, filterable: true, pageable: false, sortable: true";

		if(colWidths != null) htmlBody += colWidths + "]";

		htmlBody += "\n\t\t});";
		htmlBody += "\n\t});";
		htmlBody += "\n</script>";
	
		htmlBody += "\n<div id='grid_content'>\n";
		htmlBody += myhtml.toString();
		htmlBody += "\n</div>";
		
		return htmlBody;
	}

	public String getSelectKey() {

		Integer i = 0;
		for(BElement sview : view.getElements()) {
			String sviewName = sview.getName();
			if(sviewName.equals("DIARY") || sviewName.equals("FILES") || sviewName.equals("FORM") || sviewName.equals("GRID") ||  sviewName.equals("JASPER")) {
				String viewFilter = sview.getAttribute("viewfilter");
				if(viewFilter == null) {
					return i.toString();
				} else {
					String viewFilters[] = viewFilter.split(",");
					boolean show = true;
					for(String vfs : viewFilters) {
						String vsp[] = vfs.split("=");
						if(!vsp[1].equals(getString(vsp[0]))) show = false;
					}
					if(show) return i.toString();
				}
				i++;
			}
		}

		return null;
	}

    public String getForm(boolean isNew, String formLinkData, HttpServletRequest request) {
		boolean eof = false;
		boolean isTabs = false;
		StringBuilder response = new StringBuilder();

		String formname = view.getAttribute("name");
		String canedit = view.getAttribute("canedit");
		String currentTab = "";
	
		if((!isNew) && (rs != null)) {
			beforeFirst();
			eof = moveNext();
		}

		int i = 0;
		response.append("<div class='form-body'>\n");
		response.append("<table id='formtable'>\n");
     	for(BElement el : view.getElements()) {
			if(!(el.getName().equals("USERFIELD")|| (el.getName().equals("DEFAULT"))) || (el.getName().equals("FUNCTION"))) {
				if(el.getAttribute("tab") != null) {
					if(!isTabs) {
						response.append("\n<tr>\n<td width='120' colspan='2'>\n<div class='tabstrip'><ul>");
						String ctab = "";
						for(int j = i; j < view.getNodeSize(); j++) {
							BElement tel = view.getElement(j);
							if(tel.getAttribute("tab")==null) break;
							else {
								if(j==i) response.append("\n<li class='k-state-active'>" + tel.getAttribute("tab") + "</li>");
								else if(!ctab.equals(tel.getAttribute("tab"))) response.append("\n<li>" + tel.getAttribute("tab") + "</li>");
								ctab = tel.getAttribute("tab");
							}
						}
						response.append("\n</ul>");
					}

					if(currentTab.equals(el.getAttribute("tab"))) {
						response.append("\n<tr><td>");
					} else {
						if(isTabs) response.append("</table></div>");
						response.append("\n<div><table><tr><td>");
					}
					currentTab = el.getAttribute("tab");
					isTabs = true;
				} else if((el.getAttribute("title") != null) && (isTabs)) {
					response.append("\n</table></div></div>");
					response.append("\n</td></tr>");
					currentTab = "";
					isTabs = false;
				}

				if(el.getAttribute("title") != null) {
					if(el.getAttribute("titlepos","left").equals("top")) {
						response.append("\n<tr>\n<td style='width: 150px; align:right; vertical-align:top;'></td>\n<td><b>" + el.getAttribute("title")  + "</b>\n</td></tr>\n<tr>\n<td>");
					} else {
						response.append("\n<tr>\n<td style='width: 150px; align:right; vertical-align:top;'>" + el.getAttribute("title"));
					}

					if(el.getName().equals("GRIDBOX")) {
						response.append("<a  class='btn i_magnifying_glass icon small' href='#'");
						if(el.getAttribute("webgrid") == null) {
							response.append(" onClick=\"myClientWin('b_combolist.jsp");
							response.append("?field=" + el.getValue());
						} else {
							response.append(" onClick=\"myClientWin('b_searchlist.jsp");
							response.append("?view=" + el.getAttribute("webgrid") + ":0");
						}
						if(formLinkData != null) response.append("&formlinkdata=" + formLinkData);
						response.append("','win2')\"");
						response.append("name=\"anchor1\" id=\"anchor1\"> select </a>");
					}
					response.append(" : </td><td>");
				}
			}
			String defaultvalue = el.getAttribute("default", "");
			String default_fnct = view.getAttribute("default_fnct");
			if(default_fnct != null) defaultvalue = db.executeFunction("SELECT " + default_fnct + "('" + db.getUserID() + "')");

			if(el.getName().equals("HTML")) {
				response.append(el.getAttribute("html",""));
			} else if(el.getName().equals("TEXTFIELD")) {
				response.append("<input name='" + el.getValue() + "'");

				//whitelabel additions - using whitelabel syntax/semantics
				if(el.getAttribute("type") == null) response.append(" type='text'");
				else response.append(" type='" + el.getAttribute("type") + "'");

				if(el.getAttribute("class") == null) response.append(" class='w_50'");					 
				else response.append(" class='" + el.getAttribute("class") + "'");

				if(el.getAttribute("style") != null) response.append(" style='" + el.getAttribute("style") + "'");
				if(el.getAttribute("id") != null) response.append(" id='" + el.getAttribute("id") + "'");
				if(el.getAttribute("tooltip") != null) response.append(" title='" + el.getAttribute("tooltip") + "'");
				if(el.getAttribute("placeholder") != null) response.append(" placeholder='" + el.getAttribute("placeholder") + "'");
				if(el.getAttribute("data-instant") != null) response.append(" data-instant='" + el.getAttribute("data-instant") + "'");
				if(el.getAttribute("data-min") != null) response.append(" data-min='" + el.getAttribute("data-min") + "'");
				if(el.getAttribute("data-max") != null) response.append(" data-max='" + el.getAttribute("data-max") + "'");
				if(el.getAttribute("data-step","") != null) response.append(" data-step='" + el.getAttribute("data-step") + "'");
				if(el.getAttribute("data-start") != null) response.append(" data-start='" + el.getAttribute("data-start") + "'");
				if(el.getAttribute("data-regex") != null) response.append(" data-regex='" + el.getAttribute("data-regex") + "'");
				if(el.getAttribute("data-timeformat") != null) response.append(" data-timeformat='" + el.getAttribute("data-timeformat") + "'");
				if(el.getAttribute("data-errortext") != null) response.append(" data-errortext='" + el.getAttribute("data-errortext") + "'");
				if(el.getAttribute("required","false").equals("true")) response.append(" required = 'true' ");	
				//whitelabel end

				//custom javascript when needed
				if(el.getAttribute("js_function") != null) {
					String tgt = el.getAttribute("target","");
					response.append(" onblur=\"custom_javascript(this,\'" + el.getAttribute("js_function") + "\',\'" + tgt +"\')\" ");
				}

				//call PL/SQL function when needed - ajax
				if(el.getAttribute("ajaxfunction") != null) {
					String ajx_fxn = el.getAttribute("ajaxfunction");
					response.append(" onBlur=\"javascript:callServer('" + ajx_fxn + "',this.value,'" + el.getValue() + "','" + el.getAttribute("from") + "')\"");
				}

				if(eof) response.append(" value='" + formatData(el).replace("'", "&#39;") + "'");
				else response.append(" value='" + defaultvalue + "'");
				if(el.getAttribute("enabled","true").equals("false")) response.append(" disabled='true'");
				response.append(" class='w_50' size='50'/>");
			} else if(el.getName().equals("TEXTAREA")) {
				String fieldValue = "";
				if(eof) fieldValue = formatData(el).replace("'", "&#39;");
				else fieldValue = defaultvalue;

				response.append("<textarea name='" + el.getValue() + "'");
				if(el.getAttribute("placeholder") != null) response.append(" placeholder='" + el.getAttribute("placeholder") + "'");
				if(el.getAttribute("enabled","true").equals("false")) response.append(" disabled='true'");
				if(el.getAttribute("required","false").equals("true")) response.append(" required = 'true' ");	
				response.append(" cols='50' rows='10'>");
				response.append(fieldValue);
				response.append("</textarea>");
			} else if(el.getName().equals("EDITOR")) {
				String fieldValue = "";
				if(eof) fieldValue = formatData(el).replace("'", "&#39;");
				else fieldValue = el.getAttribute("default", "");

				response.append("<div class='wysiwyg'>");//style='width: 740px;'>");
				response.append("<textarea class='html' name='" + el.getValue() + "'");
				if(el.getAttribute("placeholder") != null) response.append(" placeholder='" + el.getAttribute("placeholder") + "'");
				if(el.getAttribute("enabled","true").equals("false")) response.append(" disabled='true'");
				response.append(" cols='50' rows='10'>");
				response.append(fieldValue);
				response.append("</textarea>");
				response.append("</div>");
			} else if(el.getName().equals("PASSWORD")) {
				response.append("<input type='password' name='" + el.getValue() + "' class='w_50' size='50'/>");
			} else if(el.getName().equals("GRIDBOX")) {
				String myval = null;
				if(eof) myval = getString(el.getValue());
				else myval = el.getAttribute("default", "");

				response.append("<input type='hidden' name='" + el.getValue() + "'");
				if(myval != null) response.append(" value='" + myval + "'");
				response.append(">");

				response.append("<input type='text' name='" + el.getValue() + "_name'");

				//call PL/SQL function when needed - ajax
				if(el.getAttribute("ajaxfunction") != null) {
					String ajx_fxn = el.getAttribute("ajaxfunction");
					response.append(" autocomplete=\"off\" ");
					response.append(" onkeypress=\"javascript:callServer('" + ajx_fxn + "',this.value,'" + el.getValue() + "','" + el.getAttribute("from") + "')\"");
				}

				if(myval != null) {
					String mysql = "SELECT " + el.getAttribute("lpfield") + " FROM " + el.getAttribute("lptable");
					if(el.getAttribute("lpkey") == null) mysql += " WHERE " + el.getValue();
					else mysql += " WHERE " + el.getAttribute("lpkey");
					mysql += " = '" + myval + "'";

					String orderBySql = el.getAttribute("orderby");
					if(orderBySql == null) mysql += " ORDER BY " + el.getAttribute("lpfield");
					else mysql += " ORDER BY " + orderBySql;

					myval = db.executeFunction(mysql);
				}
				if(myval != null) response.append(" value='" + myval + "'");
				response.append(" class='w_50' size='75'/>");
				if(el.getAttribute("ajaxfunction") != null) {
					response.append("<br/><div id='ajaxDiv'><div/>");
				}
			} else if(el.getName().equals("COMBOBOX")) {
				response.append("<select class='combobox' name='" + el.getValue() + "'>");

				String nodefault = el.getAttribute("nodefault");
				String lptable = el.getAttribute("lptable");
				String lpfield = el.getAttribute("lpfield");
				String lpkey = el.getAttribute("lpkey");
				String cmb_fnct = el.getAttribute("cmb_fnct");
				if(lpkey == null) lpkey = el.getValue();

				String mysql = "";
				if(lpkey.equals(lpfield)) mysql = "SELECT " + lpfield + " FROM " + lptable;
				else if (cmb_fnct == null) mysql = "SELECT " + lpkey + ", " + lpfield + " FROM " + lptable;
				else mysql = "SELECT " + lpkey + ", (" + cmb_fnct + ") as " + lpfield + " FROM " + lptable;

				String cmbWhereSql = el.getAttribute("where");
				if((el.getAttribute("noorg") == null) && (orgID != null) && (userOrg != null)) {
					if(cmbWhereSql == null) cmbWhereSql = "(";
					else cmbWhereSql += " AND (";
					cmbWhereSql += orgID + "=" + userOrg + ")";
				}

				if(el.getAttribute("user") != null) {
					String userFilter = "(" + el.getAttribute("user") + " = '" + db.getUserID() + "')";
					if(cmbWhereSql == null) cmbWhereSql = userFilter;
					else cmbWhereSql += " AND " + userFilter;
				}

				String tableFilter = null;
				String linkField = el.getAttribute("linkfield");
				if((linkField != null) && (formLinkData != null)) {
					if(el.getAttribute("linkfnct") == null) tableFilter = linkField + " = '" + formLinkData + "'";
					else tableFilter = linkField + " = " + el.getAttribute("linkfnct") + "('" + formLinkData + "')";

					if(cmbWhereSql == null) cmbWhereSql = "(" + tableFilter + ")";
					else cmbWhereSql += " AND (" + tableFilter + ")";
				}

				if(cmbWhereSql != null) mysql += " WHERE " + cmbWhereSql;

				String orderBySql = el.getAttribute("orderby");
				if(orderBySql == null) mysql += " ORDER BY " + lpfield;
				else mysql += " ORDER BY " + orderBySql;

				if(nodefault != null) response.append("<option></option>");

				BQuery cmbrs = new BQuery(db, mysql);
				while (cmbrs.moveNext()) {
					response.append("<option");
					if(eof) {
						if(getString(el.getValue())!=null) {
							if(getString(el.getValue()).equals(cmbrs.getString(lpkey)))
								response.append(" selected='selected'");
						}
					} else if(cmbrs.getString(lpkey).equals(defaultvalue)) {
						response.append(" selected='selected'");
					}
					response.append(" value='" + cmbrs.getString(lpkey));
					response.append("'>" + cmbrs.getString(lpfield) + "</option>\n");
				}
				cmbrs.close();
				response.append("</select>");
			} else if(el.getName().equals("COMBOLIST")) {
				response.append("<select class='combobox' name='" + el.getValue() + "'>");
				String myval = null;
				String mykey = "";
				if(eof) myval = getString(el.getValue());
				else myval = defaultvalue;

				for(BElement ell : el.getElements()) {
					if(ell.getAttribute("key") == null) mykey = ell.getValue();
					else mykey = ell.getAttribute("key");
					response.append("<option"); 
					if(ell.getAttribute("key") != null) response.append(" value='" + mykey + "'");
					if(mykey.equals(myval)) response.append(" selected='selected'");
					response.append(">" +  ell.getValue() + "</option>");	
				}
				response.append("</select>");
			} else if(el.getName().equals("CHECKBOX")) {
				response.append("<input type='checkbox' name='" + el.getValue());
				if(el.getAttribute("enabled","true").equals("false")) response.append(" disabled='true'");
				response.append("' value='true'");
				if(eof) {
					if(getBoolean(el.getValue())) response.append(" checked");
				} else if(el.getAttribute("default", "").equals("true")) {
					response.append(" checked");
				}
			
				response.append("/>");
			} else if(el.getName().equals("FILE")) {
					response.append("<input type='file' name='" + el.getValue() + "' size='50'/></td>");
			} else if(el.getName().equals("TEXTDATE")) {

				response.append("<input class='datepicker' name='" + el.getValue() + "'");
				if(el.getAttribute("required","false").equals("true")) response.append(" required = 'true' ");	
				if(el.getAttribute("enabled","true").equals("false")) response.append(" disabled='true'");
				if(el.getAttribute("placeholder") != null) response.append(" placeholder='" + el.getAttribute("placeholder") + "'");
				if(eof) {
					SimpleDateFormat dateformatter = new SimpleDateFormat("dd/MM/yyyy");
					if(getString(el.getValue())!=null) {
						String mydate = dateformatter.format(getDate(el.getValue()));				
						response.append(" value='" + mydate + "'");
					}
				} else if(el.getAttribute("default", "").equals("now")) {
					SimpleDateFormat dateParse = new SimpleDateFormat("dd/MM/yyyy");
					response.append(" value='" + dateParse.format(new Date()) + "'");
				}  else if(el.getAttribute("default", "").equals("today")) {
					SimpleDateFormat dateParse = new SimpleDateFormat("dd/MM/yyyy");
					response.append(" value='" + dateParse.format(new Date()) + "'");
				}
				response.append(" size='50'/>");
			} else if(el.getName().equals("TEXTDECIMAL")) {
				response.append("<input class='numerictextbox' type='text' name='" + el.getValue() + "'");

				if(el.getAttribute("required","false").equals("true")) response.append(" required = true ");
				if(el.getAttribute("placeholder") != null) response.append(" placeholder='" + el.getAttribute("placeholder") + "'");

				if(el.getAttribute("js_function") != null) {			
					String tgt = el.getAttribute("target","");
					response.append ( " onblur=\"custom_javascript(this,\'" + el.getAttribute("js_function") + "\',\'" + tgt +"\')\" ");					
				}

				if(el.getAttribute("ajaxfunction") != null){
					String ajx_fxn = el.getAttribute("ajaxfunction");															
					response.append ( " onBlur=\"javascript:callServer('" + ajx_fxn + "',this.value,'" + el.getValue() + "','" + el.getAttribute("from") + "')\"");					
				}

				if(el.getAttribute("enabled","true").equals("false")) response.append(" disabled='true'");
				if(eof) response.append(" value=\"" + formatData(el) + "\"");
				else response.append(" value='" + el.getAttribute("default", "") + "'");
				response.append(" size='50'/>");
			} else if(el.getName().equals("TEXTTIMESTAMP")) {
				response.append("<input class='datetimepicker' type='text' name='" + el.getValue() + "'");
				if(el.getAttribute("enabled","true").equals("false")) response.append(" disabled='true'");
				if(el.getAttribute("required","false").equals("true")) response.append(" required = 'true' ");	
				if(eof) {
					SimpleDateFormat dateformatter = new SimpleDateFormat("dd/MM/yyyy hh:mm a");
					if(getString(el.getValue()) != null) {
						String mydate = dateformatter.format(getDate(el.getValue()));				
						response.append(" value=\"" + mydate + "\"");
					}
				}
				response.append(" size='50'/>");
			} else if(el.getName().equals("SPINTIME")) {
				response.append("<input class='timepicker' type='text' name='" + el.getValue() + "'");
				if(el.getAttribute("enabled","true").equals("false")) response.append(" disabled='true'");
				if(el.getAttribute("required","false").equals("true")) response.append(" required = 'true' ");	
				if(eof) {
					SimpleDateFormat dateformatter = new SimpleDateFormat("hh:mm a");
					if(getString(el.getValue())!=null) {
						String mydate = dateformatter.format(getTime(el.getValue()));				
						response.append(" value=\"" + mydate + "\"");
					}
				} else if(el.getAttribute("default", "").equals("now")) {
					SimpleDateFormat dateParse = new SimpleDateFormat("hh:mm a");
					response.append(" value='" + dateParse.format(new Date()) + "'");
				}
				response.append(" size='50'/>");
			} else if(el.getName().equals("PICTURE")) {
				String mypic = null;
				
				response.append("<div style='width:" + el.getAttribute("w") + "px; height:" + el.getAttribute("h") + "px;'>");
				response.append("<a href=\"javascript:myPictureWin('" + el.getValue() + "')\">");
				if(eof) {
					mypic = getString(el.getValue());
					if(mypic == null) {
						response.append("<img src='resources/images/add.png'>");
					} else {
						response.append("<img height='" + el.getAttribute("h") + "px' width='auto' src='");
						response.append(el.getAttribute("pictures") + "?access=" + el.getAttribute("access"));
						response.append("&picture=" + mypic + "'>");
					}
				} else {
					response.append("<img src='resources/images/add.png'>");
				}

				response.append("</a></div>\n");
				response.append("<input type='hidden' name='" + el.getValue() + "'");
				if(mypic != null) response.append(" value='" + mypic + "'");
				else response.append(" value=''");
				response.append(" />");
			}


			if(!(el.getName().equals("USERFIELD")|| (el.getName().equals("DEFAULT"))) || (el.getName().equals("FUNCTION"))) {
				response.append("</td></tr>");
			}

			i++;
		}
		if(isTabs) {
			response.append("</table></div>");
			response.append("\n</div></td></tr>");
		}
		response.append("</table></div>");
		
		return response.toString();
    }

	public void setSelectAll() {
		selectAll = true;
	}

}

