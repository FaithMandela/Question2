package com.question;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Id;

public class Question implements Serializable {
	 @Id
	 private int id;
	 
	 @Column(name = "Question")
	 private String question;
	 
	 @Column(name = "Answer")
	 private String answer;
	 
	 public Question(String question,String answer, int id) {
		 this.question = question;
		 this.answer = answer;
		 this.id = id;
	 }
	 
	 public void setQuestion(String questions) {
		 this.question = question;
	 }
	 
	 public void setAnswer(String answer) {
		 this.answer = answer;
	 }
	 
	 public void setId(int id) {
		 this.id = id;
	 }
	 
	 public String getQuestion() {
		 return question;
	 }
	 
	 public String getAnswer() {
		 return answer;
	 }
	 
	 public int getId() {
		 return id;
	 }
	 
}
