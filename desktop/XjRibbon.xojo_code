#tag Class
Protected Class XjRibbon
Inherits DesktopCanvas
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas

		  // Capture expanded height on first paint
		  If mExpandedHeight = 0 Then
		    mExpandedHeight = Me.Height
		  End If

		  ResolveColors
		  LayoutTabs(g)
		  DrawBackground(g)
		  DrawTabStrip(g)
		  If Not mIsCollapsed Then
		    DrawContentArea(g)
		    DrawGroups(g)
		  End If
		  DrawCollapseChevron(g)
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  // Hit-test collapse chevron
		  If HitTestCollapseChevron(x, y) Then
		    mLastTabClickTime = 0
		    mLastTabClickIndex = -1
		    ClearHoverStates
		    SetCollapsed(Not mIsCollapsed)
		    Return True
		  End If

		  // Hit-test tab headers
		  Var hitTab As XjRibbonTab = HitTestTabs(x, y)
		  If hitTab <> Nil Then
		    Var tabIdx As Integer = -1
		    For i As Integer = 0 To mTabs.LastIndex
		      If mTabs(i) Is hitTab Then
		        tabIdx = i
		        Exit
		      End If
		    Next

		    // Double-click detection: toggle collapse
		    Var now As Double = Microseconds
		    If tabIdx = mLastTabClickIndex And (now - mLastTabClickTime) < kDoubleClickUs Then
		      mLastTabClickTime = 0
		      mLastTabClickIndex = -1
		      ClearHoverStates
		      SetCollapsed(Not mIsCollapsed)
		      Return True
		    End If

		    // Single click: switch tab
		    mActiveTabIndex = tabIdx
		    mLastTabClickTime = now
		    mLastTabClickIndex = tabIdx

		    // When collapsed, single-click just switches active tab (no peek)
		    // Double-click will expand via detection above

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
		      If mPressedItem.ItemType = 2 And mPressedItem.mMenuItems.Count > 0 Then
		        // Show dropdown popup menu
		        Var baseMenu As New DesktopMenuItem
		        For Each mi As DesktopMenuItem In mPressedItem.mMenuItems
		          Var menuItem As New DesktopMenuItem(mi.Text)
		          menuItem.Tag = mi.Tag
		          baseMenu.AddMenu(menuItem)
		        Next
		        Var selected As DesktopMenuItem = baseMenu.PopUp
		        If selected <> Nil Then
		          RaiseEvent DropdownMenuAction(mPressedItem.Tag, selected.Tag.StringValue)
		        End If
		      Else
		        RaiseEvent ItemPressed(mPressedItem.Tag)
		      End If
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

		  // Update per-item tooltip
		  If mHoveredItem <> Nil And mHoveredItem.TooltipText <> "" Then
		    If Me.Tooltip <> mHoveredItem.TooltipText Then
		      Me.Tooltip = mHoveredItem.TooltipText
		    End If
		  ElseIf mHoveredTab <> Nil Then
		    If Me.Tooltip <> mHoveredTab.Caption Then
		      Me.Tooltip = mHoveredTab.Caption
		    End If
		  Else
		    If Me.Tooltip <> "" Then
		      Me.Tooltip = ""
		    End If
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

	#tag Hook, Flags = &h0
		Event DropdownMenuAction(itemTag As String, menuItemTag As String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event CollapseStateChanged(isCollapsed As Boolean)
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
		    Var tab As XjRibbonTab = mTabs(index)
		    If tab.IsContextual And Not tab.IsContextVisible Then Return
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

	#tag Method, Flags = &h0
		Function AddContextualTab(caption As String, contextGroup As String, accentColor As Color) As XjRibbonTab
		  Var tab As New XjRibbonTab
		  tab.Caption = caption
		  tab.IsContextual = True
		  tab.ContextGroup = contextGroup
		  tab.ContextAccentColor = accentColor
		  tab.IsContextVisible = False
		  mTabs.Add(tab)
		  Return tab
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ShowContextualTabs(contextGroup As String)
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual And tab.ContextGroup = contextGroup Then
		      tab.IsContextVisible = True
		    End If
		  Next
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HideContextualTabs(contextGroup As String)
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual And tab.ContextGroup = contextGroup Then
		      tab.IsContextVisible = False
		    End If
		  Next
		  EnsureValidActiveTab
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HideAllContextualTabs()
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual Then
		      tab.IsContextVisible = False
		    End If
		  Next
		  EnsureValidActiveTab
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsContextualTabVisible(contextGroup As String) As Boolean
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual And tab.ContextGroup = contextGroup And tab.IsContextVisible Then
		      Return True
		    End If
		  Next
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EnsureValidActiveTab()
		  If mActiveTabIndex >= 0 And mActiveTabIndex < mTabs.Count Then
		    Var tab As XjRibbonTab = mTabs(mActiveTabIndex)
		    If Not tab.IsContextual Or tab.IsContextVisible Then Return
		  End If
		  // Active tab is invalid — find first regular tab
		  For i As Integer = 0 To mTabs.LastIndex
		    If Not mTabs(i).IsContextual Then
		      mActiveTabIndex = i
		      Return
		    End If
		  Next
		  mActiveTabIndex = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetCollapsed(value As Boolean)
		  If mIsCollapsed <> value Then
		    mIsCollapsed = value

		    Var oldH As Integer = Me.Height
		    If mIsCollapsed Then
		      Me.Height = CType(kTabStripHeight + 2, Integer)
		    Else
		      Me.Height = CType(mExpandedHeight, Integer)
		    End If

		    // Resize window by the same delta
		    Var delta As Integer = Me.Height - oldH
		    If Me.Window <> Nil Then
		      Me.Window.Height = Me.Window.Height + delta
		    End If

		    RaiseEvent CollapseStateChanged(mIsCollapsed)
		    Me.Refresh
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsCollapsed() As Boolean
		  Return mIsCollapsed
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BottomEdge() As Integer
		  Return Me.Top + Me.Height
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LayoutTabs(g As Graphics)
		  // Layout tab headers
		  Var tabX As Double = kTabPaddingH

		  For Each tab As XjRibbonTab In mTabs
		    // Skip invisible contextual tabs
		    If tab.IsContextual And Not tab.IsContextVisible Then Continue

		    Var textW As Double = g.TextWidth(tab.Caption)
		    tab.mBoundsX = tabX
		    tab.mBoundsY = 0
		    tab.mBoundsW = textW + kTabPaddingH * 2
		    tab.mBoundsH = kTabStripHeight
		    tabX = tabX + tab.mBoundsW + kTabGap
		  Next

		  // Layout groups and items for active tab
		  If mIsCollapsed Then Return
		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return

		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		  Var contentY As Double = kContentTop + kContentPadding
		  Var contentH As Double = Me.Height - kContentTop - kContentPadding * 2
		  Var groupX As Double = kGroupPaddingH

		  For Each group As XjRibbonGroup In activeTab.mGroups
		    Var itemX As Double = groupX + kGroupPaddingH
		    Var itemAreaH As Double = contentH - kGroupLabelHeight
		    Var idx As Integer = 0

		    While idx <= group.mItems.LastIndex
		      Var item As XjRibbonItem = group.mItems(idx)

		      If item.ItemType = 1 Then
		        // Small button: batch consecutive small buttons (up to 3) into a vertical column
		        Var batch() As XjRibbonItem
		        Var maxTextW As Double = 0
		        While idx <= group.mItems.LastIndex And group.mItems(idx).ItemType = 1 And batch.Count < 3
		          batch.Add(group.mItems(idx))
		          g.FontSize = 9
		          Var tw As Double = g.TextWidth(group.mItems(idx).Caption)
		          If tw > maxTextW Then maxTextW = tw
		          idx = idx + 1
		        Wend

		        Var colWidth As Double = kSmallButtonIconSize + kSmallButtonTextPadding + maxTextW + kSmallButtonTextPadding * 2
		        If colWidth < kSmallButtonMinWidth Then colWidth = kSmallButtonMinWidth

		        Var totalRowH As Double = batch.Count * kSmallButtonHeight + (batch.Count - 1) * kSmallRowGap
		        Var startY As Double = contentY + (itemAreaH - totalRowH) / 2

		        For row As Integer = 0 To batch.LastIndex
		          batch(row).mBoundsX = itemX
		          batch(row).mBoundsY = startY + row * (kSmallButtonHeight + kSmallRowGap)
		          batch(row).mBoundsW = colWidth
		          batch(row).mBoundsH = kSmallButtonHeight
		        Next

		        itemX = itemX + colWidth + kItemGap
		      Else
		        // Large or Dropdown: full height column
		        item.mBoundsX = itemX
		        item.mBoundsY = contentY
		        item.mBoundsW = kLargeButtonWidth
		        item.mBoundsH = itemAreaH
		        itemX = itemX + kLargeButtonWidth + kItemGap
		        idx = idx + 1
		      End If
		    Wend

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
		  g.DrawingColor = cBackground
		  g.FillRectangle(0, 0, g.Width, g.Height)

		  // Bottom border
		  g.DrawingColor = cBorder
		  g.FillRectangle(0, g.Height - 1, g.Width, 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTabStrip(g As Graphics)
		  For i As Integer = 0 To mTabs.LastIndex
		    Var tab As XjRibbonTab = mTabs(i)

		    // Skip invisible contextual tabs
		    If tab.IsContextual And Not tab.IsContextVisible Then Continue

		    // Contextual tab background tint
		    If tab.IsContextual And tab.IsContextVisible Then
		      g.DrawingColor = tab.ContextAccentColor
		      g.Transparency = 85
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)
		      g.Transparency = 0

		      // Thicker accent bar (3px)
		      g.DrawingColor = tab.ContextAccentColor
		      g.FillRectangle(tab.mBoundsX, 0, tab.mBoundsW, 3)
		    End If

		    If i = mActiveTabIndex Then
		      g.DrawingColor = cTabActiveBackground
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)

		      // Accent line at top — use context color for contextual tabs
		      If tab.IsContextual Then
		        g.DrawingColor = tab.ContextAccentColor
		      Else
		        g.DrawingColor = cTabAccent
		      End If
		      g.FillRectangle(tab.mBoundsX, 0, tab.mBoundsW, 2)
		    ElseIf tab.mIsHovered Then
		      g.DrawingColor = cTabHoverBackground
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)
		    End If

		    // Tab text
		    g.DrawingColor = cTabText
		    g.FontSize = 11
		    g.Bold = False
		    Var textW As Double = g.TextWidth(tab.Caption)
		    Var textX As Double = tab.mBoundsX + (tab.mBoundsW - textW) / 2
		    Var textY As Double = tab.mBoundsY + (tab.mBoundsH + g.TextHeight) / 2 - 2
		    g.DrawText(tab.Caption, textX, textY)
		  Next

		  // Tab strip bottom border
		  g.DrawingColor = cBorder
		  g.FillRectangle(0, kTabStripHeight, g.Width, 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawContentArea(g As Graphics)
		  g.DrawingColor = cContentBackground
		  g.FillRectangle(0, kContentTop, g.Width, g.Height - kContentTop - 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawGroups(g As Graphics)
		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return

		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)

		  For groupIdx As Integer = 0 To activeTab.mGroups.LastIndex
		    Var group As XjRibbonGroup = activeTab.mGroups(groupIdx)

		    // Draw items by type
		    For Each item As XjRibbonItem In group.mItems
		      Select Case item.ItemType
		      Case 1
		        DrawSmallButton(g, item)
		      Case 2
		        DrawDropdownButton(g, item)
		      Else
		        DrawLargeButton(g, item)
		      End Select
		    Next

		    // Draw group label
		    g.DrawingColor = cGroupLabelText
		    g.FontSize = 9
		    g.Bold = False
		    Var labelW As Double = g.TextWidth(group.Caption)
		    Var labelX As Double = group.mBoundsX + (group.mBoundsW - labelW) / 2
		    Var labelY As Double = group.mBoundsY + group.mBoundsH - 3
		    g.DrawText(group.Caption, labelX, labelY)

		    // Draw separator on right edge (except for last group)
		    If groupIdx < activeTab.mGroups.LastIndex Then
		      g.DrawingColor = cGroupSeparator
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
		    g.DrawingColor = cItemPressedBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 4, 4)
		  ElseIf item.mIsHovered Then
		    g.DrawingColor = cItemHoverBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 4, 4)
		  End If

		  // Icon area
		  Var iconSize As Double = kLargeButtonIconSize
		  Var iconX As Double = bx + (bw - iconSize) / 2
		  Var iconY As Double = by + 6

		  If item.Icon <> Nil Then
		    // Draw real icon
		    If item.IsEnabled Then
		      g.DrawPicture(item.Icon, iconX, iconY, iconSize, iconSize, 0, 0, item.Icon.Width, item.Icon.Height)
		    Else
		      g.Transparency = 60
		      g.DrawPicture(item.Icon, iconX, iconY, iconSize, iconSize, 0, 0, item.Icon.Width, item.Icon.Height)
		      g.Transparency = 0
		    End If
		  Else
		    // Placeholder icon (colored rectangle)
		    If item.IsEnabled Then
		      g.DrawingColor = cPlaceholderIcon
		    Else
		      g.DrawingColor = cPlaceholderIconDisabled
		    End If
		    g.FillRoundRectangle(iconX, iconY, iconSize, iconSize, 4, 4)

		    // Icon letter (first char of caption as visual hint)
		    g.DrawingColor = cPlaceholderIconText
		    g.FontSize = 16
		    g.Bold = True
		    Var letter As String = item.Caption.Left(1)
		    Var letterW As Double = g.TextWidth(letter)
		    g.DrawText(letter, iconX + (iconSize - letterW) / 2, iconY + iconSize / 2 + g.TextHeight / 2 - 3)
		  End If

		  // Button text below icon
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
		Private Sub DrawSmallButton(g As Graphics, item As XjRibbonItem)
		  Var bx As Double = item.mBoundsX
		  Var by As Double = item.mBoundsY
		  Var bw As Double = item.mBoundsW
		  Var bh As Double = item.mBoundsH

		  // Hover/pressed background
		  If item.mIsPressed Then
		    g.DrawingColor = cItemPressedBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
		  ElseIf item.mIsHovered Then
		    g.DrawingColor = cItemHoverBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
		  End If

		  // Icon (16x16) on the left
		  Var iconX As Double = bx + 3
		  Var iconY As Double = by + (bh - kSmallButtonIconSize) / 2

		  If item.Icon <> Nil Then
		    If item.IsEnabled Then
		      g.DrawPicture(item.Icon, iconX, iconY, kSmallButtonIconSize, kSmallButtonIconSize, 0, 0, item.Icon.Width, item.Icon.Height)
		    Else
		      g.Transparency = 60
		      g.DrawPicture(item.Icon, iconX, iconY, kSmallButtonIconSize, kSmallButtonIconSize, 0, 0, item.Icon.Width, item.Icon.Height)
		      g.Transparency = 0
		    End If
		  Else
		    // Small placeholder square
		    If item.IsEnabled Then
		      g.DrawingColor = cPlaceholderIcon
		    Else
		      g.DrawingColor = cPlaceholderIconDisabled
		    End If
		    g.FillRoundRectangle(iconX, iconY, kSmallButtonIconSize, kSmallButtonIconSize, 2, 2)
		  End If

		  // Text to the right of icon
		  If item.IsEnabled Then
		    g.DrawingColor = cItemText
		  Else
		    g.DrawingColor = cItemDisabledText
		  End If
		  g.FontSize = 9
		  g.Bold = False
		  Var textX As Double = iconX + kSmallButtonIconSize + kSmallButtonTextPadding
		  Var textY As Double = by + (bh + g.TextHeight) / 2 - 1
		  g.DrawText(item.Caption, textX, textY)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawDropdownButton(g As Graphics, item As XjRibbonItem)
		  // Draw the base button like a large button
		  DrawLargeButton(g, item)

		  // Draw dropdown arrow chevron below the text
		  Var arrowW As Double = kDropdownArrowSize
		  Var arrowX As Double = item.mBoundsX + (item.mBoundsW - arrowW) / 2
		  Var arrowY As Double = item.mBoundsY + item.mBoundsH - 6

		  If item.IsEnabled Then
		    g.DrawingColor = cItemText
		  Else
		    g.DrawingColor = cItemDisabledText
		  End If

		  Var midX As Double = arrowX + arrowW / 2
		  g.PenSize = 1.5
		  g.DrawLine(arrowX, arrowY, midX, arrowY + arrowW / 2)
		  g.DrawLine(midX, arrowY + arrowW / 2, arrowX + arrowW, arrowY)
		  g.PenSize = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawCollapseChevron(g As Graphics)
		  Var chevX As Double = g.Width - kCollapseChevronSize - 8
		  Var chevY As Double = (kTabStripHeight - kCollapseChevronSize) / 2
		  Var midX As Double = chevX + kCollapseChevronSize / 2

		  g.DrawingColor = cCollapseChevron
		  g.PenSize = 1.5

		  If mIsCollapsed Then
		    // Down chevron (v) — "expand"
		    Var topY As Double = chevY + 2
		    g.DrawLine(chevX, topY, midX, topY + kCollapseChevronSize / 2)
		    g.DrawLine(midX, topY + kCollapseChevronSize / 2, chevX + kCollapseChevronSize, topY)
		  Else
		    // Up chevron (^) — "collapse"
		    Var botY As Double = chevY + kCollapseChevronSize - 2
		    g.DrawLine(chevX, botY, midX, botY - kCollapseChevronSize / 2)
		    g.DrawLine(midX, botY - kCollapseChevronSize / 2, chevX + kCollapseChevronSize, botY)
		  End If

		  g.PenSize = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HitTestCollapseChevron(x As Double, y As Double) As Boolean
		  Var chevX As Double = Me.Width - kCollapseChevronSize - 8
		  Var chevY As Double = (kTabStripHeight - kCollapseChevronSize) / 2
		  Return x >= chevX - 4 And x <= chevX + kCollapseChevronSize + 4 And _
		    y >= chevY - 4 And y <= chevY + kCollapseChevronSize + 4
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HitTestTabs(x As Double, y As Double) As XjRibbonTab
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual And Not tab.IsContextVisible Then Continue
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
		  If mIsCollapsed Then Return Nil
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
		    cCollapseChevron = Color.RGB(150, 150, 150)
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
		    cCollapseChevron = Color.RGB(120, 120, 120)
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
		Private mIsCollapsed As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastTabClickTime As Double = 0
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mLastTabClickIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mExpandedHeight As Double = 0
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

	#tag Property, Flags = &h21
		Private cCollapseChevron As Color
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

	#tag Constant, Name = kDropdownArrowSize, Type = Double, Dynamic = False, Default = \"6", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSmallButtonHeight, Type = Double, Dynamic = False, Default = \"22", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSmallButtonIconSize, Type = Double, Dynamic = False, Default = \"16", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSmallButtonMinWidth, Type = Double, Dynamic = False, Default = \"60", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSmallButtonTextPadding, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kSmallRowGap, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kCollapseChevronSize, Type = Double, Dynamic = False, Default = \"12", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kDoubleClickUs, Type = Double, Dynamic = False, Default = \"400000", Scope = Private
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
