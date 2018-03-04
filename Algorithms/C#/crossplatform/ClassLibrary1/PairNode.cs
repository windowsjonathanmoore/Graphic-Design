using System;
namespace algorithms
{
	
	/// <summary> Public class for use with PairHeap. It is public
	/// only to allow references to be sent to decreaseKey.
	/// It has no public methods or members.
	/// </summary>
	/// <author>  Mark Allen Weiss, Jonathan Moore
	/// </author>
	/// <seealso cref="PairHeap">
	/// </seealso>
	public class PairNode
	{
		/// <summary> Construct the PairNode.</summary>
		/// <param name="theElement">the value stored in the node.
		/// </param>
		internal PairNode(Comparable theElement)
		{
			element = theElement;
			leftChild = null;
			nextSibling = null;
			prev = null;
		}
		
		// Friendly data; accessible by other package routines
		internal Comparable element;
		internal PairNode leftChild;
		internal PairNode nextSibling;
		internal PairNode prev;
	}
}