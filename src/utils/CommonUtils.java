/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * CommonUtils.java
 * 2014年10月9日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */
package utils;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Properties;

/**
 * 实现功能：
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月9日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class CommonUtils {

	public static String getValueByKeyFromConfig(String key) {
		Properties prop = new Properties();
		String propFileName = "config.properties";

		InputStream inputStream = CommonUtils.class.getClassLoader()
				.getResourceAsStream(propFileName);
		try {
			prop.load(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (inputStream == null) {
			System.err.println("property file '" + propFileName
					+ "' not found in the classpath");
			return null;
		}
		return prop.getProperty(key);
	}

	public static void replaceTextInBigFile(String filePath,
			String outputFilePath, char oldChar, char newChar) throws Exception {
		File inFile = new File(filePath);
		BufferedReader br = new BufferedReader(new FileReader(
				inFile));
		File outputFile = new File(outputFilePath);
		if (!outputFile.exists()) {
			outputFile.createNewFile();
		}
		BufferedWriter bw = new BufferedWriter(new FileWriter(
				outputFile));

		String line = "";
		boolean notStartLineFlag = false;
		while ( br.ready()) {
			if (notStartLineFlag) {
				bw.newLine();
			}
			line = br.readLine();
			line = line.replace(oldChar, newChar);
//			System.out.println(line);
			bw.write(line);
			notStartLineFlag = true;
		}
		br.close();
		bw.close();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		String filePath  = "/host/kp/siat/KDD/ccf_contest/user_matrix/usr_ads";
		String outputFilePath  = "/host/kp/siat/KDD/ccf_contest/user_matrix/usr_ads1";
		replaceTextInBigFile(filePath, outputFilePath, '_', '\t');
	}

}
