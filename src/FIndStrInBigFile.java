/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * FIndStrInBigFile.java
 * 2014年11月15日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;

/**
 * 实现功能：
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年11月15日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class FIndStrInBigFile {
	
	public final static String basePath = "/home/xqiu/kdd/final/";

	public static void findTextInBigFile(String filePath,String str) throws Exception {
		File inFile = new File(filePath);
		BufferedReader br = new BufferedReader(new FileReader(inFile));

		String line = "";
		while (br.ready()) {
			line = br.readLine();
			if (line.indexOf(str) !=-1) {
				// System.out.println(line);
			};
		}
		br.close();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args)  throws Exception{
		findTextInBigFile(basePath+"TrainingFeaturesWithUserPicWord_pos","NAN");
	}

}
