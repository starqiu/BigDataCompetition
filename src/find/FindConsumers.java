// Decompiled by Jad v1.5.8e2. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://kpdus.tripod.com/jad.html
// Decompiler options: packimports(3) fieldsfirst ansi space 
// Source File Name:   FindConsumers.java

package find;

import java.io.IOException;
import java.util.Iterator;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

public class FindConsumers
{
	public static class FindMapper extends Mapper
	{

		public void map(Object key, Text value, Context context)
			throws IOException, InterruptedException
		{
			String line = value.toString();
			int idx = line.indexOf("^");
			int len = line.length();
			System.out.println((new StringBuilder("idx:")).append(idx).toString());
			String out_key = line.substring(0, idx);
			String out_val = line.substring(idx + 1, len);
			context.write(new Text(out_key), new Text(out_val));
		}

		public FindMapper()
		{
		}
	}

	public static class FindReducer extends Reducer
	{

		public void reduce(Text key, Iterable values, Context context)
			throws IOException, InterruptedException
		{
			StringBuilder sb = new StringBuilder();
			String t_val = null;
			for (Iterator iterator = values.iterator(); iterator.hasNext(); sb.append((new StringBuilder(String.valueOf(t_val))).append(",").toString()))
			{
				Text time = (Text)iterator.next();
				t_val = time.toString();
			}

			Text out_val = new Text(sb.toString());
			context.write(key, out_val);
		}

		public FindReducer()
		{
		}
	}


	public FindConsumers()
	{
	}

	public static void main(String args[])
		throws Exception
	{
		Configuration conf = new Configuration();
		String otherArgs[] = (new GenericOptionsParser(conf, args)).getRemainingArgs();
		if (otherArgs.length != 2)
		{
			System.err.println("Usage: FindConsumers <in> <out>");
			System.exit(2);
		}
		Job job = new Job(conf, "Find consumers");
		job.setJarByClass(FindConsumers.class);
		job.setMapperClass(FindMapper.class);
		job.setReducerClass(FindReducer.class);
		job.setMapOutputKeyClass(Text.class);
		job.setMapOutputValueClass(Text.class);
		job.setOutputKeyClass(Text.class);
		job.setOutputValueClass(Text.class);
		FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
		FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
		System.exit(job.waitForCompletion(true) ? 0 : 1);
	}
}
