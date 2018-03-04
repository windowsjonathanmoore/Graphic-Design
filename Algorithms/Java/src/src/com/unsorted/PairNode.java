    package com.algorithms;

    /**
     * Public class for use with PairHeap. It is public
     * only to allow references to be sent to decreaseKey.
     * It has no public methods or members.
     * @author Mark Allen Weiss, Jonathan Moore
     * @see PairHeap
     */
    public class PairNode
    {
        /**
         * Construct the PairNode.
         * @param theElement the value stored in the node.
         */
        PairNode( Comparable theElement )
        {
            element     = theElement;
            leftChild   = null;
            nextSibling = null;
            prev        = null;
        }

            // Friendly data; accessible by other package routines
        Comparable element;
        PairNode   leftChild;
        PairNode   nextSibling;
        PairNode   prev;
    }
