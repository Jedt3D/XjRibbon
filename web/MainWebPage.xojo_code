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
      Height          =   146
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
      mActiveTabIndex =   0
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
   Begin WebRectangle Rectangle1
      BorderColor     =   &c000000FF
      BorderThickness =   1
      ControlCount    =   0
      ControlID       =   ""
      CornerSize      =   -1
      CSSClasses      =   ""
      Enabled         =   True
      FillColor       =   &cFFFFFF
      HasFillColor    =   False
      Height          =   150
      Index           =   -2147483648
      Indicator       =   ""
      LayoutDirection =   "LayoutDirections.LeftToRight"
      LayoutType      =   "LayoutTypes.Fixed"
      Left            =   8
      LockBottom      =   False
      LockedInPosition=   False
      LockHorizontal  =   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      LockVertical    =   False
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   2
      TabStop         =   True
      Tooltip         =   ""
      Top             =   129
      Visible         =   True
      Width           =   585
      _mDesignHeight  =   0
      _mDesignWidth   =   0
      _mPanelIndex    =   -1
      Begin WebButton Button1
         AllowAutoDisable=   False
         Cancel          =   False
         Caption         =   "OK"
         ControlID       =   ""
         CSSClasses      =   ""
         Default         =   True
         Enabled         =   True
         Height          =   38
         Index           =   -2147483648
         Indicator       =   1
         Left            =   28
         LockBottom      =   False
         LockedInPosition=   False
         LockHorizontal  =   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         LockVertical    =   False
         Outlined        =   False
         PanelIndex      =   0
         Parent          =   "Rectangle1"
         Scope           =   0
         TabIndex        =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   149
         Visible         =   True
         Width           =   100
         _mPanelIndex    =   -1
      End
      Begin WebButton Button2
         AllowAutoDisable=   False
         Cancel          =   False
         Caption         =   "OK"
         ControlID       =   ""
         CSSClasses      =   ""
         Default         =   True
         Enabled         =   True
         Height          =   38
         Index           =   -2147483648
         Indicator       =   1
         Left            =   473
         LockBottom      =   False
         LockedInPosition=   False
         LockHorizontal  =   False
         LockLeft        =   False
         LockRight       =   True
         LockTop         =   True
         LockVertical    =   False
         Outlined        =   False
         PanelIndex      =   0
         Parent          =   "Rectangle1"
         Scope           =   0
         TabIndex        =   3
         TabStop         =   True
         Tooltip         =   ""
         Top             =   149
         Visible         =   True
         Width           =   100
         _mPanelIndex    =   -1
      End
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
		  
		  // Show Table Tools by default for demo
		  XjRibbon1.ShowContextualTabs("Table Tools")
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
		Name="ControlCount"
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
		Name="Index"
		Visible=true
		Group="ID"
		InitialValue="-2147483648"
		Type="Integer"
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
		Name="ControlID"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Behavior"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LayoutType"
		Visible=true
		Group="Behavior"
		InitialValue="LayoutTypes.Fixed"
		Type="LayoutTypes"
		EditorType="Enum"
		#tag EnumValues
			"0 - Fixed"
			"1 - Flex"
		#tag EndEnumValues
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
		Name="MinimumHeight"
		Visible=true
		Group="Behavior"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Behavior"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Behavior"
		InitialValue="Untitled"
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=true
		Group="Behavior"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_ImplicitInstance"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mDesignHeight"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mDesignWidth"
		Visible=false
		Group="Behavior"
		InitialValue=""
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
	#tag ViewProperty
		Name="IsImplicitInstance"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowTabOrderWrap"
		Visible=false
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
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
		Name="LayoutDirection"
		Visible=true
		Group="WebView"
		InitialValue="LayoutDirections.LeftToRight"
		Type="LayoutDirections"
		EditorType="Enum"
		#tag EnumValues
			"0 - LeftToRight"
			"1 - RightToLeft"
			"2 - TopToBottom"
			"3 - BottomToTop"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="ScaleFactor"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Double"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
