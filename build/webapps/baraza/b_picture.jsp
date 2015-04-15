<%@ page import="org.baraza.web.*" %>

<%
	ServletContext context = getServletContext();
	String dbconfig = "java:/comp/env/jdbc/database";
	String ps = System.getProperty("file.separator");

	String title = context.getInitParameter("web_title");
	String xmlcnf = (String)session.getAttribute("xmlcnf");
	String xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlcnf;

	String userIP = request.getRemoteAddr();
	String userName = request.getRemoteUser();

	BWeb web = new BWeb(dbconfig, xmlfile);
	web.setUser(userIP, userName);
	web.init(request);

	String pictureFile = null;
	String field = request.getParameter("field");
	String upload = request.getParameter("upload");
	String contentType = request.getContentType();
	if (contentType != null) {
		if (contentType.indexOf("multipart/form-data") >= 0) {
			pictureFile = web.receivePhoto(request);
System.out.println("BASE 4040 : " + pictureFile);
		}
	}
%>


<%@ include file="/resources/include/init.jsp" %>

	<script type="text/javascript">

		function updateForm() {

			opener.document.baraza.<%= web.getPictureField() %>.value = '<%= pictureFile %>';

			self.close();

			return false;
		}
	</script>

</head>
<body>

<%	if(pictureFile == null) { %>
		<div class='configuration k-widget k-header' style='width: 500px'>
			<h2>Upload your picture</h2>
			<form id="baraza" name="baraza" method="post" enctype="multipart/form-data" action="b_picture.jsp">
					<input type='hidden' name='field' value='<%= field %>'/>
					<div><input name="picture" id="picture" type="file"/></div>
					<p><input type="submit" name="upload" value="Submit" class="k-button"/></p>
			</form>
		</div>
<% } else { %>
		<div class='configuration k-widget k-header' style='width: 500px'>
			<p><input type="button" name="updateform" value="update" onClick="updateForm()" class="k-button"/></p>
			<%= web.getPictureURL() %>
		</div>
<% } %>

</body>
</html>

<% 	web.close(); %>

