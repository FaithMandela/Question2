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
	String formid;
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
		
		formid = getParameter("actionvalue");
		getFormType();

		mystr += fhead;
		mystr += "<form id='baraza' name='baraza' method='post' action='form.jsp'>\n";
		mystr += "<table class='table' width='95%' >\n";

		mystr += printForm(null, "false");
		
		mystr += "</table>\n";
		mystr += "</form>\n";
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
		
		int fieldRows = 2;
		int fieldCount = 0;
		String fieldId = "";
		while(rs.moveNext()) {
			fieldOrder = rs.getInt("field_order");
			fieldId = rs.getString("field_id");
			shareLine = rs.getInt("share_line");

			fieldType = "TEXTFIELD";
			if(rs.getString("field_type") != null) fieldType = rs.getString("field_type").trim().toUpperCase();

			fieldclass = "";
			if(rs.getString("field_class") != null) fieldclass = " class='" + rs.getString("field_class") + "' ";
			
			question = rs.getString("question");
			if(rs.getString("question") == null) question = "";

			details = rs.getString("details");
			if(rs.getString("details") == null) details = "";

			label_position = rs.getString("label_position");
			if(rs.getString("label_position") == null) label_position = "L";

			size = 10;
			if(rs.getString("field_size") == null) size = rs.getInt("field_size");

			if(rs.getBoolean("field_bold")) question = "<b>" + question + "</b>";
			if(rs.getBoolean("field_italics")) question = "<i>" + question + "</i>";

			label = "<label for='F" + rs.getString("field_id") +  "'> " + question + "</label>";
			
			// Start a new row
			if(fieldType.equals("TITLE") || fieldType.equals("TEXT") || fieldType.equals("SUBGRID") || fieldType.equals("TABLE")) {
				if((fieldCount != 0) && (fieldCount < fieldRows)) 
					myhtml.append("<td colspan='" + String.valueOf(fieldRows * 2 - fieldCount) + "'></td></tr>\n");
				myhtml.append("<tr>");
				fieldCount = 0;
			} else {
				if((fieldCount % fieldRows) == 0) {
					myhtml.append("<tr>");
					fieldCount = 0;
				}
				if(!question.equals("")) myhtml.append("<td style='width:200'>" + label + "</td>");
			}
			
			if(fieldType.equals("TEXTFIELD")) {
				input = "<td><input " + disabled + " type='text' ";
				input += " style='width:" + rs.getString("field_size") + "0px' ";
				input += " name='F" + fieldId +  "'";
				input += " id ='F" + fieldId +  "'";
				input += getAnswer(fieldId);
				input += " placeholder='" + details +"'";
				input += " class='form-control' /></td>\n";
				fieldCount++;
			} else if(fieldType.equals("TEXTAREA")) {
				input = "<td><textarea " + disabled + " type='text' ";
				input += " style='width:" + rs.getString("field_size") + "0px' ";
				input += " name='F" + fieldId +  "'";
				input += " id ='F" + fieldId +  "'";
				input += " placeholder='" + details +"'";
				input += " class='form-control' />" + getAnswer(fieldId) + "</textarea></td>\n";
				fieldCount++;
			} else if(fieldType.equals("DATE")) {
				input = "<td><div class='input-group input-medium date date-picker' data-date-format='dd-mm-yyyy' data-date-viewmode='years'>";
				input += "<input " + disabled + " type='text' ";
				input += " style='width:" + rs.getString("field_size") + "0px' ";
				input += " name='F" + fieldId +  "'";
				input += " id ='F" + fieldId +  "'";
				input += getAnswer(fieldId);
				input += " class='form-control' />";
				input += "</div></td>\n";
				fieldCount++;
			} else if(fieldType.equals("TIME")) {
				input = "<td><div class='input-group input-medium'>\n";
				input += "<input " + disabled + " type='text' ";
				input += " style='width:" + rs.getString("field_size") + "0px' ";
				input += " name='F" + fieldId +  "'";
				input += " id ='F" + fieldId +  "'";
				input += getAnswer(fieldId);
				input += " class='form-control clockface' />\n";
				input += "	<span class='input-group-btn'>\n";
				input += "		<button class='btn default clockface-toggle' data-target='F" + fieldId + "' type='button'><i class='fa fa-clock-o'></i></button>\n";
				input += "	</span>\n";
				input += "</div></td>\n";
				fieldCount++;
			} else if(fieldType.equals("LIST")) {
				input = "<td><select class='form-control' ";
				input += " style='width:" + rs.getString("field_size") + "0px' ";
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
				myhtml.append("<td colspan='" + String.valueOf(fieldRows * 2) + "'>\n");
				myhtml.append(printSubTable(fieldId, disabled, question, table_count));
				myhtml.append("</td>\n");
				table_count++;
				fieldCount = 0;
			} else {
				System.out.println("TYPE NOT DEFINED : " + fieldType);
			}
			
			myhtml.append(input);
			
			// create a new line if the is no line sharing
			if(shareLine == -1) {
				if((fieldCount != 0) && (fieldCount < fieldRows)) 
					myhtml.append("<td colspan='" + String.valueOf(fieldRows * 2 - fieldCount) + "'></td></tr>\n");
				fieldCount = 0;
			} else if((fieldCount % fieldRows) == 0) {
				myhtml.append("</tr>\n");
			}
		}
		
		if((fieldCount % fieldRows) != 0) myhtml.append("</tr>\n");
				
		rs.close();

		return myhtml.toString();
	}
	
	public String printSubForm() {
		String myhtml = "";
		
		String mysql = "SELECT * FROM fields WHERE (form_id = " + formid + ")";
		mysql += " AND ((field_type = 'SUBGRID') OR (field_type = 'TABLE')) ";
		mysql += " ORDER BY field_order, field_id;";
		BQuery rs = new BQuery(db, mysql);
		
		while(rs.moveNext()) {
			String fieldId = rs.getString("field_id");
			JsonObjectBuilder jshd = printSubTable(fieldId);
		
			jshd.add("url", "jsondata");
			jshd.add("datatype", "json");
			jshd.add("mtype", "GET");
			jshd.add("pager", "#pager" + fieldId);
			jshd.add("viewrecords", true);
			jshd.add("gridview", true);
			jshd.add("autoencode", true);
			jshd.add("autowidth", false);
		
			JsonObject jsObj = jshd.build();
			
			myhtml += "\njQuery('#grid" + fieldId +"').jqGrid(" + jsObj.toString() + ");";
			myhtml += "\njQuery('#grid" + fieldId + "').jqGrid('navGrid', '#pager" + fieldId + "', {edit:true, add:true, del:true, search:false});";
		
			System.out.println("BASE 2030 : " + jsObj.toString());
		}
		
		return myhtml;
	}
	
	public JsonObjectBuilder printSubTable(String fieldId) {
		JsonObjectBuilder jshd = Json.createObjectBuilder();
		JsonArrayBuilder jsColModel = Json.createArrayBuilder();
		JsonArrayBuilder jsColNames = Json.createArrayBuilder();
		
		String mysql = "SELECT sub_field_id, sub_field_type, sub_field_size, sub_field_lookup, question ";
		mysql += " FROM vw_sub_fields WHERE field_id = " + fieldId;
		mysql += " ORDER BY sub_field_order";
		BQuery rs = new BQuery(db, mysql);
		
		while(rs.moveNext()) {		
			JsonObjectBuilder jsColEl = Json.createObjectBuilder();
			String fld_name = "SF" + rs.getString("sub_field_id");
			String fld_title = rs.getString("question");
			String fld_size = rs.getString("sub_field_size") + "0";
			if(fld_title == null) fld_title = "";
			if(fld_size == null) fld_size = "10";
			
			jsColNames.add(fld_title);
			jsColEl.add("name", fld_name);
			jsColEl.add("width", fld_size);
			jsColEl.add("editable", true);
			jsColModel.add(jsColEl);
		}
		
		jshd.add("colNames", jsColNames);
		jshd.add("colModel", jsColModel);

		return jshd;
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
