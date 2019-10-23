public class wordreduction extends Reducer<IntWritable,Text,IntWritable,Text>{
  @override
  public void reduce(Text keys,Iterable<IntWritable> values,Context context)
  {
    int wordcount=0;
    for(int value:values)
    {
      wordcount+=value.get();
    }
    context.write(key,new IntWritable(wordcount))
  }
}
