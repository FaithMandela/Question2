<%@ include file="/resources/include/init-login.jsp" %>
<%
	session.removeAttribute("xmlcnf");
%>

<body id="login"> 
<c:url var="url" value="/index.jsp"/>

<header>
	<div id="logo"></div>
</header>
<section id="content">
<form method="POST" action="j_security_check" id="loginform">
	<fieldset>
		<section>
			<a class="" href="application.jsp?view=1:0" style="color:#0088cc;">Register New Account</a> 
			<label for="username">Username</label>
			
			<div><input type="text" id="username" name="j_username" autofocus required></div>
			
		</section>
		<section>
			<a class="" href="application.jsp?view=2:0" style="color:#0088cc;">Recover Lost Password</a>
			<label for="password">Password</label>
		
			<div><input type="password" id="password" name="j_password" required></div>
		</section>
		<section>
			
			<div><button class="fr">Login</button></div>
		</section>
	</fieldset>
</form>
		
		
</section>

<%@ include file="/resources/include/footer.jsp" %>

