package org.test;

import java.net.MalformedURLException;
import java.net.URL;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;

import org.test.HelloService;

public class Hello {
	public static void main(String[] args) {
		try {
			URL wsdlUrl = new URL("http://saf.ngrok.io/TestWebService/TestWS?wsdl");
			QName qname = new QName("http://ws.psd.safaricom.com/", "TestWS");
			Service service = Service.create(wsdlUrl, qname);
			HelloService helloService = service.getPort(HelloService.class);
			
			System.out.println(helloService.hello("Wakanda"));
			System.out.println(helloService.hello("Arsenal"));
			System.out.println(helloService.hello("SGR"));
			System.out.println(helloService.hello("Sudan"));
			System.out.println(helloService.hello("Safaricom"));
			
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
