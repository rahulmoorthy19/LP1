#include<iostream>
using namespace std;
__global__ void add(int *a,int*b,int *c,int n)
{
  int row=blockIdx.y*blockDim.y+threadIdx.y;
  int col=blockIdx.x*blockDim.x+threadIdx.x;
  int sum=0;
  for(int i=0;i<n;i++)
  {
    sum=sum+a[row*n+i]*b[i*n+col];
  }
  c[row*n+col]=sum;
}

int main()
{
  cout<<"Enter size of matrix";
  int n;
  cin>>n;
  int a[n][n],b[n][n],c[n][n];
  for(int i=0;i<n;i++)
  {
    for(int j=0;j<n;j++)
    {
    cin>>a[i][j];
  }
}
  cout<<"Enter the 2nd matrix";
  for(int i=0;i<n;i++)
  {
    for(int j=0;j<n;j++)
    {
    cin>>b[i][j];
  }
}
  int *ad,*bd,*cd;
  int size;
  size=n*n*sizeof(int);
  cudaMalloc(&ad,size);
  cudaMalloc(&bd,size);
  cudaMalloc(&cd,size);
  cudaMemcpy(ad,a,size,cudaMemcpyHostToDevice);
  cudaMemcpy(bd,b,size,cudaMemcpyHostToDevice);
  cudaEvent_t start,end;
  dim3 grid(n,n,n);
  dim3 block(1,1,1);
  cudaEventCreate(&start);
  cudaEventCreate(&end);
  cudaEventRecord(start);
  add <<<grid,size>>>(ad,bd,cd,n);
  cudaEventRecord(end);
  float time=0;
  cudaEventElapsedTime(&time,start,end);
  cudaMemcpy(c,cd,size,cudaMemcpyDeviceToHost);

  	for(int i=0;i<n;i++)
  	{
  		for(int j=0;j<n;j++)
  		{
  		cout<<c[i][j]<<" ";
  		}
  		cout<<endl;
  	}
  cout<<"The time required is"<<time<<endl;

  }
