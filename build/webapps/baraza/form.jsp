<%@ page import="org.baraza.web.*" %>

<%
	String dbconfig = "java:/comp/env/jdbc/database";
	String entryformid = null;
	String action = request.getParameter("action");
	String value = request.getParameter("value");
	String post = request.getParameter("post");
	String process = request.getParameter("process");
	String reportexport = request.getParameter("reportexport");

	String contentType = request.getContentType();
	if (contentType != null) {
		if (contentType.indexOf("multipart/form-data") >= 0) {
			BForms uploadForms = new BForms(dbconfig);
			entryformid = uploadForms.uploadFile(request);
			uploadForms.close();

			action = "ENTRYFORM";
		}
	}

	BForms forms = new BForms(dbconfig);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ include file="resources/include/init.jsp" %>

<script type="text/javascript">

      $(document).ready(function(){

	    $('.btnAddMore').live('click',function(){

		var clonedRow = $(".subTable" + this.getAttribute("name") + " tr:last").clone().html();
		var appendRow = '<tr class = "row">' + clonedRow + '</tr>';

		$('.subTable' + this.getAttribute("name") + ' tr:last').after(appendRow);
		});

	    //when you click on the button called "delete", the function inside will be triggered.
	    $('.deleteThisRow').live('click',function(){

		var num = this.getAttribute("name");
		var rowLength = $('#subTable' + num + ' tr').length;


		//this line makes sure that we don't ever run out of rows.
		if(rowLength > 2){
		    deleteRow(this);
		    }
		else{
		    $('.subTable tr:last').after(appendRow);
		    deleteRow(this);
		    }
	      });

	function deleteRow(currentNode){
	      $(currentNode).parent().parent().remove();
	      }
	  });

</script>

<body>


<% if(action.equals("FORM")) { %>

	<div class="widget" id="form_widget">

		<FORM>
		<INPUT TYPE="button" onClick="window.print()" value="PRINT">
		</FORM>

		<div>
		    <%= forms.getForm(null, request.getParameterMap()) %>
		</div>
	</div>



<% } else if(action.equals("ENTRYFORM")) { %>
	<div id="content">
		<%= forms.getForm(entryformid, request.getParameterMap()) %>
	</div>

<% }

	forms.close();
%>

</body>
</html>
