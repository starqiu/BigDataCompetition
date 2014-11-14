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
public class AddPixelToFeatures {
	// public final static String basePath =
	// "/host/kp/siat/KDD/ccf_contest/um/";
	public final static String basePath = "/home/xqiu/kdd/data/";
	public final static String DEFAULT_PIXEL_294 = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,";

	public static void addRateToFeatures(String originPath,
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
			HashMap<String, String> pixel) throws Exception {
		String featuresRecord = "";
		String[] cols;
		int lastSepIndex = 0;
		String classIndex = "";
		boolean notStartLineFlag = false;
		String pixelVal;
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
			pixelVal = pixel.get(cols[3]);
			if (pixelVal == null) {
				System.out.println("With Class index, image id   :" + cols[3]
						+ "   null pixel,image is not found");
				pixelVal = DEFAULT_PIXEL_294;
			}
			newFeaturesBW.write(featuresRecord.substring(0, lastSepIndex) + ","
					+ pixelVal + classIndex);
		}
	}

	public static void addNewFeaturesWithoutClassIndex(BufferedReader originBR,
			BufferedReader featuresBR, BufferedWriter newFeaturesBW,
			HashMap<String, String> pixel) throws Exception {
		String featuresRecord = "";
		String[] cols;
		boolean notStartLineFlag = false;
		String pixelVal;
		while (originBR.ready() && featuresBR.ready()) {
			if (notStartLineFlag) {
				newFeaturesBW.newLine();
			} else {
				notStartLineFlag = true;
			}
			cols = originBR.readLine().split(",");
			featuresRecord = featuresBR.readLine();

			pixelVal = pixel.get(cols[3]);
			if (pixelVal == null) {
				System.out.println("Without Class index, image id   :"
						+ cols[3] + "   null pixel,image is not found");
				pixelVal = DEFAULT_PIXEL_294;
			}
			newFeaturesBW.write(featuresRecord + ","
					+ pixelVal.substring(0, pixelVal.lastIndexOf(',')));
		}
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

	public static void main(String[] args) throws Exception {

		// load pixel to map
		HashMap<String, String> pixel = readPixelIntoMap(basePath
				+ "pixelFeature.txt", ",");

		// add pixel for train set
		addRateToFeatures(basePath + "training.txt", basePath
				+ "TrainingFeaturesWithClkRate", basePath
				+ "TrainingFeaturesWithPixel", pixel, true);

		// add pixel for test set
		addRateToFeatures(basePath + "testing.txt", basePath
				+ "TestingFeaturesWithClkRate", basePath
				+ "TestingFeaturesWithPixel", pixel, true);

		// add pixel for final contest set
		addRateToFeatures(basePath + "evaluation_for_contest.txt", basePath
				+ "FinalContestFeaturesWithClkRate", basePath
				+ "FinalContestFeaturesWithPixel", pixel, false);

		/*
		 * //generate 294 zeros StringBuffer sb = new StringBuffer(); for (int i
		 * = 0; i < 294; i++) { sb.append("0,"); }
		 * System.out.println(sb.toString());
		 * System.out.println(DEFAULT_PIXEL_294.split(",").length);
		 */

	}

}
