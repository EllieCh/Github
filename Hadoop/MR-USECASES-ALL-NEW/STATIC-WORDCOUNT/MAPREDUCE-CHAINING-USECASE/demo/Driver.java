
package com.gopal.demo;

import java.io.IOException;

import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.fs.s3.FileSystemStore;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import org.apache.hadoop.mapred.join.Parser.StrToken;
import org.apache.hadoop.metrics.file.FileContext;

public class Driver 
{
	public static void main(String[] args) throws IOException 
	{
		if (args.length != 2) 
		{
			System.err.println("Usage: FileDemo1: <input path> <output path>");
			System.exit(-1);
		}
		
		//For the First Job...
		
		JobConf job1 = new JobConf(Driver.class);
		job1.setJobName( "Job 1" );
		//job1.set( "fs.default.name" , "hdfs://10.87.18.243:9000" );
		job1.set( "fs.default.name" , "hdfs://localhost:8020" );
		
		String temporaryPath = "/user/job1out";
		
		FileInputFormat.addInputPath( job1, new Path( args[0] ) );
		FileOutputFormat.setOutputPath( job1, new Path( temporaryPath ) );
		
		job1.setMapperClass( MyMapper.class );
		job1.setReducerClass( MyReducer.class );
		
		job1.setMapOutputKeyClass( Text.class );
		job1.setMapOutputValueClass( IntWritable.class );
		
		job1.setOutputKeyClass( Text.class );
		job1.setOutputValueClass( Text.class );
		
		JobClient.runJob( job1 );
		
		// For the second Job...
		
		JobConf job2 = new JobConf(Driver.class);
		job2.setJobName( "Job 2" );
		//job2.set( "fs.default.name" , "hdfs://10.87.18.243:9000" );
		job2.set( "fs.default.name" , "hdfs://localhost:8020" );
		
		FileInputFormat.addInputPath( job2 , new Path( temporaryPath ) );
		FileOutputFormat.setOutputPath( job2, new Path( args[1] ) );
		
		job2.setMapperClass( MyMapper1.class );
		job2.setReducerClass( MyReducer1.class );
		
		job2.setMapOutputKeyClass( Text.class );
		job2.setMapOutputValueClass( Text.class );
		
		job2.setOutputKeyClass( Text.class );
		job2.setOutputValueClass( Text.class );
		
		JobClient.runJob( job2 );
		
		
	}
}






