
import java.util.Base64;
import java.io.IOException;

import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class BMPesa {
	
	public static void main(String[] args) {
		BMPesa mpesa = new BMPesa();
		mpesa.authenticate("", "");
	}

	public String authenticate(String app_key, String app_secret) {
		String token = null;
		String appKeySecret = app_key + ":" + app_secret;
		byte[] bytes = appKeySecret.getBytes("ISO-8859-1");
		String encoded = Base64.getEncoder().encodeToString(bytes);

		OkHttpClient client = new OkHttpClient();

		Request request = new Request.Builder()
			.url("https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials")
			.get()
			.addHeader("authorization", "Basic " + encoded)
			.addHeader("cache-control", "no-cache")
			.build();

		try {
			Response response = client.newCall(request).execute();
		} catch(IOException ex) {
			System.out.println("IO Error");
		}

		return token;
	}
}
