package com.gopal.demo;

import java.io.IOException;
import java.util.Iterator;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.MapReduceBase;
import org.apache.hadoop.mapred.OutputCollector;
import org.apache.hadoop.mapred.Reducer;
import org.apache.hadoop.mapred.Reporter;

public class MyReducer1 extends MapReduceBase implements Reducer<Text, Text, Text, Text>
{

	@Override
	public void reduce(Text k1, Iterator<Text> k2,
			OutputCollector<Text, Text> k3, Reporter k4) throws IOException {
		
		  String comment="Fair"; 
		
		  String result="";
	      while (k2.hasNext()) {
	        result = result+ k2.next().toString();
	      }
	      
	      if( Float.parseFloat(result)>=80 && Float.parseFloat(result)<=100 )
	      {
	    	  comment="Very Good";
	      }
	      else if ( Float.parseFloat(result)>=70 && Float.parseFloat(result)<80 ) 
	      {
			  comment="Good";
		  }
	      else if ( Float.parseFloat(result)>=60 && Float.parseFloat(result)<70 ) 
	      {
	    	  comment="Fair";  
		  }
	      else if ( Float.parseFloat(result)>=50 && Float.parseFloat(result)<60 ) 
	      {
	    	  comment="Satisfactory";  
		  }
	      else 
	      {
			  comment="Fail";
		  }
	      
	      
	      k3.collect( k1,  new Text( comment ) );
	}
	
}




