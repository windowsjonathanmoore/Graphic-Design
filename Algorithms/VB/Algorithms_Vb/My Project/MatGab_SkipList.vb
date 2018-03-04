'
' * Created by: Leslie Sanford (08/27/2003)
' * Contact: jabberdabber@hotmail.com
' 


Imports System
Imports System.Collections
Imports System.Resources
Imports System.Reflection

Namespace LSCollections
	''' <summary>
	''' Represents a collection of key-and-value pairs.
	''' </summary>
	''' <remarks>
	''' The SkipList class is an implementation of the IDictionary interface. It 
	''' is based on the data structure created by William Pugh.
	''' </remarks> 
	Public Class SkipList
		Implements IDictionary
		#region " SkipList Members"

		#region " Constants"

		' Maximum level any node in a skip list can have
		Private Const MaxLevel As Integer = 32

		' Probability factor used to determine the node level
		Private Const Probability As Double = 0.5

		#end region

		#region " Fields"

		' The skip list header. It also serves as the NIL node.
		Private header As New Node(MaxLevel)

		' Comparer for comparing keys.
		Private comparer As IComparer

		' Random number generator for generating random node levels.
		Private random As New Random()

		' Current maximum list level.
		Private listLevel As Integer

		' Current number of elements in the skip list.
		Private m_count As Integer

		' Version of the skip list. Used for validation checks with 
		' enumerators.
		Private version As Long = 0

		' Resource manager for retrieving exception messages.
		Private resManager As ResourceManager

		#end region

		''' <summary>
		''' Initializes a new instance of the SkipList class that is empty and 
		''' is sorted according to the IComparable interface implemented by 
		''' each key added to the SkipList.
		''' </summary>
		''' <remarks>
		''' Each key must implement the IComparable interface to be capable of 
		''' comparisons with every other key in the SortedList. The elements 
		''' are sorted according to the IComparable implementation of each key 
		''' added to the SkipList.
		''' </remarks>
		Public Sub New()
			' Initialize the skip list.
			Initialize()

			' Load resources.
			resManager = New ResourceManager("LSCollections.Resource", Me.[GetType]().Assembly)
		End Sub

		''' <summary>
		''' Initializes a new instance of the SkipList class that is empty and 
		''' is sorted according to the specified IComparer interface.
		''' </summary>
		''' <param name="comparer">
		''' The IComparer implementation to use when comparing keys. 
		''' </param>
		''' <remarks>
		''' The elements are sorted according to the specified IComparer 
		''' implementation. If comparer is a null reference, the IComparable 
		''' implementation of each key is used; therefore, each key must 
		''' implement the IComparable interface to be capable of comparisons 
		''' with every other key in the SkipList.
		''' </remarks>
		Public Sub New(comparer As IComparer)
			' Initialize comparer with the client provided comparer.
			Me.comparer = comparer

			' Initialize the skip list.
			Initialize()

			' Load resources.
			resManager = New ResourceManager("LSCollections.Resource", Me.[GetType]().Assembly)
		End Sub

		Protected Overrides Sub Finalize()
			Try
				Clear()
			Finally
				MyBase.Finalize()
			End Try
		End Sub

		#region " Private Helper Methods"

		''' <summary>
		''' Initializes the SkipList.
		''' </summary>
		Private Sub Initialize()
			listLevel = 1
			m_count = 0

			' When the list is empty, make sure all forward references in the
			' header point back to the header. This is important because the 
			' header is used as the sentinel to mark the end of the skip list.
			Dim i As Integer = 0
			While i < MaxLevel
				header.forward(i) = header
				System.Math.Max(System.Threading.Interlocked.Increment(i),i - 1)
			End While
		End Sub

		''' <summary>
		''' Returns a level value for a new SkipList node.
		''' </summary>
		''' <returns>
		''' The level value for a new SkipList node.
		''' </returns>
		Private Function GetNewLevel() As Integer
			Dim level As Integer = 1

			' Determines the next node level.
			While random.NextDouble() < Probability AndAlso level < MaxLevel AndAlso level <= listLevel
				System.Math.Max(System.Threading.Interlocked.Increment(level),level - 1)
			End While

			Return level
		End Function

		''' <summary>
		''' Searches for the specified key.
		''' </summary>
		''' <param name="key">
		''' The key to search for.
		''' </param>
		''' <returns>
		''' Returns true if the specified key is in the SkipList.
		''' </returns>
		Private Function Search(key As Object) As Boolean
			Dim curr As Node
			Dim dummy As Node() = New Node(MaxLevel - 1) {}

			Return Search(key, curr, dummy)
		End Function

		''' <summary>
		''' Searches for the specified key.
		''' </summary>
		''' <param name="key">
		''' The key to search for.
		''' </param>
		''' <param name="curr">
		''' A SkipList node to hold the results of the search.
		''' </param>
		''' <returns>
		''' Returns true if the specified key is in the SkipList.
		''' </returns>
		''' <remarks>
		Private Function Search(key As Object, ByRef curr As Node) As Boolean
			Dim dummy As Node() = New Node(MaxLevel - 1) {}

			Return Search(key, curr, dummy)
		End Function

		''' <summary>
		''' Searches for the specified key.
		''' </summary>
		''' <param name="key">
		''' The key to search for.
		''' </param>
		''' <param name="update">
		''' An array of nodes holding references to the places in the SkipList
		''' search in which the search dropped down one level.
		''' </param>
		''' <returns>
		''' Returns true if the specified key is in the SkipList.
		''' </returns>
		Private Function Search(key As Object, update As Node()) As Boolean
			Dim curr As Node

			Return Search(key, curr, update)
		End Function

		''' <summary>
		''' Searches for the specified key.
		''' </summary>
		''' <param name="key">
		''' The key to search for.
		''' </param>
		''' <param name="curr">
		''' A SkipList node to hold the results of the search.
		''' </param>
		''' <param name="update">
		''' An array of nodes holding references to the places in the SkipList
		''' search in which the search dropped down one level.
		''' </param>
		''' <returns>
		''' Returns true if the specified key is in the SkipList.
		''' </returns>
		Private Function Search(key As Object, ByRef curr As Node, update As Node()) As Boolean
			' Make sure key isn't null.
			If key = Nothing Then
				Dim msg As String = resManager.GetString("NullKey")
				Throw New ArgumentNullException(msg)
			End If

			Dim result As Boolean

			' Check to see if we will search with a comparer.
			If not (comparer  is nothing)  Then
				result = SearchWithComparer(key, curr, update)
			Else
				' Else we're using the IComparable interface.
				result = SearchWithComparable(key, curr, update)
			End If

			Return result
		End Function

		''' <summary>
		''' Search for the specified key using a comparer.
		''' </summary>
		''' <param name="key">
		''' The key to search for.
		''' </param>
		''' <param name="curr">
		''' A SkipList node to hold the results of the search.
		''' </param>
		''' <param name="update">
		''' An array of nodes holding references to the places in the SkipList
		''' search in which the search dropped down one level.
		''' </param>
		''' <returns>
		''' Returns true if the specified key is in the SkipList.
		''' </returns>
		Private Function SearchWithComparer(key As Object, ByRef curr As Node, update As Node()) As Boolean
			Dim found As Boolean = False

			' Start from the beginning of the skip list.
			curr = header

			' Work our way down from the top of the skip list to the bottom.
			Dim i As Integer = listLevel - 1
			While i >= 0
				' While we haven't reached the end of the skip list and the 
				' current key is less than the new key.
				While curr.forward(i) <> header AndAlso comparer.Compare(curr.forward(i).entry.Key, key) < 0
					' Move forward in the skip list.
					curr = curr.forward(i)
				End While

				' Keep track of each node where we move down a level. This 
				' will be used later to rearrange node references when 
				' inserting a new element.
				update(i) = curr
				System.Math.Max(System.Threading.Interlocked.Decrement(i),i + 1)
			End While

			' Move ahead in the skip list. If the new key doesn't already 
			' exist in the skip list, this should put us at either the end of
			' the skip list or at a node with a key greater than the sarch key.
			' If the new key already exists in the skip list, this should put 
			' us at a node with a key equal to the search key.
			curr = curr.forward(0)

			' If we haven't reached the end of the skip list and the 
			' current key is equal to the search key.
			If curr <> header AndAlso comparer.Compare(key, curr.entry.Key) = 0 Then
				' Indicate that we've found the search key.
				found = True
			End If

			Return found
		End Function

		''' <summary>
		''' Search for the specified key using the IComparable interface 
		''' implemented by each key.
		''' </summary>
		''' <param name="key">
		''' The key to search for.
		''' </param>
		''' <param name="curr">
		''' A SkipList node to hold the results of the search.
		''' </param>
		''' <param name="update">
		''' An array of nodes holding references to the places in the SkipList
		''' search in which the search dropped down one level.
		''' </param>
		''' <returns>
		''' Returns true if the specified key is in the SkipList.
		''' </returns>
		''' <remarks>
		''' Assumes each key inserted into the SkipList implements the 
		''' IComparable interface.
		''' 
		''' If the specified key is in the SkipList, the curr parameter will
		''' reference the node with the key. If the specified key is not in the
		''' SkipList, the curr paramater will either hold the node with the 
		''' first key value greater than the specified key or null indicating 
		''' that the search reached the end of the SkipList.
		''' </remarks>
		Private Function SearchWithComparable(key As Object, ByRef curr As Node, update As Node()) As Boolean
			' Make sure key is comparable.
			If Not (TypeOf key Is IComparable) Then
				Dim msg As String = resManager.GetString("ComparableError")
				Throw New ArgumentException(msg)
			End If

			Dim found As Boolean = False
			Dim comp As IComparable

			' Begin at the start of the skip list.
			curr = header

			' Work our way down from the top of the skip list to the bottom.
			Dim i As Integer = listLevel - 1
			While i >= 0
				' Get the comparable interface for the current key.
				comp = DirectCast(curr.forward(i).entry.Key, IComparable)

				' While we haven't reached the end of the skip list and the 
				' current key is less than the search key.
				While curr.forward(i) <> header AndAlso comp.CompareTo(key) < 0
					' Move forward in the skip list.
					curr = curr.forward(i)
					' Get the comparable interface for the current key.
					comp = DirectCast(curr.forward(i).entry.Key, IComparable)
				End While

				' Keep track of each node where we move down a level. This 
				' will be used later to rearrange node references when 
				' inserting a new element.
				update(i) = curr
				System.Math.Max(System.Threading.Interlocked.Decrement(i),i + 1)
			End While

			' Move ahead in the skip list. If the new key doesn't already 
			' exist in the skip list, this should put us at either the end of
			' the skip list or at a node with a key greater than the search key.
			' If the new key already exists in the skip list, this should put 
			' us at a node with a key equal to the search key.
			curr = curr.forward(0)

			' Get the comparable interface for the current key.
			comp = DirectCast(curr.entry.Key, IComparable)

			' If we haven't reached the end of the skip list and the 
			' current key is equal to the search key.
			If curr <> header AndAlso comp.CompareTo(key) = 0 Then
				' Indicate that we've found the search key.
				found = True
			End If

			Return found
		End Function

		''' <summary>
		''' Inserts a key/value pair into the SkipList.
		''' </summary>
		''' <param name="key">
		''' The key to insert into the SkipList.
		''' </param>
		''' <param name="val">
		''' The value to insert into the SkipList.
		''' </param>
		''' <param name="update">
		''' An array of nodes holding references to places in the SkipList in 
		''' which the search for the place to insert the new key/value pair 
		''' dropped down one level.
		''' </param>
		Private Sub Insert(key As Object, val As Object, update As Node())
			' Get the level for the new node.
			Dim newLevel As Integer = GetNewLevel()

			' If the level for the new node is greater than the skip list 
			' level.
			If newLevel > listLevel Then
				' Make sure our update references above the current skip list
				' level point to the header. 
				Dim i As Integer = listLevel
				While i < newLevel
					update(i) = header
					System.Math.Max(System.Threading.Interlocked.Increment(i),i - 1)
				End While

				' The current skip list level is now the new node level.
				listLevel = newLevel
			End If

			' Create the new node.
			Dim newNode As New Node(newLevel, key, val)

			' Insert the new node into the skip list.
			Dim i As Integer = 0
			While i < newLevel
				' The new node forward references are initialized to point to
				' our update forward references which point to nodes further 
				' along in the skip list.
				newNode.forward(i) = update(i).forward(i)

				' Take our update forward references and point them towards 
				' the new node. 
				update(i).forward(i) = newNode
				System.Math.Max(System.Threading.Interlocked.Increment(i),i - 1)
			End While

			' Keep track of the number of nodes in the skip list.
			System.Math.Max(System.Threading.Interlocked.Increment(m_count),m_count - 1)
			' Indicate that the skip list has changed.
			System.Math.Max(System.Threading.Interlocked.Increment(version),version - 1)
		End Sub

		#end region

		#end region

		#region " Node Class"

		''' <summary>
		''' Represents a node in the SkipList.
		''' </summary>
		Private Class Node
			Implements IDisposable
			#region " Fields"

			' References to nodes further along in the skip list.
			Public forward As Node()

			' The key/value pair.
			Public entry As DictionaryEntry

			#end region

			''' <summary>
			''' Initializes an instant of a Node with its node level.
			''' </summary>
			''' <param name="level">
			''' The node level.
			''' </param>
			Public Sub New(level As Integer)
				forward = New Node(level - 1) {}
			End Sub

			''' <summary>
			''' Initializes an instant of a Node with its node level and 
			''' key/value pair.
			''' </summary>
			''' <param name="level">
			''' The node level.
			''' </param>
			''' <param name="key">
			''' The key for the node.
			''' </param>
			''' <param name="val">
			''' The value for the node.
			''' </param>
			Public Sub New(level As Integer, key As Object, val As Object)
				forward = New Node(level - 1) {}
				entry.Key = key
				entry.Value = val
			End Sub

			#region " IDisposable Members"

			''' <summary>
			''' Disposes the Node.
			''' </summary>
			Public Sub Dispose()
				Dim i As Integer = 0
				While i < forward.Length
					forward(i) = Nothing
					System.Math.Max(System.Threading.Interlocked.Increment(i),i - 1)
				End While
			End Sub

			#end region
		End Class

		#end region

		#region " SkipListEnumerator Class"

		''' <summary>
		''' Enumerates the elements of a skip list.
		''' </summary>
		Private Class SkipListEnumerator
			Implements IDictionaryEnumerator
			#region " SkipListEnumerator Members"

			#region " Fields"

			' The skip list to enumerate.
			Private list As SkipList

			' The current node.
			Private m_current As Node

			' The version of the skip list we are enumerating.
			Private version As Long

			' Keeps track of previous move result so that we can know 
			' whether or not we are at the end of the skip list.
			Private moveResult As Boolean = True

			#end region

			''' <summary>
			''' Initializes an instance of a SkipListEnumerator.
			''' </summary>
			''' <param name="list"></param>
			Public Sub New(list As SkipList)
				Me.list = list
				version = list.version
				m_current = list.header
			End Sub

			#end region

			#region " IDictionaryEnumerator Members"

			''' <summary>
			''' Gets both the key and the value of the current dictionary 
			''' entry.
			''' </summary>
			Public ReadOnly Property Entry() As DictionaryEntry
				Get
					Dim entry__1 As DictionaryEntry

					' Make sure the skip list hasn't been modified since the
					' enumerator was created.
					If version <> list.version Then
						Dim msg As String = list.resManager.GetString("InvalidEnum")
						Throw New InvalidOperationException(msg)
					' Make sure we are not before the beginning or beyond the 
					' end of the skip list.
					ElseIf m_current = list.header Then
						Dim msg As String = list.resManager.GetString("BadEnumAccess")
						Throw New InvalidOperationException()
					Else
						' Finally, all checks have passed. Get the current entry.
						entry__1 = m_current.entry
					End If

					Return entry__1
				End Get
			End Property

			''' <summary>
			''' Gets the key of the current dictionary entry.
			''' </summary>
			Public ReadOnly Property Key() As Object
				Get
					Dim key__1 As Object = Entry.Key

					Return key__1
				End Get
			End Property

			''' <summary>
			''' Gets the value of the current dictionary entry.
			''' </summary>
			Public ReadOnly Property Value() As Object
				Get
					Dim val As Object = Entry.Value

					Return val
				End Get
			End Property

			#end region

			#region " IEnumerator Members"

			''' <summary>
			''' Advances the enumerator to the next element of the skip list.
			''' </summary>
			''' <returns>
			''' true if the enumerator was successfully advanced to the next 
			''' element; false if the enumerator has passed the end of the 
			''' skip list.
			''' </returns>
			Public Function MoveNext() As Boolean
				' Make sure the skip list hasn't been modified since the
				' enumerator was created.
				If version = list.version Then
					' If the result of the previous move operation was true
					' we can still move forward in the skip list.
					If moveResult Then
						' Move forward in the skip list.
						m_current = m_current.forward(0)

						' If we are at the end of the skip list.
						If m_current = list.header Then
							' Indicate that we've reached the end of the skip 
							' list.
							moveResult = False
						End If
					End If
				Else
					' Else this version of the enumerator doesn't match that of 
					' the skip list. The skip list has been modified since the 
					' creation of the enumerator.
					Dim msg As String = list.resManager.GetString("InvalidEnum")
					Throw New InvalidOperationException(msg)
				End If

				Return moveResult
			End Function

			''' <summary>
			''' Sets the enumerator to its initial position, which is before 
			''' the first element in the skip list.
			''' </summary>
			Public Sub Reset()
				' Make sure the skip list hasn't been modified since the
				' enumerator was created.
				If version = list.version Then
					m_current = list.header
					moveResult = True
				Else
					' Else this version of the enumerator doesn't match that of 
					' the skip list. The skip list has been modified since the 
					' creation of the enumerator.
					Dim msg As String = list.resManager.GetString("InvalidEnum")
					Throw New InvalidOperationException(msg)
				End If
			End Sub

			''' <summary>
			''' Gets the current element in the skip list.
			''' </summary>
			Public ReadOnly Property Current() As Object
				Get
					Return Value
				End Get
			End Property

			#end region
		End Class

		#end region

		#region " IDictionary Members"

		''' <summary>
		''' Adds an element with the provided key and value to the SkipList.
		''' </summary>
		''' <param name="key">
		''' The Object to use as the key of the element to add. 
		''' </param>
		''' <param name="value">
		''' The Object to use as the value of the element to add. 
		''' </param>
		Public Sub Add(key As Object, value As Object)
			Dim update As Node() = New Node(MaxLevel - 1) {}

			' If key does not already exist in the skip list.
			If Not Search(key, update) Then
				' Inseart key/value pair into the skip list.
				Insert(key, value, update)
			Else
				' Else throw an exception. The IDictionary Add method throws an
				' exception if an attempt is made to add a key that already 
				' exists in the skip list.
				Dim msg As String = resManager.GetString("KeyExistsAdd")
				Throw New ArgumentException(msg)
			End If
		End Sub

		''' <summary>
		''' Removes all elements from the SkipList.
		''' </summary>
		Public Sub Clear()
			' Start at the beginning of the skip list.
			Dim curr As Node = header.forward(0)
			Dim prev As Node

			' While we haven't reached the end of the skip list.
			While curr <> header
				' Keep track of the previous node.
				prev = curr
				' Move forward in the skip list.
				curr = curr.forward(0)
				' Dispose of the previous node.
				prev.Dispose()
			End While

			' Initialize skip list and indicate that it has been changed.
			Initialize()
			System.Math.Max(System.Threading.Interlocked.Increment(version),version - 1)
		End Sub

		''' <summary>
		''' Determines whether the SkipList contains an element with the 
		''' specified key.
		''' </summary>
		''' <param name="key">
		''' The key to locate in the SkipList.
		''' </param>
		''' <returns>
		''' true if the SkipList contains an element with the key; otherwise, 
		''' false.
		''' </returns>
		Public Function Contains(key As Object) As Boolean
			Return Search(key)
		End Function

		''' <summary>
		''' Returns an IDictionaryEnumerator for the SkipList.
		''' </summary>
		''' <returns>
		''' An IDictionaryEnumerator for the SkipList.
		''' </returns>
		Public Function GetEnumerator() As IDictionaryEnumerator
			Return New SkipListEnumerator(Me)
		End Function

		''' <summary>
		''' Removes the element with the specified key from the SkipList.
		''' </summary>
		''' <param name="key">
		''' The key of the element to remove.
		''' </param>
		Public Sub Remove(key As Object)
			Dim update As Node() = New Node(MaxLevel - 1) {}
			Dim curr As Node

			If Search(key, curr, update) Then
				' Take the forward references that point to the node to be 
				' removed and reassign them to the nodes that come after it.
				Dim i As Integer = 0
				While i < listLevel AndAlso update(i).forward(i) = curr
					update(i).forward(i) = curr.forward(i)
					System.Math.Max(System.Threading.Interlocked.Increment(i),i - 1)
				End While

				curr.Dispose()

				' After removing the node, we may need to lower the current 
				' skip list level if the node had the highest level of all of
				' the nodes.
				While listLevel > 1 AndAlso header.forward(listLevel - 1) = header
					System.Math.Max(System.Threading.Interlocked.Decrement(listLevel),listLevel + 1)
				End While

				' Keep track of the number of nodes.
				System.Math.Max(System.Threading.Interlocked.Decrement(m_count),m_count + 1)
				' Indicate that the skip list has changed.
				System.Math.Max(System.Threading.Interlocked.Increment(version),version - 1)
			End If
		End Sub

		''' <summary>
		''' Gets a value indicating whether the SkipList has a fixed size.
		''' </summary>
		Public ReadOnly Property IsFixedSize() As Boolean
			Get
				Return False
			End Get
		End Property

		''' <summary>
		''' Gets a value indicating whether the IDictionary is read-only.
		''' </summary>
		Public ReadOnly Property IsReadOnly() As Boolean
			Get
				Return False
			End Get
		End Property

		''' <summary>
		''' Gets or sets the element with the specified key. This is the 
		''' indexer for the SkipList. 
		''' </summary>
		Public Default Property Item(key As Object) As Object
			Get
				Dim val As Object = Nothing
				Dim curr As Node

				If Search(key, curr) Then
					val = curr.entry.Value
				End If

				Return val
			End Get
			Set
				Dim update As Node() = New Node(MaxLevel - 1) {}
				Dim curr As Node

				' If the search key already exists in the skip list.
				If Search(key, curr, update) Then
					' Replace the current value with the new value.
					curr.entry.Value = value
					' Indicate that the skip list has changed.
					System.Math.Max(System.Threading.Interlocked.Increment(version),version - 1)
				Else
					' Else the key doesn't exist in the skip list.
					' Insert the key and value into the skip list.
					Insert(key, value, update)
				End If
			End Set
		End Property

		''' <summary>
		''' Gets an ICollection containing the keys of the SkipList.
		''' </summary>
		Public ReadOnly Property Keys() As ICollection
			Get
				' Start at the beginning of the skip list.
				Dim curr As Node = header.forward(0)
				' Create a collection to hold the keys.
				Dim collection As New ArrayList()

				' While we haven't reached the end of the skip list.
				While curr <> header
					' Add the key to the collection.
					collection.Add(curr.entry.Key)
					' Move forward in the skip list.
					curr = curr.forward(0)
				End While

				Return collection
			End Get
		End Property

		''' <summary>
		''' Gets an ICollection containing the values of the SkipList.
		''' </summary>
		Public ReadOnly Property Values() As ICollection
			Get
				' Start at the beginning of the skip list.
				Dim curr As Node = header.forward(0)
				' Create a collection to hold the values.
				Dim collection As New ArrayList()

				' While we haven't reached the end of the skip list.
				While curr <> header
					' Add the value to the collection.
					collection.Add(curr.entry.Value)
					' Move forward in the skip list.
					curr = curr.forward(0)
				End While

				Return collection
			End Get
		End Property

		#end region

		#region " ICollection Members"

		''' <summary>
		''' Copies the elements of the SkipList to an Array, starting at a 
		''' particular Array index.
		''' </summary>
		''' <param name="array">
		''' The one-dimensional Array that is the destination of the elements 
		''' copied from SkipList.
		''' </param>
		''' <param name="index">
		''' The zero-based index in array at which copying begins.
		''' </param>
		Public Sub CopyTo(array As Array, index As Integer)
			' Make sure array isn't null.
			If array = Nothing Then
				Dim msg As String = resManager.GetString("NullArrayCopyTo")
				Throw New ArgumentNullException(msg)
			' Make sure index is not negative.
			ElseIf index < 0 Then
				Dim msg As String = resManager.GetString("BadIndexCopyTo")
				Throw New ArgumentOutOfRangeException(msg)
			' Array bounds checking.
			ElseIf index >= array.Length Then
				Dim msg As String = resManager.GetString("BadIndexCopyTo")
				Throw New ArgumentException(msg)
			' Make sure that the number of elements in the skip list is not 
			' greater than the available space from index to the end of the 
			' array.
			ElseIf (array.Length - index) < Count Then
				Dim msg As String = resManager.GetString("BadIndexCopyTo")
				Throw New ArgumentException(msg)
			Else
				' Else copy elements from skip list into array.
				' Start at the beginning of the skip list.
				Dim curr As Node = header.forward(0)

				' While we haven't reached the end of the skip list.
				While curr <> header
					' Copy current value into array.
					array.SetValue(curr.entry.Value, index)

					' Move forward in the skip list and array.
					curr = curr.forward(0)
					System.Math.Max(System.Threading.Interlocked.Increment(index),index - 1)
				End While
			End If
		End Sub

		''' <summary>
		''' Gets the number of elements contained in the SkipList.
		''' </summary>
		Public ReadOnly Property Count() As Integer
			Get
				Return m_count
			End Get
		End Property

		''' <summary>
		''' Gets a value indicating whether access to the SkipList is 
		''' synchronized (thread-safe).
		''' </summary>
		Public ReadOnly Property IsSynchronized() As Boolean
			Get
				Return False
			End Get
		End Property

		''' <summary>
		''' Gets an object that can be used to synchronize access to the 
		''' SkipList.
		''' </summary>
		Public ReadOnly Property SyncRoot() As Object
			Get
				Return Me
			End Get
		End Property

		#end region

		#region " IEnumerable Members"

		''' <summary>
		''' Returns an enumerator that can iterate through the SkipList.
		''' </summary>
		''' <returns>
		''' An IEnumerator that can be used to iterate through the collection.
		''' </returns>
		Private Function GetEnumerator() As IEnumerator Implements System.Collections.IEnumerable.GetEnumerator
			Return New SkipListEnumerator(Me)
		End Function

		#end region
	End Class
End Namespace
