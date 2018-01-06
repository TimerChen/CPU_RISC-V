#include "io.h"
void solve(int n)
{
	for(int i=0;i<n;++i)
	{
		for(int j=0;j<=i;++j)
			print("*");
		print("\n");
	}
}
int main()
{
	solve(6);
	return 0;
}
