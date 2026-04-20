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
		  item.ItemType = 0
		  mItems.Add(item)
		  Return item
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddLargeButton(caption As String, tag As String, icon As Picture) As XjRibbonItem
		  Var item As New XjRibbonItem
		  item.Caption = caption
		  item.Tag = tag
		  item.Icon = icon
		  item.ItemType = 0
		  mItems.Add(item)
		  Return item
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddSmallButton(caption As String, tag As String) As XjRibbonItem
		  Var item As New XjRibbonItem
		  item.Caption = caption
		  item.Tag = tag
		  item.ItemType = 1
		  mItems.Add(item)
		  Return item
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddDropdownButton(caption As String, tag As String) As XjRibbonItem
		  Var item As New XjRibbonItem
		  item.Caption = caption
		  item.Tag = tag
		  item.ItemType = 2
		  mItems.Add(item)
		  Return item
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddSplitButton(caption As String, tag As String) As XjRibbonItem
		  Var item As New XjRibbonItem
		  item.Caption = caption
		  item.Tag = tag
		  item.ItemType = 2
		  item.IsSplitButton = True
		  mItems.Add(item)
		  Return item
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddCheckBox(caption As String, tag As String, initialState As Boolean = False) As XjRibbonItem
		  Var item As New XjRibbonItem
		  item.Caption = caption
		  item.Tag = tag
		  item.ItemType = 3
		  item.IsToggle = True
		  item.IsToggleActive = initialState
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
