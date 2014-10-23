/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * GetAllUserIds.java
 * 2014年10月14日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */
package merge;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

import utils.CommonUtils;

import comm.PrintKeysReducer;

/**
 * 实现功能：reduce数据,输出格式为userId^date
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月14日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class MergeDataWithUsersAndDate {
	private final static int indexOfDate = Integer.valueOf(CommonUtils
			.getValueByKeyFromConfig("index.of.data"));

	public static class TokenizerMapper extends
			Mapper<Object, Text, Text, NullWritable> {

		private Text userIdAndDate = new Text();

		public void map(Object key, Text value, Context context)
				throws IOException, InterruptedException {
			String[] row = value.toString().split("\\^");
			userIdAndDate.set(row[0]+"^"+row[indexOfDate].substring(0, 8));
			context.write(userIdAndDate,NullWritable.get());
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

		Job job = new Job(conf, "reduce data into userId^date") ;
		job.setJarByClass(MergeDataWithUsersAndDate.class);
		job.setMapperClass(TokenizerMapper.class);
//		job.setCombinerClass(PrintKeysReducer.class);
		job.setReducerClass(PrintKeysReducer.class);
		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(NullWritable.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(NullWritable.class);
		FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
		System.exit(job.waitForCompletion(true) ? 0 : 1);

	}

}
