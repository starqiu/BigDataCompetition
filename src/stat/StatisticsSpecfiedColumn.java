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
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

import comm.IntSumReducer;

/**
 * 统计指定列的类型数量
 * 
 * @author 邱星
 */
public class StatisticsSpecfiedColumn {

	private final static IntWritable one = new IntWritable(1);
	private final static String[] colNames = { "用户ID", "用户ID是否稳定标识符", "广告活动ID",
			"监测点ID", "浏览器类型", "操作系统类型", "浏览器语言", "IP地址", "时间", "曝光或点击标识符" };
	//private final static int colSize = colNames.length;
	private final static int[] indexsOfColNames4Stat = { 1, 4, 5, 6, 9 };
	private final static int indexsSize = indexsOfColNames4Stat.length;

	public static class StatisticsSpecfiedColumnMapper extends
			Mapper<Object, Text, Text, IntWritable> {
		public void map(Object ikey, Text ivalue, Context context)
				throws IOException, InterruptedException {
			String[] row = ivalue.toString().split("\\^");
			// System.out.println("key="+ikey.toString()+"value="+ivalue.toString());
			for (int i = 0; i < indexsSize; i++) {
				int indexOfCol = indexsOfColNames4Stat[i];
				context.write(new Text(colNames[indexOfCol] + ":"
						+ row[indexOfCol]), one);
			}
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
		job.setJarByClass(StatisticsSpecfiedColumn.class);
		job.setMapperClass(StatisticsSpecfiedColumnMapper.class);
		job.setCombinerClass(IntSumReducer.class);
		job.setReducerClass(IntSumReducer.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(IntWritable.class);
		FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
		System.exit(job.waitForCompletion(true) ? 0 : 1);

	}

}
