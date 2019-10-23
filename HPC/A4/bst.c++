#include<cstdio>
#include<mpi.h>
#include<iostream>
#include<chrono>
#include<unistd.h>

#include "time.h"

using namespace std::chrono;
using namespace std;
void binary_search(int a[],int low,int high,int rank,int key)
{
  int flag=0;
  while(low<=high)
  {

    int middle=(low+high)/2;
    if(key==a[middle])
    {
      cout<<"Element found at position"<<middle<<" by process"<<rank+1;
      flag=1;
    }
    else
    if(key>middle)
    {
      low=middle+1;
    }
    else
    if(key<middle)
    {
      high=middle-1;
    }
  }
  if(flag==0)
  {
  cout<<"Not found";
  }
}
int main(int argc,char **argv)
{
  double c[4];
  int n;
  cout<<"Enter the size of the array";
  cin>>n;
  cout<<"Enter the array in sorted form";
  int a[n];
  for(int i=0;i<n;i++)
  {
    cin>>a[i];
  }
  int key;
  cout<<"Enter the key you want to search for?";
  cin>>key;
  MPI_Init(&argc,&argv);
  int rank,size;
  MPI_Comm_size(MPI_COMM_WORLD,&size);
  MPI_Comm_rank(MPI_COMM_WORLD,&rank);
  int blocksize=n/4;
  int blocks=4;
  if(rank==0)
  {
    double start=MPI_Wtime();
    binary_search(a,rank*blocksize,(rank+1)*blocksize,rank,key);
    double end=MPI_Wtime();
    cout<<"The time for process 1 is "<<(end-start)*1000<<endl;
		c[rank]=end;
  }
  if(rank==1)
  {
    double start=MPI_Wtime();
    binary_search(a,rank*blocksize,(rank+1)*blocksize,rank,key);
    double end=MPI_Wtime();
    cout<<"The time for process 2 is "<<(end-start)*1000<<endl;
		c[rank]=end;
  }
  if(rank==2)
  {
    double start=MPI_Wtime();
    binary_search(a,rank*blocksize,(rank+1)*blocksize,rank,key);
    double end=MPI_Wtime();
    cout<<"The time for process 3 is "<<(end-start)*1000<<endl;
		c[rank]=end;
  }
  if(rank==3)
  {
    double start=MPI_Wtime();
    binary_search(a,rank*blocksize,(rank+1)*blocksize,rank,key);
    double end=MPI_Wtime();
    cout<<"The time for process 4 is "<<(end-start)*1000<<endl;
		c[rank]=end;
  }
  MPI_Finalize();
}
