//
//   This file contains the C++ code from Program 3.3 of
//   "Data Structures and Algorithms
//    with Object-Oriented Design Patterns in C++"
//   by Bruno R. Preiss.
//
//   Copyright (c) 1998 by Bruno R. Preiss, P.Eng.  All rights reserved.
//
//   Copyright (c) 2016 Jonathan Moore  All rights reserved.
//

#include <omp.h>
#include "Algorithms.h"

namespace Algorithms
{ 

int Fibonacci (int n)
{
    int previous = -1;
    int result = 1;

	#pragma omp parallel for
    for (int i = 0; i <= n; ++i)
    {
		int const sum = result + previous;
		previous = result;
		result = sum;
    }
    return result;

}

}
