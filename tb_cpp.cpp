// N tap fir filter in C++ 
// used to generate values for test vector files 

#include<iostream>
#include<stdlib.h>
using namespace std;
int main()
{
  int a[196], b[14],c[182];
    
  for(int i=0;i<=196;i++)
    a[i]=rand() % 10;

    for(int i=0;i<=182;i++)
        c[i]=0;
    
   for(int i=0;i<=14;i++)
   {b[i]=rand()%2;
       cout<<b[i]<<" ";
   }
    
    cout<<endl;
    cout<<"not the output \n";
 
 for(int i=0;i<=150;i++)
  for(int j=0;j<=14;j++)
        c[i]+=a[i+j]*b[j];

for(int i=0;i<=150;i++)
    cout<<c[i]<<" ";

     
}
