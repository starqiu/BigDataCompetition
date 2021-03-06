package seperate;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

import utils.CommonUtils;
import utils.ConsumerUtils;

/*
 * ============================================================
 * The SSE USTC Software License
 * 
 * SeperateSamples.java
 * 2014年10月8日
 * 
 * Copyright (c) 2006 China Payment and Remittance Service Co.,Ltd        
 * All rights reserved.
 * ============================================================
 */

/**
 * 实现功能： 将样本分成正样本和负样本
 * <p>
 * date author email notes<br />
 * ----------------------------------------------------------------<br />
 * 2014年10月8日 邱星 starqiu@mail.ustc.edu.cn 新建类<br />
 * </p>
 *
 */
public class SeperateSamplesMR {

	public final static ConcurrentHashMap<String, String> idAndDates = ConsumerUtils
			.getConsumerIdAndDatesMap(CommonUtils
					.getValueByKeyFromConfig("consumers.path"));

	public static class SeperateMapper extends
			Mapper<LongWritable, Text, Text, Text> {

		public void map(LongWritable ikey, Text ivalue, Context context)
				throws IOException, InterruptedException {
			Text key = new Text(ivalue.toString()
					.substring(0, ivalue.find("^")));
			System.out.print(ikey+",");
			context.write(key, ivalue);

		}

	}

	public static class SeperatePositiveReducer extends
			Reducer<Text, Text, NullWritable, Text> {

		public void reduce(Text _key, Iterable<Text> values, Context context)
				throws IOException, InterruptedException {
			/*System.out.println("idAndDates:" + idAndDates);
			System.out.println("key out:" + _key);*/
			// process values
			if (idAndDates.containsKey(_key.toString())) {
				for (Text val : values) {
					context.write(NullWritable.get(), val);
				}
			}
		}
	}

	public static class SeperateNegativeReducer extends
			Reducer<Text, Text, NullWritable, Text> {

		public void reduce(Text _key, Iterable<Text> values, Context context)
				throws IOException, InterruptedException {
			/*System.out.println("idAndDates:" + idAndDates);
			System.out.println("key out:" + _key);*/
			Configuration conf = context.getConfiguration();
			conf.getResource("consumers");
			// process values
			if (!idAndDates.containsKey(_key.toString())) {
				for (Text val : values) {
					context.write(NullWritable.get(), val);
				}
			}
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {

		Configuration conf = new Configuration();
		String otherArgs[] = (new GenericOptionsParser(conf, args))
				.getRemainingArgs();
		if (otherArgs.length != 3) {
			System.err.println("Usage: FindConsumers <in> <positive sample path> <negative sample path>");
			System.exit(3);
		}

		// get positive samples
		Job getPositiveSampleJob = new Job(conf, "get positive samples");
		getPositiveSampleJob.setJarByClass(SeperateSamplesMR.class);
		getPositiveSampleJob.setMapperClass(SeperateMapper.class);
		getPositiveSampleJob.setReducerClass(SeperatePositiveReducer.class);
		getPositiveSampleJob.setMapOutputKeyClass(Text.class);
		getPositiveSampleJob.setMapOutputValueClass(Text.class);
		getPositiveSampleJob.setOutputKeyClass(NullWritable.class);
		getPositiveSampleJob.setOutputValueClass(Text.class);
		FileInputFormat.addInputPath(getPositiveSampleJob, new Path(
				otherArgs[0]));
		FileOutputFormat.setOutputPath(getPositiveSampleJob, new Path(
				otherArgs[1]));
		int posRes = getPositiveSampleJob.waitForCompletion(true) ? 0 : 1;
		if (posRes == 1) {
			System.exit(posRes);
		}

		// get negative samples
		Job getNegativeSampleJob = new Job(conf, "get negative samples");
		getNegativeSampleJob.setJarByClass(SeperateSamplesMR.class);
		getNegativeSampleJob.setMapperClass(SeperateMapper.class);
		getNegativeSampleJob.setReducerClass(SeperateNegativeReducer.class);
		getNegativeSampleJob.setMapOutputKeyClass(Text.class);
		getNegativeSampleJob.setMapOutputValueClass(Text.class);
		getNegativeSampleJob.setOutputKeyClass(NullWritable.class);
		getNegativeSampleJob.setOutputValueClass(Text.class);
		FileInputFormat.addInputPath(getNegativeSampleJob, new Path(
				otherArgs[0]));
		FileOutputFormat.setOutputPath(getNegativeSampleJob, new Path(
				otherArgs[2]));
		System.exit(getNegativeSampleJob.waitForCompletion(true) ? 0 : 2);

	}

}
