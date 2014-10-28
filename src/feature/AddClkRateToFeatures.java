/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * AddClkRateToFeatures.java
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
public class AddClkRateToFeatures {
	public final static String basePath = "/host/kp/siat/KDD/ccf_contest/um/";

	public static void addClkRateToFeatures(String trainPath, String testPath,
			String userRatePath, String adRatePath,
			String trainingFeaturesPath, String testingFeaturesPath,
			String newTrainingFeaturesPath, String newTestingFeaturesPath)
			throws Exception {
		// load rate to map
		HashMap<String, String> userRate = readUserOrAdRateIntoMap(
				userRatePath, "\t");
		HashMap<String, String> adRate = readUserOrAdRateIntoMap(adRatePath,
				"\t");

		// add rate for train set
		addRateToFeatures(trainPath, trainingFeaturesPath,
				newTrainingFeaturesPath, userRate, adRate);
		// add rate for test set
		addRateToFeatures(testPath, testingFeaturesPath,
				newTestingFeaturesPath, userRate, adRate);

	}

	public static void addRateToFeatures(String originPath,
			String featuresPath, String newFeaturesPath,
			HashMap<String, String> userRate, HashMap<String, String> adRate)
			throws FileNotFoundException, IOException, Exception {
		BufferedReader originBR = new BufferedReader(new FileReader(new File(
				originPath)));
		BufferedReader featuresBR = new BufferedReader(new FileReader(new File(
				featuresPath)));
		BufferedWriter newFeaturesBW = new BufferedWriter(new FileWriter(
				newFeaturesPath));

		addNewFeatures(originBR, featuresBR, newFeaturesBW, userRate, adRate);

		originBR.close();
		featuresBR.close();
		newFeaturesBW.close();
	}

	public static void addNewFeatures(BufferedReader originBR,
			BufferedReader featuresBR, BufferedWriter newFeaturesBW,
			HashMap<String, String> userRate, HashMap<String, String> adRate)
			throws Exception {
		String featuresRecord = "";
		String[] cols;
		int lastSepIndex = 0;
		String classIndex = "";
		boolean notStartLineFlag = false;
		String userRateVal;
		String adRateVal;
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
			userRateVal = userRate.get(cols[0]);
			if (userRateVal == null) {
				userRateVal = "0";
			}
			adRateVal = adRate.get(cols[1]);
			if (adRateVal == null) {
				adRateVal = "0";
			}
			newFeaturesBW.write(featuresRecord.substring(0, lastSepIndex) + ","
					+ userRateVal + "," + adRateVal + "," + classIndex);
		}
	}

	public static HashMap<String, String> readUserOrAdRateIntoMap(String path,
			String sep) throws Exception {
		HashMap<String, String> userOrAdRate = new HashMap<>();
		BufferedReader br = new BufferedReader(new FileReader(new File(path)));
		String line = "";
		String[] cols;
		while (br.ready()) {
			line = br.readLine();
			cols = line.split(sep);
			userOrAdRate.put(cols[0], cols[3]);
		}
		return userOrAdRate;
	}

	public static HashMap<String, String> readUserAndAdRateIntoMap(String path,
			String sep) throws Exception {
		HashMap<String, String> userAndAdRate = new HashMap<>();
		BufferedReader br = new BufferedReader(new FileReader(new File(path)));
		String line = "";
		String[] cols;
		while (br.ready()) {
			line = br.readLine();
			cols = line.split(sep);
			userAndAdRate.put(cols[0] + "," + cols[1], cols[4]);
		}
		return userAndAdRate;
	}

	public static void main(String[] args) throws Exception {
		addClkRateToFeatures(basePath + "training.txt", basePath
				+ "testing.txt", basePath + "userRate1", basePath + "adRate",
				basePath + "TrainingFeatures1", basePath + "TestingFeatures1",
				basePath + "trainingFeaturesWithClkRate", basePath
						+ "testingFeaturesWithClkRate");
	}

}
