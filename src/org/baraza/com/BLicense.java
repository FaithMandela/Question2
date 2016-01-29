/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.com;

import java.security.MessageDigest;
import java.security.PublicKey;
import java.security.PrivateKey;
import java.security.KeyPair;
import java.security.SecureRandom;
import java.security.KeyPairGenerator;
import java.security.Signature;
import java.security.KeyFactory;
import java.security.spec.X509EncodedKeySpec;
import org.apache.commons.codec.binary.Base64;

import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.SignatureException;
import java.security.InvalidKeyException;
import java.security.spec.InvalidKeySpecException;
import java.io.UnsupportedEncodingException;


public class BLicense {

	KeyPair keyPair;

	public static void main(String args[]) {
	
		BLicense lic = new BLicense();
		lic.encript("dennis sdaf dsfsa dsaf dsaf df dsa fdsf dsf dsf sfd as sdf sdf fsdaf d df fsdf dsf dsf ", "salt");
		KeyPair kpl = lic.generateKey();
		byte[] signedData = lic.signData(kpl, "my data");
		
		boolean signed = lic.verifyData(kpl.getPublic().getEncoded(), signedData, "my data  ");
	}

	public BLicense() {
		keyPair = generateKey();
	}
	
	/**
	* Run the application - desktop mode
	* Use {@link #createLicense(String, String, String, String)} 
	* 
	* @param holder This String field can hold the holder's name, common name (cname)	
	* @param productKey - This String field can hold a product key, serial number, serial code or any other String-representable data necessary for identifying this license.
	* @param MachineID - This String field can hold the machine X500Principal identification, UUID, Mac address, hardware ID, or any other String-representable data necessary for identifying this license.
	* @param databaseID - This field holds the ID for the database
	*/
	public byte[] createLicense(String holder, String productKey, String MachineID, String databaseID) {
		String licData = holder + "\n" + productKey  + "\n" + MachineID + "\n" + databaseID;
		byte[] signedData = signData(keyPair, licData);
		
		return signedData;
	}
	
	public boolean verifyLicense(String holder, String productKey, String MachineID, String databaseID, byte[] signedData, byte[] publicKey) {
		String licData = holder + "\n" + productKey  + "\n" + MachineID + "\n" + databaseID;
	
		boolean signed = verifyData(publicKey, signedData, licData);
		
		return signed;
	}
	
	public byte[] getPublicKey() {
		return keyPair.getPublic().getEncoded();
	}
	
	private KeyPair generateKey() {
		KeyPair pair = null;

		try {
			SecureRandom random = SecureRandom.getInstance("SHA1PRNG", "SUN");
			KeyPairGenerator keyGen = KeyPairGenerator.getInstance("DSA", "SUN");		
			keyGen.initialize(1024, random);
			
			pair = keyGen.generateKeyPair();
			PublicKey pub = pair.getPublic();			
			PrivateKey priv = pair.getPrivate();
			
			System.out.println("BASE 10 : " + priv);
			System.out.println("BASE 20 : " + pub);
		} catch(NoSuchAlgorithmException ex) {
			System.out.println("Public key generation error : " + ex);
		} catch(NoSuchProviderException ex) {
			System.out.println("Public key generation error : " + ex);
		}
		
		return pair;
	}
	
	private byte[] signData(KeyPair pair, String data) {
		try {
			Signature dsa = Signature.getInstance("SHA1withDSA", "SUN"); 
			dsa.initSign(pair.getPrivate());
			dsa.update(data.getBytes("UTF-8"));
			byte[] realSig = dsa.sign();
			return realSig;
		} catch(NoSuchAlgorithmException ex) {
			System.out.println("No algorithim : " + ex.getMessage());
		} catch(UnsupportedEncodingException ex) {
			System.out.println("Unsupported Encoding : " + ex.getMessage());
		} catch(NoSuchProviderException ex) {
			System.out.println("Public key generation error : " + ex);
		} catch(SignatureException ex) {
			System.out.println("Public key generation error : " + ex);
		} catch(InvalidKeyException ex) {
			System.out.println("Public key generation error : " + ex);
		}
		
		return null;
	}
	
	private boolean verifyData(byte[] publicKey, byte[] signedData, String data) {
		boolean signed = false;
		
		try {
			X509EncodedKeySpec pubKeySpec = new X509EncodedKeySpec(publicKey);
			KeyFactory keyFactory = KeyFactory.getInstance("DSA", "SUN");
			PublicKey pubKey = keyFactory.generatePublic(pubKeySpec);
			Signature sig = Signature.getInstance("SHA1withDSA", "SUN");
			sig.initVerify(pubKey);
			sig.update(data.getBytes("UTF-8"));
			signed = sig.verify(signedData);

			System.out.println("signature verifies: " + signed);
		} catch(NoSuchAlgorithmException ex) {
			System.out.println("No algorithim : " + ex.getMessage());
		} catch(UnsupportedEncodingException ex) {
			System.out.println("Unsupported Encoding : " + ex.getMessage());
		} catch(SignatureException ex) {
			System.out.println("Public key generation error : " + ex);
		} catch(NoSuchProviderException ex) {
			System.out.println("Public key generation error : " + ex);
		} catch(InvalidKeyException ex) {
			System.out.println("Public key generation error : " + ex);
		} catch(InvalidKeySpecException ex) {
			System.out.println("Public key generation error : " + ex);
		}
		
		return signed;
	}

	
	public String encript(String input, String salt) {
		if((input == null) || (salt == null)) return null;
		String hash = null;
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-512"); 	// SHA-512 generator instance
			md.update(salt.getBytes("UTF-8"));							// Update the salt
			byte raw[] = md.digest(input.getBytes("UTF-8"));			// Digest the message
			
			Base64 coder = new Base64(32);
			hash = new String(coder.encode(raw));	 					// Encoding to BASE64
			hash = hash.replace("\n", "");
		} catch(NoSuchAlgorithmException ex) {
			System.out.println("No algorithim : " + ex.getMessage());
		} catch(UnsupportedEncodingException ex) {
			System.out.println("Unsupported Encoding : " + ex.getMessage());
		}
		
		System.out.println("Hash : " + hash);
		
		return hash;
	}
	
}
