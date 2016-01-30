package com.mapred.compressCodec;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.compress.CompressionCodec;
import org.apache.hadoop.io.compress.GzipCodec;
import org.apache.hadoop.mapred.FileInputFormat;
import org.apache.hadoop.mapred.FileOutputFormat;
import org.apache.hadoop.mapred.JobClient;
import org.apache.hadoop.mapred.JobConf;
import java.io.IOException;
import java.util.StringTokenizer;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.Mapper;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reporter;
import java.util.Iterator;
import org.apache.hadoop.mapred.Reducer;


public class compressCodec 
{
	public class MyMapper extends MapReduceBase implements Mapper<LongWritable, Text, Text, IntWritable>
	{

		
		public void map(LongWritable k1, Text k2,
				OutputCollector<Text, IntWritable> k3, Reporter k4)
				throws IOException 
		{
			String line = k2.toString();
			
			StringTokenizer itr = new StringTokenizer(line);//Iterating for every separate words in the line.
		      
		    String player=itr.nextToken();  //it gives the name of the batsman.
		    String playerRun=itr.nextToken(); //it gives the runs scored in a particular match by that batsman.
		    IntWritable run=new IntWritable( Integer.parseInt(playerRun) );//typecasted as required by the framework.
		    k3.collect( new Text(player) , run);//Mapper output<-->Reducer input.
		}

		
	}
	public class MyReducer extends MapReduceBase implements Reducer<Text, IntWritable, Text, IntWritable> 
	{

		public void reduce(Text k1, Iterator<IntWritable> k2,
				OutputCollector<Text, IntWritable> k3, Reporter k4)
				throws IOException 
		{
			int sum = 0;
		    while (k2.hasNext()) {
		        sum += k2.next().get();
		     }	
		    
		    k3.collect( k1 , new IntWritable(sum) );
		}
		
	}
	public static void main(String[] args) throws Exception 
	{
		if (args.length != 2) 
		{
			System.err.println("Usage: FileDemo1: <input path> <output path>");
			System.exit(-1);
		}
		
		JobConf conf = new JobConf(compressCodec.class);
		conf.setJobName( "demo3" );
		
		FileInputFormat.addInputPath( conf, new Path( args[0] ) );
		FileOutputFormat.setOutputPath( conf, new Path( args[1] ) );
		
		conf.setMapperClass( MyMapper.class );
		conf.setReducerClass( MyReducer.class );
		
		conf.setBoolean( "mapred.output.compress" , true );
		conf.setClass( "mapred.output.compression.codec" , GzipCodec.class , compressCodec.class );
		
		
		
		conf.setOutputKeyClass( Text.class );
		conf.setOutputValueClass( IntWritable.class );
		
		JobClient.runJob( conf );
	
	}
}