<%@ page import="org.baraza.web.*" %>
<%@ page import="org.baraza.xml.BElement" %>

<%
	ServletContext context = getServletContext();
	String dbconfig = "java:/comp/env/jdbc/database";
	String xmlcnf = request.getParameter("xml");
	if(request.getParameter("logoff") == null) {
		if(xmlcnf == null) xmlcnf = (String)session.getAttribute("xmlcnf");
		if(xmlcnf == null) xmlcnf = context.getInitParameter("config_file");
		if(xmlcnf != null) session.setAttribute("xmlcnf", xmlcnf);
	}

	String ps = System.getProperty("file.separator");
	String xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlcnf;
	String reportPath = context.getRealPath("reports") + ps;

	String userIP = request.getRemoteAddr();
	String userName = request.getRemoteUser();

	BWeb web = new BWeb(dbconfig, xmlfile);
	web.setUser(userIP, userName);
	web.init(request);
	BElement root = web.getRoot();
%>

<%@ include file="/resources/include/init.jsp" %>

</head>

<body>

	<div id="pageoptions">
		<ul>
			<li><%= web.getEntityName() %> | </li>
			<li><a href="http://www.openbaraza.org" target='_blank'>Made On Baraza   | </a></li>
			<li><a href="http://www.dewcis.com" target='_blank'>Made by Dew CIS Solutions Ltd | </a></li>
			<li><a href="logout.jsp?logoff=yes">Logout  | </a></li>
		</ul>
	</div>

	<header>
		<div id="logo">
		</div>
		<div id="header">
		</div>
	</header>

	<nav>
		<div id="main-menu">
	           	<%= web.getMenu() %>

	            <div id="bottom"></div>
		</div>
	</nav>
	
	<section id="content">


	<form id="baraza" name="baraza" method="post" action="b_passwordchange.jsp">
	  <table width="300">
<% 
	String myoutput = "";
	if(request.getParameter("Update") != null) {
		String oldpassword = request.getParameter("oldpassword");
		String newpassword = request.getParameter("newpassword");
		String confpassword = request.getParameter("confpassword");

		if(newpassword == null) newpassword = "";
		if(!newpassword.equals(confpassword)) {
			myoutput = "<tr><td colspan='2'><b>The is a password mismatch beween the new and confirmed password.</b></td></tr>\n";
		} else {
			String fnct = root.getAttribute("password");
			String mysql = "SELECT " + fnct + "('" + web.getUserID() + "', '" + oldpassword + "','";
			mysql += newpassword + "')";
			myoutput = "<tr><td colspan='2'><b>" + web.executeFunction(mysql) + ".</b></td></tr>\n";
		}
	} 
%>
		<%= myoutput %>
		<tr><td>Old Password : </td><td><input type="password" name="oldpassword"><td></tr>
		<tr><td>New Password : </td><td><input type="password" name="newpassword"><td></tr>
		<tr><td>Confirm Passord : </td><td><input type="password" name="confpassword"><td></tr>
		<tr><td></td><td><input type="submit" name="Update" value="Update"/></td></tr>
	  </table>
	</form>

</section>
 
<%@ include file="/resources/include/footer.jsp" %>


