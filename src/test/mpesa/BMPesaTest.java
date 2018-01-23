
import java.util.concurrent.TimeUnit;
import java.util.Base64;
import java.util.Iterator;
import java.io.IOException;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.BorderLayout;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JLabel;
import javax.swing.JButton;
import javax.swing.JTextField;

import org.json.JSONObject;
import org.json.JSONException;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class BMPesaTest implements ActionListener {

	String auth = null;
	
	public static void main(String[] args) {
		BMPesaTest mpesaTest = new BMPesaTest();
	}
	
	
	public BMPesaTest() {
		auth = authenticate("r1renXMh8prPMjoooC2c3TAwQjG6z1va", "Hp6MN1RX8Bvc7vGI");
		
		JPanel headerPanel = new JPanel();
		JPanel bodyPanel = new JPanel();
		
		JFrame frame = new JFrame("FrameDemo");
		frame.getContentPane().add(headerPanel, BorderLayout.PAGE_START);
		frame.getContentPane().add(bodyPanel, BorderLayout.CENTER);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(1100, 800);
		frame.setVisible(true);
	}

	public String authenticate(String app_key, String app_secret) {
		String auth = null;
		try {
			String appKeySecret = app_key + ":" + app_secret;
			byte[] byteData = appKeySecret.getBytes("ISO-8859-1");
			String encoded = Base64.getEncoder().encodeToString(byteData);

			OkHttpClient client = new OkHttpClient();
			Request request = new Request.Builder()
				.url("https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials")
				.get()
				.addHeader("authorization", "Basic " + encoded)
				.addHeader("cache-control", "no-cache")
				.build();
			Response response = client.newCall(request).execute();
			
			String rBody = response.body().string();
			System.out.println("BASE 1010 : " + rBody);

			JSONObject jObject = new JSONObject(rBody);
			auth = jObject.getString("access_token");

			System.out.println("access_token : " + auth);
		} catch(IOException ex) {
			System.out.println("IO Error : " + ex);
		} catch(JSONException ex) {
			System.out.println("JSON Error : " + ex);
		}

		return auth;
	}
	
	
	public String testTransaction(String auth, String shortCode, String commandID, String amount, String MSISDN, String billRefNumber) {
		String resp = null;
		
		try {
			JSONObject jObject = new JSONObject();
			jObject.put("ShortCode", shortCode);
			jObject.put("CommandID", commandID);
			jObject.put("Amount", amount);
			jObject.put("Msisdn", MSISDN);
			jObject.put("BillRefNumber", billRefNumber);
			
System.out.println("BASE 2010 : " + jObject.toString());
			
			//OkHttpClient client = new OkHttpClient();
			OkHttpClient client = new OkHttpClient.Builder()
				.connectTimeout(20, TimeUnit.SECONDS)
				.writeTimeout(20, TimeUnit.SECONDS)
				.readTimeout(30, TimeUnit.SECONDS)
				.build();
			
			MediaType mediaType = MediaType.parse("application/json");
			RequestBody body = RequestBody.create(mediaType, jObject.toString());
			Request request = new Request.Builder()
				.url("https://sandbox.safaricom.co.ke/mpesa/c2b/v1/simulate")
				.post(body)
				.addHeader("authorization", "Bearer " + auth)
				.addHeader("content-type", "application/json")
				.build();
			Response response = client.newCall(request).execute();
						
System.out.println(response.body().string());
		} catch(IOException ex) {
			System.out.println("IO Error : " + ex);
		} catch(JSONException ex) {
			System.out.println("JSON Error : " + ex);
		}

		return resp;
	}
	
	public void actionPerformed(ActionEvent ev) {
		System.out.println("BASE click : " + ev.getActionCommand());	
	
		if(ev.getActionCommand().equals("Test")) {
			String resp = testTransaction(auth, "600617", "CustomerPayBillOnline", "123", "254708374149", "ESL");
		}
	}

}
