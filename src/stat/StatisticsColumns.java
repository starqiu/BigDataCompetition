/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * StatisticsColumns.java
 * 2014年10月11日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */
package stat;

import java.io.IOException;
import java.util.HashSet;

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

/**
 * 实现功能：统计列,通用的MapReduce,只需改变colNames和输入,即可统计其他数据
 * 输入:monitor data
 * 输出:每一列的数据种类数
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月11日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class StatisticsColumns {
	private final static IntWritable one = new IntWritable(1);
	private final static Text[] colNames = { new Text("用户ID"),
			new Text("用户ID是否稳定标识符"), new Text("广告活动ID"), new Text("监测点ID"),
			new Text("浏览器类型"), new Text("操作系统类型"), new Text("浏览器语言"),
			new Text("IP地址"), new Text("时间"), new Text("曝光或点击标识符") };
	private final static int colSize = colNames.length;

	public static class StatisticsColumnsValueSortMapper extends
			Mapper<Object, Text, Text, Text> {
		public void map(Object ikey, Text ivalue, Context context)
				throws IOException, InterruptedException {
			String[] row = ivalue.toString().split("\\^");
//			System.out.println("key="+ikey.toString()+"value="+ivalue.toString());
			for (int i = 0; i < colSize; i++) {
				context.write(colNames[i], new Text(row[i]));
			}
		}
	}

	public static class StatisticsColumnsValueSortReducer extends
			Reducer<Text, Text, Text, IntWritable> {
		private IntWritable sortCount = new IntWritable();
		private HashSet<String> valSet = new HashSet<>();
		public void reduce(Text _key, Iterable<Text> values, Context context)
				throws IOException, InterruptedException {
			// process values
			for (Text val : values) {
				valSet.add(val.toString());
			}
			sortCount.set(valSet.size());
//			System.out.println("key="+_key.toString()+"value="+Arrays.toString(valSet.toArray()));
			valSet.clear();
			context.write(_key,sortCount);
		}
	}

	/**
	 * @param args
	 * @throws IOException
	 * @throws InterruptedException
	 * @throws ClassNotFoundException
	 */
	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
		String otherArgs[] = (new GenericOptionsParser(conf, args))
				.getRemainingArgs();
		if (otherArgs.length != 2) {
			System.err.println("Usage: StatisticsColumns  <in> <out>");
			System.exit(2);
		}
		
		Job job = new Job(conf, "StatisticsColumns");
		job.setJarByClass(StatisticsColumns.class);
		job.setMapperClass(StatisticsColumnsValueSortMapper.class);
		job.setReducerClass(StatisticsColumnsValueSortReducer.class);
		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(Text.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
		FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}

}
