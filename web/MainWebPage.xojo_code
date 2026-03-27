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
		Sub HashTagChanged(hashTag As String)
		  // Handle dropdown menu selection callback from JavaScript
		  If hashTag.BeginsWith("xjdd:") Then
		    Var parts() As String = hashTag.Split(":")
		    If parts.Count >= 3 Then
		      Var itemTag As String = parts(1)
		      Var menuTag As String = parts(2)
		      XjRibbon1.HandleDropdownSelection(itemTag, menuTag)
		    End If
		    // Clear the hash
		    Session.HashTag = ""
		  End If
		End Sub
	#tag EndEvent

	#tag Event
		Sub Shown()
		  // === Home Tab ===
		  Var homeTab As XjRibbonTab = XjRibbon1.AddTab("Home")

		  // Clipboard: large Paste + small Cut/Copy
		  Var clipGroup As XjRibbonGroup = homeTab.AddNewGroup("Clipboard")
		  Call clipGroup.AddLargeButton("Paste", "clipboard.paste")
		  Call clipGroup.AddSmallButton("Cut", "clipboard.cut")
		  Call clipGroup.AddSmallButton("Copy", "clipboard.copy")

		  // Font: small buttons stacked 3-high
		  Var fontGroup As XjRibbonGroup = homeTab.AddNewGroup("Font")
		  Call fontGroup.AddSmallButton("Bold", "font.bold")
		  Call fontGroup.AddSmallButton("Italic", "font.italic")
		  Call fontGroup.AddSmallButton("Underline", "font.underline")

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
		  Call showGroup.AddSmallButton("Ruler", "view.ruler")
		  Call showGroup.AddSmallButton("Grid", "view.grid")
		  Call showGroup.AddSmallButton("Guides", "view.guides")
		End Sub
	#tag EndEvent
#tag EndWindowCode

#tag Events XjRibbon1
	#tag Event
		Sub ItemPressed(tag As String)
		  MessageBox("Ribbon item pressed: " + tag)
		End Sub
	#tag EndEvent
	#tag Event
		Sub DropdownMenuAction(itemTag As String, menuItemTag As String)
		  MessageBox("Dropdown " + itemTag + " selected: " + menuItemTag)
		End Sub
	#tag EndEvent
#tag EndEvents

