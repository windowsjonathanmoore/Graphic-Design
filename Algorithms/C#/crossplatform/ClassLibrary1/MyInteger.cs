using System;
namespace algorithms
{
	
	/// <summary> Wrapper class for use with generic data structures.
	/// Mimics Integer.
	/// In Java 1.2, you can use Integer if Comparable is needed.
	/// </summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	public sealed class MyInteger : Comparable, Hashable
	{
		/// <summary> Construct the MyInteger object with initial value 0.</summary>
		public MyInteger():this(0)
		{
		}
		
		/// <summary> Construct the MyInteger object.</summary>
		/// <param name="x">the initial value.
		/// </param>
		public MyInteger(int x)
		{
			value_Renamed = x;
		}
		
		/// <summary> Gets the stored int value.</summary>
		/// <returns> the stored value.
		/// </returns>
		public int intValue()
		{
			return value_Renamed;
		}
		
		/// <summary> Implements the toString method.</summary>
		/// <returns> the String representation.
		/// </returns>
		public override System.String ToString()
		{
			return System.Convert.ToString(value_Renamed);
		}
		
		/// <summary> Implements the compareTo method.</summary>
		/// <param name="rhs">the other MyInteger object.
		/// </param>
		/// <returns> 0 if two objects are equal;
		/// less than zero if this object is smaller;
		/// greater than zero if this object is larger.
		/// </returns>
		/// <exception cref="ClassCastException">if rhs is not
		/// a MyInteger.
		/// </exception>
		public int compareTo(Comparable rhs)
		{
			return value_Renamed < ((MyInteger) rhs).value_Renamed?- 1:(value_Renamed == ((MyInteger) rhs).value_Renamed?0:1);
		}
		
		/// <summary> Implements the equals method.</summary>
		/// <param name="rhs">the second MyInteger.
		/// </param>
		/// <returns> true if the objects are equal, false otherwise.
		/// </returns>
		/// <exception cref="ClassCastException">if rhs is not
		/// a MyInteger.
		/// </exception>
		public  override bool Equals(System.Object rhs)
		{
			return rhs != null && value_Renamed == ((MyInteger) rhs).value_Renamed;
		}
		
		/// <summary> Implements the hash method.</summary>
		/// <param name="tableSize">the hash table size.
		/// </param>
		/// <returns> a number between 0 and tableSize-1.
		/// </returns>
		public int hash(int tableSize)
		{
			if (value_Renamed < 0)
				return (- value_Renamed) % tableSize;
			else
				return value_Renamed % tableSize;
		}
		
		private int value_Renamed;
		//UPGRADE_NOTE: The following method implementation was automatically added to preserve functionality. "ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?index='!DefaultContextWindowIndex'&keyword='jlca1306'"
		public override int GetHashCode()
		{
			return base.GetHashCode();
		}
	}
}