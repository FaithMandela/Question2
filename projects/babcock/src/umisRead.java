

import java.net.URL;
import java.net.MalformedURLException;
import org.baraza.web.BWebServiceService;
import org.baraza.web.BWebService;

public class umisRead {

	public static void main(String args[]) {
	
		try {
	
			URL wsURL = new URL("http://demo.dewcis.com/babcock/webservice?wsdl");
		
			BWebServiceService bws = new BWebServiceService(wsURL);
			BWebService port = bws.getBWebServicePort();
			
			String resp = port.getWsData(getStudentRequest("06/0382"), "test123");
			System.out.println("Reading student data: \n" + resp);
						
			resp = port.getWsData(getTimeTableRequest("06/0382"), "test123");
			System.out.println("Reading timetable data: \n" + resp);
			
			resp = port.getWsData(getGradeRequest("06/0382", "2009/2010.3"), "test123");
			System.out.println("Reading student data: \n" + resp);
						
		} catch (MalformedURLException ex) {
			System.out.println("URL access error : " + ex);
		}
	}
	
	private static String getFoodService(String studentId) {	
		String xml = "<QUERY>\n";
		xml += "<GRID name=\"Food Service\" keyfield=\"studentid\" table=\"ws_food_service\" where=\"studentid = '" + studentId + "'\">\n";
		xml += "	<TEXTFIELD>studentid</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>studentname</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>mealtype</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>studylevel</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>majorid</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>majorname</TEXTFIELD>\n";
		xml += "</GRID>\n";
		xml += "</QUERY>\n";
		
		return xml;
	}
	
	private static String getStudentRequest(String studentId) {	
		String xml = "<QUERY>\n";
		xml += "<GRID name=\"student\" keyfield=\"studentid\" table=\"ws_students\" where=\"studentid = '" + studentId + "'\">\n";
		xml += "	<TEXTFIELD>studentid</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>firstname</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>othernames</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>surname</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>birthdate</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>mobile</TEXTFIELD>\n";
		xml += "	<TEXTFIELD>email</TEXTFIELD>\n";
		xml += "</GRID>\n";
		xml += "</QUERY>\n";
		
		return xml;
	}
	
	private static String getTimeTableRequest(String studentId) {	
		String xml = "<QUERY>\n";
		xml += "<GRID name=\"Timetable\" table=\"ws_student_timetable\" where=\"studentid = '" + studentId + "'\">\n";
		xml += "		<TEXTFIELD>starttime</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>endtime</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>cmonday</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>ctuesday</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>cwednesday</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>cthursday</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>cfriday</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>csunday</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>lab</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>lab</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>courseid</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>coursetitle</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>instructorname</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>classoption</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>assetname</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>location</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>building</TEXTFIELD>\n";
		xml += "	</GRID>\n";
		xml += "</QUERY>\n";
		
		return xml;
	}
	
	private static String getGradeRequest(String studentId, String semsterId) {	
		String xml = "<QUERY>\n";
		xml += "	<GRID name=\"Grades\" keyfield=\"qstudentid\" table=\"ws_student_grades\" ";
		xml += "where=\"(studentid = '" + studentId + "') AND (quarterid = '" + semsterId + "')\">\n";
		xml += "		<TEXTFIELD>quarterid</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>StudyLevel</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>credit</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>gpa</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>cummcredit</TEXTFIELD>\n";
		xml += "		<TEXTFIELD>cummgpa</TEXTFIELD>\n";
		xml += "	</GRID>\n";
		xml += "</QUERY>\n";
		
		return xml;
	}

}


