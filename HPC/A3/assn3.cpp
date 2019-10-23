//Bubble Sort
#include<iostream>
#include<chrono>
#include "omp.h"
using namespace std;
using namespace std::chrono;
void serial_bubble(int a[],int b)
{
  for(int i=0;i<b;i++)
  {
    for(int j=0;j<b;j++)
    {
      if(a[j]>a[j+1])
      {
        int temp;
        temp=a[j];
        a[j]=a[j+1];
        a[j+1]=temp;
      }
    }
  }
  cout<<"\n";
  cout<<"The sorted array after serial bubble sort is:\n";
  for(int i=0;i<b;i++)
  {
    cout<<"\t"<<a[i];
  }
}

void parallel_bubble(int a[],int b)
{
  time_point<system_clock> start,end;

  omp_set_num_threads(2);
  int first=0;
  start=system_clock::now();
  for(int i=0;i<b;i++)
  {
    first=i%2;
    #pragma omp parallel for default(none),shared(a,first,b)
    for(int j=first;j<b-1;j+=2)
    {
      if(a[j]>a[j+1])
      {
        int temp;
        temp=a[j];
        a[j]=a[j+1];
        a[j+1]=temp;
      }
    }
  }
  end=start=system_clock::now();
  duration<double> time=end-start;
  float time_taken=time.count()*1000
  cout<<"\n";
  cout<<"The sorted array after serial bubble sort is:\n";
  for(int i=0;i<b;i++)
  {
    cout<<"\t"<<a[i];
  }
}

int main()
{
  cout<<"Enter the size of the array to be sorted";
  int n;
  cin>>n;
  int a[n];
  for(int i=0;i<n;i++)
  {
    cin>>a[i];
  }
  parallel_bubble(a,n);
}
