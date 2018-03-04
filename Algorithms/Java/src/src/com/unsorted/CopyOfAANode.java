    package com.algorithms;

    // Basic node stored in AVL trees
    // Note that this class is not accessible outside
    // of package DataStructures

    class CopyOfAANode
    {
            // Constructors
        CopyOfAANode( Comparable theElement )
        {
            this( theElement, null, null );
        }

        CopyOfAANode( Comparable theElement, CopyOfAANode lt, CopyOfAANode rt )
        {
            element  = theElement;
            left     = lt;
            right    = rt;
            level    = 1;
        }

            // Friendly data; accessible by other package routines
        Comparable element;      // The data in the node
        CopyOfAANode     left;         // Left child
        CopyOfAANode     right;        // Right child
        int        level;        // Level
    }
