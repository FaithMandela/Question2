
import java.util.Base64;
import java.util.Iterator;
import java.io.IOException;

import org.json.JSONObject;
import org.json.JSONException;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class BMPesa {
	
	public static void main(String[] args) {
		BMPesa mpesa = new BMPesa();
		
		String validationURL = "http://62.24.122.19:9090/mpesa/validation";
		String confirmationURL =  "http://62.24.122.19:9090/mpesa/confirmation";
		String auth = mpesa.authenticate("r1renXMh8prPMjoooC2c3TAwQjG6z1va", "Hp6MN1RX8Bvc7vGI");
		String resp = mpesa.registerURL(auth, "600617", validationURL, confirmationURL);
		resp = mpesa.testTransaction(auth, "600617", "CustomerPayBillOnline", "100", "254708374149","xyz");
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

			JSONObject jObject = new JSONObject(response.body().string());
			auth = jObject.getString("access_token");

			System.out.println("access_token : " + auth);
		} catch(IOException ex) {
			System.out.println("IO Error");
		} catch(JSONException ex) {
			System.out.println("JSON Error");
		}

		return auth;
	}
	
	public String registerURL(String auth, String shortCode, String validationURL, String confirmationURL) {
		String resp = null;
		
		try {
			JSONObject jObject = new JSONObject();
			jObject.put("ShortCode", shortCode);
			jObject.put("ResponseType", "Completed");
			jObject.put("ValidationURL", validationURL);
			jObject.put("ConfirmationURL", confirmationURL);
			
System.out.println("BASE 2010 : " + jObject.toString());
			
			OkHttpClient client = new OkHttpClient();
			MediaType mediaType = MediaType.parse("application/json");
			RequestBody body = RequestBody.create(mediaType, jObject.toString());
			Request request = new Request.Builder()
				.url("https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl")
				.post(body)
				.addHeader("authorization", "Bearer " + auth)
				.addHeader("content-type", "application/json")
				.build();
			Response response = client.newCall(request).execute();
			
System.out.println(response.body().string());
		} catch(IOException ex) {
			System.out.println("IO Error");
		} catch(JSONException ex) {
			System.out.println("JSON Error");
		}

		return resp;
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
			
			OkHttpClient client = new OkHttpClient();
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
			System.out.println("IO Error");
		} catch(JSONException ex) {
			System.out.println("JSON Error");
		}

		return resp;
	}

}
