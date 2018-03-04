package com.search;

public class SequentialSearch2
{
	
	public static int search(String key, String[] a)
	{
	for (int i = 0; i < a.length; i++)
		if ( a[i].compareTo(key) == 0 ) return i;
	return -1;
	}
}
