/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * getAllClickRecords.java
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
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

/**
 * 实现功能： 得到所有CLK的记录
 * <p>
 * date	        author            email		           notes<br />
 * ----------------------------------------------------------------<br />
 *2014年10月14日        邱星         starqiu@mail.ustc.edu.cn	    新建类<br /></p>
 *
 */
public class getAllClickRecords {
	
	public static class TokenizerMapper extends
			Mapper<Object, Text, Text, NullWritable> {

		public void map(Object key, Text value, Context context)
				throws IOException, InterruptedException {
			String[] row = value.toString().split("\\^");
			boolean isClick = "CLK".equals(row[9])?true:false;
			if (isClick) {
				context.write(value,NullWritable.get());
//				System.out.println(value);
			}
		}
	}

	/**
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
		String[] otherArgs = new GenericOptionsParser(conf, args)
				.getRemainingArgs();
		if (otherArgs.length != 2) {
			System.err.println("Usage: StatisticsTotalDataNum <in> <out>");
			System.exit(2);

		}

		Job job = new Job(conf, "Get All  Click rows");
		job.setJarByClass(getAllClickRecords.class);
		job.setMapperClass(TokenizerMapper.class);
		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(NullWritable.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(NullWritable.class);
		FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
		System.exit(job.waitForCompletion(true) ? 0 : 1);

	}

}

