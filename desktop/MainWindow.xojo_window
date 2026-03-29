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
      Top             =   132
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
      Top             =   132
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
		  homeTab.KeyTip = "H"
		  
		  // Clipboard: large Paste + small Cut/Copy (mixed layout demo)
		  Var clipGroup As XjRibbonGroup = homeTab.AddNewGroup("Clipboard")
		  Var pasteItem As XjRibbonItem = clipGroup.AddLargeButton("Paste", "clipboard.paste")
		  pasteItem.TooltipText = "Paste from clipboard (Cmd+V)"
		  Call clipGroup.AddSmallButton("Cut", "clipboard.cut")
		  Call clipGroup.AddSmallButton("Copy", "clipboard.copy")
		  
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
		  insertTab.KeyTip = "N"
		  
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
		  viewTab.KeyTip = "W"
		  
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
	#tag Event
		Sub CollapseStateChanged(isCollapsed As Boolean)
		  #Pragma Unused isCollapsed
		  // Reposition controls below the ribbon
		  Var newTop As Integer = XjRibbon1.BottomEdge + 10
		  ShowTableToolsButton.Top = newTop
		  ShowPictureToolsButton.Top = newTop
		End Sub
	#tag EndEvent
#tag EndEvents
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
		Name="Interfaces"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasTitleBar"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
