using System;
namespace algorithms
{
	
	// BinarySearchTree class
	//
	// CONSTRUCTION: with no initializer
	//
	// ******************PUBLIC OPERATIONS*********************
	// void insert( x )       --> Insert x
	// void remove( x )       --> Remove x (unimplemented)
	// Comparable find( x )   --> Return item that matches x
	// Comparable findMin( )  --> Return smallest item
	// Comparable findMax( )  --> Return largest item
	// boolean isEmpty( )     --> Return true if empty; else false
	// void makeEmpty( )      --> Remove all items
	// void printTree( )      --> Print tree in sorted order
	
	/// <summary> Implements an AVL tree.
	/// Note that all "matching" is based on the compareTo method.
	/// </summary>
	/// <author>  Mark Allen Weiss
	/// </author>
	public class AvlTree
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
		public AvlTree()
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
			System.Console.Out.WriteLine("Sorry, remove unimplemented");
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
		private Comparable elementAt(AvlNode t)
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
		private AvlNode insert(Comparable x, AvlNode t)
		{
			if (t == null)
				t = new AvlNode(x, null, null);
			else if (x.compareTo(t.element) < 0)
			{
				t.left = insert(x, t.left);
				if (height(t.left) - height(t.right) == 2)
					if (x.compareTo(t.left.element) < 0)
						t = rotateWithLeftChild(t);
					else
						t = doubleWithLeftChild(t);
			}
			else if (x.compareTo(t.element) > 0)
			{
				t.right = insert(x, t.right);
				if (height(t.right) - height(t.left) == 2)
					if (x.compareTo(t.right.element) > 0)
						t = rotateWithRightChild(t);
					else
						t = doubleWithRightChild(t);
			}
			else
			{
			} // Duplicate; do nothing
			t.height = max(height(t.left), height(t.right)) + 1;
			return t;
		}
		
		/// <summary> Internal method to find the smallest item in a subtree.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> node containing the smallest item.
		/// </returns>
		private AvlNode findMin(AvlNode t)
		{
			if (t == null)
				return t;
			
			while (t.left != null)
				t = t.left;
			return t;
		}
		
		/// <summary> Internal method to find the largest item in a subtree.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> node containing the largest item.
		/// </returns>
		private AvlNode findMax(AvlNode t)
		{
			if (t == null)
				return t;
			
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
		private AvlNode find(Comparable x, AvlNode t)
		{
			while (t != null)
				if (x.compareTo(t.element) < 0)
					t = t.left;
				else if (x.compareTo(t.element) > 0)
					t = t.right;
				else
					return t; // Match
			
			return null; // No match
		}
		
		/// <summary> Internal method to print a subtree in sorted order.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		private void  printTree(AvlNode t)
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
		
		/// <summary> Return the height of node t, or -1, if null.</summary>
		private static int height(AvlNode t)
		{
			return t == null?- 1:t.height;
		}
		
		/// <summary> Return maximum of lhs and rhs.</summary>
		private static int max(int lhs, int rhs)
		{
			return lhs > rhs?lhs:rhs;
		}
		
		/// <summary> Rotate binary tree node with left child.
		/// For AVL trees, this is a single rotation for case 1.
		/// Update heights, then return new root.
		/// </summary>
		private static AvlNode rotateWithLeftChild(AvlNode k2)
		{
			AvlNode k1 = k2.left;
			k2.left = k1.right;
			k1.right = k2;
			k2.height = max(height(k2.left), height(k2.right)) + 1;
			k1.height = max(height(k1.left), k2.height) + 1;
			return k1;
		}
		
		/// <summary> Rotate binary tree node with right child.
		/// For AVL trees, this is a single rotation for case 4.
		/// Update heights, then return new root.
		/// </summary>
		private static AvlNode rotateWithRightChild(AvlNode k1)
		{
			AvlNode k2 = k1.right;
			k1.right = k2.left;
			k2.left = k1;
			k1.height = max(height(k1.left), height(k1.right)) + 1;
			k2.height = max(height(k2.right), k1.height) + 1;
			return k2;
		}
		
		/// <summary> Double rotate binary tree node: first left child
		/// with its right child; then node k3 with new left child.
		/// For AVL trees, this is a double rotation for case 2.
		/// Update heights, then return new root.
		/// </summary>
		private static AvlNode doubleWithLeftChild(AvlNode k3)
		{
			k3.left = rotateWithRightChild(k3.left);
			return rotateWithLeftChild(k3);
		}
		
		/// <summary> Double rotate binary tree node: first right child
		/// with its left child; then node k1 with new right child.
		/// For AVL trees, this is a double rotation for case 3.
		/// Update heights, then return new root.
		/// </summary>
		private static AvlNode doubleWithRightChild(AvlNode k1)
		{
			k1.right = rotateWithLeftChild(k1.right);
			return rotateWithRightChild(k1);
		}
		
		/// <summary>The tree root. </summary>
		private AvlNode root;
		
		
		// Test program
		[STAThread]
		public static void  Main(System.String[] args)
		{
			AvlTree t = new AvlTree();
			//UPGRADE_NOTE: Final was removed from the declaration of 'NUMS '. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1003'"
			int NUMS = 4000;
			//UPGRADE_NOTE: Final was removed from the declaration of 'GAP '. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1003'"
			int GAP = 37;
			
			System.Console.Out.WriteLine("Checking... (no more output means success)");
			
			for (int i = GAP; i != 0; i = (i + GAP) % NUMS)
				t.insert(new MyInteger(i));
			
			if (NUMS < 40)
				t.printTree();
			if (((MyInteger) (t.findMin())).intValue() != 1 || ((MyInteger) (t.findMax())).intValue() != NUMS - 1)
				System.Console.Out.WriteLine("FindMin or FindMax error!");
			
			for (int i = 1; i < NUMS; i++)
				if (((MyInteger) (t.find(new MyInteger(i)))).intValue() != i)
					System.Console.Out.WriteLine("Find error1!");
		}
	}
}