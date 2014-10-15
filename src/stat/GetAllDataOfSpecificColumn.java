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
package stat;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
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
 * 实现功能：获取指定列中的不同值
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月14日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class GetAllDataOfSpecificColumn {
	private final static String[] colNames = { "用户ID", "用户ID是否稳定标识符", "广告活动ID",
			"监测点ID", "浏览器类型", "操作系统类型", "浏览器语言", "IP地址", "时间", "曝光或点击标识符" };
	private final static int indexOfSpecCol = Integer.valueOf(CommonUtils
			.getValueByKeyFromConfig("index.of.specific.column"));

	public static class TokenizerMapper extends
			Mapper<Object, Text, Text, Text> {

		private Text column = new Text();

		public void map(Object key, Text value, Context context)
				throws IOException, InterruptedException {
			String[] row = value.toString().split("\\^");
			column.set(row[indexOfSpecCol]);
			context.write(column,column);
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

		Job job = new Job(conf, "Get All  "+colNames[indexOfSpecCol]);
		job.setJarByClass(GetAllDataOfSpecificColumn.class);
		job.setMapperClass(TokenizerMapper.class);
//		job.setCombinerClass(PrintKeysReducer.class);
		job.setReducerClass(PrintKeysReducer.class);
		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(Text.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(NullWritable.class);
		FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]+indexOfSpecCol));
		System.exit(job.waitForCompletion(true) ? 0 : 1);

	}

}
