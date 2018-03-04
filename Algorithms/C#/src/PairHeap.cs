using System;
namespace algorithms
{
	
	// PairHeap class
	//
	// CONSTRUCTION: with no initializer
	//
	// ******************PUBLIC OPERATIONS*********************
	// PairNode insert( x )   --> Insert x, return position
	// Comparable deleteMin( )--> Return and remove smallest item
	// Comparable findMin( )  --> Return smallest item
	// boolean isEmpty( )     --> Return true if empty; else false
	// void makeEmpty( )      --> Remove all items
	// void decreaseKey( PairNode p, newVal )
	//                        --> Decrease value in node p
	
	/// <summary> Implements a pairing heap.
	/// Supports a decreaseKey operation.
	/// Note that all "matching" is based on the compareTo method.
	/// </summary>
	/// <author>  Mark Allen Weiss Jonathan moore
	/// </author>
	/// <seealso cref="PairNode">
	/// </seealso>
	public class PairHeap
	{
		/// <summary> Test if the priority queue is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return root == null;
			}
			
		}
		/// <summary> Construct the pairing heap.</summary>
		public PairHeap()
		{
			root = null;
		}
		
		/// <summary> Insert into the priority queue, and return a PairNode
		/// that can be used by decreaseKey.
		/// Duplicates are allowed.
		/// </summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <returns> the node containing the newly inserted item.
		/// </returns>
		public virtual PairNode insert(Comparable x)
		{
			PairNode newNode = new PairNode(x);
			
			if (root == null)
				root = newNode;
			else
				root = compareAndLink(root, newNode);
			return newNode;
		}
		
		/// <summary> Find the smallest item in the priority queue.</summary>
		/// <returns> the smallest item, or null if empty.
		/// </returns>
		public virtual Comparable findMin()
		{
			if (Empty)
				return null;
			return root.element;
		}
		
		/// <summary> Remove the smallest item from the priority queue.</summary>
		/// <returns> the smallest item, or null if empty.
		/// </returns>
		public virtual Comparable deleteMin()
		{
			if (Empty)
				return null;
			
			Comparable x = findMin();
			if (root.leftChild == null)
				root = null;
			else
				root = combineSiblings(root.leftChild);
			
			return x;
		}
		
		/// <summary> Change the value of the item stored in the pairing heap.
		/// Does nothing if newVal is larger than the currently stored value.
		/// </summary>
		/// <param name="p">any node returned by addItem.
		/// </param>
		/// <param name="newVal">the new value, which must be smaller
		/// than the currently stored value.
		/// </param>
		public virtual void  decreaseKey(PairNode p, Comparable newVal)
		{
			if (p.element.compareTo(newVal) < 0)
				return ; // newVal cannot be bigger
			p.element = newVal;
			if (p != root)
			{
				if (p.nextSibling != null)
					p.nextSibling.prev = p.prev;
				if (p.prev.leftChild == p)
					p.prev.leftChild = p.nextSibling;
				else
					p.prev.nextSibling = p.nextSibling;
				
				p.nextSibling = null;
				root = compareAndLink(root, p);
			}
		}
		
		/// <summary> Make the priority queue logically empty.</summary>
		public virtual void  makeEmpty()
		{
			root = null;
		}
		
		private PairNode root;
		
		/// <summary> Internal method that is the basic operation to maintain order.
		/// Links first and second together to satisfy heap order.
		/// </summary>
		/// <param name="first">root of tree 1, which may not be null.
		/// first.nextSibling MUST be null on entry.
		/// </param>
		/// <param name="second">root of tree 2, which may be null.
		/// </param>
		/// <returns> result of the tree merge.
		/// </returns>
		private PairNode compareAndLink(PairNode first, PairNode second)
		{
			if (second == null)
				return first;
			
			if (second.element.compareTo(first.element) < 0)
			{
				// Attach first as leftmost child of second
				second.prev = first.prev;
				first.prev = second;
				first.nextSibling = second.leftChild;
				if (first.nextSibling != null)
					first.nextSibling.prev = first;
				second.leftChild = first;
				return second;
			}
			else
			{
				// Attach second as leftmost child of first
				second.prev = first;
				first.nextSibling = second.nextSibling;
				if (first.nextSibling != null)
					first.nextSibling.prev = first;
				second.nextSibling = first.leftChild;
				if (second.nextSibling != null)
					second.nextSibling.prev = second;
				first.leftChild = second;
				return first;
			}
		}
		
		private PairNode[] doubleIfFull(PairNode[] array, int index)
		{
			if (index == array.Length)
			{
				PairNode[] oldArray = array;
				
				array = new PairNode[index * 2];
				for (int i = 0; i < index; i++)
					array[i] = oldArray[i];
			}
			return array;
		}
		
		// The tree array for combineSiblings
		private PairNode[] treeArray = new PairNode[5];
		
		/// <summary> Internal method that implements two-pass merging.</summary>
		/// <param name="firstSibling">the root of the conglomerate;
		/// assumed not null.
		/// </param>
		private PairNode combineSiblings(PairNode firstSibling)
		{
			if (firstSibling.nextSibling == null)
				return firstSibling;
			
			// Store the subtrees in an array
			int numSiblings = 0;
			for (; firstSibling != null; numSiblings++)
			{
				treeArray = doubleIfFull(treeArray, numSiblings);
				treeArray[numSiblings] = firstSibling;
				firstSibling.prev.nextSibling = null; // break links
				firstSibling = firstSibling.nextSibling;
			}
			treeArray = doubleIfFull(treeArray, numSiblings);
			treeArray[numSiblings] = null;
			
			// Combine subtrees two at a time, going left to right
			int i = 0;
			for (; i + 1 < numSiblings; i += 2)
				treeArray[i] = compareAndLink(treeArray[i], treeArray[i + 1]);
			
			int j = i - 2;
			
			// j has the result of last compareAndLink.
			// If an odd number of trees, get the last one.
			if (j == numSiblings - 3)
				treeArray[j] = compareAndLink(treeArray[j], treeArray[j + 2]);
			
			// Now go right to left, merging last tree with
			// next to last. The result becomes the new last.
			for (; j >= 2; j -= 2)
				treeArray[j - 2] = compareAndLink(treeArray[j - 2], treeArray[j]);
			
			return treeArray[0];
		}
		
		// Test program
		[STAThread]
		public static void  Main(System.String[] args)
		{
			PairHeap h = new PairHeap();
			int numItems = 10000;
			int i = 37;
			int j;
			
			System.Console.Out.WriteLine("Checking; no bad output is good");
			for (i = 37; i != 0; i = (i + 37) % numItems)
				h.insert(new MyInteger(i));
			for (i = 1; i < numItems; i++)
				if (((MyInteger) (h.deleteMin())).intValue() != i)
					System.Console.Out.WriteLine("Oops! " + i);
			
			PairNode[] p = new PairNode[numItems];
			for (i = 0, j = numItems / 2; i < numItems; i++, j = (j + 71) % numItems)
				p[j] = h.insert(new MyInteger(j + numItems));
			for (i = 0, j = numItems / 2; i < numItems; i++, j = (j + 53) % numItems)
				h.decreaseKey(p[j], new MyInteger(((MyInteger) p[j].element).intValue() - numItems));
			i = - 1;
			while (!h.Empty)
				if (((MyInteger) (h.deleteMin())).intValue() != ++i)
					System.Console.Out.WriteLine("Oops! " + i + " ");
			System.Console.Out.WriteLine("Check completed");
		}
	}
}