/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * SeperateSample.java
 * 2014年11月11日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */
package seperate;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

/**
 * 实现功能： Seperate samples into postive and negetive sampel
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年11月11日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class SeperateSample {
	// public final static String basePath
	// ="/host/kp/siat/KDD/ccf_contest/um/finalContest/";
	public final static String basePath = "/home/xqiu/kdd/final/";

	public static void seperateSample(String fileName) throws Exception {
		BufferedReader br = new BufferedReader(new FileReader(new File(basePath
				+ fileName)));
		BufferedWriter posWR = new BufferedWriter(new FileWriter(new File(
				basePath + fileName + "_pos")));
		BufferedWriter negWR = new BufferedWriter(new FileWriter(new File(
				basePath + fileName + "_neg")));

		String featuresRecord = "";
		String[] cols;
		int lastSepIndex = 0;
		String classIndex = "";
		boolean notStartLineFlag_pos = false;
		boolean notStartLineFlag_neg = false;
		while (br.ready()) {

			featuresRecord = br.readLine();
			lastSepIndex = featuresRecord.lastIndexOf(',');
			classIndex = featuresRecord.substring(lastSepIndex + 1,
					featuresRecord.length());

			if ("0".equals(classIndex)) {
				if (notStartLineFlag_neg) {
					negWR.newLine();
				} else {
					notStartLineFlag_neg = true;
				}
				negWR.write(featuresRecord);
			} else {
				if (notStartLineFlag_pos) {
					posWR.newLine();
				} else {
					notStartLineFlag_pos = true;
				}
				posWR.write(featuresRecord);
			}
		}

		br.close();
		posWR.close();
		negWR.close();
	}

	/**
	 * @param wr
	 * @param featuresRecord
	 * @param notStartLineFlag
	 * @return
	 * @throws IOException
	 */
	public static void writeToFile(BufferedWriter wr, String featuresRecord,
			Boolean notStartLineFlag) throws IOException {
		if (notStartLineFlag) {
			wr.newLine();
		} else {
			notStartLineFlag = true;
		}
		wr.write(featuresRecord);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		seperateSample("TrainingFeaturesWithPixel");
	}

}
