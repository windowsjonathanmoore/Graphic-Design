//
//   This file contains the C++ code from Program 2.6 of
//   "Data Structures and Algorithms
//    with Object-Oriented Design Patterns in C++"
//   by Bruno R. Preiss.
//
//   Copyright (c) 1998 by Bruno R. Preiss, P.Eng.  All rights reserved.
//
//   Copyright (c) 2016 by Jonathan Moore.  All rights reserved.
//

#include <omp.h>
#include "Algorithms.h"

namespace Algorithms 
{

	int GeometricSeriesSum(int x, int n)
	{
		int sum = 0;

		#pragma omp parallel for
		for (int i = 0; i <= n; ++i)
		{
			int prod = 1;

			#pragma omp parallel for
			for (int j = 0; j < i; ++j)
			{
				prod *= x;
				sum += prod;
			}

		}
		return sum;
	}
}
