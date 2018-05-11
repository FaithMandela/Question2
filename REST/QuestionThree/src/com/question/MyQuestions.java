package com.question;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.jws.WebMethod;
import javax.jws.WebService;
import javax.persistence.Entity;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

@WebService()
@Entity
@Path("/quiz")
public class MyQuestions {
	
	String details = ""; 
	String serverName = "localhost";
	String mydatabase = "questions";
	String url = "jdbc:mysql://" + serverName + "/" + mydatabase;
	
	String username = "root";
	String password = "";
	
	@GET
    @Path("/retrive")
	@Produces("text/html")
	@WebMethod(operationName = "retrive")
	
	
	//Retrieve questions and answers
	public String retrieve(int id) {
		 ResultSet rs = null;
		
		 
		 try {
			 Class.forName("com.mysql.jdbc.Driver");
			 Connection connection = DriverManager.getConnection(url, username, password);
			 
			 String query = "Select * from qanswers";
			 
			 PreparedStatement st = connection.prepareStatement(query);
	         rs = st.executeQuery();
	         
	         
	         while(rs.next()) {
	        	 details = "<html><body>";
		         details = details + "<form>";
		         details = details + "<label>"+rs.getInt(id)+"</label>";
		         details = details + "<input type = 'radio' >"+rs.getString("answer")+"</br>";
	         }
	         details += "</form></body></html>";
                
			 
		 }catch(Exception e) {
			 e.printStackTrace();
		 }
		 return details;
	}
	
	//Answer a question
	@POST
    @Path("/answer")
	@Produces("text/html")
	@WebMethod(operationName = "insert")
	public void answerQuestion(String answer) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection connection = DriverManager.getConnection(url, username, password);
			
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
}
