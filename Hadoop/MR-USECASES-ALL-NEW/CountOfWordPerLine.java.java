package com.countofwordperline.mapred;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
//import org.apache.hadoop.mapreduce.KeyValueTextInputFormat.*;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
//import org.apache.hadoop.mapred.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Reducer.Context;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

import com.wordcountline.com.wordcountline;
import com.wordcountline.com.wordcountline.TokenizerMapper;


public class CountOfWordPerLine {
	
	public static class TokenizerMapper
    extends Mapper<Object, Text , Text, IntWritable>{

 int line=0;
 private Text word = new Text();
 private Text summary = new Text();
 private IntWritable linenum = new IntWritable(); 
 private static final IntWritable one = new IntWritable(1);
   
 public void map(Object key, Text value, Context context
                 ) throws IOException, InterruptedException {
   StringTokenizer itr = new StringTokenizer(value.toString());
   line = line + 1;
   linenum.set(line);
     while (itr.hasMoreTokens()) { // bigdata 123 tool 787
     word.set(itr.nextToken());//big
     String line = linenum.toString();
     summary.set(word.toString() + " " + line);
     context.write(summary, one);//<hadoop,1,1>  <is,1,1>
     
   }
 }
}

	public static class IntSumReducer
    extends Reducer<Text,IntWritable,Text,IntWritable> {//hadoop,1,1,1,
 private IntWritable result = new IntWritable();

 public void reduce(Text key, Iterable<IntWritable> values,
                    Context context
                    ) throws IOException, InterruptedException {
   int sum = 0;
   for (IntWritable val : values) {
     sum += val.get();
   }
   result.set(sum);
   context.write(key, result);
 }
}
	
public static void main(String[] args) throws Exception {
  Configuration conf = new Configuration();
  Job job = new Job(conf, "Count Of Word Per Line");
  job.setJarByClass(CountOfWordPerLine.class);
  
  job.setMapperClass(TokenizerMapper.class);
  job.setCombinerClass(IntSumReducer.class);
  job.setReducerClass(IntSumReducer.class);
  
  job.setOutputKeyClass(Text.class);
  job.setOutputValueClass(IntWritable.class);
  
 
  FileInputFormat.addInputPath(job, new Path(args[0]));
  FileOutputFormat.setOutputPath(job, new Path(args[1]));

  System.exit(job.waitForCompletion(true) ? 0 : 1);
}
}
