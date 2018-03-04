//
//   This file contains the C++ code from Program 3.1 of
//   "Data Structures and Algorithms
//    with Object-Oriented Design Patterns in C++"
//   by Bruno R. Preiss.
//
//   Copyright (c) 1998 by Bruno R. Preiss, P.Eng.  All rights reserved.
//
//	 Copyright (c) 2016 Joanthan Moore  All rights reserved
//
//   
//
#include <omp.h>
#include "Algorithms.h"

namespace Algorithms
{
	int Horner(int a[], int n, int x)
	{
		int result = a[n];

		#pragma omp parallel for
		for (int i = n - 1; i >= 0; --i)
		{
			result = result * x + a[i];
		}

		return result;
	}
}
