
import helloservice.*;
import javax.xml.ws.WebServiceRef;

public class wsdlTest1 {

	@WebServiceRef(wsdlLocation = "http://localhost:8080/test1/HelloService?wsdl")
	private static HelloService service;

	public static void main(String args[]) {

		Hello port = HelloService.getHelloPort();
		String sh = port.sayHello("Dennis");

		System.out.println("Finished excecution : " + sh);
	}

}
