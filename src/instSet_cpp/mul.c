int xmuly(int x,int y)
{
	if(x == 0)
	{
		return 0;
	}
	return xmuly(x-1,y)+y;
}
int main()
{
	int i;
	i = 200 + xmuly(11,3);
	return i;
}
