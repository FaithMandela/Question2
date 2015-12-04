/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.web;

import org.apache.poi.poifs.filesystem.*;
import org.apache.poi.hssf.usermodel.*;

import java.util.logging.Logger;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.text.SimpleDateFormat;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.InputStream;
import java.io.IOException;
import java.io.PrintWriter;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.JsonArrayBuilder;

import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;
import org.baraza.xml.BXML;
import org.baraza.xml.BElement;
import org.baraza.utils.BNumberFormat;
import org.baraza.utils.BCipher;

public class BWebForms {
	Logger log = Logger.getLogger(BWebForms.class.getName());
	Map<String, String[]> params;
	Map<String, String> answers;
	Map<String, String> subanswers;
	String entryFormId = null;
	String formid = "0";
	String fhead, ffoot, ftitle;

	BDB db = null;
	String access_text = null;

	public BWebForms(String dbconfig) {
		db = new BDB(dbconfig);
	}

	public BWebForms(String dbconfig, String at) {
	    db = new BDB(dbconfig);
	    access_text = at;
	}

	public String getWebForm(String entryformid, Map<String, String[]> sParams) {
		String mystr = "";

		answers = new HashMap<String, String>();
		subanswers = new HashMap<String, String>();
		params = new HashMap<String, String[]>(sParams);
		
		String entityId = null;
		String approveStatus = null;
		
		String action = getParameter("action");
		if((action == null) || (action.trim().equals("FORM"))) {
			formid = getParameter("actionvalue");
		} else {
			String entryFormId = getParameter("actionvalue");
			Map<String, String> formRS = db.readFields("form_id, entity_id, approve_status", "entry_forms WHERE entry_form_id = " + entryFormId);
			formid = formRS.get("form_id");
			entityId = formRS.get("entity_id");
			approveStatus = formRS.get("approve_status");
		}
		
		getFormType();

		mystr += fhead;
		mystr += printForm(null, "false");
		mystr += ffoot;

		return mystr;
	}
	
	public void getFormType() {
		fhead = "";
		ffoot = "";
		ftitle = "";

		String mysql = "SELECT form_header, form_footer, form_name, form_number ";
		mysql += "FROM forms WHERE form_id = " + formid;
		BQuery rs = new BQuery(db, mysql);
		if(rs.moveNext()) {
			fhead = rs.getString("form_header");
			ffoot = rs.getString("form_footer");
			ftitle = rs.getString("form_number") + " : " + rs.getString("form_name");
		}
		rs.close();

		if(fhead == null) fhead = "";
		else fhead = "<section>" + fhead + "</section>\n";

		if(ffoot == null) ffoot = "";
		else ffoot = "<section>" + ffoot + "</section>\n";
	}
	
	public String getFormTabs() {
		StringBuilder myhtml = new StringBuilder();
		
		String mysql = "SELECT * FROM fields WHERE (form_id = " + formid + ")";
		mysql += " AND (field_type = 'TAB') ";
		mysql += " ORDER BY field_order, field_id;";
		BQuery rs = new BQuery(db, mysql);
		
		int tabCount = 0;
		String tabs = "";
		while(rs.moveNext()) {
			String question = rs.getString("question");
			if(rs.getString("question") == null) question = "";

			if(tabCount == 0) tabs = "<li class='active'>";
			else tabs += "\n<li>";
			tabs += "<a href='#tab" + rs.getString("field_id") + "' data-toggle='tab'>" + question + " </a></li>\n";
			
			tabCount++;
		}
			
		if(tabCount > 0) {
			myhtml.append("<div class='row'>\n"
			+ "	<div class='col-md-12'>\n"
			+ "		<div class='tabbable portlet-tabs'>\n"
			+ "			<ul class='nav nav-tabs'>\n"
			+ tabs
			+ "			</ul>\n"
			+ "		</div>\n"
			+ "	</div>\n"
			+ "</div>\n"
			+ "<div class='tab-content'>\n");
		}
		
		
		return myhtml.toString();
	}
		
