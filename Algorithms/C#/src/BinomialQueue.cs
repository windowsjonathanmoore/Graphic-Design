using System;
namespace algorithms
{
	
	// BinomialQueue class
	//
	// CONSTRUCTION: with a negative infinity sentinel
	//
	// ******************PUBLIC OPERATIONS*********************
	// void insert( x )       --> Insert x
	// Comparable deleteMin( )--> Return and remove smallest item
	// Comparable findMin( )  --> Return smallest item
	// boolean isEmpty( )     --> Return true if empty; else false
	// boolean isFull( )      --> Return true if full; else false
	// void makeEmpty( )      --> Remove all items
	// vod merge( rhs )       --> Absord rhs into this heap
	// ******************ERRORS********************************
	// Overflow if CAPACITY is exceeded
	
	/// <summary> Implements a binomial queue.
	/// Note that all "matching" is based on the compareTo method.
	/// </summary>
	/// <author>  Mark Allen Weiss, Jonathan Moore
	/// </author>
	public class BinomialQueue
	{
		/// <summary> Test if the priority queue is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return currentSize == 0;
			}
			
		}
		/// <summary> Test if the priority queue is logically full.</summary>
		/// <returns> true if full, false otherwise.
		/// </returns>
		virtual public bool Full
		{
			get
			{
				return currentSize == capacity();
			}
			
		}
		/// <summary> Construct the binomial queue.</summary>
		public BinomialQueue()
		{
			theTrees = new BinomialNode[MAX_TREES];
			makeEmpty();
		}
		
		/// <summary> Merge rhs into the priority queue.
		/// rhs becomes empty. rhs must be different from this.
		/// </summary>
		/// <param name="rhs">the other binomial queue.
		/// </param>
		/// <exception cref="Overflow">if result exceeds capacity.
		/// </exception>
		public virtual void  merge(BinomialQueue rhs)
		{
			if (this == rhs)
			// Avoid aliasing problems
				return ;
			
			if (currentSize + rhs.currentSize > capacity())
				throw new Overflow();
			
			currentSize += rhs.currentSize;
			
			BinomialNode carry = null;
			for (int i = 0, j = 1; j <= currentSize; i++, j *= 2)
			{
				BinomialNode t1 = theTrees[i];
				BinomialNode t2 = rhs.theTrees[i];
				
				int whichCase = t1 == null?0:1;
				whichCase += (t2 == null?0:2);
				whichCase += (carry == null?0:4);
				
				switch (whichCase)
				{
					
					case 0: 
					/* No trees */
					case 1:  /* Only this */
						break;
					
					case 2:  /* Only rhs */
						theTrees[i] = t2;
						rhs.theTrees[i] = null;
						break;
					
					case 4:  /* Only carry */
						theTrees[i] = carry;
						carry = null;
						break;
					
					case 3:  /* this and rhs */
						carry = combineTrees(t1, t2);
						theTrees[i] = rhs.theTrees[i] = null;
						break;
					
					case 5:  /* this and carry */
						carry = combineTrees(t1, carry);
						theTrees[i] = null;
						break;
					
					case 6:  /* rhs and carry */
						carry = combineTrees(t2, carry);
						rhs.theTrees[i] = null;
						break;
					
					case 7:  /* All three */
						theTrees[i] = carry;
						carry = combineTrees(t1, t2);
						rhs.theTrees[i] = null;
						break;
					}
			}
			
			for (int k = 0; k < rhs.theTrees.Length; k++)
				rhs.theTrees[k] = null;
			rhs.currentSize = 0;
		}
		
		/// <summary> Return the result of merging equal-sized t1 and t2.</summary>
		private static BinomialNode combineTrees(BinomialNode t1, BinomialNode t2)
		{
			if (t1.element.compareTo(t2.element) > 0)
				return combineTrees(t2, t1);
			t2.nextSibling = t1.leftChild;
			t1.leftChild = t2;
			return t1;
		}
		
		/// <summary> Insert into the priority queue, maintaining heap order.
		/// This implementation is not optimized for O(1) performance.
		/// </summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <exception cref="Overflow">if capacity exceeded.
		/// </exception>
		public virtual void  insert(Comparable x)
		{
			BinomialQueue oneItem = new BinomialQueue();
			oneItem.currentSize = 1;
			oneItem.theTrees[0] = new BinomialNode(x);
			
			merge(oneItem);
		}
		
		/// <summary> Find the smallest item in the priority queue.</summary>
		/// <returns> the smallest item, or null, if empty.
		/// </returns>
		public virtual Comparable findMin()
		{
			if (Empty)
				return null;
			
			return theTrees[findMinIndex()].element;
		}
		
		
		/// <summary> Find index of tree containing the smallest item in the priority queue.
		/// The priority queue must not be empty.
		/// </summary>
		/// <returns> the index of tree containing the smallest item.
		/// </returns>
		private int findMinIndex()
		{
			int i;
			int minIndex;
			
			for (i = 0; theTrees[i] == null; i++)
				;
			
			for (minIndex = i; i < theTrees.Length; i++)
				if (theTrees[i] != null && theTrees[i].element.compareTo(theTrees[minIndex].element) < 0)
					minIndex = i;
			
			return minIndex;
		}
		
		/// <summary> Remove the smallest item from the priority queue.</summary>
		/// <returns> the smallest item, or null, if empty.
		/// </returns>
		public virtual Comparable deleteMin()
		{
			if (Empty)
				return null;
			
			int minIndex = findMinIndex();
			Comparable minItem = theTrees[minIndex].element;
			
			BinomialNode deletedTree = theTrees[minIndex].leftChild;
			
			BinomialQueue deletedQueue = new BinomialQueue();
			deletedQueue.currentSize = (1 << minIndex) - 1;
			for (int j = minIndex - 1; j >= 0; j--)
			{
				deletedQueue.theTrees[j] = deletedTree;
				deletedTree = deletedTree.nextSibling;
				deletedQueue.theTrees[j].nextSibling = null;
			}
			
			theTrees[minIndex] = null;
			currentSize -= (deletedQueue.currentSize + 1);
			
			try
			{
				merge(deletedQueue);
			}
			catch (Overflow e)
			{
			}
			return minItem;
		}
		
		/// <summary> Make the priority queue logically empty.</summary>
		public virtual void  makeEmpty()
		{
			currentSize = 0;
			for (int i = 0; i < theTrees.Length; i++)
				theTrees[i] = null;
		}
		
		
		private const int MAX_TREES = 14;
		
		private int currentSize; // # items in priority queue
		private BinomialNode[] theTrees; // An array of tree roots
		
		
		/// <summary> Return the capacity.</summary>
		private int capacity()
		{
			return (1 << theTrees.Length) - 1;
		}
		
		[STAThread]
		public static void  Main(System.String[] args)
		{
			int numItems = 10000;
			BinomialQueue h = new BinomialQueue();
			BinomialQueue h1 = new BinomialQueue();
			int i = 37;
			
			System.Console.Out.WriteLine("Starting check.");
			try
			{
				for (i = 37; i != 0; i = (i + 37) % numItems)
					if (i % 2 == 0)
						h1.insert(new MyInteger(i));
					else
						h.insert(new MyInteger(i));
				
				h.merge(h1);
				for (i = 1; i < numItems; i++)
					if (((MyInteger) (h.deleteMin())).intValue() != i)
						System.Console.Out.WriteLine("Oops! " + i);
			}
			catch (Overflow e)
			{
				System.Console.Out.WriteLine("Unexpected overflow");
			}
			System.Console.Out.WriteLine("Check done.");
		}
	}
}