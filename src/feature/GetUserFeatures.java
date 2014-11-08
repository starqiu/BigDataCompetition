/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * GetUserFeatures.java
 * 2014年10月23日
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
 * 实现功能：
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月23日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class GetUserFeatures {

//	public final static String basePath = "/host/kp/siat/KDD/ccf_contest/um/";
	public final static String basePath = "/home/xqiu/kdd/data/";
	public final static int FEATURE_LENGTH = 25;
	public final static int IMP_WEIGHT = 1;
	public final static int CLK_WEIGHT = 1;

	// 用户年龄(Age）
	public final static int MAX_AGE = 70;
	public final static int MIN_AGE = 1;
	public final static float MEAN_AGE = 26.5f;
	public final static int AGE_RANGE = MAX_AGE - MIN_AGE;

	// 用户从注册至今的时长(Registration Age）
	public final static int MAX_REG_AGE = 5295;
	public final static int MIN_REG_AGE = 2;
	public final static int REG_AGE_RANGE = MAX_REG_AGE - MIN_REG_AGE;

	public final static String STR_WITH_25_ZEROS = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0";

	public static HashMap<String, String> readAdFeatureIntoMap(String path,
			String sep) throws Exception {
		HashMap<String, String> adFeature = new HashMap<>();
		BufferedReader br = new BufferedReader(new FileReader(new File(path)));
		String line = "";
		String[] cols;
		String featureStr = "";
		// igmore the header
		br.readLine();
		while (br.ready()) {
			line = br.readLine();
			cols = line.split(sep);
			// 25 features
			featureStr = join(",", cols, 3);
			adFeature.put(cols[0], featureStr);
		}
		return adFeature;
	}

	public static HashMap<String, String> readUserFeatureIntoMap(String path,
			String sep) throws Exception {
		HashMap<String, String> userFeature = new HashMap<>();
		BufferedReader br = new BufferedReader(new FileReader(new File(path)));
		String line = "";
		String[] cols;
		String featureStr = "";
		String userId = "";
		// igmore the header
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

			// 25 features
			featureStr = join(",", cols, 1);
			userFeature.put(cols[0], featureStr);
		}
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

	public static HashMap<String, String> readUserAdFeatureIntoMap(String path,
			String sep) throws Exception {
		HashMap<String, String> userAdFeature = new HashMap<>();
		BufferedReader br = new BufferedReader(new FileReader(new File(path)));
		String line = "";
		String[] cols;
		String featureStr = "";
		// igmore the header
		br.readLine();
		while (br.ready()) {
			line = br.readLine();
			cols = line.split(sep);
			// key is adID ,value is 25 features string
			userAdFeature.put(cols[0], cols[1]);
		}
		return userAdFeature;
	}

	public static void getUserAdFeatureIntoFile(String path, String outPutPath,
			HashMap<String, String> adFeature) throws Exception {
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
		String record = "";
		String features = "";
		boolean notStartLineFlag = false;
		while (br.ready()) {
			if (notStartLineFlag) {
				bw.newLine();
			} else {
				notStartLineFlag = true;
			}
			line = br.readLine();
			cols = line.split("\t");
			userId = cols[0];
			record = cols[1];
			features = transformRecordToFeature(record, adFeature);
			// System.out.println(line);
			bw.write(userId + "\t" + features);
		}
		br.close();
		bw.close();
	}

	public static void getAllFeatureWithClassIdIntoFile(String path,
			String outPutPath, HashMap<String, String> userFeature,
			HashMap<String, String> adFeature,int classIndex) throws Exception {
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
		String adId = "";
		String features = "";
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
			adId = cols[1];
			line = userFeature.get(userId) + "," + adFeature.get(adId) + ","
					+ cols[classIndex];
			// System.out.println(line);
			bw.write(line);
		}
		br.close();
		bw.close();
	}
	
	public static void getAllFeatureWithClassIdIntoFile4FinalContest(String path,
			String outPutPath, HashMap<String, String> userFeature,
			HashMap<String, String> adFeature) throws Exception {
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
		String adId = "";
		String features = "";
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
			adId = cols[1];
			line = userFeature.get(userId) + "," + adFeature.get(adId) ;
			// System.out.println(line);
			bw.write(line);
		}
		br.close();
		bw.close();
	}

	
	public static String transformRecordToFeature(String record,
			HashMap<String, String> adFeature) {

		String[] arr = record.split(",");
		String[] adAndAction;
		String feature = "";
		String[] featureArrStr;
		int weight = 0;
		if (arr.length == 1) {
			adAndAction = arr[0].split("_");
			feature = adFeature.get(adAndAction[0]);
		} else {
			int[] featureArr = new int[FEATURE_LENGTH];
			for (String str : arr) {
				adAndAction = str.split("_");
				feature = adFeature.get(adAndAction[0]);
				featureArrStr = feature.split(",");
				weight = "0".equals(adAndAction[1]) ? IMP_WEIGHT : CLK_WEIGHT;
				for (int i = 0; i < FEATURE_LENGTH; i++) {
					featureArr[i] += Integer.parseInt(featureArrStr[i])
							* weight;
				}
			}
			feature = join(",", featureArr, 0);
		}
		return feature;
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

	public static String join(String delimiter, int[] arr, int start) {
		StringBuffer sb = new StringBuffer();
		sb.append(arr[start]);
		int len = arr.length;
		for (int i = start + 1; i < len; i++) {
			sb.append(delimiter);
			sb.append(arr[i]);
		}
		return sb.toString();
	}

	public static void getUserFeatureIntoFile(String path, String outPutPath,
			HashMap<String, String> adFeature,
			HashMap<String, String> userAdFeature) throws Exception {
		File inFile = new File(path);
		BufferedReader br = new BufferedReader(new FileReader(inFile));
		File outputFile = new File(outPutPath);
		if (!outputFile.exists()) {
			outputFile.createNewFile();
		}
		BufferedWriter bw = new BufferedWriter(new FileWriter(outputFile));

		String line = "";
		String[] cols;
		boolean notStartLineFlag = false;
		while (br.ready()) {
			if (notStartLineFlag) {
				bw.newLine();
			} else {
				notStartLineFlag = true;
			}
			line = br.readLine();
			cols = line.split(",");

			// System.out.println(line);
			bw.write(line);
		}
		br.close();
		bw.close();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {

		HashMap<String, String> adFeature = readAdFeatureIntoMap(basePath
				+ "ads.txt", "\t");
		/*
		 * getUserAdFeatureIntoFile(basePath + "usr_ads_new", basePath +
		 * "userAdFeature", adFeature);
		 */
		// HashMap<String, String> userAdFeature =
		// readUserAdFeatureIntoMap(basePath+"userAdFeature","\t");
		/*HashMap<String, String> userFeature = readUserFeatureIntoMap(basePath
				+ "users", ",");*/
		HashMap<String, String> userFeature = readUserFeatureIntoMap(basePath
				+ "users.txt", ",");
		getAllFeatureWithClassIdIntoFile(basePath + "training.txt", basePath
				+ "TrainingFeatures", userFeature, adFeature,5);
//		getAllFeatureWithClassIdIntoFile(basePath + "testing.txt", basePath
//				+ "TestingFeatures", userFeature, adFeature,5);
//		getAllFeatureWithClassIdIntoFile4FinalContest(basePath + "evaluation_for_contest.txt", basePath
//				+ "FinalContestFeatures", userFeature, adFeature);

	}
}
