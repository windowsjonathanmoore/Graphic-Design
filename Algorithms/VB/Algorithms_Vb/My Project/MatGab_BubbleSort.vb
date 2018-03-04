Imports System
Imports System.Collections.Generic
Imports System.Collections
Imports System.Text

Namespace Algorithms
	Public Class BubbleSort
		Public Sub bubble_sort_generic(Of T As IComparable)(array As T())
			Dim right_border As Long = array.Length - 1

			Do
				Dim last_exchange As Long = 0

				Dim i As Long = 0
				While i < right_border
					If array(i).CompareTo(array(i + 1)) > 0 Then
						Dim temp As T = array(i)
						array(i) = array(i + 1)
						array(i + 1) = temp

						last_exchange = i
					End If
					System.Math.Max(System.Threading.Interlocked.Increment(i),i - 1)
				End While

				right_border = last_exchange
			Loop While right_border > 0
		End Sub
	End Class
End Namespace

