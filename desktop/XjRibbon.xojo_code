#tag Class
Protected Class XjRibbon
Inherits DesktopCanvas
	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #Pragma Unused areas
		  If mExpandedHeight = 0 Then mExpandedHeight = Me.Height
		  ResolveColors
		  LayoutTabs(g)
		  DrawBackground(g)
		  DrawTabStrip(g)
		  If Not mIsCollapsed Then
		    DrawContentArea(g)
		    DrawGroups(g)
		  End If
		  DrawCollapseChevron(g)
		  DrawFocusRing(g)
		  DrawKeyTips(g)
		End Sub
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  Me.SetFocus
		  If mKeyTipMode <> kKeyTipNone Then DismissKeyTips
		  If HitTestCollapseChevron(x, y) Then
		    mLastTabClickTime = 0
		    mLastTabClickIndex = -1
		    ClearHoverStates
		    SetCollapsed(Not mIsCollapsed)
		    Return True
		  End If
		  Var hitTab As XjRibbonTab = HitTestTabs(x, y)
		  If hitTab <> Nil Then
		    Var tabIdx As Integer = -1
		    For i As Integer = 0 To mTabs.LastIndex
		      If mTabs(i) Is hitTab Then
		        tabIdx = i
		        Exit
		      End If
		    Next
		    Var now As Double = Microseconds
		    If tabIdx = mLastTabClickIndex And (now - mLastTabClickTime) < kDoubleClickUs Then
		      mLastTabClickTime = 0
		      mLastTabClickIndex = -1
		      ClearHoverStates
		      SetCollapsed(Not mIsCollapsed)
		      Return True
		    End If
		    mActiveTabIndex = tabIdx
		    mLastTabClickTime = now
		    mLastTabClickIndex = tabIdx
		    ClearHoverStates
		    Me.Refresh
		    Return True
		  End If
		  Var hitItem As XjRibbonItem = HitTestItems(x, y)
		  If hitItem <> Nil And hitItem.IsEnabled Then
		    mPressedItem = hitItem
		    If hitItem.ItemType = 2 And hitItem.IsSplitButton Then
		      mPressedOnArrow = x >= hitItem.mBoundsX + hitItem.mBoundsW - kArrowZoneWidth
		    Else
		      mPressedOnArrow = False
		    End If
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
		    Var pressed As XjRibbonItem = mPressedItem
		    mPressedItem = Nil
		    Var hitItem As XjRibbonItem = HitTestItems(x, y)
		    If hitItem Is pressed And pressed.IsEnabled Then
		      If pressed.ItemType = 2 And pressed.mMenuItems.Count > 0 Then
		        If pressed.IsSplitButton And Not mPressedOnArrow Then
		          // SplitButton body click — fire ItemPressed (no menu)
		          RaiseEvent ItemPressed(pressed.Tag)
		        Else
		          // Arrow click or plain dropdown — open popup menu
		          Var baseMenu As New DesktopMenuItem
		          For Each mi As DesktopMenuItem In pressed.mMenuItems
		            Var menuItem As New DesktopMenuItem(mi.Text)
		            menuItem.Tag = mi.Tag
		            baseMenu.AddMenu(menuItem)
		          Next
		          Var selected As DesktopMenuItem = baseMenu.PopUp
		          If selected <> Nil Then RaiseEvent DropdownMenuAction(pressed.Tag, selected.Tag.StringValue)
		        End If
		      Else
		        If pressed.IsToggle Then pressed.IsToggleActive = Not pressed.IsToggleActive
		        RaiseEvent ItemPressed(pressed.Tag)
		      End If
		    End If
		    pressed.mIsPressed = False
		    Me.Refresh
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub MouseMove(x As Integer, y As Integer)
		  Var needsRefresh As Boolean = False
		  Var hitTab As XjRibbonTab = HitTestTabs(x, y)
		  If Not (hitTab Is mHoveredTab) Then
		    If mHoveredTab <> Nil Then mHoveredTab.mIsHovered = False
		    mHoveredTab = hitTab
		    If mHoveredTab <> Nil Then mHoveredTab.mIsHovered = True
		    needsRefresh = True
		  End If
		  Var hitItem As XjRibbonItem = HitTestItems(x, y)
		  If Not (hitItem Is mHoveredItem) Then
		    If mHoveredItem <> Nil Then mHoveredItem.mIsHovered = False
		    mHoveredItem = hitItem
		    If mHoveredItem <> Nil Then mHoveredItem.mIsHovered = True
		    needsRefresh = True
		  End If
		  If mHoveredItem <> Nil And mHoveredItem.TooltipText <> "" Then
		    If Me.Tooltip <> mHoveredItem.TooltipText Then Me.Tooltip = mHoveredItem.TooltipText
		  ElseIf mHoveredTab <> Nil Then
		    If Me.Tooltip <> mHoveredTab.Caption Then Me.Tooltip = mHoveredTab.Caption
		  Else
		    If Me.Tooltip <> "" Then Me.Tooltip = ""
		  End If
		  If needsRefresh Then Me.Refresh
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

	#tag Event
		Sub Opening()
		  Me.AllowFocus = True
		  Me.AllowTabs = True
		  Me.AllowFocusRing = False
		End Sub
	#tag EndEvent

	#tag Event
		Function KeyDown(key As String) As Boolean
		  Return HandleKeyDown(key)
		End Function
	#tag EndEvent

	#tag Event
		Sub FocusLost()
		  DismissKeyTips
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
		    If tab.IsContextual And tab.ContextGroup = contextGroup Then tab.IsContextVisible = True
		  Next
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HideContextualTabs(contextGroup As String)
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual And tab.ContextGroup = contextGroup Then tab.IsContextVisible = False
		  Next
		  EnsureValidActiveTab
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub HideAllContextualTabs()
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual Then tab.IsContextVisible = False
		  Next
		  EnsureValidActiveTab
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsContextualTabVisible(contextGroup As String) As Boolean
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual And tab.ContextGroup = contextGroup And tab.IsContextVisible Then Return True
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
		    Var delta As Integer = Me.Height - oldH
		    If Me.Window <> Nil Then Me.Window.Height = Me.Window.Height + delta
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

	#tag Method, Flags = &h0
		Function GetToggleState(tag As String) As Boolean
		  Var item As XjRibbonItem = FindItemByTag(tag)
		  If item <> Nil Then Return item.IsToggleActive
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetToggleState(tag As String, value As Boolean)
		  Var item As XjRibbonItem = FindItemByTag(tag)
		  If item <> Nil Then
		    item.IsToggleActive = value
		    Me.Refresh
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FindItemByTag(tag As String) As XjRibbonItem
		  For Each tab As XjRibbonTab In mTabs
		    For Each group As XjRibbonGroup In tab.mGroups
		      For Each item As XjRibbonItem In group.mItems
		        If item.Tag = tag Then Return item
		      Next
		    Next
		  Next
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LayoutTabs(g As Graphics)
		  Var tabX As Double = kTabPaddingH
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual And Not tab.IsContextVisible Then Continue
		    Var textW As Double = g.TextWidth(tab.Caption)
		    tab.mBoundsX = tabX
		    tab.mBoundsY = 0
		    tab.mBoundsW = textW + kTabPaddingH * 2
		    tab.mBoundsH = kTabStripHeight
		    tabX = tabX + tab.mBoundsW + kTabGap
		  Next
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
		        Var batch() As XjRibbonItem
		        Var maxTextW As Double = 0
		        While idx <= group.mItems.LastIndex And group.mItems(idx).ItemType = 1 And batch.Count < 3
		          batch.Add(group.mItems(idx))
		          g.FontSize = 11
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
		      ElseIf item.ItemType = 3 Then
		        // CheckBox column batch (same 3-per-column stacking, different colWidth formula)
		        Var cbBatch() As XjRibbonItem
		        Var cbMaxTextW As Double = 0
		        While idx <= group.mItems.LastIndex And group.mItems(idx).ItemType = 3 And cbBatch.Count < 3
		          cbBatch.Add(group.mItems(idx))
		          g.FontSize = 11
		          Var cbTw As Double = g.TextWidth(group.mItems(idx).Caption)
		          If cbTw > cbMaxTextW Then cbMaxTextW = cbTw
		          idx = idx + 1
		        Wend
		        Var cbGlyph As Double = 13
		        Var cbColWidth As Double = cbGlyph + kSmallButtonTextPadding + cbMaxTextW + kSmallButtonTextPadding * 2
		        If cbColWidth < kSmallButtonMinWidth Then cbColWidth = kSmallButtonMinWidth
		        Var cbTotalH As Double = cbBatch.Count * kSmallButtonHeight + (cbBatch.Count - 1) * kSmallRowGap
		        Var cbStartY As Double = contentY + (itemAreaH - cbTotalH) / 2
		        For row As Integer = 0 To cbBatch.LastIndex
		          cbBatch(row).mBoundsX = itemX
		          cbBatch(row).mBoundsY = cbStartY + row * (kSmallButtonHeight + kSmallRowGap)
		          cbBatch(row).mBoundsW = cbColWidth
		          cbBatch(row).mBoundsH = kSmallButtonHeight
		        Next
		        itemX = itemX + cbColWidth + kItemGap
		      ElseIf item.ItemType = 4 Then
		        // Separator: visual column gap, no bounds needed, no draw
		        item.mBoundsW = 0
		        item.mBoundsH = 0
		        itemX = itemX + kItemGap
		        idx = idx + 1
		      Else
		        item.mBoundsX = itemX
		        item.mBoundsY = contentY
		        // Auto-expand width to fit caption; add fixed arrow zone for SplitButtons
		        g.FontSize = 11
		        g.Bold = False
		        Var captionLinesLayout() As String = item.Caption.Split(Chr(10))
		        Var maxCapW As Double = 0
		        For Each cl As String In captionLinesLayout
		          maxCapW = Max(maxCapW, g.TextWidth(cl))
		        Next
		        Var btnW As Double = Max(kLargeButtonWidth, maxCapW + 16)
		        If item.IsSplitButton Then btnW = btnW + kArrowZoneWidth
		        item.mBoundsW = btnW
		        item.mBoundsH = itemAreaH
		        itemX = itemX + btnW + kItemGap
		        idx = idx + 1
		      End If
		    Wend
		    Var groupInnerW As Double = itemX - groupX - kGroupPaddingH
		    If group.mItems.Count > 0 Then groupInnerW = groupInnerW - kItemGap
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
		  g.DrawingColor = cBorder
		  g.FillRectangle(0, g.Height - 1, g.Width, 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawTabStrip(g As Graphics)
		  For i As Integer = 0 To mTabs.LastIndex
		    Var tab As XjRibbonTab = mTabs(i)
		    If tab.IsContextual And Not tab.IsContextVisible Then Continue
		    If tab.IsContextual And tab.IsContextVisible Then
		      g.DrawingColor = tab.ContextAccentColor
		      g.Transparency = 85
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)
		      g.Transparency = 0
		      g.DrawingColor = tab.ContextAccentColor
		      g.FillRectangle(tab.mBoundsX, 0, tab.mBoundsW, 3)
		    End If
		    If i = mActiveTabIndex Then
		      g.DrawingColor = cTabActiveBackground
		      g.FillRectangle(tab.mBoundsX, tab.mBoundsY, tab.mBoundsW, tab.mBoundsH)
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
		    g.DrawingColor = cTabText
		    g.FontSize = 13
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
		    For Each item As XjRibbonItem In group.mItems
		      Select Case item.ItemType
		      Case 1
		        DrawSmallButton(g, item)
		      Case 2
		        DrawDropdownButton(g, item)
		      Case 3
		        DrawCheckBoxItem(g, item)
		      Case 4
		        // Separator — no rendering
		      Else
		        DrawLargeButton(g, item)
		      End Select
		    Next
		    g.DrawingColor = cGroupLabelText
		    g.FontSize = 11
		    g.Bold = False
		    Var labelW As Double = g.TextWidth(group.Caption)
		    g.DrawText(group.Caption, group.mBoundsX + (group.mBoundsW - labelW) / 2, group.mBoundsY + group.mBoundsH - 3)
		    If groupIdx < activeTab.mGroups.LastIndex Then
		      g.DrawingColor = cGroupSeparator
		      g.FillRectangle(group.mBoundsX + group.mBoundsW + kGroupGap / 2, group.mBoundsY + 2, 1, group.mBoundsH - kGroupLabelHeight - 4)
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
		  If item.mIsPressed Then
		    g.DrawingColor = cItemPressedBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 4, 4)
		  ElseIf item.IsToggle And item.IsToggleActive Then
		    If item.mIsHovered Then
		      g.DrawingColor = cToggleActiveHoverBackground
		    Else
		      g.DrawingColor = cToggleActiveBackground
		    End If
		    g.FillRoundRectangle(bx, by, bw, bh, 4, 4)
		    g.DrawingColor = cBorder
		    g.DrawRoundRectangle(bx + 0.5, by + 0.5, bw - 1, bh - 1, 4, 4)
		  ElseIf item.mIsHovered Then
		    g.DrawingColor = cItemHoverBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 4, 4)
		  End If
		  Var iconSize As Double = kLargeButtonIconSize
		  Var iconX As Double = bx + (bw - iconSize) / 2
		  Var iconY As Double = by + 6
		  If item.Icon <> Nil Then
		    If item.IsEnabled Then
		      g.DrawPicture(item.Icon, iconX, iconY, iconSize, iconSize, 0, 0, item.Icon.Width, item.Icon.Height)
		    Else
		      g.Transparency = 60
		      g.DrawPicture(item.Icon, iconX, iconY, iconSize, iconSize, 0, 0, item.Icon.Width, item.Icon.Height)
		      g.Transparency = 0
		    End If
		  Else
		    If item.IsEnabled Then
		      g.DrawingColor = cPlaceholderIcon
		    Else
		      g.DrawingColor = cPlaceholderIconDisabled
		    End If
		    g.FillRoundRectangle(iconX, iconY, iconSize, iconSize, 4, 4)
		    g.DrawingColor = cPlaceholderIconText
		    g.FontSize = 18
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
		  g.FontSize = 11
		  g.Bold = False
		  Var captionLines() As String = item.Caption.Split(Chr(10))
		  If captionLines.Count > 1 Then
		    Var drawBodyW As Double = If(item.IsSplitButton, bw - kArrowZoneWidth, bw)
		    Var line1W As Double = g.TextWidth(captionLines(0))
		    Var line2W As Double = g.TextWidth(captionLines(1))
		    g.DrawText(captionLines(0), bx + (drawBodyW - line1W) / 2, iconY + iconSize + 7)
		    g.DrawText(captionLines(1), bx + (drawBodyW - line2W) / 2, iconY + iconSize + 19)
		  Else
		    Var drawBodyW As Double = If(item.IsSplitButton, bw - kArrowZoneWidth, bw)
		    Var textW As Double = g.TextWidth(item.Caption)
		    g.DrawText(item.Caption, bx + (drawBodyW - textW) / 2, iconY + iconSize + 12)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawSmallButton(g As Graphics, item As XjRibbonItem)
		  Var bx As Double = item.mBoundsX
		  Var by As Double = item.mBoundsY
		  Var bw As Double = item.mBoundsW
		  Var bh As Double = item.mBoundsH
		  If item.mIsPressed Then
		    g.DrawingColor = cItemPressedBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
		  ElseIf item.IsToggle And item.IsToggleActive Then
		    If item.mIsHovered Then
		      g.DrawingColor = cToggleActiveHoverBackground
		    Else
		      g.DrawingColor = cToggleActiveBackground
		    End If
		    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
		    g.DrawingColor = cBorder
		    g.DrawRoundRectangle(bx + 0.5, by + 0.5, bw - 1, bh - 1, 3, 3)
		  ElseIf item.mIsHovered Then
		    g.DrawingColor = cItemHoverBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
		  End If
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
		    If item.IsEnabled Then
		      g.DrawingColor = cPlaceholderIcon
		    Else
		      g.DrawingColor = cPlaceholderIconDisabled
		    End If
		    g.FillRoundRectangle(iconX, iconY, kSmallButtonIconSize, kSmallButtonIconSize, 2, 2)
		  End If
		  If item.IsEnabled Then
		    g.DrawingColor = cItemText
		  Else
		    g.DrawingColor = cItemDisabledText
		  End If
		  g.FontSize = 11
		  g.Bold = False
		  g.DrawText(item.Caption, iconX + kSmallButtonIconSize + kSmallButtonTextPadding, by + (bh + g.TextHeight) / 2 - 1)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawDropdownButton(g As Graphics, item As XjRibbonItem)
		  DrawLargeButton(g, item)
		  Var arrowW As Double = kDropdownArrowSize

		  If item.IsSplitButton Then
		    // Separator at fixed kArrowZoneWidth from right edge (not percentage)
		    Var sepX As Double = item.mBoundsX + item.mBoundsW - kArrowZoneWidth
		    g.DrawingColor = cBorder
		    g.FillRectangle(sepX, item.mBoundsY + 4, 1, item.mBoundsH - 8)
		    // Chevron centered in fixed arrow zone
		    Var arrowZoneX As Double = sepX
		    Var arrowX As Double = arrowZoneX + (kArrowZoneWidth - arrowW) / 2
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
		  Else
		    // Plain dropdown: chevron centered in full button width (unchanged)
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
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawCheckBoxItem(g As Graphics, item As XjRibbonItem)
		  Var bx As Double = item.mBoundsX
		  Var by As Double = item.mBoundsY
		  Var bw As Double = item.mBoundsW
		  Var bh As Double = item.mBoundsH

		  // Hover / pressed background for the whole row
		  If item.mIsPressed Then
		    g.DrawingColor = cItemPressedBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
		  ElseIf item.mIsHovered Then
		    g.DrawingColor = cItemHoverBackground
		    g.FillRoundRectangle(bx, by, bw, bh, 3, 3)
		  End If

		  // Glyph: 13x13 rounded rect, vertically centered
		  Var glyphSize As Double = 13
		  Var glyphX As Double = bx + 2
		  Var glyphY As Double = by + (bh - glyphSize) / 2

		  If item.IsToggleActive Then
		    // Checked: blue fill + white checkmark
		    g.DrawingColor = cTabAccent
		    g.FillRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2, 2)
		    g.DrawingColor = Color.RGB(255, 255, 255)
		    g.PenSize = 1.5
		    g.DrawLine(glyphX + 2, glyphY + 6, glyphX + 5, glyphY + 9)
		    g.DrawLine(glyphX + 5, glyphY + 9, glyphX + 11, glyphY + 3)
		    g.PenSize = 1
		  Else
		    // Unchecked: white interior with cBorder border
		    g.DrawingColor = cContentBackground
		    g.FillRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2, 2)
		    g.DrawingColor = cBorder
		    g.DrawRoundRectangle(glyphX, glyphY, glyphSize, glyphSize, 2, 2)
		  End If

		  // Text label
		  If item.IsEnabled Then
		    g.DrawingColor = cItemText
		  Else
		    g.DrawingColor = cItemDisabledText
		  End If
		  g.FontSize = 11
		  g.Bold = False
		  Var textX As Double = glyphX + glyphSize + kSmallButtonTextPadding
		  g.DrawText(item.Caption, textX, by + (bh + g.TextHeight) / 2 - 1)
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
		    Var topY As Double = chevY + 2
		    g.DrawLine(chevX, topY, midX, topY + kCollapseChevronSize / 2)
		    g.DrawLine(midX, topY + kCollapseChevronSize / 2, chevX + kCollapseChevronSize, topY)
		  Else
		    Var botY As Double = chevY + kCollapseChevronSize - 2
		    g.DrawLine(chevX, botY, midX, botY - kCollapseChevronSize / 2)
		    g.DrawLine(midX, botY - kCollapseChevronSize / 2, chevX + kCollapseChevronSize, botY)
		  End If
		  g.PenSize = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawKeyTips(g As Graphics)
		  If mKeyTipMode = kKeyTipNone Then Return
		  If mKeyTipMode = kKeyTipLevel1 Then
		    For Each tab As XjRibbonTab In mTabs
		      If tab.IsContextual And Not tab.IsContextVisible Then Continue
		      If tab.KeyTip = "" Then Continue
		      DrawKeyTipBadge(g, tab.KeyTip, tab.mBoundsX + tab.mBoundsW / 2, tab.mBoundsY + tab.mBoundsH - 2)
		    Next
		  ElseIf mKeyTipMode = kKeyTipLevel2 Then
		    If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return
		    Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		    For Each group As XjRibbonGroup In activeTab.mGroups
		      For Each item As XjRibbonItem In group.mItems
		        If item.KeyTip = "" Or Not item.IsEnabled Then Continue
		        If item.ItemType = 1 Then
		          DrawKeyTipBadge(g, item.KeyTip, item.mBoundsX + item.mBoundsW - 8, item.mBoundsY + item.mBoundsH / 2)
		        Else
		          DrawKeyTipBadge(g, item.KeyTip, item.mBoundsX + item.mBoundsW / 2, item.mBoundsY + item.mBoundsH - 2)
		        End If
		      Next
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawKeyTipBadge(g As Graphics, letter As String, cx As Double, cy As Double)
		  g.FontSize = 11
		  g.Bold = True
		  Var tw As Double = g.TextWidth(letter)
		  Var badgeW As Double = tw + 8
		  If badgeW < 16 Then badgeW = 16
		  Var bx As Double = cx - badgeW / 2
		  Var by As Double = cy - 7
		  g.DrawingColor = cKeyTipBackground
		  g.FillRoundRectangle(bx, by, badgeW, 14, 3, 3)
		  g.DrawingColor = cKeyTipBorder
		  g.DrawRoundRectangle(bx, by, badgeW, 14, 3, 3)
		  g.DrawingColor = cKeyTipText
		  g.DrawText(letter, cx - tw / 2, cy + g.TextHeight / 2 - 2)
		  g.Bold = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DrawFocusRing(g As Graphics)
		  If mKeyTipMode = kKeyTipNone Then Return
		  g.DrawingColor = cFocusRing
		  g.PenSize = 2
		  If mKeyTipMode = kKeyTipLevel1 And mFocusedTabIndex >= 0 And mFocusedTabIndex <= mTabs.LastIndex Then
		    Var tab As XjRibbonTab = mTabs(mFocusedTabIndex)
		    g.DrawRoundRectangle(tab.mBoundsX - 1, tab.mBoundsY, tab.mBoundsW + 2, tab.mBoundsH, 3, 3)
		  ElseIf mKeyTipMode = kKeyTipLevel2 And mFocusedGroupIndex >= 0 Then
		    If mActiveTabIndex >= 0 And mActiveTabIndex < mTabs.Count Then
		      Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		      If mFocusedGroupIndex <= activeTab.mGroups.LastIndex Then
		        Var group As XjRibbonGroup = activeTab.mGroups(mFocusedGroupIndex)
		        If mFocusedItemIndex >= 0 And mFocusedItemIndex <= group.mItems.LastIndex Then
		          Var item As XjRibbonItem = group.mItems(mFocusedItemIndex)
		          Var r As Double = If(item.ItemType = 1, 3, 4)
		          g.DrawRoundRectangle(item.mBoundsX - 1, item.mBoundsY - 1, item.mBoundsW + 2, item.mBoundsH + 2, r, r)
		        End If
		      End If
		    End If
		  End If
		  g.PenSize = 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HitTestCollapseChevron(x As Double, y As Double) As Boolean
		  Var chevX As Double = Me.Width - kCollapseChevronSize - 8
		  Var chevY As Double = (kTabStripHeight - kCollapseChevronSize) / 2
		  Return x >= chevX - 4 And x <= chevX + kCollapseChevronSize + 4 And y >= chevY - 4 And y <= chevY + kCollapseChevronSize + 4
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HitTestTabs(x As Double, y As Double) As XjRibbonTab
		  For Each tab As XjRibbonTab In mTabs
		    If tab.IsContextual And Not tab.IsContextVisible Then Continue
		    If x >= tab.mBoundsX And x < tab.mBoundsX + tab.mBoundsW And y >= tab.mBoundsY And y < tab.mBoundsY + tab.mBoundsH Then Return tab
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
		      If x >= item.mBoundsX And x < item.mBoundsX + item.mBoundsW And y >= item.mBoundsY And y < item.mBoundsY + item.mBoundsH Then Return item
		    Next
		  Next
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AssignKeyTips()
		  Var usedLetters As New Dictionary
		  For Each tab As XjRibbonTab In mTabs
		    If tab.KeyTip <> "" Then usedLetters.Value(tab.KeyTip.Uppercase) = True
		  Next
		  For Each tab As XjRibbonTab In mTabs
		    If tab.KeyTip = "" Then tab.KeyTip = AutoPickLetter(tab.Caption, usedLetters)
		  Next
		  For Each tab As XjRibbonTab In mTabs
		    Var tabUsed As New Dictionary
		    For Each group As XjRibbonGroup In tab.mGroups
		      For Each item As XjRibbonItem In group.mItems
		        If item.KeyTip <> "" Then tabUsed.Value(item.KeyTip.Uppercase) = True
		      Next
		    Next
		    For Each group As XjRibbonGroup In tab.mGroups
		      For Each item As XjRibbonItem In group.mItems
		        If item.KeyTip = "" Then item.KeyTip = AutoPickLetter(item.Caption, tabUsed)
		      Next
		    Next
		  Next
		  mKeyTipsAssigned = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AutoPickLetter(caption As String, used As Dictionary) As String
		  If caption.Length > 0 Then
		    Var first As String = caption.Left(1).Uppercase
		    If first >= "A" And first <= "Z" And Not used.HasKey(first) Then
		      used.Value(first) = True
		      Return first
		    End If
		  End If
		  For i As Integer = 1 To caption.Length - 1
		    Var ch As String = caption.Middle(i, 1).Uppercase
		    If ch >= "A" And ch <= "Z" And Not used.HasKey(ch) Then
		      used.Value(ch) = True
		      Return ch
		    End If
		  Next
		  For code As Integer = 65 To 90
		    Var ch As String = Chr(code)
		    If Not used.HasKey(ch) Then
		      used.Value(ch) = True
		      Return ch
		    End If
		  Next
		  Return "?"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleKeyDown(key As String) As Boolean
		  Var keyCode As Integer = Asc(key)
		  If keyCode = 27 Then
		    If mKeyTipMode = kKeyTipLevel2 Then
		      mKeyTipMode = kKeyTipLevel1
		      ClearFocusState
		      Me.Refresh
		      Return True
		    ElseIf mKeyTipMode = kKeyTipLevel1 Then
		      DismissKeyTips
		      Return True
		    End If
		    Return False
		  End If
		  If mKeyTipMode = kKeyTipNone Then
		    If Keyboard.ControlKey And Keyboard.OptionKey And Keyboard.ShiftKey Then
		      Var isK As Boolean = False
		      #If TargetMacOS Then
		        isK = Keyboard.AsyncKeyDown(&h28)
		      #Else
		        isK = (key.Uppercase = "K" Or keyCode = 75)
		      #EndIf
		      If isK Then
		        If Not mKeyTipsAssigned Then AssignKeyTips
		        mKeyTipMode = kKeyTipLevel1
		        mFocusedTabIndex = mActiveTabIndex
		        Me.Refresh
		        Return True
		      End If
		    End If
		  End If
		  If mKeyTipMode > kKeyTipNone Then
		    Select Case keyCode
		    Case 28
		      Return HandleArrowLeft
		    Case 29
		      Return HandleArrowRight
		    Case 30
		      Return HandleArrowUp
		    Case 31
		      Return HandleArrowDown
		    End Select
		  End If
		  If mKeyTipMode > kKeyTipNone And (keyCode = 13 Or keyCode = 3 Or keyCode = 32) Then
		    Return ActivateFocusedElement
		  End If
		  If mKeyTipMode = kKeyTipLevel2 And keyCode = 9 Then Return HandleTabKey
		  If mKeyTipMode = kKeyTipLevel1 Then Return MatchKeyTipLevel1(key.Uppercase)
		  If mKeyTipMode = kKeyTipLevel2 Then Return MatchKeyTipLevel2(key.Uppercase)
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MatchKeyTipLevel1(ch As String) As Boolean
		  For i As Integer = 0 To mTabs.LastIndex
		    Var tab As XjRibbonTab = mTabs(i)
		    If tab.IsContextual And Not tab.IsContextVisible Then Continue
		    If tab.KeyTip.Uppercase = ch Then
		      mActiveTabIndex = i
		      If tab.mGroups.Count > 0 And tab.mGroups(0).mItems.Count > 0 And Not mIsCollapsed Then
		        mKeyTipMode = kKeyTipLevel2
		        mFocusedGroupIndex = 0
		        mFocusedItemIndex = 0
		      Else
		        mKeyTipMode = kKeyTipNone
		      End If
		      ClearHoverStates
		      Me.Refresh
		      Return True
		    End If
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MatchKeyTipLevel2(ch As String) As Boolean
		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return False
		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		  For Each group As XjRibbonGroup In activeTab.mGroups
		    For Each item As XjRibbonItem In group.mItems
		      If item.KeyTip.Uppercase = ch And item.IsEnabled Then
		        ActivateItemByKeyboard(item)
		        DismissKeyTips
		        Return True
		      End If
		    Next
		  Next
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ActivateItemByKeyboard(item As XjRibbonItem)
		  If item.ItemType = 2 And item.mMenuItems.Count > 0 Then
		    Var baseMenu As New DesktopMenuItem
		    For Each mi As DesktopMenuItem In item.mMenuItems
		      Var menuItem As New DesktopMenuItem(mi.Text)
		      menuItem.Tag = mi.Tag
		      baseMenu.AddMenu(menuItem)
		    Next
		    Var selected As DesktopMenuItem = baseMenu.PopUp
		    If selected <> Nil Then RaiseEvent DropdownMenuAction(item.Tag, selected.Tag.StringValue)
		  Else
		    If item.IsToggle Then item.IsToggleActive = Not item.IsToggleActive
		    RaiseEvent ItemPressed(item.Tag)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleArrowLeft() As Boolean
		  If mKeyTipMode = kKeyTipLevel1 Then
		    Var idx As Integer = mFocusedTabIndex - 1
		    While idx >= 0
		      If Not mTabs(idx).IsContextual Or mTabs(idx).IsContextVisible Then
		        mFocusedTabIndex = idx
		        mActiveTabIndex = idx
		        Me.Refresh
		        Return True
		      End If
		      idx = idx - 1
		    Wend
		  ElseIf mKeyTipMode = kKeyTipLevel2 Then
		    MoveFocusItem(-1)
		    Me.Refresh
		  End If
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleArrowRight() As Boolean
		  If mKeyTipMode = kKeyTipLevel1 Then
		    Var idx As Integer = mFocusedTabIndex + 1
		    While idx <= mTabs.LastIndex
		      If Not mTabs(idx).IsContextual Or mTabs(idx).IsContextVisible Then
		        mFocusedTabIndex = idx
		        mActiveTabIndex = idx
		        Me.Refresh
		        Return True
		      End If
		      idx = idx + 1
		    Wend
		  ElseIf mKeyTipMode = kKeyTipLevel2 Then
		    MoveFocusItem(1)
		    Me.Refresh
		  End If
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleArrowDown() As Boolean
		  If mKeyTipMode = kKeyTipLevel1 Then
		    If mIsCollapsed Then Return True
		    If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return True
		    Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		    If activeTab.mGroups.Count = 0 Or activeTab.mGroups(0).mItems.Count = 0 Then Return True
		    mKeyTipMode = kKeyTipLevel2
		    mFocusedGroupIndex = 0
		    mFocusedItemIndex = 0
		    Me.Refresh
		  ElseIf mKeyTipMode = kKeyTipLevel2 Then
		    Call MoveFocusItemVertical(1)
		    Me.Refresh
		  End If
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleArrowUp() As Boolean
		  If mKeyTipMode = kKeyTipLevel2 Then
		    If Not MoveFocusItemVertical(-1) Then
		      mKeyTipMode = kKeyTipLevel1
		      ClearFocusState
		      mFocusedTabIndex = mActiveTabIndex
		    End If
		    Me.Refresh
		  End If
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub MoveFocusItem(direction As Integer)
		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return
		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		  Var allItems() As XjRibbonItem
		  Var allGroupIdx() As Integer
		  Var allItemIdx() As Integer
		  For gi As Integer = 0 To activeTab.mGroups.LastIndex
		    For ii As Integer = 0 To activeTab.mGroups(gi).mItems.LastIndex
		      allItems.Add(activeTab.mGroups(gi).mItems(ii))
		      allGroupIdx.Add(gi)
		      allItemIdx.Add(ii)
		    Next
		  Next
		  If allItems.Count = 0 Then Return
		  Var currentFlat As Integer = -1
		  For fi As Integer = 0 To allItems.LastIndex
		    If allGroupIdx(fi) = mFocusedGroupIndex And allItemIdx(fi) = mFocusedItemIndex Then
		      currentFlat = fi
		      Exit
		    End If
		  Next
		  If currentFlat < 0 Then currentFlat = 0
		  currentFlat = currentFlat + direction
		  If currentFlat < 0 Then currentFlat = allItems.LastIndex
		  If currentFlat > allItems.LastIndex Then currentFlat = 0
		  mFocusedGroupIndex = allGroupIdx(currentFlat)
		  mFocusedItemIndex = allItemIdx(currentFlat)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MoveFocusItemVertical(direction As Integer) As Boolean
		  If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return False
		  Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		  If mFocusedGroupIndex < 0 Or mFocusedGroupIndex > activeTab.mGroups.LastIndex Then Return False
		  Var group As XjRibbonGroup = activeTab.mGroups(mFocusedGroupIndex)
		  If mFocusedItemIndex < 0 Or mFocusedItemIndex > group.mItems.LastIndex Then Return False
		  Var currentItem As XjRibbonItem = group.mItems(mFocusedItemIndex)
		  If currentItem.ItemType <> 1 Then Return False
		  Var newIdx As Integer = mFocusedItemIndex + direction
		  If newIdx < 0 Or newIdx > group.mItems.LastIndex Then Return False
		  If group.mItems(newIdx).ItemType <> 1 Then Return False
		  If Abs(group.mItems(newIdx).mBoundsX - currentItem.mBoundsX) < 2 Then
		    mFocusedItemIndex = newIdx
		    Return True
		  End If
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ActivateFocusedElement() As Boolean
		  If mKeyTipMode = kKeyTipLevel1 Then
		    If mIsCollapsed Then Return True
		    If mFocusedTabIndex < 0 Or mFocusedTabIndex >= mTabs.Count Then Return True
		    mActiveTabIndex = mFocusedTabIndex
		    Var focusedTab As XjRibbonTab = mTabs(mActiveTabIndex)
		    If focusedTab.mGroups.Count = 0 Or focusedTab.mGroups(0).mItems.Count = 0 Then
		      Me.Refresh
		      Return True
		    End If
		    mKeyTipMode = kKeyTipLevel2
		    mFocusedGroupIndex = 0
		    mFocusedItemIndex = 0
		    Me.Refresh
		    Return True
		  ElseIf mKeyTipMode = kKeyTipLevel2 Then
		    If mActiveTabIndex < 0 Or mActiveTabIndex >= mTabs.Count Then Return False
		    Var activeTab As XjRibbonTab = mTabs(mActiveTabIndex)
		    If mFocusedGroupIndex < 0 Or mFocusedGroupIndex > activeTab.mGroups.LastIndex Then Return False
		    Var group As XjRibbonGroup = activeTab.mGroups(mFocusedGroupIndex)
		    If mFocusedItemIndex < 0 Or mFocusedItemIndex > group.mItems.LastIndex Then Return False
		    Var item As XjRibbonItem = group.mItems(mFocusedItemIndex)
		    If item.IsEnabled Then ActivateItemByKeyboard(item)
		    DismissKeyTips
		    Return True
		  End If
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleTabKey() As Boolean
		  MoveFocusItem(1)
		  Me.Refresh
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DismissKeyTips()
		  mKeyTipMode = kKeyTipNone
		  ClearFocusState
		  Me.Refresh
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ClearFocusState()
		  mFocusedTabIndex = -1
		  mFocusedGroupIndex = -1
		  mFocusedItemIndex = -1
		End Sub
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
		    cToggleActiveBackground = Color.RGB(55, 70, 90)
		    cToggleActiveHoverBackground = Color.RGB(65, 80, 100)
		    cKeyTipBackground = Color.RGB(60, 60, 60)
		    cKeyTipBorder = Color.RGB(120, 120, 120)
		    cKeyTipText = Color.RGB(240, 240, 240)
		    cFocusRing = Color.RGB(60, 150, 230)
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
		    cToggleActiveBackground = Color.RGB(200, 220, 240)
		    cToggleActiveHoverBackground = Color.RGB(185, 210, 235)
		    cKeyTipBackground = Color.RGB(255, 255, 255)
		    cKeyTipBorder = Color.RGB(150, 150, 150)
		    cKeyTipText = Color.RGB(0, 0, 0)
		    cFocusRing = Color.RGB(0, 120, 212)
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
		Private mPressedOnArrow As Boolean = False
	#tag EndProperty
	#tag Property, Flags = &h21
		Private mKeyTipMode As Integer = 0
	#tag EndProperty
	#tag Property, Flags = &h21
		Private mKeyTipsAssigned As Boolean = False
	#tag EndProperty
	#tag Property, Flags = &h21
		Private mFocusedTabIndex As Integer = -1
	#tag EndProperty
	#tag Property, Flags = &h21
		Private mFocusedGroupIndex As Integer = -1
	#tag EndProperty
	#tag Property, Flags = &h21
		Private mFocusedItemIndex As Integer = -1
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
	#tag Property, Flags = &h21
		Private cToggleActiveBackground As Color
	#tag EndProperty
	#tag Property, Flags = &h21
		Private cToggleActiveHoverBackground As Color
	#tag EndProperty
	#tag Property, Flags = &h21
		Private cKeyTipBackground As Color
	#tag EndProperty
	#tag Property, Flags = &h21
		Private cKeyTipBorder As Color
	#tag EndProperty
	#tag Property, Flags = &h21
		Private cKeyTipText As Color
	#tag EndProperty
	#tag Property, Flags = &h21
		Private cFocusRing As Color
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
	#tag Constant, Name = kArrowZoneWidth, Type = Double, Dynamic = False, Default = \"20", Scope = Private
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
	#tag Constant, Name = kKeyTipNone, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant
	#tag Constant, Name = kKeyTipLevel1, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant
	#tag Constant, Name = kKeyTipLevel2, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant
	#tag Constant, Name = kItemTypeLarge, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant
	#tag Constant, Name = kItemTypeSmall, Type = Double, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant
	#tag Constant, Name = kItemTypeDropdown, Type = Double, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant
	#tag Constant, Name = kItemTypeCheckBox, Type = Double, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant
	#tag Constant, Name = kItemTypeSeparator, Type = Double, Dynamic = False, Default = \"4", Scope = Public
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
