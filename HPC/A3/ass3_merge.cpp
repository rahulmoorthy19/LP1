#include<iostream>
#include<chrono>
#include "omp.h"
using namespace std;
using namespace std::chrono;

void merge(int a[],int low,int middle,int middle1,int high)
{
  int temp[100];
  int k=0;
  int s1=low;
  int s2=middle1;
  while(s1<=middle && s2<=high)
  {
      if(a[s1]<a[s2])
      {
        temp[k++]=a[s1++];
      }
      else
      {
        temp[k++]=a[s2++];
      }
  }
  while(s1<=middle)
  {
    temp[k++]=a[s1++];
  }
  while(s2<=high)
  {
    temp[k++]=a[s2++];
  }
  int i,j;
  for(i=low,j=0;i<=high;i++,j++)
  {
    a[i]=temp[j];
  }
}

void merge_serial(int a[],int low,int high)
{
  if(low<high)
  {
    int middle=(low+high)/2;
    merge_serial(a,low,middle);
    merge_serial(a,middle+1,high);
    merge(a,low,middle,middle+1,high);
  }
}
void merge_parallel(int a[],int low,int high)
{
  if(low<high)
  {
    int middle=(low+high)/2;
  #pragma omp parallel sections
  {
    #pragma omp  section
    {
      merge_serial(a,low,middle);
    }
    #pragma omp  section
    {
      merge_serial(a,middle+1,high);
    }
  }
    merge(a,low,middle,middle+1,high);
  }
}

int main()
{
  time_point<system_clock> start,end;
  int n;
  cout<<"Enter the size of the array you want to sort:";
  cin>>n;
  int a[1000];
  for(int i=0;i<n;i++)
  {
    a[i]=n%100;
  }
  start=system_clock::now();
  merge_serial(a,0,n-1);
  end=system_clock::now();
  duration<double> time=end-start;
  cout<<"The time taken for serial sorting is:"<<time.count()*1000;
  omp_set_num_threads(2);
  start=system_clock::now();
  merge_parallel(a,0,n-1);
  end=system_clock::now();
  duration<double> time1=end-start;
  cout<<"The time taken for parallel sorting is:"<<time1.count()*1000;
}
