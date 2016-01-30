package com.dynamic.wordcount;

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

public class DynamicWordCount {

  public static class Map extends Mapper<LongWritable, Text, Text, IntWritable>
  {
	  private final static IntWritable one = new IntWritable(1);
	  private Text word = new Text();
	  
	  public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException 
	  {
		  String line = value.toString();
		  String[] words=line.split(" ");
		  Configuration conf=context.getConfiguration();
		  String newWord=conf.get("RunTimeArg");
		  for(String wrd:words)
		  {
			  if(wrd.equals(newWord))
			  {
				  word.set(wrd);
				  context.write(word, one);  
			  }
		  }
	  }
	} 
  
  public static class Reduce extends Reducer<Text, IntWritable, Text, IntWritable> 
  {
	  public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException 
	  {
		  int sum = 0;
		  for (IntWritable val : values)
		  {
			  sum += val.get();
		  }
		  context.write(key, new IntWritable(sum));
	  }
  }

  public static void main(String[] args) throws Exception 
  {
	  Configuration conf = new Configuration();
	  conf.set("RunTimeArg",args[2]);
	  Job job = new Job(conf, "DynamicWordCount");
	  
	  
	  job.setJarByClass(DynamicWordCount.class);

	  job.setOutputKeyClass(Text.class);
	  job.setOutputValueClass(IntWritable.class);

	  job.setMapperClass(Map.class);
	  job.setReducerClass(Reduce.class);
	  job.setInputFormatClass(TextInputFormat.class);
	  job.setOutputFormatClass(TextOutputFormat.class);
	
	  FileInputFormat.addInputPath(job, new Path(args[0]));
	  FileOutputFormat.setOutputPath(job, new Path(args[1]));
	
	  job.waitForCompletion(true);
  }
}