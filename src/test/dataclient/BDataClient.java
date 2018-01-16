import java.util.concurrent.TimeUnit;
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

public class BDataClient {

	public static void main(String args[]) {

		String myURL = "http://localhost:9090/hr/dataserver";
		
		BDataClient dataClient = new BDataClient();
		String auth = dataClient.authenticate(myURL, "r1renXMh8prPMjoooC2c3TAwQjG6z1va", "Hp6MN1RX8Bvc7vGI");

	}

	public String authenticate(String myURL, String app_key, String app_secret) {
		String auth = null;
		try {
			String appKeySecret = app_key + ":" + app_secret;
			byte[] byteData = appKeySecret.getBytes("ISO-8859-1");
			String encoded = Base64.getEncoder().encodeToString(byteData);
System.out.println("BASE 1010 : " + encoded);

			OkHttpClient client = new OkHttpClient();
			Request request = new Request.Builder()
				.url(myURL + "?grant_type=client_credentials")
				.get()
				.addHeader("authorization", "Basic " + encoded)
				.addHeader("cache-control", "no-cache")
				.build();
			Response response = client.newCall(request).execute();
			
			String rBody = response.body().string();
System.out.println("BASE 1040 : " + rBody);

		} catch(IOException ex) {
			System.out.println("IO Error : " + ex);
		}

		return auth;
	}
	
	public String sendData(String myURL, String auth, String data) {
		String resp = null;
		
		try {			
System.out.println("BASE 2010 : " + data);
			
			OkHttpClient client = new OkHttpClient();
			MediaType mediaType = MediaType.parse("application/json");
			RequestBody body = RequestBody.create(mediaType, data);
			Request request = new Request.Builder()
				.url(myURL + "?type=datain")
				.post(body)
				.addHeader("authorization", "Bearer " + auth)
				.addHeader("content-type", "application/json")
				.build();
			Response response = client.newCall(request).execute();
			
System.out.println(response.body().string());
		} catch(IOException ex) {
			System.out.println("IO Error : " + ex);
		}

		return resp;
	}

}


