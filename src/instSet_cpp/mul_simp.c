int xmuly(int x,int y)
{
	if(x == 0)
	{
		return 1;
	}
	return xmuly(x-1,y)+y;
}
int main()
{
	int i;
	i = xmuly(0,2);
	return i;
}
