<%@ page import="org.baraza.web.*" %>
<%@ page import="org.baraza.xml.BElement" %>

<%@ include file="/resources/include/init.jsp" %>

<%
	ServletContext context = getServletContext();
	String xmlcnf = "application.xml";
	session.setAttribute("xmlcnf", xmlcnf);
	String dbconfig = "java:/comp/env/jdbc/database";

	String ps = System.getProperty("file.separator");
	String xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlcnf;
	String reportPath = context.getRealPath("reports") + ps;

	String userIP = request.getRemoteAddr();
	String userName = request.getRemoteUser();

	BWeb web = new BWeb(dbconfig, xmlfile);
	web.setUser(userIP, userName);
	web.init(request);
	web.setMainPage("c_application.jsp");

	String entryformid = null;
	String action = request.getParameter("action");
	String value = request.getParameter("value");
	String post = request.getParameter("post");
	String process = request.getParameter("process");
	String reportexport = request.getParameter("reportexport");
	String excelexport = request.getParameter("excelexport");

	String fieldTitles = web.getFieldTitles();
	String auditTable = null;

	String opResult = null;
	if(process != null) {
		if(process.equals("Action")) {
			String operation = request.getParameter("operation");
			opResult = web.setOperations(operation, request);
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
%>

<!--For diary inclusion-->
<% if(web.isDiary()) { %>
		<%@ include file="/resources/include/diary.js" %>
		<%=web.getCalendar()%>
	});});</script>
<% } %>

</head>

<body>

	<header>
		<div id="logo">
		</div>
		<div id="header">
		</div>
	</header>

	<section>

		<div>If you have previously registered on this site just login directly <a href="index.jsp">here</a></div>

		<div>Click <a href="application.jsp?view=2:0">here</a> if you have forgotten your password. </div>

	</section>
	
	<section>

		<form id="baraza" name="baraza" method="post" action="application.jsp" data-confirm-send="false" data-ajax="false">
				<%= web.getHiddenValues() %>
				<%= web.getTabs() %>
				<%= web.getButtons() %>

				<% if(opResult != null) out.println("<div style='color:#FF0000'>" + opResult + "</div>"); %>
				<%= web.getSaveMsg() %>

				<%= web.getBody(request, reportPath) %>
				<%= web.getFilters() %>

				<%
				String actionOp = web.getOperations();
				if(actionOp != null) {
				%>
				    <div>
						<%= actionOp %>
						<button type="submit" name="process" value="Action" class="i_cog icon small"/>Action</button>
						<button type="submit" name="process" value="Check All" class="i_cog icon small"/>Check All</button>
				  	</<div>
				<%	} %>

				<% if(fieldTitles != null) { %>
					<table border="0" cellpadding="0" cellspacing="0"><tr>
						<td width="100"><%= fieldTitles %></td>
						<td width="100">
							<select class='fnctcombobox' name='filtertype'>
								<option value='ilike'>Contains (case insensitive)</option>
								<option value='like'>Contains (case sensitive)</option>
								<option value='='>Equal to</option>
								<option value='>'>Greater than</option>
								<option value='<'>Less than</option>
								<option value='<='>Less or Equal</option>
								<option value='>='>Greater or Equal</option>
							</select>
						</td>
						<td width="180"><input name="reportfilter" type="text" id="search" /></td>
						<td width="55"><input name='and' type='checkbox'/> And</td>
						<td width="55"><input name='or' type='checkbox' /> Or</td>
						<td width="55"><button class="i_magnifying_glass icon small" name="search" value="Search">Search</button></td>
						<td width="105"></td>
						<td width="55"><button class="i_arrow_up icon small" name="sortasc" id="ascending" value=" ">ASC</button></td>
						<td width="55"><button class="i_arrow_down icon small" name="sortdesc" id="descending" value=" ">DESC</button></td>
					</tr></table>
				<% } %>

				<%
				if(web.isForm()) {
					out.println(web.getFormButtons());
					if(auditTable != null) out.println(auditTable);
				} else if(web.isEditField()) { 
					out.println("<button class='submit' name='process' value='Submit'>Submit</button>");

					String operation = web.getOperations();
					if(operation != null) out.println(operation);
				}
				%>

			<%= web.showFooter() %>
		</form>

		<%= web.getFileButtons() %>
		
	</section>

<% 	web.close(); %>
	
<%@ include file="/resources/include/footer.jsp" %>

