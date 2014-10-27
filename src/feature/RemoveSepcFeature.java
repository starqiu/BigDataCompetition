/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * RemoveSepcFeature.java
 * 2014年10月27日
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

/**
 * 实现功能： 移除指定的列
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月27日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class RemoveSepcFeature {
	public final static String basePath = "/host/kp/siat/KDD/ccf_contest/um/";
	// start from 1
	public final static int featureIndex = 5;

	public static void rmSpecFeature4TrainAndTest(String trainingFeaturesPath,
			String testingFeaturesPath, String newTrainingFeaturesPath,
			String newTestingFeaturesPath) throws Exception {

		// remove featue for train set
		rmSpecFeature(trainingFeaturesPath, newTrainingFeaturesPath,
				featureIndex);
		// remove featue for test set
		rmSpecFeature(testingFeaturesPath, newTestingFeaturesPath, featureIndex);

	}

	public static void rmSpecFeature(String featuresPath,
			String newFeaturesPath, int featureIndex)
			throws FileNotFoundException, IOException, Exception {
		BufferedReader featuresBR = new BufferedReader(new FileReader(new File(
				featuresPath)));
		BufferedWriter newFeaturesBW = new BufferedWriter(new FileWriter(
				newFeaturesPath));

		rmFeature(featuresBR, newFeaturesBW, featureIndex);

		featuresBR.close();
		newFeaturesBW.close();
	}

	public static void rmFeature(BufferedReader featuresBR,
			BufferedWriter newFeaturesBW, int featureIndex) throws Exception {
		String[] cols;
		boolean notStartLineFlag = false;
		int featureLength = 0;
		while (featuresBR.ready()) {
			if (notStartLineFlag) {
				newFeaturesBW.newLine();
			} else {
				notStartLineFlag = true;
			}
			cols = featuresBR.readLine().split(",");
			featureLength = cols.length;
			if (featureIndex == 1) {// the first col
				newFeaturesBW.write(join(",", cols, 1, featureLength));
			} else if (featureIndex == featureLength) {// the last col
				newFeaturesBW.write(join(",", cols, 0, featureLength - 1));
			} else {
				newFeaturesBW.write(join(",", cols, 0, featureIndex - 1) + ","
						+ join(",", cols, featureIndex, featureLength));
			}
		}
	}

	public static String join(String delimiter, Object[] arr, int start, int end) {
		StringBuffer sb = new StringBuffer();
		sb.append(arr[start]);
		for (int i = start + 1; i < end; i++) {
			sb.append(delimiter);
			sb.append(arr[i]);
		}
		return sb.toString();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		rmSpecFeature4TrainAndTest(basePath + "TrainingFeatures", basePath
				+ "TestingFeatures", basePath + "newTrainingFeatures", basePath
				+ "newTestingFeatures");
	}

}
