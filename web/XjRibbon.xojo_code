#tag Class
Protected Class XjRibbon
Inherits WebCanvas
	#tag Event
		Sub Paint(g As WebGraphics)
		  ResolveColors
		  LayoutTabs(g)
		  DrawBackground(g)
		  DrawTabStrip(g)
		  DrawContentArea(g)
		  DrawGroups(g)
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseDown(x As Integer, y As Integer)
		  // Hit-test tab headers
		  Var hitTab As XjRibbonTab = HitTestTabs(x, y)
		  If hitTab <> Nil Then
		    For i As Integer = 0 To mTabs.LastIndex
		      If mTabs(i) Is hitTab Then
		        mActiveTabIndex = i
		        Exit
		      End If
		    Next
		    ClearHoverStates
		    Me.Refresh
		    Return
		  End If

		  // Hit-test items
		  Var hitItem As XjRibbonItem = HitTestItems(x, y)
		  If hitItem <> Nil And hitItem.IsEnabled Then
		    mPressedItem = hitItem
		    hitItem.mIsPressed = True
		    Me.Refresh
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseUp(x As Integer, y As Integer)
		  If mPressedItem <> Nil Then
		    Var hitItem As XjRibbonItem = HitTestItems(x, y)
		    If hitItem Is mPressedItem And mPressedItem.IsEnabled Then
		      RaiseEvent ItemPressed(mPressedItem.Tag)
		    End If
		    mPressedItem.mIsPressed = False
		    mPressedItem = Nil
		    Me.Refresh
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(x As Integer, y As Integer)
		  Var needsRefresh As Boolean = False

		  // Simulate MouseExit: check if cursor is outside bounds
		  If x < 0 Or y < 0 Or x > Me.Width Or y > Me.Height Then
		    If mHoveredTab <> Nil Or mHoveredItem <> Nil Then
		      ClearHoverStates
		      needsRefresh = True
		    End If
		    If needsRefresh Then Me.Refresh
		    Return
		  End If

		  // Hit-test tab headers
		  Var hitTab As XjRibbonTab = HitTestTabs(x, y)
		  If Not (hitTab Is mHoveredTab) Then
		    If mHoveredTab <> Nil Then
		      mHoveredTab.mIsHovered = False
		    End If
		    mHoveredTab = hitTab
		    If mHoveredTab <> Nil Then
		      mHoveredTab.mIsHovered = True
		    End If
		    needsRefresh = True
		  End If

		  // Hit-test items
		  Var hitItem As XjRibbonItem = HitTestItems(x, y)
		  If Not (hitItem Is mHoveredItem) Then
		    If mHoveredItem <> Nil Then
		      mHoveredItem.mIsHovered = False
		    End If
		    mHoveredItem = hitItem
		    If mHoveredItem <> Nil Then
		      mHoveredItem.mIsHovered = True
		    End If
		    needsRefresh = True
		  End If

		  If needsRefresh Then
		    Me.Refresh
		  End If
		End Sub
	#tag EndEvent

	#tag Hook, Flags = &h0
		Event ItemPressed(tag As String)
	#tag EndHook

	#tag Method, Flags = &h0
		Function AddTab(caption As String) As XjRibbonTab
		  Var tab As New XjRibbonTab
		  tab.Caption = caption
		  mTabs.Add(tab)
		  Me.Refresh
		  Return tab
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SelectTab(index As Integer)
		  If index >= 0 And index < mTabs.Count Then
		    mActiveTabIndex = index
		    ClearHoverStates
		    Me.Refresh
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Clear()
		  mTabs.RemoveAll
		  mActiveTabIndex = 0
		  mHoveredItem = Nil
		  mPressedItem = Nil
		  mHoveredTab = Nil
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LayoutTabs(g As WebGraphics)
		  Var tabX As Double = kTabPaddingH

		  For Each tab As XjRibbonTab In mTabs
		    Var textW As Double = g.TextWidth(tab.Caption)
		    tab.mBoundsX = tabX
		    tab.mBoundsY = 0
		    tab.mBoundsW = textW + kTabPaddingH * 2
		    tab.mBoundsH = kTabStripHeight
		    tabX = tabX + tab.mBoundsW + kTabGap
		  Next

		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return

		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		  Var contentY As Double = kContentTop + kContentPadding
		  Var contentH As Double = Me.Height - kContentTop - kContentPadding * 2
		  Var groupX As Double = kGroupPaddingH

		  For Each group As XjRibbonGroup In activeTab.mGroups
		    Var itemX As Double = groupX + kGroupPaddingH
		    Var itemAreaH As Double = contentH - kGroupLabelHeight

		    For Each item As XjRibbonItem In group.mItems
		      item.mBoundsX = itemX
		      item.mBoundsY = contentY
		      item.mBoundsW = kLargeButtonWidth
		      item.mBoundsH = itemAreaH
		      itemX = itemX + kLargeButtonWidth + kItemGap
		    Next

		    Var groupInnerW As Double = itemX - groupX - kGroupPaddingH
		    If group.mItems.Count > 0 Then
		      groupInnerW = groupInnerW - kItemGap
		    End If
		    groupInnerW = groupInnerW + kGroupPaddingH

		    Var labelW As Double = g.TextWidth(group.Caption) + kGroupPaddingH * 2
		    group.mBoundsX = groupX
		    group.mBoundsY = contentY
		    group.mBoundsW = Max(groupInnerW + kGroupPaddingH, labelW)
		    group.mBoundsH = contentH

		    groupX = groupX + group.mBoundsW + kGroupGap
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ResolveColors()
		  If Color.IsDarkMode Then
		    cBackground = Color.RGB(40, 40, 40)
		    cContentBackground = Color.RGB(50, 50, 50)
		    cBorder = Color.RGB(70, 70, 70)
		    cTabText = Color.RGB(220, 220, 220)
		    cTabActiveBackground = Color.RGB(50, 50, 50)
		    cTabHoverBackground = Color.RGB(60, 70, 80)
		    cTabAccent = Color.RGB(60, 150, 230)
		    cItemText = Color.RGB(220, 220, 220)
		    cItemDisabledText = Color.RGB(100, 100, 100)
		    cItemHoverBackground = Color.RGB(70, 80, 95)
		    cItemPressedBackground = Color.RGB(55, 70, 90)
		    cGroupLabelText = Color.RGB(150, 150, 150)
		    cGroupSeparator = Color.RGB(70, 70, 70)
		    cPlaceholderIcon = Color.RGB(60, 150, 230)
		    cPlaceholderIconDisabled = Color.RGB(80, 80, 80)
		    cPlaceholderIconText = Color.RGB(255, 255, 255)
		  Else
		    cBackground = Color.RGB(245, 245, 245)
		    cContentBackground = Color.RGB(255, 255, 255)
		    cBorder = Color.RGB(210, 210, 210)
		    cTabText = Color.RGB(60, 60, 60)
		    cTabActiveBackground = Color.RGB(255, 255, 255)
		    cTabHoverBackground = Color.RGB(230, 240, 250)
		    cTabAccent = Color.RGB(0, 120, 212)
		    cItemText = Color.RGB(60, 60, 60)
		    cItemDisabledText = Color.RGB(160, 160, 160)
		    cItemHoverBackground = Color.RGB(220, 235, 250)
		    cItemPressedBackground = Color.RGB(200, 220, 240)
		    cGroupLabelText = Color.RGB(120, 120, 120)
		    cGroupSeparator = Color.RGB(220, 220, 220)
		    cPlaceholderIcon = Color.RGB(0, 120, 212)
		    cPlaceholderIconDisabled = Color.RGB(180, 180, 180)
		    cPlaceholderIconText = Color.RGB(255, 255, 255)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawBackground(g As WebGraphics)
		  g.DrawingColor = cBackground
		  g.FillRectangle(0, 0, g.Width, g.Height)

		  g.DrawingColor = cBorder
		  g.FillRectangle(0, g.Height - 1, g.Width, 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTabStrip(g As WebGraphics)
		  For i As Integer = 0 To mTabs.LastIndex
		    Var tab As XjRibbonTab = mTabs(i)

		    If i = mActiveTabIndex Then
		      g.DrawingColor = cTabActiveBackground
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)

		      g.DrawingColor = cTabAccent
		      g.FillRectangle(tab.mBoundsX, 0, tab.mBoundsW, 2)
		    ElseIf tab.mIsHovered Then
		      g.DrawingColor = cTabHoverBackground
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)
		    End If

		    g.DrawingColor = cTabText
		    g.FontSize = 11
		    g.Bold = False
		    Var textW As Double = g.TextWidth(tab.Caption)
		    Var textX As Double = tab.mBoundsX + (tab.mBoundsW - textW) / 2
		    Var textY As Double = tab.mBoundsY + (tab.mBoundsH + g.TextHeight) / 2 - 2
		    g.DrawText(tab.Caption, textX, textY)
		  Next

		  g.DrawingColor = cBorder
		  g.FillRectangle(0, kTabStripHeight, g.Width, 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawContentArea(g As WebGraphics)
		  g.DrawingColor = cContentBackground
		  g.FillRectangle(0, kContentTop, g.Width, g.Height - kContentTop - 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawGroups(g As WebGraphics)
		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return

		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)

		  For groupIdx As Integer = 0 To activeTab.mGroups.LastIndex
		    Var group As XjRibbonGroup = activeTab.mGroups(groupIdx)

		    For Each item As XjRibbonItem In group.mItems
		      DrawLargeButton(g, item)
		    Next

		    g.DrawingColor = cGroupLabelText
		    g.FontSize = 9
		    g.Bold = False
		    Var labelW As Double = g.TextWidth(group.Caption)
		    Var labelX As Double = group.mBoundsX + (group.mBoundsW - labelW) / 2
		    Var labelY As Double = group.mBoundsY + group.mBoundsH - 3
		    g.DrawText(group.Caption, labelX, labelY)

		    If groupIdx < activeTab.mGroups.LastIndex Then
		      g.DrawingColor = cGroupSeparator
		      Var sepX As Double = group.mBoundsX + group.mBoundsW + kGroupGap / 2
		      g.FillRectangle(sepX, group.mBoundsY + 2, 1, group.mBoundsH - kGroupLabelHeight - 4)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawLargeButton(g As WebGraphics, item As XjRibbonItem)
		  Var bx As Double = item.mBoundsX
		  Var by As Double = item.mBoundsY
		  Var bw As Double = item.mBoundsW
		  Var bh As Double = item.mBoundsH

		  If item.mIsPressed Then
		    g.DrawingColor = cItemPressedBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 4)
		  ElseIf item.mIsHovered Then
		    g.DrawingColor = cItemHoverBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 4)
		  End If

		  Var iconSize As Double = kLargeButtonIconSize
		  Var iconX As Double = bx + (bw - iconSize) / 2
		  Var iconY As Double = by + 6

		  If item.Icon <> Nil Then
		    g.DrawPicture(item.Icon, iconX, iconY, iconSize, iconSize, 0, 0, item.Icon.Width, item.Icon.Height)
		  Else
		    If item.IsEnabled Then
		      g.DrawingColor = cPlaceholderIcon
		    Else
		      g.DrawingColor = cPlaceholderIconDisabled
		    End If
		    g.FillRoundRectangle(iconX, iconY, iconSize, iconSize, 4)

		    g.DrawingColor = cPlaceholderIconText
		    g.FontSize = 16
		    g.Bold = True
		    Var letter As String = item.Caption.Left(1)
		    Var letterW As Double = g.TextWidth(letter)
		    g.DrawText(letter, iconX + (iconSize - letterW) / 2, iconY + iconSize / 2 + g.TextHeight / 2 - 3)
		  End If

		  If item.IsEnabled Then
		    g.DrawingColor = cItemText
		  Else
		    g.DrawingColor = cItemDisabledText
		  End If
		  g.FontSize = 9
		  g.Bold = False
		  Var textW As Double = g.TextWidth(item.Caption)
		  Var textX As Double = bx + (bw - textW) / 2
		  Var textY As Double = iconY + iconSize + 12
		  g.DrawText(item.Caption, textX, textY)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HitTestTabs(x As Double, y As Double) As XjRibbonTab
		  For Each tab As XjRibbonTab In mTabs
		    If x >= tab.mBoundsX And x < tab.mBoundsX + tab.mBoundsW And _
		      y >= tab.mBoundsY And y < tab.mBoundsY + tab.mBoundsH Then
		      Return tab
		    End If
		  Next
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HitTestItems(x As Double, y As Double) As XjRibbonItem
		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return Nil

		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		  For Each group As XjRibbonGroup In activeTab.mGroups
		    For Each item As XjRibbonItem In group.mItems
		      If x >= item.mBoundsX And x < item.mBoundsX + item.mBoundsW And _
		        y >= item.mBoundsY And y < item.mBoundsY + item.mBoundsH Then
		        Return item
		      End If
		    Next
		  Next
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClearHoverStates()
		  If mHoveredTab <> Nil Then
		    mHoveredTab.mIsHovered = False
		    mHoveredTab = Nil
		  End If
		  If mHoveredItem <> Nil Then
		    mHoveredItem.mIsHovered = False
		    mHoveredItem = Nil
		  End If
		End Sub
	#tag EndMethod

	#tag Property, Flags = &h0
		mTabs() As XjRibbonTab
	#tag EndProperty

	#tag Property, Flags = &h0
		mActiveTabIndex As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHoveredItem As XjRibbonItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mPressedItem As XjRibbonItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mHoveredTab As XjRibbonTab
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cBackground As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cContentBackground As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cBorder As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cTabText As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cTabActiveBackground As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cTabHoverBackground As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cTabAccent As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cItemText As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cItemDisabledText As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cItemHoverBackground As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cItemPressedBackground As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cGroupLabelText As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cGroupSeparator As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cPlaceholderIcon As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cPlaceholderIconDisabled As Color
	#tag EndProperty

	#tag Property, Flags = &h21
		Private cPlaceholderIconText As Color
	#tag EndProperty

	#tag Constant, Name = kTabStripHeight, Type = Double, Dynamic = False, Default = \"24", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTabPaddingH, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kTabGap, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kContentTop, Type = Double, Dynamic = False, Default = \"26", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kContentPadding, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kGroupLabelHeight, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kGroupPaddingH, Type = Double, Dynamic = False, Default = \"8", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kGroupGap, Type = Double, Dynamic = False, Default = \"8", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLargeButtonWidth, Type = Double, Dynamic = False, Default = \"56", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kLargeButtonIconSize, Type = Double, Dynamic = False, Default = \"32", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kItemGap, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag ViewBehavior
		#tag ViewProperty
			Name="PanelIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mPanelIndex"
			Visible=false
			Group="Behavior"
			InitialValue="-1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Visual Controls"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Indicator"
			Visible=false
			Group="Visual Controls"
			InitialValue=""
			Type="WebUIControl.Indicators"
			EditorType="Enum"
			#tag EnumValues
				"0 - Default"
				"1 - Primary"
				"2 - Secondary"
				"3 - Success"
				"4 - Danger"
				"5 - Warning"
				"6 - Info"
				"7 - Light"
				"8 - Dark"
				"9 - Link"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="ControlID"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DiffEngineDisabled"
			Visible=true
			Group="Canvas"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Behavior"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockHorizontal"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockVertical"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Visible=true
			Group="Behavior"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="_mName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
