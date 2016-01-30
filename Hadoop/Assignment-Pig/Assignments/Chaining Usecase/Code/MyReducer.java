package com.gopal.demo;

import java.io.IOException;
import java.util.Iterator;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reducer;
import org.apache.hadoop.mapred.Reporter;

public class MyReducer extends MapReduceBase implements Reducer<Text, IntWritable, Text, Text>
{

	@Override
	public void reduce(Text k1, Iterator<IntWritable> k2,
			OutputCollector<Text, Text> k3, Reporter k4) throws IOException {
		
		  float sum = 0, count=0 ,average=0;
		  		  
	      while (k2.hasNext()) {
	        sum += k2.next().get();
	        count++;
	      }
	      
	      average = (sum/count);
	      String averageString = ""+average;
	      //sum: Total runs scored by that particular batsman in the tournament.
	      k3.collect( k1, new Text( averageString ));
	      //Final output from the Reducer, that is the total runs scored by each batsman in the tournament.
		
	}
	
}
