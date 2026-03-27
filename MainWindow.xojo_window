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
   Title           =   "XjRibbon Demo"
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
      LockRight       =   False
      LockTop         =   True
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
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Opening()
		  // === Home Tab ===
		  Var homeTab As XjRibbonTab = XjRibbon1.AddTab("Home")

		  Var clipGroup As XjRibbonGroup = homeTab.AddNewGroup("Clipboard")
		  Call clipGroup.AddLargeButton("Paste", "clipboard.paste")
		  Call clipGroup.AddLargeButton("Cut", "clipboard.cut")
		  Call clipGroup.AddLargeButton("Copy", "clipboard.copy")

		  Var fontGroup As XjRibbonGroup = homeTab.AddNewGroup("Font")
		  Call fontGroup.AddLargeButton("Bold", "font.bold")
		  Call fontGroup.AddLargeButton("Italic", "font.italic")
		  Call fontGroup.AddLargeButton("Underline", "font.underline")

		  Var paraGroup As XjRibbonGroup = homeTab.AddNewGroup("Paragraph")
		  Call paraGroup.AddLargeButton("Left", "para.left")
		  Call paraGroup.AddLargeButton("Center", "para.center")
		  Call paraGroup.AddLargeButton("Right", "para.right")

		  // === Insert Tab ===
		  Var insertTab As XjRibbonTab = XjRibbon1.AddTab("Insert")

		  Var tableGroup As XjRibbonGroup = insertTab.AddNewGroup("Tables")
		  Call tableGroup.AddLargeButton("Table", "insert.table")

		  Var imageGroup As XjRibbonGroup = insertTab.AddNewGroup("Illustrations")
		  Call imageGroup.AddLargeButton("Picture", "insert.picture")
		  Call imageGroup.AddLargeButton("Shapes", "insert.shapes")
		  Call imageGroup.AddLargeButton("Chart", "insert.chart")

		  // === View Tab ===
		  Var viewTab As XjRibbonTab = XjRibbon1.AddTab("View")

		  Var zoomGroup As XjRibbonGroup = viewTab.AddNewGroup("Zoom")
		  Call zoomGroup.AddLargeButton("Zoom In", "view.zoomin")
		  Call zoomGroup.AddLargeButton("Zoom Out", "view.zoomout")
		  Call zoomGroup.AddLargeButton("100%", "view.zoom100")

		  Var showGroup As XjRibbonGroup = viewTab.AddNewGroup("Show")
		  Call showGroup.AddLargeButton("Ruler", "view.ruler")
		  Call showGroup.AddLargeButton("Grid", "view.grid")
		End Sub
	#tag EndEvent
#tag EndWindowCode

#tag Events XjRibbon1
	#tag Event
		Sub ItemPressed(tag As String)
		  MessageBox("Ribbon item pressed: " + tag)
		End Sub
	#tag EndEvent
#tag EndEvents

