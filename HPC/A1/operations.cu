#include<iostream>
using namespace std;
#define size 256
#define ssize size*4

__global__ void max_reduction(int *v,int *v_r)
{
  __shared__ int partial_sum[ssize];
  int tid=blockIdx.x*blockDim.x+threadIdx.x;
  partial_sum[threadIdx.x]=v[tid];
  __syncthreads();
  for(int i=blockDim.x/2;i>0;i=i/2)
  {
    if(threadIdx.x<i)
    {
      partial_sum[threadIdx.x]=max(partial_sum[threadIdx.x],partial_sum[threadIdx.x+i]);
    }
    __syncthreads();
  }
  if(threadIdx.x==0)
  {
    v_r[blockIdx.x]=partial_sum[0];
  }
}

__global__ void min_reduction(int *v,int *v_r)
{
  __shared__ int partial_sum[ssize];
  int tid=blockIdx.x*blockDim.x+threadIdx.x;
  partial_sum[threadIdx.x]=v[tid];
  __syncthreads();
  for(int i=blockDim.x/2;i>0;i=i/2)
  {
    if(threadIdx.x<i)
    {
      partial_sum[threadIdx.x]=min(partial_sum[threadIdx.x],partial_sum[threadIdx.x+i]);
    }
    __syncthreads();
  }
  if(threadIdx.x==0)
  {
    v_r[blockIdx.x]=partial_sum[0];
  }
}

__global__ void sum_reduction(int *v,int *v_r)
{
  __shared__ int partial_sum[ssize];
  int tid=blockIdx.x*blockDim.x+threadIdx.x;
  partial_sum[threadIdx.x]=v[tid];
  __syncthreads();
  for(int i=blockDim.x/2;i>0;i=i/2)
  {
    if(threadIdx.x<i)
    {
      partial_sum[threadIdx.x]+=partial_sum[threadIdx.x+i];
    }
    __syncthreads();
  }
  if(threadIdx.x==0)
  {
    v_r[blockIdx.x]=partial_sum[0];
  }
}

__global__ void variance_reduction(int *v,int *v_r,float *mean)
{
  __shared__ int partial_sum[ssize];
  int tid=blockIdx.x*blockDim.x+threadIdx.x;
  partial_sum[threadIdx.x]=v[tid];
  __syncthreads();
  partial_sum[threadIdx.x]=(partial_sum[threadIdx.x]-*mean)*(partial_sum[threadIdx.x]-*mean);
  __syncthreads();
  for(int i=blockDim.x/2;i>0;i=i/2)
  {
    if(threadIdx.x<i)
    {
      partial_sum[threadIdx.x]+=partial_sum[threadIdx.x+i];
    }
    __syncthreads();
  }
  if(threadIdx.x==0)
  {
    v_r[blockIdx.x]=partial_sum[0];
  }
}

int main()
{
  int n = size*size;
  int blockthread=size;
  int no_block=n/blockthread;
  int *a;
  int *a_gpu;
  int *b_gpu;
  int *b;
  float time;

  cudaMalloc(&a_gpu,n*sizeof(int));
  cudaMalloc(&b_gpu,no_block*sizeof(int));
  a=(int*)malloc(n*sizeof(int));
  b=(int*)malloc(no_block*sizeof(int));
  for(int i =0;i<n;i++){
    a[i]= rand()%1000;
  }
  cudaMemcpy(a_gpu,a,n*sizeof(int),cudaMemcpyHostToDevice);
  cudaEvent_t start,stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  cudaEventRecord(start);
  max_reduction<<<no_block,blockthread>>>(a_gpu,b_gpu);
  max_reduction<<<1,blockthread>>>(b_gpu,b_gpu);
  cudaMemcpy(b,b_gpu,blockthread*sizeof(int),cudaMemcpyDeviceToHost);
  cudaEventRecord(stop);
  cudaEventElapsedTime(&time,start,stop);
  cout<<b[0]<<"\n";
  cout<<time;
}
