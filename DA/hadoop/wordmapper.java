public class wordmapper extends Mapper<LongWritable,Text,Text,IntWritable>{
  @override
  public void map(LongWritable key,Text value,Context context)
  {
    String line=value.toString();
    for(String word:line.split("\\W+")){
      if (word.length()>0)
      {
        context.write(new Text(word),new IntWritable(1))
      }
    }
  }

}
