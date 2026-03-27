#tag DesktopWindow
Begin DesktopWindow MainWindow
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   HasTitleBar     =   True
   Height          =   400
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   2094610431
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "XjRibbon Demo for Desktop"
   Type            =   0
   Visible         =   True
   Width           =   600
   Begin XjRibbon XjRibbon1
      AllowAutoDeactivate=   True
      AllowFocus      =   False
      AllowFocusRing  =   True
      AllowTabs       =   False
      Backdrop        =   0
      Enabled         =   True
      Height          =   122
      Index           =   -2147483648
      Left            =   0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      mActiveTabIndex =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   0
      Transparent     =   False
      Visible         =   True
      Width           =   600
   End
   Begin DesktopButton ShowTableToolsButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Show Table Tools"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   140
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   140
   End
   Begin DesktopButton ShowPictureToolsButton
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Show Picture Tools"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   170
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   140
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   140
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  // === Home Tab ===
		  Var homeTab As XjRibbonTab = XjRibbon1.AddTab("Home")
		  
		  // Clipboard: large Paste + small Cut/Copy (mixed layout demo)
		  Var clipGroup As XjRibbonGroup = homeTab.AddNewGroup("Clipboard")
		  Var pasteItem As XjRibbonItem = clipGroup.AddLargeButton("Paste", "clipboard.paste")
		  pasteItem.TooltipText = "Paste from clipboard (Cmd+V)"
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
		  
		  // Illustrations: large buttons + dropdown for Shapes
		  Var imageGroup As XjRibbonGroup = insertTab.AddNewGroup("Illustrations")
		  Call imageGroup.AddLargeButton("Picture", "insert.picture")
		  
		  Var shapesBtn As XjRibbonItem = imageGroup.AddDropdownButton("Shapes", "insert.shapes")
		  shapesBtn.TooltipText = "Insert a shape"
		  shapesBtn.AddMenuItem("Rectangle", "shapes.rect")
		  shapesBtn.AddMenuItem("Circle", "shapes.circle")
		  shapesBtn.AddMenuItem("Arrow", "shapes.arrow")
		  shapesBtn.AddMenuItem("Line", "shapes.line")
		  
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

		  // === Contextual Tab: Table Tools ===
		  Var tableDesign As XjRibbonTab = XjRibbon1.AddContextualTab("Design", "Table Tools", Color.RGB(0, 128, 0))
		  Var styleGroup As XjRibbonGroup = tableDesign.AddNewGroup("Table Styles")
		  Call styleGroup.AddLargeButton("Style 1", "table.style1")
		  Call styleGroup.AddLargeButton("Style 2", "table.style2")
		  Call styleGroup.AddLargeButton("Style 3", "table.style3")

		  // === Contextual Tab: Picture Tools ===
		  Var picFormat As XjRibbonTab = XjRibbon1.AddContextualTab("Format", "Picture Tools", Color.RGB(200, 120, 0))
		  Var adjustGroup As XjRibbonGroup = picFormat.AddNewGroup("Adjust")
		  Call adjustGroup.AddLargeButton("Brightness", "pic.brightness")
		  Call adjustGroup.AddLargeButton("Contrast", "pic.contrast")
		  Call adjustGroup.AddLargeButton("Crop", "pic.crop")
		End Sub
	#tag EndEvent


#tag EndWindowCode

#tag Events ShowTableToolsButton
	#tag Event
		Sub Pressed()
		  If XjRibbon1.IsContextualTabVisible("Table Tools") Then
		    XjRibbon1.HideContextualTabs("Table Tools")
		    Me.Caption = "Show Table Tools"
		  Else
		    XjRibbon1.ShowContextualTabs("Table Tools")
		    Me.Caption = "Hide Table Tools"
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents

#tag Events ShowPictureToolsButton
	#tag Event
		Sub Pressed()
		  If XjRibbon1.IsContextualTabVisible("Picture Tools") Then
		    XjRibbon1.HideContextualTabs("Picture Tools")
		    Me.Caption = "Show Picture Tools"
		  Else
		    XjRibbon1.ShowContextualTabs("Picture Tools")
		    Me.Caption = "Hide Picture Tools"
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents

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
