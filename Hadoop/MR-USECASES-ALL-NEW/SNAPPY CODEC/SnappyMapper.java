package com.compress.snappy;

import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.Mapper;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reporter;

public class SnappyMapper extends MapReduceBase implements Mapper<LongWritable, Text, Text, IntWritable>
{

	
	public void map(LongWritable k1, Text k2,
			OutputCollector<Text, IntWritable> k3, Reporter k4)
			throws IOException 
	{
		String line = k2.toString();
		
		StringTokenizer itr = new StringTokenizer(line, "#");//Iterating for every separate words in the line.
	      
	    String player=itr.nextToken();  //it gives the name of the batsman.
	    String playerRun=itr.nextToken(); //it gives the runs scored in a particular match by that batsman.
	    String word = itr.nextToken();
	    String country = itr.nextToken();
	    String playername = player + word + country;
	    IntWritable run=new IntWritable( Integer.parseInt(playerRun) );//typecasted as required by the framework.
	    k3.collect( new Text(playername) , run);//Mapper output<-->Reducer input.
	}

	
}

