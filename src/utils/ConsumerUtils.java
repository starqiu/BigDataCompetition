/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * ConsumerUtils.java
 * 2014年10月8日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */
package utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 实现功能： 
 * <p>
 * date	        author            email		           notes<br />
 * ----------------------------------------------------------------<br />
 *2014年10月8日        邱星         starqiu@mail.ustc.edu.cn	    新建类<br /></p>
 *
 */
public class ConsumerUtils {
	
	public static ConcurrentHashMap<String, String>  getConsumerIdAndDatesMap(String filePath) throws IOException{
		ConcurrentHashMap<String, String> idAndDates = new ConcurrentHashMap<String, String>();
		BufferedReader br = new BufferedReader(new FileReader(new File(filePath)));
		String[] line;
		while(br.ready()){
			line = br.readLine().split("\t");
			idAndDates.put(line[0]	, line[1]);
		}
		return idAndDates;
	}

	/**
	 * @param args
	 */
	/*public static void main(String[] args) {
		try {
			ConcurrentHashMap<String, String> idAndDates  = getConsumerIdAndDatesMap("/home/starqiu/data/consumers");
			System.out.println("hhehh");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}*/

}

