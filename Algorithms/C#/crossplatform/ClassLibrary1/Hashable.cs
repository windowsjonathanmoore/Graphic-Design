using System;
namespace algorithms
{
	
	/// <summary> Protocol for Hashable objects.</summary>
	/// <author>  Mark Allen Weiss, Jonathan Moore
	/// </author>
	public interface Hashable
	{
		/// <summary> Compute a hash function for this object.</summary>
		/// <param name="tableSize">the hash table size.
		/// </param>
		/// <returns> (deterministically) a number between
		/// 0 and tableSize-1, distributed equitably.
		/// </returns>
		int hash(int tableSize);
	}
}