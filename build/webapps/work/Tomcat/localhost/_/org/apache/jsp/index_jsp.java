/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.54
 * Generated at: 2015-04-05 18:25:09 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import org.baraza.web.*;
import org.baraza.xml.BElement;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(3);
    _jspx_dependants.put("/resources/include/init.jsp", Long.valueOf(1427112316000L));
    _jspx_dependants.put("/resources/include/diary.js", Long.valueOf(1427112316000L));
    _jspx_dependants.put("/resources/include/footer.jsp", Long.valueOf(1427112316000L));
  }

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\n');
      out.write('\n');
      out.write('\n');
      out.write("<!doctype html\">\n");
      out.write("<html lang=\"en-us\">\n");
      out.write(" <head>\n");
      out.write("\t<meta charset=\"utf-8\">\n");
      out.write("\t<title>Open Baraza</title>\n");
      out.write("\t<meta name=\"description\" content=\"Open Baraza\">\n");
      out.write("\t<meta name=\"author\" content=\"Dew CIS Solutions LTD\">\n");
      out.write("\t<!-- Apple iOS and Android stuff -->\n");
      out.write("\t<meta name=\"apple-mobile-web-app-capable\" content=\"no\">\n");
      out.write("\t<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\">\n");
      out.write("\t<link rel=\"apple-touch-icon-precomposed\" href=\"apple-touch-icon-precomposed.png\">\n");
      out.write("\t\n");
      out.write("\t<!-- Apple iOS and Android stuff - don't remove! -->\n");
      out.write("\t<meta name=\"viewport\" content=\"width=device-width,initial-scale=1,user-scalable=no,maximum-scale=1\">\n");
      out.write("\t\n");
      out.write("    <link href=\"resources/themes/default/kendo.common.css\" rel=\"stylesheet\" />\n");
      out.write("    <link href=\"resources/themes/default/kendo.default.css\" rel=\"stylesheet\" />\n");
      out.write("    <link href=\"resources/themes/default/main.css\" rel=\"stylesheet\" >\n");
      out.write("\t\n");
      out.write("    <script src=\"resources/js/kendoui/jquery.min.js\" ></script>\n");
      out.write("    <script src=\"resources/js/kendoui/kendo.all.js\" ></script>\n");
      out.write("\t<script src=\"resources/js/jquery-ui-1.8.16.custom.min.js\"></script>\n");
      out.write("\t<script src=\"resources/js/custom.js\"></script>\t\n");
      out.write("\t\n");
      out.write("\t<!-- some basic functions -->\n");
      out.write("\t<script src=\"resources/js/functions.js\"></script>\n");
      out.write("\t\t\n");
      out.write("\t<!-- all Third Party Plugins and Whitelabel Plugins -->\n");
      out.write("\t<script src=\"resources/js/plugins.js\"></script>\n");
      out.write("\t<script src=\"resources/js/editor.js\"></script>\n");
      out.write("\t<script src=\"resources/js/calendar.js\"></script>\n");
      out.write("\t<script src=\"resources/js/flot.js\"></script>\n");
      out.write("\t<script src=\"resources/js/elfinder.js\"></script>\n");
      out.write("\t<script src=\"resources/js/datatables.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Alert.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Autocomplete.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Breadcrumb.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Calendar.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Chart.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Color.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Date.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Editor.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Dialog.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Fileexplorer.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Form.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Gallery.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Number.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Slider.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Store.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Time.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Valid.js\"></script>\n");
      out.write("\t<script src=\"resources/js/wl_Widget.js\"></script>\n");
      out.write("\t\n");
      out.write("\t<!-- configuration to overwrite settings -->\n");
      out.write("\t<script src=\"resources/js/config.js\"></script>\n");
      out.write("\t<script src=\"resources/js/script.js\"></script>\n");
      out.write("\t\t\t\t\n");
      out.write("  \n");
      out.write('\n');
      out.write('\n');

	ServletContext context = getServletContext();
	String dbconfig = "java:/comp/env/jdbc/database";
	String xmlcnf = request.getParameter("xml");
	if(request.getParameter("logoff") == null) {
		if(xmlcnf == null) xmlcnf = (String)session.getAttribute("xmlcnf");
		if(xmlcnf == null) xmlcnf = context.getInitParameter("config_file");
		if(xmlcnf != null) session.setAttribute("xmlcnf", xmlcnf);
	} else {
		session.removeAttribute("xmlcnf");
		session.invalidate();
  	}

	String ps = System.getProperty("file.separator");
	String xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlcnf;
	String reportPath = context.getRealPath("reports") + ps;

	String userIP = request.getRemoteAddr();
	String userName = request.getRemoteUser();

	BWeb web = new BWeb(dbconfig, xmlfile);
	web.setUser(userIP, userName);
	web.init(request);
	web.setMainPage("index.jsp");

	String entryformid = null;
	String action = request.getParameter("action");
	String value = request.getParameter("value");
	String post = request.getParameter("post");
	String process = request.getParameter("process");
	String actionprocess = request.getParameter("actionprocess");
	if(actionprocess != null) process = "actionProcess";
	String reportexport = request.getParameter("reportexport");
	String excelexport = request.getParameter("excelexport");

	String fieldTitles = web.getFieldTitles();
	String auditTable = null;

	String opResult = null;
	if(process != null) {
		if(process.equals("Action")) {
			String operation = request.getParameter("operation");
			opResult = web.setOperations(operation, request);
		} else if(process.equals("actionProcess")) {
			opResult = web.setOperation(actionprocess, request);
		} else if(process.equals("FormAction")) {
			String actionKey = request.getParameter("actionkey");
			opResult = web.setOperation(actionKey, request);
		} else if(process.equals("Update")) {
			web.updateForm(request);
		} else if(process.equals("Delete")) {
			web.deleteForm(request);
		} else if(process.equals("Submit")) {
			web.submitGrid(request);
		} else if(process.equals("Check All")) {
			web.setSelectAll();
		} else if(process.equals("Audit")) {
			auditTable = web.getAudit();
		}
	}

	if(excelexport != null) reportexport = excelexport;
	if(reportexport != null) {
		out.println("	<script>");
		out.println("		window.open('show_report?report=" + reportexport + "');");
		out.println("	</script>");
	}

      out.write("\n");
      out.write("\n");
      out.write("<!--For diary inclusion-->\n");
 if(web.isDiary()) { 
      out.write('\n');
      out.write('	');
      out.write('	');
      out.write("<script type='text/javascript'>\n");
      out.write("\t$(document).ready(function() {\n");
      out.write("\t\t$('#calendar').fullCalendar({\n");
      out.write("\t\t\theader: {\n");
      out.write("\t\t\t\tleft: 'prev,next,today',\n");
      out.write("\t\t\t\tcenter: 'title',\n");
      out.write("\t\t\t\tright: 'month,agendaWeek,agendaDay'\n");
      out.write("\t\t\t},\t\t\t\n");
      out.write("\t\t\teditable: true,\n");
      out.write("\t\t\tweekends: false,\n");
      out.write("\n");
      out.write("\t\t\teventResize: function(event, dayDelta, minuteDelta, revertFunc) {\n");
      out.write("\t\t\t\tif (confirm(\"Confirm change to save new dates?\")) {\n");
      out.write("\t\t\t\t\tmakeRequest(\"barazaajax?fnct=calresize&id=\" + event.id + \"&enddate=\" + $.fullCalendar.formatDate(event.end, 'yyyy-MM-dd')\n");
      out.write("\t\t\t\t\t\t+ \"&endtime=\" + $.fullCalendar.formatDate(event.end, 'HH:mm:ss'));\n");
      out.write("\t\t\t\t} else {\n");
      out.write("\t\t\t\t\trevertFunc();\n");
      out.write("\t\t\t\t}\n");
      out.write("\t\t\t},\n");
      out.write("\n");
      out.write("\t\t\teventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {\n");
      out.write("\t\t\t\tif (confirm(\"Confirm change to save new dates?\")) {\n");
      out.write("\t\t\t\t\tmakeRequest(\"barazaajax?fnct=calmove&id=\" + event.id \n");
      out.write("\t\t\t\t\t\t+ \"&startdate=\" + $.fullCalendar.formatDate(event.start, 'yyyy-MM-dd')\n");
      out.write("\t\t\t\t\t\t+ \"&starttime=\" + $.fullCalendar.formatDate(event.start, 'HH:mm:ss')\n");
      out.write("\t\t\t\t\t\t+ \"&enddate=\" + $.fullCalendar.formatDate(event.end, 'yyyy-MM-dd')\n");
      out.write("\t\t\t\t\t\t+ \"&endtime=\" + $.fullCalendar.formatDate(event.end, 'HH:mm:ss'));\n");
      out.write("\t\t\t\t} else {\n");
      out.write("\t\t\t\t\trevertFunc();\n");
      out.write("\t\t\t\t}\n");
      out.write("\t\t\t},\n");
      out.write("\n");
      out.write('\n');
      out.write('	');
      out.write('	');
      out.print(web.getCalendar());
      out.write("\n");
      out.write("\t});});</script>\n");
 } 
      out.write("\n");
      out.write("\n");
      out.write("</head>\n");
      out.write("\n");
      out.write("<body>\n");
      out.write("\n");
      out.write("\t<div id=\"pageoptions\">\n");
      out.write("\t\t<ul>\n");
      out.write("\t\t\t<li>");
      out.print( web.getOrgName() );
      out.write(" | </li>\n");
      out.write("\t\t\t<li>");
      out.print( web.getEntityName() );
      out.write(" | </li>\n");
      out.write("\t\t\t<li><a href=\"b_passwordchange.jsp\">Change Password</a> | </li>\n");
      out.write("\t\t\t<li><a href=\"logout.jsp?logoff=yes\">Logout | </a></li>\n");
      out.write("\t\t\t<li><a href=\"http://www.openbaraza.org\" target='_blank'>Made On Baraza  |  </a></li>\n");
      out.write("\t\t\t<li><a href=\"http://www.dewcis.com\" target='_blank'>Made by Dew CIS Solutions Ltd</a></li>\n");
      out.write("\n");
      out.write("\t\t</ul>\n");
      out.write("\t</div>\n");
      out.write("\n");
      out.write("\t<header>\n");
      out.write("\t\t<div id=\"logo\">\n");
      out.write("\t\t</div>\n");
      out.write("\t\t<div id=\"header\">\n");
      out.write("\t\t</div>\n");
      out.write("\t</header>\n");
      out.write("\n");
      out.write("\t<nav>\n");
      out.write("\t\t<div id=\"main-menu\">\n");
      out.write("\t           \t");
      out.print( web.getMenu() );
      out.write("\n");
      out.write("\n");
      out.write("\t            <div id=\"bottom\"></div>\n");
      out.write("\t\t</div>\n");
      out.write("\t</nav>\n");
      out.write("\t\n");
      out.write("\t<section id=\"content\">\n");
      out.write("\n");
      out.write("\t\t<form id=\"baraza\" name=\"baraza\" method=\"post\" action=\"index.jsp\" data-confirm-send=\"false\" data-ajax=\"false\">\n");
      out.write("\t\t\t\t");
      out.print( web.getHiddenValues() );
      out.write("\n");
      out.write("\t\t\t\t");
      out.print( web.getTabs() );
      out.write("\n");
      out.write("\t\t\t\t");
      out.print( web.getButtons() );
      out.write("\n");
      out.write("\n");
      out.write("\t\t\t\t");
 if(opResult != null) out.println("<div style='color:#FF0000'>" + opResult + "</div>"); 
      out.write("\n");
      out.write("\t\t\t\t");
      out.print( web.getSaveMsg() );
      out.write("\n");
      out.write("\n");
      out.write("\t\t\t\t");
      out.print( web.getBody(request, reportPath) );
      out.write("\n");
      out.write("\t\t\t\t");
      out.print( web.getFilters() );
      out.write("\n");
      out.write("\n");
      out.write("\t\t\t\t");

				String actionOp = web.getOperations();
				if(actionOp != null) {
				
      out.write("\n");
      out.write("\t\t\t\t    <div>\n");
      out.write("\t\t\t\t\t\t");
      out.print( actionOp );
      out.write("\n");
      out.write("\t\t\t\t\t\t<button type=\"submit\" name=\"process\" value=\"Action\" class=\"i_cog icon small\"/>Action</button>\n");
      out.write("\t\t\t\t\t\t<button type=\"submit\" name=\"process\" value=\"Check All\" class=\"i_cog icon small\"/>Check All</button>\n");
      out.write("\t\t\t\t  \t</<div>\n");
      out.write("\t\t\t\t");
	} 
      out.write("\n");
      out.write("\n");
      out.write("\t\t\t\t");
 if(fieldTitles != null) { 
      out.write("\n");
      out.write("\t\t\t\t\t<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr>\n");
      out.write("\t\t\t\t\t\t<td width=\"100\">");
      out.print( fieldTitles );
      out.write("</td>\n");
      out.write("\t\t\t\t\t\t<td width=\"100\">\n");
      out.write("\t\t\t\t\t\t\t<select class='fnctcombobox' name='filtertype'>\n");
      out.write("\t\t\t\t\t\t\t\t<option value='ilike'>Contains (case insensitive)</option>\n");
      out.write("\t\t\t\t\t\t\t\t<option value='like'>Contains (case sensitive)</option>\n");
      out.write("\t\t\t\t\t\t\t\t<option value='='>Equal to</option>\n");
      out.write("\t\t\t\t\t\t\t\t<option value='>'>Greater than</option>\n");
      out.write("\t\t\t\t\t\t\t\t<option value='<'>Less than</option>\n");
      out.write("\t\t\t\t\t\t\t\t<option value='<='>Less or Equal</option>\n");
      out.write("\t\t\t\t\t\t\t\t<option value='>='>Greater or Equal</option>\n");
      out.write("\t\t\t\t\t\t\t</select>\n");
      out.write("\t\t\t\t\t\t</td>\n");
      out.write("\t\t\t\t\t\t<td width=\"180\"><input name=\"reportfilter\" type=\"text\" id=\"search\" /></td>\n");
      out.write("\t\t\t\t\t\t<td width=\"55\"><input name='and' type='checkbox'/> And</td>\n");
      out.write("\t\t\t\t\t\t<td width=\"55\"><input name='or' type='checkbox' /> Or</td>\n");
      out.write("\t\t\t\t\t\t<td width=\"55\"><button class=\"i_magnifying_glass icon small\" name=\"search\" value=\"Search\">Search</button></td>\n");
      out.write("\t\t\t\t\t\t<td width=\"105\"></td>\n");
      out.write("\t\t\t\t\t\t<td width=\"55\"><button class=\"i_arrow_up icon small\" name=\"sortasc\" id=\"ascending\" value=\" \">ASC</button></td>\n");
      out.write("\t\t\t\t\t\t<td width=\"55\"><button class=\"i_arrow_down icon small\" name=\"sortdesc\" id=\"descending\" value=\" \">DESC</button></td>\n");
      out.write("\t\t\t\t\t</tr></table>\n");
      out.write("\t\t\t\t");
 } 
      out.write("\n");
      out.write("\n");
      out.write("\t\t\t\t");

				if(web.isForm()) {
					out.println(web.getFormButtons());
					if(auditTable != null) out.println(auditTable);
				} else if(web.isEditField()) {
					out.println("<button class='submit' name='process' value='Submit'>Submit</button>");
				}
				
      out.write("\n");
      out.write("\n");
      out.write("\t\t\t");
      out.print( web.showFooter() );
      out.write("\n");
      out.write("\t\t</form>\n");
      out.write("\n");
      out.write("\t\t");
      out.print( web.getFileButtons() );
      out.write("\n");
      out.write("\t\t\n");
      out.write("\t</section>\n");
      out.write("\n");
 	web.close(); 
      out.write('\n');
      out.write('	');
      out.write('\n');
      out.write("\t<footer>&copy; 2012 - Dew CIS Solutions LTD, All Rights Reserved</footer>\n");
      out.write("</body>\n");
      out.write("</html>");
      out.write('\n');
      out.write('\n');
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
