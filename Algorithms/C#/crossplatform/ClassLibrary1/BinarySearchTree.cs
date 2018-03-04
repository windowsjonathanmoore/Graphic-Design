using System;
namespace algorithms
{
	
	// BinarySearchTree class
	//
	// CONSTRUCTION: with no initializer
	//
	// ******************PUBLIC OPERATIONS*********************
	// void insert( x )       --> Insert x
	// void remove( x )       --> Remove x
	// Comparable find( x )   --> Return item that matches x
	// Comparable findMin( )  --> Return smallest item
	// Comparable findMax( )  --> Return largest item
	// boolean isEmpty( )     --> Return true if empty; else false
	// void makeEmpty( )      --> Remove all items
	// void printTree( )      --> Print tree in sorted order
	
	/// <summary> Implements an unbalanced binary search tree.
	/// Note that all "matching" is based on the compareTo method.
	/// </summary>
	/// <author>  Jonathan Moore
	/// </author>
	public class BinarySearchTree
	{
		/// <summary> Test if the tree is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return root == null;
			}
			
		}
		/// <summary> Construct the tree.</summary>
		public BinarySearchTree()
		{
			root = null;
		}
		
		/// <summary> Insert into the tree; duplicates are ignored.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		public virtual void  insert(Comparable x)
		{
			root = insert(x, root);
		}
		
		/// <summary> Remove from the tree. Nothing is done if x is not found.</summary>
		/// <param name="x">the item to remove.
		/// </param>
		public virtual void  remove(Comparable x)
		{
			root = remove(x, root);
		}
		
		/// <summary> Find the smallest item in the tree.</summary>
		/// <returns> smallest item or null if empty.
		/// </returns>
		public virtual Comparable findMin()
		{
			return elementAt(findMin(root));
		}
		
		/// <summary> Find the largest item in the tree.</summary>
		/// <returns> the largest item of null if empty.
		/// </returns>
		public virtual Comparable findMax()
		{
			return elementAt(findMax(root));
		}
		
		/// <summary> Find an item in the tree.</summary>
		/// <param name="x">the item to search for.
		/// </param>
		/// <returns> the matching item or null if not found.
		/// </returns>
		public virtual Comparable find(Comparable x)
		{
			return elementAt(find(x, root));
		}
		
		/// <summary> Make the tree logically empty.</summary>
		public virtual void  makeEmpty()
		{
			root = null;
		}
		
		/// <summary> Print the tree contents in sorted order.</summary>
		public virtual void  printTree()
		{
			if (Empty)
				System.Console.Out.WriteLine("Empty tree");
			else
				printTree(root);
		}
		
		/// <summary> Internal method to get element field.</summary>
		/// <param name="t">the node.
		/// </param>
		/// <returns> the element field or null if t is null.
		/// </returns>
		private Comparable elementAt(BinaryNode t)
		{
			return t == null?null:t.element;
		}
		
		/// <summary> Internal method to insert into a subtree.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> the new root.
		/// </returns>
		private BinaryNode insert(Comparable x, BinaryNode t)
		{
			/* 1*/
			if (t == null)
			/* 2*/
				t = new BinaryNode(x, null, null);
			/* 3*/
			else if (x.compareTo(t.element) < 0)
			/* 4*/
				t.left = insert(x, t.left);
			/* 5*/
			else if (x.compareTo(t.element) > 0)
			/* 6*/
				t.right = insert(x, t.right);
			/* 7*/
			/* 8*/
			else
			{
			} // Duplicate; do nothing
			/* 9*/ return t;
		}
		
		/// <summary> Internal method to remove from a subtree.</summary>
		/// <param name="x">the item to remove.
		/// </param>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> the new root.
		/// </returns>
		private BinaryNode remove(Comparable x, BinaryNode t)
		{
			if (t == null)
				return t; // Item not found; do nothing
			if (x.compareTo(t.element) < 0)
				t.left = remove(x, t.left);
			else if (x.compareTo(t.element) > 0)
				t.right = remove(x, t.right);
			else if (t.left != null && t.right != null)
			// Two children
			{
				t.element = findMin(t.right).element;
				t.right = remove(t.element, t.right);
			}
			else
				t = (t.left != null)?t.left:t.right;
			return t;
		}
		
		/// <summary> Internal method to find the smallest item in a subtree.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> node containing the smallest item.
		/// </returns>
		private BinaryNode findMin(BinaryNode t)
		{
			if (t == null)
				return null;
			else if (t.left == null)
				return t;
			return findMin(t.left);
		}
		
		/// <summary> Internal method to find the largest item in a subtree.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> node containing the largest item.
		/// </returns>
		private BinaryNode findMax(BinaryNode t)
		{
			if (t != null)
				while (t.right != null)
					t = t.right;
			
			return t;
		}
		
		/// <summary> Internal method to find an item in a subtree.</summary>
		/// <param name="x">is item to search for.
		/// </param>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> node containing the matched item.
		/// </returns>
		private BinaryNode find(Comparable x, BinaryNode t)
		{
			if (t == null)
				return null;
			if (x.compareTo(t.element) < 0)
				return find(x, t.left);
			else if (x.compareTo(t.element) > 0)
				return find(x, t.right);
			else
				return t; // Match
		}
		
		/// <summary> Internal method to print a subtree in sorted order.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		private void  printTree(BinaryNode t)
		{
			if (t != null)
			{
				printTree(t.left);
				//UPGRADE_TODO: Method 'java.io.PrintStream.println' was converted to 'System.Console.Out.WriteLine' which has a different behavior. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1073_javaioPrintStreamprintln_javalangObject'"
				//UPGRADE_TODO: The equivalent in .NET for method 'java.lang.Object.toString' may return a different value. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1043'"
				System.Console.Out.WriteLine(t.element);
				printTree(t.right);
			}
		}
		
		/// <summary>The tree root. </summary>
		private BinaryNode root;
		
		
		// Test program
		[STAThread]
		public static void  Main(System.String[] args)
		{
			BinarySearchTree t = new BinarySearchTree();
			//UPGRADE_NOTE: Final was removed from the declaration of 'NUMS '. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1003'"
			int NUMS = 4000;
			//UPGRADE_NOTE: Final was removed from the declaration of 'GAP '. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1003'"
			int GAP = 37;
			
			System.Console.Out.WriteLine("Checking... (no more output means success)");
			
			for (int i = GAP; i != 0; i = (i + GAP) % NUMS)
				t.insert(new MyInteger(i));
			
			for (int i = 1; i < NUMS; i += 2)
				t.remove(new MyInteger(i));
			
			if (NUMS < 40)
				t.printTree();
			if (((MyInteger) (t.findMin())).intValue() != 2 || ((MyInteger) (t.findMax())).intValue() != NUMS - 2)
				System.Console.Out.WriteLine("FindMin or FindMax error!");
			
			for (int i = 2; i < NUMS; i += 2)
				if (((MyInteger) (t.find(new MyInteger(i)))).intValue() != i)
					System.Console.Out.WriteLine("Find error1!");
			
			for (int i = 1; i < NUMS; i += 2)
			{
				if (t.find(new MyInteger(i)) != null)
					System.Console.Out.WriteLine("Find error2!");
			}
		}
	}
}