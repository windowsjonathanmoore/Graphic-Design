using System;
namespace algorithms
{
	
	// AATree class
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
	
	/// <summary> Implements an AA-tree.
	/// Note that all "matching" is based on the compareTo method.
	/// </summary>
	/// <author>  Mark Allen Weiss
	/// </author>
	public class AATree
	{
		/// <summary> Test if the tree is logically empty.</summary>
		/// <returns> true if empty, false otherwise.
		/// </returns>
		virtual public bool Empty
		{
			get
			{
				return root == nullNode;
			}
			
		}
		/// <summary> Construct the tree.</summary>
		public AATree()
		{
			root = nullNode;
		}
		
		/// <summary> Insert into the tree. Does nothing if x is already present.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		public virtual void  insert(Comparable x)
		{
			root = insert(x, root);
		}
		
		/// <summary> Remove from the tree. Does nothing if x is not found.</summary>
		/// <param name="x">the item to remove.
		/// </param>
		public virtual void  remove(Comparable x)
		{
			deletedNode = nullNode;
			root = remove(x, root);
		}
		
		/// <summary> Find the smallest item in the tree.</summary>
		/// <returns> the smallest item or null if empty.
		/// </returns>
		public virtual Comparable findMin()
		{
			if (Empty)
				return null;
			
			AANode ptr = root;
			
			while (ptr.left != nullNode)
				ptr = ptr.left;
			
			return ptr.element;
		}
		
		/// <summary> Find the largest item in the tree.</summary>
		/// <returns> the largest item or null if empty.
		/// </returns>
		public virtual Comparable findMax()
		{
			if (Empty)
				return null;
			
			AANode ptr = root;
			
			while (ptr.right != nullNode)
				ptr = ptr.right;
			
			return ptr.element;
		}
		
		/// <summary> Find an item in the tree.</summary>
		/// <param name="x">the item to search for.
		/// </param>
		/// <returns> the matching item of null if not found.
		/// </returns>
		public virtual Comparable find(Comparable x)
		{
			AANode current = root;
			nullNode.element = x;
			
			for (; ; )
			{
				if (x.compareTo(current.element) < 0)
					current = current.left;
				else if (x.compareTo(current.element) > 0)
					current = current.right;
				else if (current != nullNode)
					return current.element;
				else
					return null;
			}
		}
		
		/// <summary> Make the tree logically empty.</summary>
		public virtual void  makeEmpty()
		{
			root = nullNode;
		}
		
		/// <summary> Print the tree contents in sorted order.</summary>
		public virtual void  printTree()
		{
			if (Empty)
				System.Console.Out.WriteLine("Empty tree");
			else
				printTree(root);
		}
		
		/// <summary> Internal method to insert into a subtree.</summary>
		/// <param name="x">the item to insert.
		/// </param>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> the new root.
		/// </returns>
		private AANode insert(Comparable x, AANode t)
		{
			if (t == nullNode)
				t = new AANode(x, nullNode, nullNode);
			else if (x.compareTo(t.element) < 0)
				t.left = insert(x, t.left);
			else if (x.compareTo(t.element) > 0)
				t.right = insert(x, t.right);
			else
				return t;
			
			t = skew(t);
			t = split(t);
			return t;
		}
		
		/// <summary> Internal method to remove from a subtree.</summary>
		/// <param name="x">the item to remove.
		/// </param>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> the new root.
		/// </returns>
		private AANode remove(Comparable x, AANode t)
		{
			if (t != nullNode)
			{
				// Step 1: Search down the tree and set lastNode and deletedNode
				lastNode = t;
				if (x.compareTo(t.element) < 0)
					t.left = remove(x, t.left);
				else
				{
					deletedNode = t;
					t.right = remove(x, t.right);
				}
				
				// Step 2: If at the bottom of the tree and
				//         x is present, we remove it
				if (t == lastNode)
				{
					if (deletedNode == nullNode || x.compareTo(deletedNode.element) != 0)
						return t; // Item not found; do nothing
					deletedNode.element = t.element;
					t = t.right;
				}
				// Step 3: Otherwise, we are not at the bottom; rebalance
				else if (t.left.level < t.level - 1 || t.right.level < t.level - 1)
				{
					if (t.right.level > --t.level)
						t.right.level = t.level;
					t = skew(t);
					t.right = skew(t.right);
					t.right.right = skew(t.right.right);
					t = split(t);
					t.right = split(t.right);
				}
			}
			return t;
		}
		
		/// <summary> Internal method to print a subtree in sorted order.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		private void printTree(AANode t)
		{
			if (t != t.left)
			{
				printTree(t.left);
				//UPGRADE_TODO: The equivalent in .NET for method 'java.lang.Object.toString' may return a different value. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1043'"
				System.Console.Out.WriteLine(t.element.ToString());
				printTree(t.right);
			}
		}
		
		/// <summary> Skew primitive for AA-trees.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> the new root after the rotation.
		/// </returns>
		private AANode skew(AANode t)
		{
			if (t.left.level == t.level)
				t = rotateWithLeftChild(t);
			return t;
		}
		
		/// <summary> Split primitive for AA-trees.</summary>
		/// <param name="t">the node that roots the tree.
		/// </param>
		/// <returns> the new root after the rotation.
		/// </returns>
		private AANode split(AANode t)
		{
			if (t.right.right.level == t.level)
			{
				t = rotateWithRightChild(t);
				t.level++;
			}
			return t;
		}
		
		/// <summary> Rotate binary tree node with left child.</summary>
		internal static AANode rotateWithLeftChild(AANode k2)
		{
			AANode k1 = k2.left;
			k2.left = k1.right;
			k1.right = k2;
			return k1;
		}
		
		/// <summary> Rotate binary tree node with right child.</summary>
		internal static AANode rotateWithRightChild(AANode k1)
		{
			AANode k2 = k1.right;
			k1.right = k2.left;
			k2.left = k1;
			return k2;
		}
		
		private AANode root;
		private static AANode nullNode;
		
		private static AANode deletedNode;
		private static AANode lastNode;		
		
		static AATree()
		{
			{
				nullNode = new AANode(null);
				nullNode.left = nullNode.right = nullNode;
				nullNode.level = 0;
			}
		}
	}
}