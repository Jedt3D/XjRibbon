#tag Class
Protected Class XjRibbonTab
	#tag Method, Flags = &h0
		Sub AddGroup(group As XjRibbonGroup)
		  mGroups.Add(group)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AddNewGroup(caption As String) As XjRibbonGroup
		  Var group As New XjRibbonGroup
		  group.Caption = caption
		  mGroups.Add(group)
		  Return group
		End Function
	#tag EndMethod

	#tag Property, Flags = &h0
		Caption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		mGroups() As XjRibbonGroup
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

	#tag Property, Flags = &h0
		mIsHovered As Boolean
	#tag EndProperty

End Class
#tag EndClass
