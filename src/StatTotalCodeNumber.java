import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;

/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * StatTotalCodeNumber.java
 * 2014年11月7日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */

/**
 * 实现功能：统计代码行数
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年11月7日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class StatTotalCodeNumber {
	public final static String BASE_PATH = "/home/starqiu/workspace/BigDataCompetition/";
	public final static String SAVE_File_PATH = "/home/starqiu/totalCode.txt";
	public final static String CODE_SUFFIX_REG = "^[^\\.]+\\.(R|java|c|h|cpp)$";

	public static void mergeCodeInto1File(File file, FilenameFilter filter,
			BufferedWriter totalCodeBW) throws Exception{
		
		if (file.isDirectory()) {
			File[] files = file.listFiles(filter);
			for (File file2 : files) {
				if (file2.isDirectory()) {
					mergeCodeInto1File(file2, filter, totalCodeBW);
				}else {
					appendToFile(totalCodeBW, file2);
				}
			}
		} else {
			appendToFile(totalCodeBW, file);
		}
	}

	/**
	 * @param totalCodeBW
	 * @param file2
	 * @throws IOException
	 * @throws FileNotFoundException
	 */
	public static void appendToFile(BufferedWriter totalCodeBW, File file2)
			throws IOException, FileNotFoundException {
		totalCodeBW.newLine();
		BufferedReader br = new BufferedReader(new FileReader(file2));
		while(br.ready()) {
			 totalCodeBW.write(br.readLine());
			 totalCodeBW.newLine();
		}
		br.close();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		File file = new File(BASE_PATH);
		BufferedWriter totalCodeBW = new BufferedWriter(new FileWriter(
				new File(SAVE_File_PATH)));
		FilenameFilter filter = new FilenameFilter() {

			@Override
			public boolean accept(File dir, String name) {
				File file = new File(dir, name);
				if (file.isHidden()) {
					return false;
				}
				if (file.isDirectory()
						|| ((!file.isDirectory()) && name
								.matches(CODE_SUFFIX_REG))) {
					return true;
				}
				return false;
			}
		};

		mergeCodeInto1File(file, filter, totalCodeBW);
		totalCodeBW.close();
		// System.out.println(".Rproj.user".matches(CODE_SUFFIX_REG));

	}
}
