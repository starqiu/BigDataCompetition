/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * AddPixelToFeatures.java
 * 2014年10月26日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */
package feature;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.HashMap;

/**
 * 实现功能：add click rate into features
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月26日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class GetUserPixelFeatures {
	// public final static String basePath = "/host/kp/siat/KDD/ccf_contest/um/";
	public final static String basePath = "/home/xqiu/kdd/final/";
	public final static String DEFAULT_PIXEL_294 = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,";

	
	public static void getAllFeatureWithClassIdIntoFile(String path,
			String outPutPath, HashMap<String, String> userFeature,
			HashMap<String, String> pixelFeature,int classIndex) throws Exception {
		File inFile = new File(path);
		BufferedReader br = new BufferedReader(new FileReader(inFile));
		File outputFile = new File(outPutPath);
		if (!outputFile.exists()) {
			outputFile.createNewFile();
		}
		BufferedWriter bw = new BufferedWriter(new FileWriter(outputFile));

		String line = "";
		String[] cols;
		String userId = "";
		String pixelVal;
		boolean notStartLineFlag = false;
		while (br.ready()) {
			if (notStartLineFlag) {
				bw.newLine();
			} else {
				notStartLineFlag = true;
			}
			line = br.readLine();
			cols = line.split(",");
			userId = cols[0];
			pixelVal = pixelFeature.get(cols[3]);
			if (pixelVal == null) {
				System.out.println("Without Class index, image id   :"
						+ cols[3] + "   null pixel,image is not found");
				pixelVal = DEFAULT_PIXEL_294;
			}
			line = userFeature.get(userId) + "," + pixelVal+ cols[classIndex];
			// System.out.println(line);
			bw.write(line);
		}
		br.close();
		bw.close();
	}
	
	public static void getAllFeatureWithClassIdIntoFile4FinalContest(String path,
			String outPutPath, HashMap<String, String> userFeature,
			HashMap<String, String> pixelFeature) throws Exception {
		File inFile = new File(path);
		BufferedReader br = new BufferedReader(new FileReader(inFile));
		File outputFile = new File(outPutPath);
		if (!outputFile.exists()) {
			outputFile.createNewFile();
		}
		BufferedWriter bw = new BufferedWriter(new FileWriter(outputFile));
		
		String line = "";
		String[] cols;
		String userId = "";
		String pixelVal;
		boolean notStartLineFlag = false;
		while (br.ready()) {
			if (notStartLineFlag) {
				bw.newLine();
			} else {
				notStartLineFlag = true;
			}
			line = br.readLine();
			cols = line.split(",");
			userId = cols[0];
			pixelVal = pixelFeature.get(cols[3]);
			if (pixelVal == null) {
				System.out.println("Without Class index, image id   :"
						+ cols[3] + "   null pixel,image is not found");
				pixelVal = DEFAULT_PIXEL_294;
			}
			line = userFeature.get(userId) + "," + pixelVal.substring(0, pixelVal.lastIndexOf(','));
			// System.out.println(line);
			bw.write(line);
		}
		br.close();
		bw.close();
	}

	public static HashMap<String, String> readPixelIntoMap(String path,
			String sep) throws Exception {
		HashMap<String, String> pixel = new HashMap<>();
		BufferedReader br = new BufferedReader(new FileReader(new File(path)));
		String line = "";
		int firstSepIndex = -1;
		while (br.ready()) {
			line = br.readLine();
			firstSepIndex = line.indexOf(sep);
			pixel.put(line.substring(0, firstSepIndex),
					line.substring(firstSepIndex + 1, line.length()));
		}
		br.close();
		return pixel;
	}
	
	public static HashMap<String, String> readUserFeatureIntoMap(String path,
			String sep) throws Exception {
		HashMap<String, String> userFeature = new HashMap<>();
		BufferedReader br = new BufferedReader(new FileReader(new File(path)));
		String line = "";
		String[] cols;
		String featureStr = "";
		while (br.ready()) {
			line = br.readLine();
			cols = line.split(sep);

			// modify the sex field 2:female =>-1,\N:unknown=>0,1:male
			if ("2".equals(cols[1])) {
				cols[1] = "-1";
			} else if ("\\N".equals(cols[1])) {
				cols[1] = "0";
			}

			// modify the age field (\N:unknown=>0 ) and decrete it
			cols[2] = "\\N".equals(cols[2]) ? "0" : decreteAge(Integer
					.parseInt(cols[2]));
			/*
			 * if ("\\N".equals(cols[2])) { cols[2] = "0"; } else { cols[2] =
			 * decreteAge(Integer.parseInt(cols[2])); }
			 */

			// decrete Registration Age
			cols[3] = "\\N".equals(cols[3]) ? "0" : decreteRegistAge(Integer
					.parseInt(cols[3]));
			/*
			 * if ("\\N".equals(cols[3])) { cols[3] = "0"; }
			 */

			// modify the region field
			if ("\\N".equals(cols[4])) {
				cols[4] = "0";
			}

			featureStr = join(",", cols, 1);
			userFeature.put(cols[0], featureStr);
		}
		br.close();
		return userFeature;
	}

	public static String decreteAge(int age) {
		String result = "0";
		if (age >= 0 && age < 10) {
			result = "0";
		} else if (age >= 10 && age < 20) {
			result = "1";
		} else if (age >= 20 && age < 30) {
			result = "2";
		} else if (age >= 30 && age < 40) {
			result = "3";
		} else if (age >= 40 && age < 50) {
			result = "4";
		} else {
			result = "5";
		}

		return result;
	}

	public static String decreteRegistAge(int registAge) {
		String result = "0";
		if (registAge >= 0 && registAge < 1000) {
			result = "0";
		} else if (registAge >= 1000 && registAge < 2000) {
			result = "1";
		} else if (registAge >= 2000 && registAge < 3000) {
			result = "2";
		} else if (registAge >= 3000 && registAge < 4000) {
			result = "3";
		} else {
			result = "4";
		}

		return result;
	}
	
	public static String join(String delimiter, Object[] arr, int start) {
		StringBuffer sb = new StringBuffer();
		sb.append(arr[start]);
		int len = arr.length;
		for (int i = start + 1; i < len; i++) {
			sb.append(delimiter);
			sb.append(arr[i]);
		}
		return sb.toString();
	}
	
	public static void main(String[] args) throws Exception {

		// load pixel to map
		HashMap<String, String> pixelFeature = readPixelIntoMap(basePath
				+ "pixelFeature.txt", ",");
		HashMap<String, String> userFeature = readUserFeatureIntoMap(basePath
				+ "users.txt", ",");
		
		getAllFeatureWithClassIdIntoFile(basePath + "training.txt", basePath
				+ "TrainingFeaturesWithUserPixel", userFeature, pixelFeature,5);
		getAllFeatureWithClassIdIntoFile(basePath + "testing.txt", basePath
				+ "TestingFeaturesWithUserPixel", userFeature, pixelFeature,5);
		getAllFeatureWithClassIdIntoFile4FinalContest(basePath + "evaluation_for_contest.txt", basePath
				+ "FinalContestFeaturesWithUserPixel", userFeature, pixelFeature);

		/*
		 * //generate 294 zeros StringBuffer sb = new StringBuffer(); for (int i
		 * = 0; i < 294; i++) { sb.append("0,"); }
		 * System.out.println(sb.toString());
		 * System.out.println(DEFAULT_PIXEL_294.split(",").length);
		 */

	}

}
