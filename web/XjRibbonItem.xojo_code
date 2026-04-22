#tag Class
Protected Class XjRibbonItem
	#tag Method, Flags = &h0
		Sub AddMenuItem(caption As String, tag As String)
		  // Adds a menu item to this button's popup menu. Use with Dropdown and SplitButton types.
		  Var mi As New WebMenuItem(caption)
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

	// Controls whether this item responds to mouse events and renders as active.
	#tag Property, Flags = &h0
		IsEnabled As Boolean = True
	#tag EndProperty

	// Internal item type: 0=Large, 1=Small, 2=Dropdown/Split, 3=CheckBox, 4=Separator.
	#tag Property, Flags = &h0
		ItemType As Integer = 0
	#tag EndProperty

	// Picture displayed as the button icon. Large buttons: 32x32px. Small buttons: 16x16px.
	#tag Property, Flags = &h0
		Icon As Picture
	#tag EndProperty

	// Tooltip shown on hover. Leave empty for no tooltip.
	#tag Property, Flags = &h0
		TooltipText As String
	#tag EndProperty

	// When True, this item behaves as a toggle button — maintaining pressed/depressed state.
	#tag Property, Flags = &h0
		IsToggle As Boolean = False
	#tag EndProperty

	// Current toggle state. True = active/pressed. Read/write. Also used as CheckBox checked state.
	#tag Property, Flags = &h0
		IsToggleActive As Boolean = False
	#tag EndProperty

	// When True on a Dropdown button, the body fires ItemPressed directly; only the arrow opens the menu.
	#tag Property, Flags = &h0
		IsSplitButton As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0
		mMenuItems() As WebMenuItem
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
