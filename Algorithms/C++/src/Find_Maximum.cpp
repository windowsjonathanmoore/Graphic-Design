//
//   This file contains the C++ code from Program 2.4 of
//   "Data Structures and Algorithms
//    with Object-Oriented Design Patterns in C++"
//   by Bruno R. Preiss.
//
//   Copyright (c) 1998, 2016 Jonathan Moore, Bruno R. Preiss, P.Eng.  All rights reserved.

#include <omp.h>

 int FindMaximum (int a [], int n)
{
    int result = a [0];

	#pragma omp parallel for
	for (int i = 1; i < n; ++i)
	{
		if (a[i] > result)
			result = a[i];
	}
	
    return result;
}
