package com.gopal.compressTest;

import java.io.IOException;
import java.util.Iterator;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reducer;
import org.apache.hadoop.mapred.Reporter;

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

