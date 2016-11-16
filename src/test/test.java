import java.net.*;
import java.io.*;

public class test {

	public static void main(String args[]) {

		try {
			URL aURL = new URL("https://www.etranzact.net/WebConnectPlus/query.jsp?TERMINAL_ID=0690000082&TRANSDATE=2016-11-16&TRANSDESC=186278;Pay;2016/2017.1;SUDEJO0001&TRANSACTION_ID=DEFAULT");

			System.out.println("protocol = " + aURL.getProtocol());
			System.out.println("authority = " + aURL.getAuthority());
			System.out.println("host = " + aURL.getHost());
			System.out.println("port = " + aURL.getPort());
			System.out.println("path = " + aURL.getPath());
			System.out.println("query = " + aURL.getQuery());
			System.out.println("filename = " + aURL.getFile());
			System.out.println("ref = " + aURL.getRef());

			BufferedReader in = new BufferedReader(new InputStreamReader(aURL.openStream()));

			String inputLine;
			while ((inputLine = in.readLine()) != null)
				System.out.println(inputLine);
			in.close();
		} catch(MalformedURLException ex) {
			System.out.println("Malformed URL Exception : " + ex);
		} catch(IOException ex) {
			System.out.println("IO Exception : " + ex);
		}

		System.out.println("Exiting Test mode");
	}
}


