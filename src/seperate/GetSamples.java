/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * GetSamples.java
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
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 实现功能：
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年11月11日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class GetSamples {
	public final static String basePath = "/home/xqiu/kdd/data/pixel/";

	// try
/*	public final static int POS_SAMPEL_COUNT = 10;
	public final static int TOTAL_SAMPEL_COUNT = 200;*/

	// train
	  public final static int POS_SAMPEL_COUNT = 746056; 
	  public final static int TOTAL_SAMPEL_COUNT = 19887768;
	 
	// test
	// public final static int POS_SAMPEL_COUNT = 97530;
	// public final static int TOTAL_SAMPEL_COUNT = 2731704;

	public static List<Integer> randomArrayList(List<Integer> totalArr,
			int sampleNumber) {
		Collections.shuffle(totalArr);
		return new ArrayList<>(totalArr.subList(0, sampleNumber));
	}

	public static void getSampleIntoBufer(BufferedReader br, BufferedWriter bw,
			List<Integer> randomArr) throws Exception {
		boolean notStartLineFlag = false;
		int currentLineNo = 0;
		int currentRandomIndex = 0;
		int len = randomArr.size();
		while ((currentRandomIndex < len) && br.ready()) {

			if (randomArr.get(currentRandomIndex) == currentLineNo) {
				currentRandomIndex++;
				if (notStartLineFlag) {
					bw.newLine();
				} else {
					notStartLineFlag = true;
				}
				bw.write(br.readLine());
			} else {
				br.readLine();
			}
			currentLineNo++;

		}
	}

	public static void getSampleIntoFile(String totalFileName,
			String sampleFileName, List<Integer> randomArr) throws Exception{
		BufferedReader br = new BufferedReader(new FileReader(new File(basePath+totalFileName)));
		BufferedWriter bw = new BufferedWriter(new FileWriter(new File(basePath+ sampleFileName)));
		
		getSampleIntoBufer(br,bw,randomArr);
		
		br.close();
		bw.close();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		ArrayList<Integer> totalArr = new ArrayList<>(TOTAL_SAMPEL_COUNT);
		for (int i = 0; i < TOTAL_SAMPEL_COUNT; i++) {
			totalArr.add(i);
		}
		ArrayList<Integer> sampleArr;
		for (int i = 2; i <6; i++) {
			sampleArr= (ArrayList<Integer>) randomArrayList(
					totalArr, i * POS_SAMPEL_COUNT);
			Collections.sort(sampleArr);
			getSampleIntoFile("TrainingFeaturesWithPixel_neg","TrainingFeaturesWithPixel_neg_sample_"+i,sampleArr);
		}
	}

}
