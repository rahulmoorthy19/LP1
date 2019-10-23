#include<iostream>
using namespace std;
__global__ void add(int *a,int*b,int *c,int n)
{
  int index=blockIdx.x*blockDim.x+threadIdx.x;
  if(index<n)
  {
    c[index]=a[index]+b[index];
  }
}

int main()
{
  cout<<"Enter size of vector";
  int n;
  cin>>n;
  int a[n],b[n],c[n];
  for(int i=0;i<n;i++)
  {
    cin>>a[i];
    b[i]=a[i];
  }
  int *ad,*bd,*cd;
  int size;
  size=n*sizeof(int);
  cudaMalloc(&ad,size);
  cudaMalloc(&bd,size);
  cudaMalloc(&cd,size);
  cudaMemcpy(ad,a,size,cudaMemcpyHostToDevice);
  cudaMemcpy(bd,b,size,cudaMemcpyHostToDevice);
  cudaEvent_t start,end;
  dim3 grid(256,1);
  dim3 block(32,1);
  cudaEventCreate(&start);
  cudaEventCreate(&end);
  cudaEventRecord(start);
  add <<<grid,block>>>(ad,bd,cd,n);
  cudaEventRecord(end);
  float time=0;
  cudaEventElapsedTime(&time,start,end);
  cudaMemcpy(c,cd,size,cudaMemcpyDeviceToHost);
  for(int i=0;i<n;i++)
  {
  cout<<c[i]<<endl;
  }
  cout<<"The time required is"<<time<<endl;

  }
