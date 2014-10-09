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
import java.util.HashMap;
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
	
	public static int  validatePositiveAndNegativeSamples(String consumersFilePath,String posFilePath,String negFilePath) throws IOException{
		BufferedReader consumersBr = new BufferedReader(new FileReader(new File(consumersFilePath)));
		BufferedReader posBr = new BufferedReader(new FileReader(new File(posFilePath)));
		BufferedReader negBr = new BufferedReader(new FileReader(new File(negFilePath)));
		HashMap<String, String> consumers = new HashMap<String, String>();
		String[] line;
		while(consumersBr.ready()){
			line = consumersBr.readLine().split("\t");
			consumers.put(line[0]	, line[1]);
		}
		
		while(posBr.ready()){
			line = posBr.readLine().split("\t");
			if (!consumers.containsKey(line[0])) {
				System.err.println("positive sample is not pure!");
				return 1;
			}
		}
		while(negBr.ready()){
			line = negBr.readLine().split("\t");
			if (consumers.containsKey(line[0])) {
				System.err.println("negative sample is not pure!");
				return 1;
			}
		}
		System.out.println("the samples seperate correctly!");
		return 0;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		validatePositiveAndNegativeSamples("/home/starqiu/data/consumers","/home/starqiu/data/posSmpl/part-r-00000","/home/starqiu/data/negSmpl/part-r-00000");
	}

}

