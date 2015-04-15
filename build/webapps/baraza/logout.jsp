<%@ include file="/resources/include/init.jsp" %>

<%
	session.removeAttribute("xmlcnf");
	session.invalidate();
%>

<body>

	<div id="pageoptions">
		<ul>
			<li><a href="index.jsp">Home</a></li>
			<li><a href="register.jsp">Register</a></li>
			<li><a href="dashboard.jsp">My Account</a></li>
		</ul>
	</div>

	<header>
		<div id="logo">
		</div>
		<div id="header">
		</div>
	</header>
	
	<c:url var="url" value="/index.jsp"/>
		
	<div class="alert warning">You are logged out</div>
	<div class="g12">
		<p>Please enter a user name or password that is authorized to access this application</p>
		<a class="btn i_refresh_4 icon" href="index.jsp">Login</a>
		<a class="btn i_key icon" href="application.jsp?view=2:0">Recover Lost Password</a>
		<a class="btn i_user icon" href="application.jsp?view=1:0">Register New Account</a>
	</div>
    
<%@ include file="/resources/include/footer.jsp" %>


