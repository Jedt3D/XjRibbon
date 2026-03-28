#tag WebPage
Begin WebPage MainWebPage
   AllowTabOrderWrap=   True
   Compatibility   =   ""
   ControlCount    =   0
   ControlID       =   ""
   CSSClasses      =   ""
   Enabled         =   False
   Height          =   400
   ImplicitInstance=   True
   Index           =   -2147483648
   Indicator       =   0
   IsImplicitInstance=   False
   LayoutDirection =   0
   LayoutType      =   0
   Left            =   0
   LockBottom      =   False
   LockHorizontal  =   False
   LockLeft        =   True
   LockRight       =   False
   LockTop         =   True
   LockVertical    =   False
   MinimumHeight   =   400
   MinimumWidth    =   600
   PanelIndex      =   0
   ScaleFactor     =   0.0
   TabIndex        =   0
   Title           =   "XjRibbon Demo for Web"
   Top             =   0
   Visible         =   True
   Width           =   600
   _ImplicitInstance=   False
   _mDesignHeight  =   0
   _mDesignWidth   =   0
   _mName          =   ""
   _mPanelIndex    =   -1
   Begin XjRibbon XjRibbon1
      ControlID       =   ""
      CSSClasses      =   ""
      DiffEngineDisabled=   False
      Enabled         =   True
      Height          =   121
      Index           =   -2147483648
      Indicator       =   ""
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Visible         =   True
      Width           =   600
      _mPanelIndex    =   -1
   End
End
#tag EndWebPage

#tag WindowCode
	#tag Event
		Sub Shown()
		  // === Home Tab ===
		  Var homeTab As XjRibbonTab = XjRibbon1.AddTab("Home")

		  // Clipboard: large Paste + small Cut/Copy (with tooltips)
		  Var clipGroup As XjRibbonGroup = homeTab.AddNewGroup("Clipboard")
		  Var pasteBtn As XjRibbonItem = clipGroup.AddLargeButton("Paste", "clipboard.paste")
		  pasteBtn.TooltipText = "Paste from clipboard (Ctrl+V)"
		  Var cutBtn As XjRibbonItem = clipGroup.AddSmallButton("Cut", "clipboard.cut")
		  cutBtn.TooltipText = "Cut selection (Ctrl+X)"
		  Var copyBtn As XjRibbonItem = clipGroup.AddSmallButton("Copy", "clipboard.copy")
		  copyBtn.TooltipText = "Copy selection (Ctrl+C)"

		  // Font: small toggle buttons stacked 3-high
		  Var fontGroup As XjRibbonGroup = homeTab.AddNewGroup("Font")
		  Var boldItem As XjRibbonItem = fontGroup.AddSmallButton("Bold", "font.bold")
		  boldItem.IsToggle = True
		  Var italicItem As XjRibbonItem = fontGroup.AddSmallButton("Italic", "font.italic")
		  italicItem.IsToggle = True
		  Var underlineItem As XjRibbonItem = fontGroup.AddSmallButton("Underline", "font.underline")
		  underlineItem.IsToggle = True

		  // Paragraph: small buttons
		  Var paraGroup As XjRibbonGroup = homeTab.AddNewGroup("Paragraph")
		  Call paraGroup.AddSmallButton("Left", "para.left")
		  Call paraGroup.AddSmallButton("Center", "para.center")
		  Call paraGroup.AddSmallButton("Right", "para.right")

		  // === Insert Tab ===
		  Var insertTab As XjRibbonTab = XjRibbon1.AddTab("Insert")

		  Var tableGroup As XjRibbonGroup = insertTab.AddNewGroup("Tables")
		  Call tableGroup.AddLargeButton("Table", "insert.table")

		  // Illustrations: large + dropdown
		  Var imageGroup As XjRibbonGroup = insertTab.AddNewGroup("Illustrations")
		  Call imageGroup.AddLargeButton("Picture", "insert.picture")

		  Var shapesBtn As XjRibbonItem = imageGroup.AddDropdownButton("Shapes", "insert.shapes")
		  shapesBtn.TooltipText = "Insert a shape"
		  shapesBtn.AddMenuItem("Rectangle", "shapes.rect")
		  shapesBtn.AddMenuItem("Circle", "shapes.circle")
		  shapesBtn.AddMenuItem("Arrow", "shapes.arrow")

		  Call imageGroup.AddLargeButton("Chart", "insert.chart")

		  // === View Tab ===
		  Var viewTab As XjRibbonTab = XjRibbon1.AddTab("View")

		  Var zoomGroup As XjRibbonGroup = viewTab.AddNewGroup("Zoom")
		  Call zoomGroup.AddLargeButton("Zoom In", "view.zoomin")
		  Call zoomGroup.AddLargeButton("Zoom Out", "view.zoomout")
		  Call zoomGroup.AddLargeButton("100%", "view.zoom100")

		  Var showGroup As XjRibbonGroup = viewTab.AddNewGroup("Show")
		  Var rulerItem As XjRibbonItem = showGroup.AddSmallButton("Ruler", "view.ruler")
		  rulerItem.IsToggle = True
		  Var gridItem As XjRibbonItem = showGroup.AddSmallButton("Grid", "view.grid")
		  gridItem.IsToggle = True
		  Var guidesItem As XjRibbonItem = showGroup.AddSmallButton("Guides", "view.guides")
		  guidesItem.IsToggle = True
		End Sub
	#tag EndEvent
#tag EndWindowCode

#tag Events XjRibbon1
	#tag Event
		Sub ItemPressed(tag As String)
		  If tag.BeginsWith("font.") Or tag.BeginsWith("view.ruler") Or tag.BeginsWith("view.grid") Or tag.BeginsWith("view.guides") Then
		    Var state As Boolean = XjRibbon1.GetToggleState(tag)
		    MessageBox(tag + " toggled: " + If(state, "ON", "OFF"))
		  Else
		    MessageBox("Ribbon item pressed: " + tag)
		  End If
		End Sub
	#tag EndEvent
	#tag Event
		Sub DropdownMenuAction(itemTag As String, menuItemTag As String)
		  MessageBox("Dropdown " + itemTag + " selected: " + menuItemTag)
		End Sub
	#tag EndEvent
#tag EndEvents

