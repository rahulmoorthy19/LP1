public class wordcount{
  public static void main(String[] args) throws Exception
  {
    Job job=new Job()
    job.setJarByClass(wordcount.class);
    job.setJarName("Word Count");
    job.setMapperClass(wordmapper.class);
    job.setReducerClass(wordreduction.class);
    FileInputFormat.setInputPath(job,new Path(args[1]));
    FileOutputFormat.setOutputPath(job,new Path(args[1]));
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);
  }
}
