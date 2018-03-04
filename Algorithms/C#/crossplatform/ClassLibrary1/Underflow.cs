using System;
namespace algorithms
{
	
	/// <summary> Exception class for access in empty containers
	/// such as stacks, queues, and priority queues.
	/// </summary>
	/// <author>  Mark Allen Weiss Jonathan Moore
	/// </author>
	[Serializable]
	public class Underflow:System.Exception
	{
	}
}