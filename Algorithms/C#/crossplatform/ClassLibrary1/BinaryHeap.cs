using System;
namespace algorithms
{
	
	// BinaryHeap class
	//
	// CONSTRUCTION: with optional capacity (that defaults to 100)
	//
	// ******************PUBLIC OPERATIONS*********************
	// void insert( x )       --> Insert x
	// Comparable deleteMin( )--> Return and remove smallest item
	// Comparable findMin( )  --> Return smallest item
	// boolean isEmpty( )     --> Return true if empty; else false
	// boolean isFull( )      --> Return true if full; else false
	// void makeEmpty( )      --> Remove all items
	// ******************ERRORS********************************
	// Throws Overflow if capacity exceeded
	
	/// <summary> Implements a binary heap.
	/// Note that all "matching" is based on the compareTo method.
	/// </summary>
	/// <author>  Mark Allen Weiss
	/// </author>
	public class BinaryHeap
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
				return currentSize == array.Length - 1;
			}
			
		}
		/// <summary> Construct the binary heap.</summary>
		public BinaryHeap():this(DEFAULT_CAPACITY)
		{
		}
		
		/// <summary> Construct the binary heap.</summary>
		/// <param name="capacity">the capacity of the binary heap.
		/// </param>
		public BinaryHeap(int capacity)
		{
			currentSize = 0;
			array = new Comparable[capacity + 1];
		}
		
		/// <summary> Insert into the priority queue, maintaining heap order.
		/// Duplicates are allowed.
		/// </summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <exception cref="Overflow">if container is full.
		/// </exception>
		public virtual void  insert(Comparable x)
		{
			if (Full)
				throw new Overflow();
			
			// Percolate up
			int hole = ++currentSize;
			for (; hole > 1 && x.compareTo(array[hole / 2]) < 0; hole /= 2)
				array[hole] = array[hole / 2];
			array[hole] = x;
		}
		
		/// <summary> Find the smallest item in the priority queue.</summary>
		/// <returns> the smallest item, or null, if empty.
		/// </returns>
		public virtual Comparable findMin()
		{
			if (Empty)
				return null;
			return array[1];
		}
		
		/// <summary> Remove the smallest item from the priority queue.</summary>
		/// <returns> the smallest item, or null, if empty.
		/// </returns>
		public virtual Comparable deleteMin()
		{
			if (Empty)
				return null;
			
			Comparable minItem = findMin();
			array[1] = array[currentSize--];
			percolateDown(1);
			
			return minItem;
		}
		
		/// <summary> Establish heap order property from an arbitrary
		/// arrangement of items. Runs in linear time.
		/// </summary>
		private void  buildHeap()
		{
			for (int i = currentSize / 2; i > 0; i--)
				percolateDown(i);
		}
		
		/// <summary> Make the priority queue logically empty.</summary>
		public virtual void  makeEmpty()
		{
			currentSize = 0;
		}
		
		private const int DEFAULT_CAPACITY = 100;
		
		private int currentSize; // Number of elements in heap
		private Comparable[] array; // The heap array
		
		/// <summary> Internal method to percolate down in the heap.</summary>
		/// <param name="hole">the index at which the percolate begins.
		/// </param>
		private void  percolateDown(int hole)
		{
			/* 1*/ int child;
			/* 2*/ Comparable tmp = array[hole];
			
			/* 3*/
			for (; hole * 2 <= currentSize; hole = child)
			{
				/* 4*/ child = hole * 2;
				/* 5*/
				if (child != currentSize && array[child + 1].compareTo(array[child]) < 0)
				/* 7*/
					child++;
				/* 8*/
				if (array[child].compareTo(tmp) < 0)
				/* 9*/
					array[hole] = array[child];
				/*10*/
				else
					break;
			}
			/*11*/ array[hole] = tmp;
		}
		
		// Test program
		[STAThread]
		public static void  Main(System.String[] args)
		{
			int numItems = 10000;
			BinaryHeap h = new BinaryHeap(numItems);
			int i = 37;
			
			try
			{
				for (i = 37; i != 0; i = (i + 37) % numItems)
					h.insert(new MyInteger(i));
				for (i = 1; i < numItems; i++)
					if (((MyInteger) (h.deleteMin())).intValue() != i)
						System.Console.Out.WriteLine("Oops! " + i);
				
				for (i = 37; i != 0; i = (i + 37) % numItems)
					h.insert(new MyInteger(i));
				h.insert(new MyInteger(0));
				i = 9999999;
				h.insert(new MyInteger(i));
				for (i = 1; i <= numItems; i++)
					if (((MyInteger) (h.deleteMin())).intValue() != i)
						System.Console.Out.WriteLine("Oops! " + i + " ");
			}
			catch (Overflow e)
			{
				System.Console.Out.WriteLine("Overflow (expected)! " + i);
			}
		}
	}
}