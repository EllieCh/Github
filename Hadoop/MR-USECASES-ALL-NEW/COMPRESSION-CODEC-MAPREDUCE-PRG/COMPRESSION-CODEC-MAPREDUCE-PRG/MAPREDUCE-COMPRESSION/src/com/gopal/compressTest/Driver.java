package com.gopal.compressTest;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.compress.CompressionCodec;
import org.apache.hadoop.io.compress.GzipCodec;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;

public class Driver 
{
	public static void main(String[] args) throws Exception 
	{
		if (args.length != 2) 
		{
			System.err.println("Usage: FileDemo1: <input path> <output path>");
			System.exit(-1);
		}
		
		JobConf conf = new JobConf(Driver.class);
		conf.setJobName( "demo3" );
		
		FileInputFormat.addInputPath( conf, new Path( args[0] ) );
		FileOutputFormat.setOutputPath( conf, new Path( args[1] ) );
		
		conf.setMapperClass( MyMapper.class );
		conf.setReducerClass( MyReducer.class );
		
		conf.setBoolean( "mapred.output.compress" , true );
		conf.setClass( "mapred.output.compression.codec" , GzipCodec.class , CompressionCodec.class );
		
		
		
		conf.setOutputKeyClass( Text.class );
		conf.setOutputValueClass( IntWritable.class );
		
		JobClient.runJob( conf );
	
	}
}
