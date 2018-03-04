using System;
namespace algorithms
{
	
	/// <summary> Protocol for Comparable objects.
	/// In Java 1.2, you can remove this file.
	/// </summary>
	/// <author>  Mark Allen Weiss, Jonathan Moore
	/// </author>
	public interface Comparable
	{
		/// <summary> Compare this object with rhs.</summary>
		/// <param name="rhs">the second Comparable.
		/// </param>
		/// <returns> 0 if two objects are equal;
		/// less than zero if this object is smaller;
		/// greater than zero if this object is larger.
		/// </returns>
		int compareTo(Comparable rhs);
	}
}