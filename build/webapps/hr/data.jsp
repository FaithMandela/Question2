<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>My First Grid</title>

<%@ page import="org.baraza.web.*" %>
<%
	ServletContext context = getServletContext();
	String xmlcnf = (String)session.getAttribute("xmlcnf");
	String ps = System.getProperty("file.separator");
	String xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlcnf;
	String reportPath = context.getRealPath("reports") + ps;
	String dbconfig = "java:/comp/env/jdbc/database";

	String userIP = request.getRemoteAddr();
	String userName = request.getRemoteUser();

	BWeb web = new BWeb(dbconfig, xmlfile);
	web.setUser(userIP, userName);
	web.init(request);

	String jshd = web.getJSONHeader();
%>

<link rel="stylesheet" type="text/css" media="screen" href="resources/themes/default/light/jquery-ui.css" />
<link rel="stylesheet" type="text/css" media="screen" href="resources/css/ui.jqgrid.css" />
 
<style type="text/css">
html, body {
    margin: 0;
    padding: 0;
    font-size: 75%;
}
</style>
 
<script src="resources/js/jquery-1.11.0.min.js" type="text/javascript"></script>
<script src="resources/js/grid.locale-en.js" type="text/javascript"></script>
<script src="resources/js/jquery.jqGrid.min.js" type="text/javascript"></script>
 
<script type="text/javascript">
$(function () {
    $("#list").jqGrid(<%= jshd %>); 
}); 
</script>
 
</head>
<body>
    <table id="list"><tr><td></td></tr></table> 
    <div id="pager"></div> 
</body>
</html>

