#tag Class
Protected Class XjRibbonGroup
	#tag Method, Flags = &h0
		Sub AddItem(item As XjRibbonItem)
		  mItems.Add(item)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddLargeButton(caption As String, tag As String) As XjRibbonItem
		  Var item As New XjRibbonItem
		  item.Caption = caption
		  item.Tag = tag
		  mItems.Add(item)
		  Return item
		End Function
	#tag EndMethod

	#tag Property, Flags = &h0
		Caption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		mItems() As XjRibbonItem
	#tag EndProperty

	#tag Property, Flags = &h0
		mBoundsX As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		mBoundsY As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		mBoundsW As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		mBoundsH As Double
	#tag EndProperty

End Class
#tag EndClass
