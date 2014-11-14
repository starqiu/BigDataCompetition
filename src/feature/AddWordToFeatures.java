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
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
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
public class AddWordToFeatures {
	// public final static String basePath =
	// "/host/kp/siat/KDD/ccf_contest/um/";
	public final static String basePath = "/home/xqiu/kdd/final/";

	public static void addWordToFeatures(String originPath,
			String featuresPath, String newFeaturesPath,
			HashMap<String, String> pixel, boolean haveClassIndex)
			throws FileNotFoundException, IOException, Exception {
		BufferedReader originBR = new BufferedReader(new FileReader(new File(
				originPath)));
		BufferedReader featuresBR = new BufferedReader(new FileReader(new File(
				featuresPath)));
		BufferedWriter newFeaturesBW = new BufferedWriter(new FileWriter(
				newFeaturesPath));

		if (haveClassIndex) {
			addNewFeatures(originBR, featuresBR, newFeaturesBW, pixel);
		} else {
			addNewFeaturesWithoutClassIndex(originBR, featuresBR,
					newFeaturesBW, pixel);

		}

		originBR.close();
		featuresBR.close();
		newFeaturesBW.close();
	}

	public static void addNewFeatures(BufferedReader originBR,
			BufferedReader featuresBR, BufferedWriter newFeaturesBW,
			HashMap<String, String> wordMap) throws Exception {
		String featuresRecord = "";
		String[] cols;
		int lastSepIndex = 0;
		String classIndex = "";
		boolean notStartLineFlag = false;
		String word;
		while (originBR.ready() && featuresBR.ready()) {
			if (notStartLineFlag) {
				newFeaturesBW.newLine();
			} else {
				notStartLineFlag = true;
			}
			cols = originBR.readLine().split(",");
			featuresRecord = featuresBR.readLine();
			lastSepIndex = featuresRecord.lastIndexOf(',');
			classIndex = featuresRecord.substring(lastSepIndex + 1,
					featuresRecord.length());
			word = wordMap.get(cols[1]);
			newFeaturesBW.write(featuresRecord.substring(0, lastSepIndex) + ","
					+ word+"," + classIndex);
		}
	}

	public static void addNewFeaturesWithoutClassIndex(BufferedReader originBR,
			BufferedReader featuresBR, BufferedWriter newFeaturesBW,
			HashMap<String, String> wordMap) throws Exception {
		String featuresRecord = "";
		String[] cols;
		boolean notStartLineFlag = false;
		String word;
		while (originBR.ready() && featuresBR.ready()) {
			if (notStartLineFlag) {
				newFeaturesBW.newLine();
			} else {
				notStartLineFlag = true;
			}
			cols = originBR.readLine().split(",");
			featuresRecord = featuresBR.readLine();

			word = wordMap.get(cols[1]);
			newFeaturesBW.write(featuresRecord + ","+ word);
		}
	}

	public static HashMap<String, String> readWordIntoMap(String path,
			String sep) throws Exception {
		HashMap<String, String> word = new HashMap<>();
		BufferedReader br = new BufferedReader(new FileReader(new File(path)));
		String line = "";
		int lineNo = 1;
		while (br.ready()) {
			line = br.readLine();
			word.put(String.valueOf(lineNo++),line);
		}
		br.close();
		return word;
	}

	public static void main(String[] args) throws Exception {

		// load word to map
		HashMap<String, String> wordFeature = readWordIntoMap(basePath
				+ "words_feature.txt", ",");

		// add word for train set
		addWordToFeatures(basePath + "training.txt", basePath
				+ "TrainingFeatures", basePath
				+ "TrainingFeaturesWithUserPicWord", wordFeature, true);

		// add word for test set
		addWordToFeatures(basePath + "testing.txt", basePath
				+ "TestingFeatures", basePath
				+ "TestingFeaturesWithUserPicWord", wordFeature, true);

		// add word for final contest set
		addWordToFeatures(basePath + "evaluation_for_contest.txt", basePath
				+ "FinalContestFeatures", basePath
				+ "FinalContestFeaturesWithUserPicWord", wordFeature, false);

		/*
		 * //generate 294 zeros StringBuffer sb = new StringBuffer(); for (int i
		 * = 0; i < 294; i++) { sb.append("0,"); }
		 * System.out.println(sb.toString());
		 * System.out.println(DEFAULT_PIXEL_294.split(",").length);
		 */
	}

}
