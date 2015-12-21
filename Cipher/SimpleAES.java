// Java Example for Communication with SimpleAES

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.CipherOutputStream;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.bind.DatatypeConverter;

public class SimpleAES {

	// Beispiel
	public static void main(String[] args) throws Exception {
		String password = "MyPassword123";

		MessageDigest md = MessageDigest.getInstance("MD5");
		byte[] key = md.digest(password.getBytes("UTF8"));

		String sourceString = "Hallo, dies ist ein Test des SimpleAES Moduls für Strings.";
		System.out.println(sourceString);
		String encodedString = CryptString(key, Cipher.ENCRYPT_MODE, sourceString, null, null);
		System.out.println(encodedString);
		String decodedString = CryptString(key, Cipher.DECRYPT_MODE, encodedString, null, null);
		System.out.println(decodedString);
	}

	public static class SimpleAESConfig {
		public int bits = 128;
		public String cipherMode = "CBC";
		public String padding = "PKCS5Padding";
	}

	public static Cipher getCipher(byte[] key, int mode, byte[] iv, SimpleAESConfig options) {
		if (options == null) {
			options = new SimpleAESConfig();
		}
		try {
			key = Arrays.copyOfRange(key, 0, options.bits / 8);
			Cipher cipher = Cipher.getInstance("AES/" + options.cipherMode + "/" + options.padding);
			cipher.init(mode, new SecretKeySpec(key, "AES"), new IvParameterSpec(iv));
			return cipher;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static byte[] CryptMemory(byte[] key, int mode, byte[] data, SimpleAESConfig options) {
		try {
			if (mode == Cipher.ENCRYPT_MODE) {
				byte[] iv = new SecureRandom().generateSeed(16);
				Cipher cipher = getCipher(key, mode, iv, options);
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				baos.write(iv);
				baos.write(cipher.doFinal(data));
				return baos.toByteArray();
			}
			if (mode == Cipher.DECRYPT_MODE) {
				Cipher cipher = getCipher(key, mode, Arrays.copyOfRange(data, 0, 16), options);
				return cipher.doFinal(Arrays.copyOfRange(data, 16, data.length));
			}
		} catch (IllegalBlockSizeException | BadPaddingException | IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static String CryptString(byte[] key, int mode, String string, String type, SimpleAESConfig options) {
		if (type == null) {
			type = "UTF8";
		}
		try {
			if (mode == Cipher.ENCRYPT_MODE) {
				return Base64Encoder(CryptMemory(key, mode, string.getBytes(type), options));
			}
			if (mode == Cipher.DECRYPT_MODE) {
				return new String(CryptMemory(key, mode, Base64Decoder(string), options), type);
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return null;
	}

	public static void CryptFile(byte[] key, int mode, File sourceFile, File newFile, SimpleAESConfig options) throws IOException {
		if (!newFile.exists()) {
			try {
				newFile.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		try (FileOutputStream fos = new FileOutputStream(newFile); FileInputStream fis = new FileInputStream(sourceFile);) {
			BufferedOutputStream bos = null;
			BufferedInputStream bis = null;
			try {
				if (mode == Cipher.ENCRYPT_MODE) {
					byte[] iv = new SecureRandom().generateSeed(16);
					fos.write(iv);
					Cipher cipher = getCipher(key, mode, iv, options);
					bos = new BufferedOutputStream(new CipherOutputStream(fos, cipher));
					bis = new BufferedInputStream(new FileInputStream(sourceFile));
				}
				if (mode == Cipher.DECRYPT_MODE) {
					byte[] iv = new byte[16];
					fis.read(iv);
					Cipher cipher = getCipher(key, mode, iv, options);
					bos = new BufferedOutputStream(new FileOutputStream(newFile));
					bis = new BufferedInputStream(new CipherInputStream(fis, cipher));
				}
				byte[] buffer = new byte[1024];
				int length;
				while ((length = bis.read(buffer)) > 0) {
					bos.write(buffer, 0, length);
				}
			} finally {
				if (bis != null) {
					bis.close();
				}
				if (bos != null) {
					bos.close();
				}
			}
		}
	}

	public static String Base64Encoder(byte[] data) {
		return DatatypeConverter.printBase64Binary(data);
	}

	public static byte[] Base64Decoder(String base64String) {
		return DatatypeConverter.parseBase64Binary(base64String);
	}

}