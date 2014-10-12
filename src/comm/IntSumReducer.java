/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * IntSumReducer.java
 * 2014年10月12日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */
package comm;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * 实现功能：
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月12日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 */
public  class  IntSumReducer extends
		Reducer<Text, IntWritable, Text, IntWritable> {

	private IntWritable result = new IntWritable();

	public void reduce(Text key, Iterable<IntWritable> values, Context context)
			throws IOException, InterruptedException {

		int sum = 0;
		for (IntWritable val : values) {
			sum += val.get();
		}
		result.set(sum);
		context.write(key, result);
	}

}
