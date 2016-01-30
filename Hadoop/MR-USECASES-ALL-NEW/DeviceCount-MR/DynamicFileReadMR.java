package com.gopal.mapred;

import java.io.IOException;
import java.util.Iterator;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.FileSplit;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.Mapper;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reducer;
import org.apache.hadoop.mapred.Reporter;
import org.apache.hadoop.mapred.TextInputFormat;
import org.apache.hadoop.mapred.TextOutputFormat;


public class DynamicFileReadMR {

	//mapper class
	public static class MapperClass extends MapReduceBase implements Mapper<LongWritable,Text, Text, IntWritable>
	{
		// object,line of text
		@Override
		public void map(LongWritable key, Text value,OutputCollector<Text, IntWritable> output, Reporter reporter)
		throws IOException {
			String v[]=value.toString().split(" ");
			int sum=0;
			for(int i=0;i<v.length;i++)
				sum=sum+Integer.parseInt(v[i].toString());
			
			FileSplit fileSplit = (FileSplit)reporter.getInputSplit();
			  String filename = fileSplit.getPath().getName();
	
			output.collect(new Text(filename), new IntWritable(sum));

		}
	}
	public static class ReducerClass extends MapReduceBase implements Reducer<Text, IntWritable, Text, IntWritable>
	{
		public void reduce(Text key, Iterator<IntWritable> values,
				OutputCollector<Text, IntWritable> output, Reporter reporter)
		throws IOException {
			
			int sum=0;
			while(values.hasNext())
			{
				sum=Integer.parseInt(values.next().toString())+sum;
	
			}
			output.collect(key, new IntWritable(sum));
		}


	}

	public static void main(String[] args) throws IOException {
		JobConf conf=new JobConf();
		conf.setJarByClass(DynamicFileReadMR.class);
		conf.setJobName("DynamicFileReadMR");

		conf.setOutputKeyClass(Text.class);
		conf.setOutputValueClass(IntWritable.class);

		conf.setMapperClass(MapperClass.class);
		conf.setReducerClass(ReducerClass.class);

		conf.setInputFormat(TextInputFormat.class);
		conf.setOutputFormat(TextOutputFormat.class);

		//conf.setJar("/home/mrinmoy/Downloads/DynamicFileReadMR.jar");

		org.apache.hadoop.mapred.FileInputFormat.setInputPaths(conf,new Path(args[0]));
		org.apache.hadoop.mapred.FileOutputFormat.setOutputPath(conf,new Path(args[1]));

		JobClient.runJob(conf);
	}
}