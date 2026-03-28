#tag Class
Protected Class XjRibbonItem
	#tag Method, Flags = &h0
		Sub AddMenuItem(caption As String, tag As String)
		  Var mi As New DesktopMenuItem(caption)
		  mi.Tag = tag
		  mMenuItems.Add(mi)
		End Sub
	#tag EndMethod

	#tag Property, Flags = &h0
		Caption As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Tag As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IsEnabled As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0
		ItemType As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0
		Icon As Picture
	#tag EndProperty

	#tag Property, Flags = &h0
		TooltipText As String
	#tag EndProperty

	#tag Property, Flags = &h0
		IsToggle As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		IsToggleActive As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		KeyTip As String
	#tag EndProperty

	#tag Property, Flags = &h0
		mMenuItems() As DesktopMenuItem
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

	#tag Property, Flags = &h0
		mIsPressed As Boolean
	#tag EndProperty

End Class
#tag EndClass