	//new printForm() method based on tables
	public String printForm(String disabled, String process) {
		StringBuilder myhtml = new StringBuilder();

		int fieldOrder = 0;
		int shareLine = 0;
		int sl = -1;
		int cnt_title = 0;
		int size = 0;
		int table_count = 0;

		String label = "";
		String input = "";
		String fieldType = "TEXTFIELD";
		String fieldclass = "";
		String question = "";
		String details = "";
		String label_position = "";

		if(disabled == null) disabled = "";
		else disabled = " disabled=\"true\" ";

		boolean isTabs = false;
		String tab = "";
		String tab_head = "";
		String tab_body = "";

		String mysql = "SELECT * FROM fields WHERE form_id = " + formid;
		mysql += " ORDER BY field_order, field_id;";
		BQuery rs = new BQuery(db, mysql);
		
		int elCount = 0;
		int fieldRows = 2;
		int fieldCount = 0;
		int tabCount = 0;
		String fieldId = "";
		while(rs.moveNext()) {
			fieldOrder = rs.getInt("field_order");
			fieldId = rs.getString("field_id");
			shareLine = rs.getInt("share_line");

			fieldType = "TEXTFIELD";
			if(rs.getString("field_type") != null) fieldType = rs.getString("field_type").trim().toUpperCase();
			
			question = rs.getString("question");
			if(rs.getString("question") == null) question = "";

			details = rs.getString("details");
			if(rs.getString("details") == null) details = "";

			fieldclass = "";
			if(rs.getString("field_class") != null) fieldclass = " class='" + rs.getString("field_class") + "' ";
			
			size = 10;
			if(rs.getString("field_size") != null) size = rs.getInt("field_size");

			if(rs.getBoolean("field_bold")) question = "<b>" + question + "</b>";
			if(rs.getBoolean("field_italics")) question = "<i>" + question + "</i>";

			label = "<label for='F" + rs.getString("field_id") +  "'> " + question + "</label>";
			
			// Start a new row
			if(fieldType.equals("TITLE") || fieldType.equals("TEXT") || fieldType.equals("SUBGRID") || fieldType.equals("TABLE")) {
				if((elCount == 0) && (tabCount == 0)) myhtml.append("<table class='table' width='95%' >\n");
				
				if((fieldCount != 0) && (fieldCount < fieldRows)) 
					myhtml.append("<td colspan='" + String.valueOf(fieldRows * 2 - fieldCount) + "'></td></tr>\n");
				myhtml.append("<tr>");
				fieldCount = 0;
			} else if(fieldType.equals("TAB")) {
				if(tabCount == 0) {
					myhtml.append("<div class='tab-pane active' id='tab" + fieldId + "'>\n");
				} else {
					myhtml.append("</table></div>");
					myhtml.append("<div class='tab-pane' id='tab" + fieldId + "'>\n");
				}
				myhtml.append("<table class='table' width='95%' >\n");
				tabCount++;
			} else {
				if((elCount == 0) && (tabCount == 0)) myhtml.append("<table class='table' width='95%' >\n");
				
				if((fieldCount % fieldRows) == 0) {
					myhtml.append("<tr>");
					fieldCount = 0;
				}
				if(!question.equals("")) myhtml.append("<td style='width:200px'>" + label + "</td>");
			}
			
			if(fieldType.equals("TEXTFIELD")) {
				input = "<td><input " + disabled + " type='text' "
				+ " style='width:" + size + "0px' "
				+ " name='F" + fieldId +  "'"
				+ " id ='F" + fieldId +  "'"
				+ getAnswer(fieldId)
				+ " placeholder='" + details +"'"
				+ " class='form-control' /></td>\n";
				fieldCount++;
			} else if(fieldType.equals("TEXTAREA")) {
				input = "<td><textarea " + disabled + " type='text' "
				+ " style='width:" + size + "0px' "
				+ " name='F" + fieldId +  "'"
				+ " id ='F" + fieldId +  "'"
				+ " placeholder='" + details +"'"
				+ " class='form-control' />" + getAnswer(fieldId) + "</textarea></td>\n";
				fieldCount++;
			} else if(fieldType.equals("DATE")) {
				input = "<td><div class='input-group input-medium date date-picker' data-date-format='dd-mm-yyyy' data-date-viewmode='years'>";
				input += "<input " + disabled + " type='text' "
				+ " style='width:" + size + "0px' "
				+ " name='F" + fieldId +  "'"
				+ " id ='F" + fieldId +  "'"
				+ getAnswer(fieldId)
				+ " class='form-control'/>";
				input += "<span class='input-group-btn'>"
				+ "<button class='btn default' type='button'><i class='fa fa-calendar'></i></button>"
				+ "</span>";
				input += "</div></td>\n";
				fieldCount++;
			} else if(fieldType.equals("TIME")) {
				input = "<td><div class='input-group input-medium'>\n";
				input += "<input " + disabled + " type='text' "
				+ " style='width:" + size + "0px' "
				+ " name='F" + fieldId +  "'"
				+ " id ='F" + fieldId +  "'"
				+ getAnswer(fieldId)
				+ " class='form-control'/>";
				input += "<span class='input-group-btn'>"
				+ "	<button class='btn default clockface-toggle' data-target='F" + fieldId + "' type='button'><i class='fa fa-clock-o'></i></button>"
				+ "</span>";
				input += "</div></td>\n";
				fieldCount++;
			} else if(fieldType.equals("LIST")) {
				input = "<td><select class='form-control' ";
				input += " style='width:" + size + "0px' ";
				input += " name='F" + fieldId +  "'";
				input += " id='F" + fieldId +  "'";
				input += ">\n";

				String lookups = rs.getString("field_lookup");
				String listVal = answers.get("F" + fieldId);
				if(listVal == null) listVal = "";
				else listVal = listVal.replace("\"", "").trim();

				if(lookups != null) {
					String[] lookup = lookups.split("#");
					for(String lps : lookup) {
						if(lps.compareToIgnoreCase(listVal)==0)
							input += "<option selected='selected'>" + lps + "</option>\n";
						else
							input += "<option>" + lps + "</option>\n";
					}
				}

				input += "</select></td>\n";
				fieldCount++;
			} else if(fieldType.equals("SELECT")) {
				input = "<td><select class='form-control' ";
				input += " name='F" + fieldId + "'";
				input += " id='F" + fieldId + "'";
				input += " style='width:" + size + "0px' ";
				input += ">\n";

				String lookups = rs.getString("field_lookup");
				String selectVal = answers.get("F" + fieldId);
				if(selectVal == null) selectVal = "";
				else selectVal = selectVal.replace("\"","").trim();
				String spanVal = "";

				if(lookups != null) {
					BQuery lprs = new BQuery(db, lookups);
					int cols = lprs.getColnum();

					while(lprs.moveNext()) {
						if(cols == 1){
							if(lprs.readField(1).trim().compareToIgnoreCase(selectVal)==0) {
								spanVal = lprs.readField(1);
								input += "<option value='" + lprs.readField(1) + "' selected='selected'>" + lprs.readField(1) + "</option>\n";
							} else {
								input += "<option value='" + lprs.readField(1) + "'>" + lprs.readField(1) + "</option>\n";
							}
						} else {
							if(lprs.readField(1).trim().compareToIgnoreCase(selectVal)==0) {
								spanVal = lprs.readField(2);
								input += "<option value='" + lprs.readField(1) + "' selected='selected'>" + lprs.readField(2) + "</option>\n";
							} else {
								input += "<option value='" + lprs.readField(1) + "'>" + lprs.readField(2) + "</option>\n";
							}
						}
					}
					lprs.close();
				}
				input += "</select></td>\n";
				fieldCount++;
			} else if(fieldType.equals("TITLE")) {
				cnt_title ++;
				input = "<td colspan='" + String.valueOf(fieldRows * 2) + "'>";
				input += "<div class='form_title'><b><strong>" + question + "</strong></b></div>";
				input += "</td>\n";
				fieldCount = 0;
			} else if(fieldType.equals("TEXT")) {
				cnt_title ++;
				input = "<td colspan='" + String.valueOf(fieldRows * 2) + "'>";
				input += "<div class='form_text'>" + question + "</div>";
				input += "</td>\n";
				fieldCount = 0;
			} else if(fieldType.equals("SUBGRID") || fieldType.equals("TABLE")) {
				input = "";
				myhtml.append("<td colspan='" + String.valueOf(fieldRows * 2) + "'>"
				+ "<div class='container'>"
				+ "	<div class='col-md-12 column'>"
				+ "		<div id='sub_table" + fieldId + "'></div>"
				+ "	</div>"
				+ "	<a id='add_row" + fieldId + "' class='btn btn-default pull-left'>Add Row</a>"
				+"</div>"
				+ "</td>");
				
				table_count++;
				fieldCount = 0;
			} else if(fieldType.equals("TAB")) {
				input = "";
				fieldCount = 0;
			} else {
				System.out.println("TYPE NOT DEFINED : " + fieldType);
			}
			
			myhtml.append(input);
			
			// create a new line if the is no line sharing
			if(!fieldType.equals("TAB")) {
				if(shareLine == -1) {
					if((fieldCount != 0) && (fieldCount < fieldRows)) 
						myhtml.append("<td colspan='" + String.valueOf(fieldRows * 2 - fieldCount) + "'></td></tr>\n");
					fieldCount = 0;
				} else if((fieldCount % fieldRows) == 0) {
					myhtml.append("</tr>\n");
				}
			}
			
			elCount++;
		}
		
		if((fieldCount % fieldRows) != 0) myhtml.append("</tr>\n");
		
		if(tabCount == 0) {
			myhtml.append("</table>");
		} else {
			myhtml.append("</table>\n</div>\n</div>");
		}
				
		rs.close();

		return myhtml.toString();
	}
	
