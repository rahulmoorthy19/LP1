#include<iostream>
using namespace std;
__global__ void add(int *a,int*b,int *c,int n)
{
  int row=blockIdx.x;
  int sum=0;
  for(int i=0;i<n;i++)
  {
    sum=sum+a[row*n+i]*b[i];
  }
  c[row]=sum;
}

int main()
{
  cout<<"Enter size of matrix";
  int n;
  cin>>n;
  int a[n][n],b[n],c[n];
  for(int i=0;i<n;i++)
  {
    for(int j=0;j<n;j++)
    {
    cin>>a[i][j];
  }
}
  cout<<"Enter the vector";
  for(int i=0;i<n;i++)
  {
    cin>>b[i];
  }
  int *ad,*bd,*cd;
  int size,size1;
  size=n*sizeof(int);
  size1=n*n*sizeof(int);
  cudaMalloc(&ad,size1);
  cudaMalloc(&bd,size);
  cudaMalloc(&cd,size);
  cudaMemcpy(ad,a,size1,cudaMemcpyHostToDevice);
  cudaMemcpy(bd,b,size,cudaMemcpyHostToDevice);
  cudaEvent_t start,end;
  dim3 grid(n,1);
  dim3 block(1,1);
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
