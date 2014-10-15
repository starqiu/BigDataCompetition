/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * PrintKeysReducer.java
 * 2014年10月14日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */
package comm;

import java.io.IOException;

import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

/**
 * 实现功能： 只打印value
 * <p>
 * date	        author            email		           notes<br />
 * ----------------------------------------------------------------<br />
 *2014年10月14日        邱星         starqiu@mail.ustc.edu.cn	    新建类<br /></p>
 *
 */
public class PrintValuesReducer extends Reducer<Text, Object, NullWritable, Object> {

	public void reduce(Text _key, Iterable<Object> values, Context context)
			throws IOException, InterruptedException {
		// process values
		for (Object val : values) {
			context.write(NullWritable.get(),val);
			System.out.println(val);
		}
	}

}

