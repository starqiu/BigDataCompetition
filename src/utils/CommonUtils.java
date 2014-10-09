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

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * 实现功能： 
 * <p>
 * date	        author            email		           notes<br />
 * ----------------------------------------------------------------<br />
 *2014年10月9日        邱星         starqiu@mail.ustc.edu.cn	    新建类<br /></p>
 *
 */
public class CommonUtils {
	
	public static String getValueByKeyFromConfig(String key) {
		Properties prop = new Properties();
		String propFileName = "config.properties";
 
		InputStream inputStream = CommonUtils.class.getClassLoader().getResourceAsStream(propFileName);
		try {
			prop.load(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (inputStream == null) {
			System.err.println("property file '" + propFileName + "' not found in the classpath");
			return null;
		}
		return prop.getProperty(key);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		System.out.println(getValueByKeyFromConfig("consumers.path"));
	}

}

