package stat;
/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * StatisticsTotalDataNum.java
 * 2014年9月25日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */

/**
 * 实现功能： 统计数据总共有多少条
 * <p>
 * date	        author            email		           notes<br />
 * ----------------------------------------------------------------<br />
 *2014年9月25日        邱星         starqiu@mail.ustc.edu.cn	    新建类<br /></p>
 *
 */
import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

import comm.IntSumReducer;

public class StatisticsTotalDataNum {

	public static class TokenizerMapper extends
			Mapper<Object, Text, Text, IntWritable> {

		private final static IntWritable one = new IntWritable(1);
		private final static Text fixKey = new Text("totalDataNum");

		public void map(Object key, Text value, Context context) throws IOException, InterruptedException {

			context.write(fixKey, one);
		}
	}

	public static void main(String[] args) throws Exception {

		Configuration conf = new Configuration();
		String[] otherArgs = new GenericOptionsParser(conf, args)
				.getRemainingArgs();
		if (otherArgs.length != 2) {
			System.err.println("Usage: StatisticsTotalDataNum <in> <out>");
			System.exit(2);

		}

		Job job = new Job(conf, "Statistics Total Data Num");
		job.setJarByClass(StatisticsTotalDataNum.class);
		job.setMapperClass(TokenizerMapper.class);
		job.setCombinerClass(IntSumReducer.class);
		job.setReducerClass(IntSumReducer.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);
		FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
		System.exit(job.waitForCompletion(true) ? 0 : 1);

	}

}
