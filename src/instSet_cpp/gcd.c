int gcd(int x,int y)
{

	if(x==0) return y;
	if(y==0) return x;
	if(x < y)return gcd(y-x,x);
	return gcd(x-y,y);
}
int main()
{
	int i;
	i = gcd(7, 1);
	return i;
}