	public String printSubForm() {
		String myhtml = "";
		String tableList = null;
		
		String mysql = "SELECT * FROM fields WHERE (form_id = " + formid + ")";
		mysql += " AND ((field_type = 'SUBGRID') OR (field_type = 'TABLE')) ";
		mysql += " ORDER BY field_order, field_id;";
		BQuery rs = new BQuery(db, mysql);
		
		while(rs.moveNext()) {
			myhtml += "\n\n" + printSubTable(rs.getString("field_id"), rs.getString("field_size"));
			
			if(tableList == null) tableList = "var db_list = ['db" + rs.getString("field_id") + ".table'";
			else tableList += ", 'db" + rs.getString("field_id") + ".table'";
		}
		if(tableList == null) tableList = "var db = [";
		tableList += "];";
		
		myhtml += "\n\n" + tableList;
		
		return myhtml;
	}
	
	public String printSubTable(String fieldId, String tableSize) {
		StringBuilder myhtml = new StringBuilder();
		
		String mysql = "SELECT sub_field_id, sub_field_type, sub_field_size, sub_field_lookup, question ";
		mysql += " FROM vw_sub_fields WHERE field_id = " + fieldId;
		mysql += " ORDER BY sub_field_order";
		BQuery rs = new BQuery(db, mysql);
		
		myhtml.append("var db" + fieldId + " = {\n"
		+ "loadData: function(filter) { return this.table;  },\n"
		+ "insertItem: function(insertingClient) { this.table.push(insertingClient); },\n"
		+ "updateItem: function(updatingClient) { },\n"
		+ "deleteItem: function(deletingClient) {\n"
		+ "var clientIndex = $.inArray(deletingClient, this.table);\n"
		+ "this.table.splice(clientIndex, 1);\n"
		+ "}};\n"
		+ "window.db" + fieldId + " = db" + fieldId + ";\n"
		+ "db" + fieldId + ".table = [ ];\n\n"
		+ "$('#sub_table" + fieldId + "').jsGrid(");
			
		JsonObjectBuilder jshd = Json.createObjectBuilder();
		jshd.add("width", tableSize + "%");
		jshd.add("height", "200px");
		jshd.add("editing", true);
		jshd.add("filtering", false);
		jshd.add("sorting", false);
		jshd.add("paging", false);
		
		jshd.add("data", "#db_table#");
		
		JsonArrayBuilder jsColModel = Json.createArrayBuilder();
		while(rs.moveNext()) {		
			JsonObjectBuilder jsColEl = Json.createObjectBuilder();
			String fld_name = "SF" + rs.getString("sub_field_id");
			String fld_title = rs.getString("question");
			String fld_size = rs.getString("sub_field_size");
			String fld_type = rs.getString("sub_field_type");
			if(fld_title == null) fld_title = "";
			if(fld_size == null) fld_size = "100";
			else fld_size = fld_size + "0";
		
			jsColEl.add("title", fld_title);
			jsColEl.add("name", fld_name);
			jsColEl.add("width", fld_size);
			if(fld_type.equals("TEXTFIELD")) jsColEl.add("type", "text");
			if(fld_type.equals("TEXTAREA")) jsColEl.add("type", "textarea");
			jsColModel.add(jsColEl);
		}
		JsonObjectBuilder jsColEl = Json.createObjectBuilder();
		jsColEl.add("type", "control");
		jsColModel.add(jsColEl);
		jshd.add("fields", jsColModel);
		
		JsonObject jsObj = jshd.build();
		String tableDef = jsObj.toString().replaceAll("\"#db_table#\"", "db" + fieldId + ".table");
		myhtml.append(tableDef + "\n);");
		
		myhtml.append("\n$(document).ready(function(){"
		+ "$('#add_row" + fieldId + "').click(function(){$('#sub_table" + fieldId + "').jsGrid('insertItem');});\n});\n");

		return myhtml.toString();
	}
	
