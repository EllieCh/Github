package com.mapred.custompart;

import java.io.IOException;

	import org.apache.hadoop.conf.Configuration;
	import org.apache.hadoop.fs.FileSystem;
	import org.apache.hadoop.fs.Path;
	import org.apache.hadoop.io.IntWritable;
	import org.apache.hadoop.io.Text;
	import org.apache.hadoop.mapreduce.Job;
	import org.apache.hadoop.mapreduce.Mapper;
	import org.apache.hadoop.mapreduce.Partitioner;
	import org.apache.hadoop.mapreduce.Reducer;
	import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
	import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
	import org.apache.hadoop.util.Tool;
	import org.apache.hadoop.util.ToolRunner;

public class customPartition  {

	   
		public static class PartitionMapper extends	Mapper<Object, Text, Text, Text> {

					public void map(Object key, Text value, Context context)throws IOException, InterruptedException {

				String[] tokens = value.toString().split("\t");

				String gender = tokens[2].toString();
				String nameAgeScore = tokens[0]+"\t"+tokens[1]+"\t"+tokens[3];
				
				context.write(new Text(gender), new Text(nameAgeScore));
			}
		}

		//AgePartitioner is a custom Partitioner to partition the data according to age.
		//The age is a part of the value from the input file.
		//The data is partitioned based on the range of the age.
		//In this example, there are 3 partitions, the first partition contains the information where the age is less than 20
		//The second partition contains data with age ranging between 20 and 50 and the third partition contains data where the age is >50.
		public static class AgePartitioner extends Partitioner<Text, Text> {

			
			public int getPartition(Text key, Text value, int numReduceTasks) {

				String [] nameAgeScore = value.toString().split("\t");
				String age = nameAgeScore[1];
				int ageInt = Integer.parseInt(age);
				
				

				//if the age is <20, assign partition 0
				if(ageInt <=20){				
					return 0;
				}
				//else if the age is between 20 and 50, assign partition 1
				if(ageInt >20 && ageInt <=50){
					
					return 1 % numReduceTasks;
				}
				//otherwise assign partition 2
				else
					return 2 % numReduceTasks;
				
			}
		}
		
		//The data belonging to the same partition go to the same reducer. In a particular partition, all the values with the same key are iterated and the person with the maximum score is found.
		//Therefore the output of the reducer will contain the male and female maximum scorers in each of the 3 age categories.

		// the type parameters are the input keys type, the input values type, the
		// output keys type, the output values type

		static class ParitionReducer extends Reducer<Text, Text, Text, Text>
	{

			@Override
			public void reduce(Text key, Iterable<Text> values, Context context)
					throws IOException, InterruptedException 
					{

				int maxScore = Integer.MIN_VALUE;
				
				String name = " ";
				String age = " ";
				String gender = " ";
				int score = 0;
				//iterating through the values corresponding to a particular key
				for(Text val: values){
				
					String [] valTokens = val.toString().split("\t");
					score = Integer.parseInt(valTokens[2]);
				
	                //if the new score is greater than the current maximum score, update the fields as they will be the output of the reducer after all the values are processed for a particular key			
	   			    if(score > maxScore){
						name = valTokens[0];
						age = valTokens[1];
						gender = key.toString();
	                    maxScore = score;
					}
				}
				context.write(new Text(name), new Text("age- "+age+"\t"+gender+"\tscore-"+maxScore));
			}
		}

		
		
		

		public static void main(String[] args) throws Exception {

			Configuration conf = new Configuration();
		    Job job = new Job(conf, "word count");
		    job.setJarByClass(customPartition.class);
		    job.setNumReduceTasks(3);
		    
		    job.setMapperClass(PartitionMapper.class);
		    job.setPartitionerClass(AgePartitioner.class);
		    job.setReducerClass(ParitionReducer.  class);

		    job.setOutputKeyClass(Text.class);
		    job.setOutputValueClass(Text.class);
		    
		    FileInputFormat.addInputPath(job, new Path(args[0]));
		    FileOutputFormat.setOutputPath(job, new Path(args[1]));

		    System.exit(job.waitForCompletion(true) ? 0 : 1);
		}
}
