#tag Class
Protected Class XjRibbon
Inherits DesktopCanvas
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas

		  LayoutTabs(g)
		  DrawBackground(g)
		  DrawTabStrip(g)
		  DrawContentArea(g)
		  DrawGroups(g)
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
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
		    Return True
		  End If

		  // Hit-test items
		  Var hitItem As XjRibbonItem = HitTestItems(x, y)
		  If hitItem <> Nil And hitItem.IsEnabled Then
		    mPressedItem = hitItem
		    hitItem.mIsPressed = True
		    Me.Refresh
		    Return True
		  End If

		  Return True
		End Function
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

	#tag Event
		Sub MouseExit()
		  ClearHoverStates
		  If mPressedItem <> Nil Then
		    mPressedItem.mIsPressed = False
		    mPressedItem = Nil
		  End If
		  Me.Refresh
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
		Private Sub LayoutTabs(g As Graphics)
		  // Layout tab headers
		  Var tabX As Double = kTabPaddingH

		  For Each tab As XjRibbonTab In mTabs
		    Var textW As Double = g.TextWidth(tab.Caption)
		    tab.mBoundsX = tabX
		    tab.mBoundsY = 0
		    tab.mBoundsW = textW + kTabPaddingH * 2
		    tab.mBoundsH = kTabStripHeight
		    tabX = tabX + tab.mBoundsW + kTabGap
		  Next

		  // Layout groups and items for active tab
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
		Private Sub DrawBackground(g As Graphics)
		  g.DrawingColor = Color.RGB(245, 245, 245)
		  g.FillRectangle(0, 0, g.Width, g.Height)

		  // Bottom border
		  g.DrawingColor = Color.RGB(210, 210, 210)
		  g.FillRectangle(0, g.Height - 1, g.Width, 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTabStrip(g As Graphics)
		  For i As Integer = 0 To mTabs.LastIndex
		    Var tab As XjRibbonTab = mTabs(i)

		    If i = mActiveTabIndex Then
		      // Active tab: white background
		      g.DrawingColor = Color.RGB(255, 255, 255)
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)

		      // Blue accent line at top
		      g.DrawingColor = Color.RGB(0, 120, 212)
		      g.FillRectangle(tab.mBoundsX, 0, tab.mBoundsW, 2)
		    ElseIf tab.mIsHovered Then
		      // Hovered tab: light blue
		      g.DrawingColor = Color.RGB(230, 240, 250)
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)
		    End If

		    // Tab text
		    g.DrawingColor = Color.RGB(60, 60, 60)
		    g.FontSize = 11
		    g.Bold = False
		    Var textW As Double = g.TextWidth(tab.Caption)
		    Var textX As Double = tab.mBoundsX + (tab.mBoundsW - textW) / 2
		    Var textY As Double = tab.mBoundsY + (tab.mBoundsH + g.TextHeight) / 2 - 2
		    g.DrawText(tab.Caption, textX, textY)
		  Next

		  // Tab strip bottom border
		  g.DrawingColor = Color.RGB(210, 210, 210)
		  g.FillRectangle(0, kTabStripHeight, g.Width, 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawContentArea(g As Graphics)
		  // White content area below tab strip
		  g.DrawingColor = Color.RGB(255, 255, 255)
		  g.FillRectangle(0, kContentTop, g.Width, g.Height - kContentTop - 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawGroups(g As Graphics)
		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return

		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)

		  For groupIdx As Integer = 0 To activeTab.mGroups.LastIndex
		    Var group As XjRibbonGroup = activeTab.mGroups(groupIdx)

		    // Draw items
		    For Each item As XjRibbonItem In group.mItems
		      DrawLargeButton(g, item)
		    Next

		    // Draw group label
		    g.DrawingColor = Color.RGB(120, 120, 120)
		    g.FontSize = 9
		    g.Bold = False
		    Var labelW As Double = g.TextWidth(group.Caption)
		    Var labelX As Double = group.mBoundsX + (group.mBoundsW - labelW) / 2
		    Var labelY As Double = group.mBoundsY + group.mBoundsH - 3
		    g.DrawText(group.Caption, labelX, labelY)

		    // Draw separator on right edge (except for last group)
		    If groupIdx < activeTab.mGroups.LastIndex Then
		      g.DrawingColor = Color.RGB(220, 220, 220)
		      Var sepX As Double = group.mBoundsX + group.mBoundsW + kGroupGap / 2
		      g.FillRectangle(sepX, group.mBoundsY + 2, 1, group.mBoundsH - kGroupLabelHeight - 4)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawLargeButton(g As Graphics, item As XjRibbonItem)
		  Var bx As Double = item.mBoundsX
		  Var by As Double = item.mBoundsY
		  Var bw As Double = item.mBoundsW
		  Var bh As Double = item.mBoundsH

		  // Background for hover/pressed states
		  If item.mIsPressed Then
		    g.DrawingColor = Color.RGB(200, 220, 240)
		    g.FillRoundRectangle(bx, by, bw, bh, 4, 4)
		  ElseIf item.mIsHovered Then
		    g.DrawingColor = Color.RGB(220, 235, 250)
		    g.FillRoundRectangle(bx, by, bw, bh, 4, 4)
		  End If

		  // Placeholder icon (colored rectangle)
		  Var iconSize As Double = kLargeButtonIconSize
		  Var iconX As Double = bx + (bw - iconSize) / 2
		  Var iconY As Double = by + 6

		  If item.IsEnabled Then
		    g.DrawingColor = Color.RGB(0, 120, 212)
		  Else
		    g.DrawingColor = Color.RGB(180, 180, 180)
		  End If
		  g.FillRoundRectangle(iconX, iconY, iconSize, iconSize, 4, 4)

		  // Icon letter (first char of caption as visual hint)
		  g.DrawingColor = Color.RGB(255, 255, 255)
		  g.FontSize = 16
		  g.Bold = True
		  Var letter As String = item.Caption.Left(1)
		  Var letterW As Double = g.TextWidth(letter)
		  g.DrawText(letter, iconX + (iconSize - letterW) / 2, iconY + iconSize / 2 + g.TextHeight / 2 - 3)

		  // Button text below icon
		  If item.IsEnabled Then
		    g.DrawingColor = Color.RGB(60, 60, 60)
		  Else
		    g.DrawingColor = Color.RGB(160, 160, 160)
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

	#tag Constant, Name = kItemTypeLarge, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kItemTypeSmall, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kItemTypeDropdown, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
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
			Name="Width"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Visible=true
			Group="Position"
			InitialValue="100"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockLeft"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockTop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockRight"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LockBottom"
			Visible=true
			Group="Position"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabIndex"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabPanelIndex"
			Visible=false
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TabStop"
			Visible=true
			Group="Position"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowAutoDeactivate"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backdrop"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="Picture"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Enabled"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Tooltip"
			Visible=true
			Group="Appearance"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocusRing"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Visible"
			Visible=true
			Group="Appearance"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowFocus"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="AllowTabs"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Transparent"
			Visible=true
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