	public String printSubTable(String fieldId, String disabled, String caption, int table_count) {
		StringBuilder myhtml = new StringBuilder();

		String mysql = "SELECT sub_field_id, sub_field_type, sub_field_size, sub_field_lookup, question ";
		mysql += " FROM vw_sub_fields WHERE field_id = " + fieldId;
		mysql += " ORDER BY sub_field_order";
		BQuery rs = new BQuery(db, mysql);

		String mytitle = "";
		String titleshare = "";
		String sharetitle = "";

		Map<String, String> subFields = new HashMap<String, String>();
		Map<String, String> subFieldLookups = new HashMap<String, String>();
		Map<String, String> subFieldSize = new HashMap<String, String>();
		List<String> subFieldOrder = new ArrayList<String>();

		String filltb = "";			// declares an array of String responce
		String tableRows = "";
		String ans = "";
		String sub_field_type = "TEXTFIELD";
		String sub_field_size = "";

		while(rs.moveNext()) {
			subFieldOrder.add(rs.getString("sub_field_id"));
			subFields.put(rs.getString("sub_field_id"), rs.getString("sub_field_type"));
			subFieldSize.put(rs.getString("sub_field_id"), rs.getString("sub_field_size"));
			subFieldLookups.put(rs.getString("sub_field_id"), rs.getString("sub_field_lookup"));

			mytitle += "<th>" + rs.getString("question") + "</th>";
		}

		int j = 1;
		boolean printRow = true;

		while(printRow) {
			filltb = "<tr>";
			boolean hasData = false;

			//search:
			for(String subFieldID : subFieldOrder) {
				ans = getAnswer(subFieldID, j);
				String answer = subanswers.get("SF:" + subFieldID + ":" + Integer.toString(j));

				if(answer == null) answer = "";
				else hasData = true;

				sub_field_type = subFields.get(subFieldID);
				sub_field_size = subFieldSize.get(subFieldID);

				if(sub_field_type.equals("TEXTFIELD")) {
					filltb += "<td><input" + disabled + " class='form-control' type='text' ";
					filltb += " style='width:" + sub_field_size + "0px' ";
					filltb += " id='SF:" + subFieldID + "'";
					filltb += " name='SF:" + subFieldID + "'";
					filltb += ans + "/></td>\n";
				} else if(sub_field_type.equals("LIST")) {
					filltb += "<td><select classx='form-control'";
					filltb += " id='SF:" + subFieldID + "'";
					filltb += " name='SF:" + subFieldID + "'";
					filltb += ">\n";
					String lookups = subFieldLookups.get(subFieldID);
					if(lookups != null) {
						String[] lookup = lookups.split("#");
						for(String lps : lookup) {
							if(lps.equals(answer)) filltb += "<option selected='selected'>" + lps + "</option>\n";
							else filltb += "<option>" + lps + "</option>\n";
						}
					}
					filltb += "</select></td>\n";
				} else if(sub_field_type.equals("SELECT")) {
					filltb += "<td><select classx='form-control' ";
					filltb += " id='SF:" + subFieldID + "'";
					filltb += " name='SF:" + subFieldID + "'";
					filltb += ">\n";
					String lookups = subFieldLookups.get(subFieldID);
					String spn = "";
					if(lookups != null) {
						BQuery lprs = new BQuery(db, lookups);
						int cols = lprs.getColnum();
						while(lprs.moveNext()) {
							if(cols == 1){
								if(lprs.readField(1).equals(answer)) {
									spn = lprs.readField(1);
									filltb += "<option value='" + lprs.readField(1) + "' selected='selected'>" + lprs.readField(1) + "</option>\n";
								} else {
									filltb += "<option value='" + lprs.readField(1) + "'>" + lprs.readField(1) + "</option>\n";
								}
							} else {
								if(lprs.readField(1).equals(answer)) {
									spn = lprs.readField(2);
									filltb += "<option value='" + lprs.readField(1) + "' selected='selected'>" + lprs.readField(2) + "</option>\n";
								} else {
									filltb += "<option value='" + lprs.readField(1) + "'>" + lprs.readField(2) + "</option>\n";
								}
							}
						}
						lprs.close();
					}
					filltb += "</select>";
					filltb += "<span " + " id='tableselect" + subFieldID +  "' " + " class='noscreen'> " + spn + "</span></td>\n";
				}
			}

			if(hasData)
				filltb += "<td><input type='button' class='deleteThisRow' name='del_row" + table_count + "_" + j + "' value='Delete'/></td>";
			filltb += "</tr>\n";

			if(hasData) tableRows += filltb;
			else printRow = false;

			j++;
		}

		if(j == 2) tableRows += filltb;

		myhtml.append("<div class='portlet-body'>\n");
		myhtml.append("<div class=table-toolbar>\n");
		myhtml.append("</div>");
		myhtml.append("<table class='table table-striped table-hover table-bordered' id='sample_editable_" + table_count + "'>\n");
		myhtml.append("<thead><tr>" + mytitle + "<th></th></tr></thead>\n");
		myhtml.append(tableRows);
		myhtml.append("</table>\n");
		myhtml.append("<div><a id='add_row" + table_count + "' class='btn btn-default pull-left'>Add Row</a>\n");
		myhtml.append("</div'>\n");

		rs.close();

		return myhtml.toString();
	}

	public String getParameter(String paramName) {
		String paramValue = null;
		if(params.get(paramName) != null) paramValue = params.get(paramName)[0];
		return paramValue;
	}

	public String getAnswer(String fieldid) {
		String answer = answers.get("F" + fieldid);

		if(answer == null) {
			answer = "";
		} else if(answer.trim().equals("")) {
			answer = "";
		} else {
			answer = answer.replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
			answer = " value=\"" + answer + "\" ";
		}

		return answer;
	}

	public String getAnswer(String subfieldid, int answerline) {
		String answer = null;
		String qst = "SF:" + subfieldid + ":" + Integer.toString(answerline);
		answer = subanswers.get(qst);

		if(answer == null) {
			answer = "";
		} else if(answer.trim().equals("")) {
			answer = "";
		} else {
			answer = answer.replaceAll("&", "&amp;").replaceAll("\"", "&quot;");
			answer = " value=\"" + answer + "\" ";
		}

		return answer;
	}
	
	public String getTitle() {
		return ftitle;
	}
	
	public void close() {
		if(db != null) db.close();
	}

}
