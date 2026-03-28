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
   Height          =   554
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   1910552575
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "XjRibbon Menu Creator"
   Type            =   0
   Visible         =   True
   Width           =   820
   Begin DesktopLabel ProjectName
      AllowAutoDeactivate=   True
      Bold            =   False
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
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   """TOOLBAR_NAME"" Structure"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   254
   End
   Begin DesktopListBox RibbonStructure
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   True
      AllowFocusRing  =   True
      AllowResizableColumns=   False
      AllowRowDragging=   True
      AllowRowReordering=   True
      Bold            =   False
      ColumnCount     =   3
      ColumnWidths    =   "*,25%,25%"
      DefaultRowHeight=   22
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   3
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   450
      Index           =   -2147483648
      InitialValue    =   "Caption	Type	Dropdown"
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   52
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   434
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin DesktopButton CopyToolbarCode
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Copy Toolbar Code"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   664
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   "Paste the source code to your XjRibbon instance's Opening Event"
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   136
   End
   Begin DesktopPopupMenu AddItemPopup
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      InitialValue    =   "-- select item --\nRibbon Tab\nRibbon Group\nRibbon Large Button\nRibbon Small Button"
      Italic          =   False
      Left            =   331
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      SelectedRowIndex=   -1
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   123
   End
   Begin DesktopLabel Label2
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   286
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "Add"
      TextAlignment   =   3
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   33
   End
   Begin DesktopLabel StatusBar
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   False
      Scope           =   0
      Selectable      =   False
      TabIndex        =   7
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "XjToolbar Designer version 0.6.0"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   514
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   780
   End
   Begin DesktopGroupBox GroupBox1
      AllowAutoDeactivate=   True
      Bold            =   False
      Caption         =   "Inspector"
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   450
      Index           =   -2147483648
      Italic          =   False
      Left            =   466
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   52
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   334
      Begin DesktopTextField CaptionField
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         AllowSpellChecking=   False
         AllowTabs       =   False
         BackgroundColor =   &cFFFFFF
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Format          =   ""
         HasBorder       =   True
         Height          =   22
         Hint            =   "Clipboard"
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   598
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MaximumCharactersAllowed=   0
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   1
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   88
         Transparent     =   False
         Underline       =   False
         ValidationMask  =   ""
         Visible         =   True
         Width           =   182
      End
      Begin DesktopLabel Label4
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   486
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   0
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Caption"
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   88
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopLabel Label5
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   486
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   2
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Tag"
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   120
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopLabel Label6
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   486
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   4
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Item Type"
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   152
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopLabel Label8
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   486
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   7
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Tooltip Text"
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   216
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopCheckBox IsEnabled
         AllowAutoDeactivate=   True
         Bold            =   False
         Caption         =   "Is Enabled?"
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   598
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Scope           =   0
         TabIndex        =   6
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   184
         Transparent     =   False
         Underline       =   False
         Value           =   False
         Visible         =   True
         VisualState     =   0
         Width           =   182
      End
      Begin DesktopTextField TagField
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         AllowSpellChecking=   False
         AllowTabs       =   False
         BackgroundColor =   &cFFFFFF
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Format          =   ""
         HasBorder       =   True
         Height          =   22
         Hint            =   "clipboard.paste"
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   598
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MaximumCharactersAllowed=   0
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   3
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   122
         Transparent     =   False
         Underline       =   False
         ValidationMask  =   ""
         Visible         =   True
         Width           =   182
      End
      Begin DesktopTextField TooltipTextField
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         AllowSpellChecking=   False
         AllowTabs       =   False
         BackgroundColor =   &cFFFFFF
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Format          =   ""
         HasBorder       =   True
         Height          =   22
         Hint            =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   598
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MaximumCharactersAllowed=   0
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   8
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   216
         Transparent     =   False
         Underline       =   False
         ValidationMask  =   ""
         Visible         =   True
         Width           =   182
      End
      Begin DesktopLabel Label10
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   486
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   9
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Resource Name"
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   250
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopTextField ResourceNameField
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         AllowSpellChecking=   False
         AllowTabs       =   False
         BackgroundColor =   &cFFFFFF
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Format          =   ""
         HasBorder       =   True
         Height          =   22
         Hint            =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   598
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MaximumCharactersAllowed=   0
         Password        =   False
         ReadOnly        =   False
         Scope           =   0
         TabIndex        =   10
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   248
         Transparent     =   False
         Underline       =   False
         ValidationMask  =   ""
         Visible         =   True
         Width           =   182
      End
      Begin DesktopLabel Label11
         AllowAutoDeactivate=   True
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Height          =   20
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   486
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         Multiline       =   False
         Scope           =   0
         Selectable      =   False
         TabIndex        =   11
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   "Menu Item"
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   280
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   100
      End
      Begin DesktopListBox MenuItems
         AllowAutoDeactivate=   True
         AllowAutoHideScrollbars=   True
         AllowExpandableRows=   False
         AllowFocusRing  =   True
         AllowResizableColumns=   False
         AllowRowDragging=   True
         AllowRowReordering=   True
         Bold            =   False
         ColumnCount     =   2
         ColumnWidths    =   "60%,40%"
         DefaultRowHeight=   22
         DropIndicatorVisible=   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         GridLineStyle   =   3
         HasBorder       =   True
         HasHeader       =   True
         HasHorizontalScrollbar=   False
         HasVerticalScrollbar=   True
         HeadingIndex    =   -1
         Height          =   170
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         InitialValue    =   "Caption	Tag"
         Italic          =   False
         Left            =   486
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         RequiresSelection=   False
         RowSelectionType=   0
         Scope           =   0
         TabIndex        =   13
         TabPanelIndex   =   0
         TabStop         =   True
         Tooltip         =   ""
         Top             =   312
         Transparent     =   False
         Underline       =   False
         Visible         =   True
         Width           =   294
         _ScrollOffset   =   0
         _ScrollWidth    =   -1
      End
      Begin DesktopBevelButton AddMenuItem
         Active          =   False
         AllowAutoDeactivate=   True
         AllowFocus      =   True
         AllowTabStop    =   True
         BackgroundColor =   &c00000000
         BevelStyle      =   0
         Bold            =   False
         ButtonStyle     =   0
         Caption         =   "Add Menu Item"
         CaptionAlignment=   3
         CaptionDelta    =   0
         CaptionPosition =   1
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         HasBackgroundColor=   False
         Height          =   22
         Icon            =   0
         IconAlignment   =   0
         IconDeltaX      =   0
         IconDeltaY      =   0
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   657
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MenuStyle       =   0
         PanelIndex      =   0
         Scope           =   0
         TabIndex        =   12
         TabPanelIndex   =   0
         TextColor       =   &c00000000
         Tooltip         =   ""
         Top             =   280
         Transparent     =   False
         Underline       =   False
         Value           =   False
         Visible         =   True
         Width           =   123
         _mIndex         =   0
         _mInitialParent =   ""
         _mName          =   ""
         _mPanelIndex    =   0
      End
      Begin DesktopTextField ItemTypeField
         AllowAutoDeactivate=   True
         AllowFocusRing  =   True
         AllowSpellChecking=   False
         AllowTabs       =   False
         BackgroundColor =   &cFFFFFF
         Bold            =   False
         Enabled         =   True
         FontName        =   "System"
         FontSize        =   0.0
         FontUnit        =   0
         Format          =   ""
         HasBorder       =   True
         Height          =   22
         Hint            =   ""
         Index           =   -2147483648
         InitialParent   =   "GroupBox1"
         Italic          =   False
         Left            =   598
         LockBottom      =   False
         LockedInPosition=   False
         LockLeft        =   True
         LockRight       =   False
         LockTop         =   True
         MaximumCharactersAllowed=   0
         Password        =   False
         ReadOnly        =   True
         Scope           =   0
         TabIndex        =   5
         TabPanelIndex   =   0
         TabStop         =   True
         Text            =   ""
         TextAlignment   =   0
         TextColor       =   &c000000
         Tooltip         =   ""
         Top             =   152
         Transparent     =   True
         Underline       =   False
         ValidationMask  =   ""
         Visible         =   True
         Width           =   182
      End
   End
   Begin DesktopRadioGroup ProjectType
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Horizontal      =   True
      Index           =   -2147483648
      InitialValue    =   "Desktop\nWeb"
      Italic          =   False
      Left            =   476
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Scope           =   0
      SelectedIndex   =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   176
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function CancelClosing(appQuitting As Boolean) As Boolean
		  #Pragma Unused appQuitting
		  Return Not PromptSaveIfDirty
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  // Center-align the Dropdown column and Type column
		  RibbonStructure.ColumnAlignmentAt(1) = DesktopListBox.Alignments.Center
		  RibbonStructure.ColumnAlignmentAt(2) = DesktopListBox.Alignments.Center

		  UpdateTitle
		  SetInspectorState("none")
		  LoadSampleRibbon
		End Sub
	#tag EndEvent


	#tag MenuHandler
		Function FileNew() As Boolean Handles FileNew.Action
		  NewProject
		  Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function HelpAbout() As Boolean Handles HelpAbout.Action
		  Var about As New AboutBox
		  about.ShowModal
		  Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function OpenItem() As Boolean Handles OpenItem.Action
		  OpenProject
		  Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function SaveAsItem() As Boolean Handles SaveAsItem.Action
		  SaveAsToFile
		  Return True
		End Function
	#tag EndMenuHandler

	#tag MenuHandler
		Function SaveItem() As Boolean Handles SaveItem.Action
		  SaveToFile
		  Return True
		End Function
	#tag EndMenuHandler


	#tag Method, Flags = &h0
		Function BuildJSON() As String
		  // Walk the ListBox hierarchy and build JSON string
		  Var root As New JSONItem
		  root.Value("version") = "1.0"
		  If ProjectType.SelectedIndex = 0 Then
		    root.Value("projectType") = "desktop"
		  Else
		    root.Value("projectType") = "web"
		  End If
		  
		  Var tabs As New JSONItem("[]")
		  
		  Var i As Integer = 0
		  While i < RibbonStructure.RowCount
		    Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(i))
		    If d = Nil Or d.Value("type") <> "tab" Then
		      i = i + 1
		      Continue
		    End If
		    
		    Var tabObj As New JSONItem
		    tabObj.Value("caption") = d.Value("caption")
		    
		    Var groups As New JSONItem("[]")
		    
		    // Walk children of this tab
		    Var j As Integer = i + 1
		    While j < RibbonStructure.RowCount And RibbonStructure.RowDepthAt(j) > 0
		      Var gd As Dictionary = Dictionary(RibbonStructure.RowTagAt(j))
		      If gd <> Nil And gd.Value("type") = "group" Then
		        Var groupObj As New JSONItem
		        groupObj.Value("caption") = gd.Value("caption")
		        
		        Var items As New JSONItem("[]")
		        
		        // Walk children of this group
		        Var k As Integer = j + 1
		        While k < RibbonStructure.RowCount And RibbonStructure.RowDepthAt(k) > 1
		          Var id As Dictionary = Dictionary(RibbonStructure.RowTagAt(k))
		          If id <> Nil Then
		            Var itemObj As New JSONItem
		            itemObj.Value("caption") = id.Value("caption")
		            itemObj.Value("tag") = id.Lookup("tag", "")
		            itemObj.Value("itemType") = id.Value("type")
		            itemObj.Value("isEnabled") = id.Lookup("isEnabled", True)
		            itemObj.Value("tooltipText") = id.Lookup("tooltipText", "")
		            
		            Var menuItemsArr As New JSONItem("[]")
		            Var miList() As Dictionary = id.Lookup("menuItems", Nil)
		            If miList <> Nil Then
		              For Each mi As Dictionary In miList
		                Var miObj As New JSONItem
		                miObj.Value("caption") = mi.Lookup("caption", "")
		                miObj.Value("tag") = mi.Lookup("tag", "")
		                menuItemsArr.Add(miObj)
		              Next
		            End If
		            itemObj.Value("menuItems") = menuItemsArr
		            
		            items.Add(itemObj)
		          End If
		          k = k + 1
		        Wend
		        
		        groupObj.Value("items") = items
		        groups.Add(groupObj)
		        j = k
		      Else
		        j = j + 1
		      End If
		    Wend
		    
		    tabObj.Value("groups") = groups
		    tabs.Add(tabObj)
		    i = j
		  Wend
		  
		  root.Value("tabs") = tabs
		  Return root.ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteSelectedRow()
		  Var row As Integer = RibbonStructure.SelectedRowIndex
		  If row < 0 Then Return
		  
		  MarkDirty
		  RibbonStructure.RemoveRowAt(row)
		  
		  // Select nearest row
		  If RibbonStructure.RowCount > 0 Then
		    If row >= RibbonStructure.RowCount Then
		      row = RibbonStructure.RowCount - 1
		    End If
		    RibbonStructure.SelectedRowIndex = row
		  Else
		    SetInspectorState("none")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindLastChildRow(parentRow As Integer) As Integer
		  // Find the last descendant row of parentRow
		  // Returns parentRow itself if it has no children
		  Var parentDepth As Integer = RibbonStructure.RowDepthAt(parentRow)
		  Var lastChild As Integer = parentRow
		  
		  For i As Integer = parentRow + 1 To RibbonStructure.RowCount - 1
		    If RibbonStructure.RowDepthAt(i) > parentDepth Then
		      lastChild = i
		    Else
		      Exit
		    End If
		  Next
		  
		  Return lastChild
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FindParentOfType(row As Integer, targetType As String) As Integer
		  // If the selected row IS the target type, return it
		  // Otherwise walk up to find a parent of the target type
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d <> Nil And d.Value("type") = targetType Then Return row
		  
		  // For "group": if an item is selected, walk backwards to find its group
		  // For "tab": walk backwards to find the tab
		  Var targetDepth As Integer = 0
		  If targetType = "group" Then targetDepth = 1
		  
		  For i As Integer = row - 1 DownTo 0
		    Var pd As Dictionary = Dictionary(RibbonStructure.RowTagAt(i))
		    If pd <> Nil And pd.Value("type") = targetType Then Return i
		    // Stop if we've gone past the parent level
		    If RibbonStructure.RowDepthAt(i) < targetDepth Then Exit
		  Next
		  
		  Return -1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CascadeTagUpdate(row As Integer)
		  // Cascade tag regeneration when a row's caption changes
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d = Nil Then Return

		  Var rowType As String = d.Value("type")
		  Var newCaption As String = d.Value("caption")

		  If rowType = "large" Or rowType = "small" Then
		    // Item: update its own tag + cascade to menu items
		    Var groupCaption As String = ""
		    For p As Integer = row - 1 DownTo 0
		      Var pd As Dictionary = Dictionary(RibbonStructure.RowTagAt(p))
		      If pd <> Nil And pd.Value("type") = "group" Then
		        groupCaption = pd.Value("caption")
		        Exit
		      End If
		    Next
		    If groupCaption <> "" Then
		      Var newTag As String = GenerateTag(groupCaption, newCaption)
		      d.Value("tag") = newTag
		      mUpdatingInspector = True
		      TagField.Text = newTag
		      mUpdatingInspector = False

		      // Cascade to menu items
		      Var miPrefix As String = newCaption.Lowercase.ReplaceAll(" ", "")
		      Var miList() As Dictionary = d.Lookup("menuItems", Nil)
		      If miList <> Nil Then
		        For Each mi As Dictionary In miList
		          mi.Value("tag") = miPrefix + "." + mi.Value("caption").StringValue.Lowercase.ReplaceAll(" ", "")
		        Next
		        If MenuItems.Enabled Then
		          mUpdatingInspector = True
		          PopulateInspector(row)
		          mUpdatingInspector = False
		        End If
		      End If
		    End If

		  ElseIf rowType = "group" Then
		    // Group: cascade to all child item tags + their menu items
		    For i As Integer = row + 1 To RibbonStructure.RowCount - 1
		      Var cd As Dictionary = Dictionary(RibbonStructure.RowTagAt(i))
		      If cd = Nil Then Continue
		      Var ct As String = cd.Value("type")
		      If ct = "tab" Or ct = "group" Then Exit
		      If ct = "large" Or ct = "small" Then
		        Var itemCaption As String = cd.Value("caption")
		        cd.Value("tag") = GenerateTag(newCaption, itemCaption)
		        Var miPrefix As String = itemCaption.Lowercase.ReplaceAll(" ", "")
		        Var miList() As Dictionary = cd.Lookup("menuItems", Nil)
		        If miList <> Nil Then
		          For Each mi As Dictionary In miList
		            mi.Value("tag") = miPrefix + "." + mi.Value("caption").StringValue.Lowercase.ReplaceAll(" ", "")
		          Next
		        End If
		      End If
		    Next

		  ElseIf rowType = "tab" Then
		    // Tab: cascade through all items using their group captions
		    Var currentGroupCaption As String = ""
		    For i As Integer = row + 1 To RibbonStructure.RowCount - 1
		      Var cd As Dictionary = Dictionary(RibbonStructure.RowTagAt(i))
		      If cd = Nil Then Continue
		      Var ct As String = cd.Value("type")
		      If ct = "tab" Then Exit
		      If ct = "group" Then currentGroupCaption = cd.Value("caption")
		      If (ct = "large" Or ct = "small") And currentGroupCaption <> "" Then
		        Var itemCaption As String = cd.Value("caption")
		        cd.Value("tag") = GenerateTag(currentGroupCaption, itemCaption)
		        Var miPrefix As String = itemCaption.Lowercase.ReplaceAll(" ", "")
		        Var miList() As Dictionary = cd.Lookup("menuItems", Nil)
		        If miList <> Nil Then
		          For Each mi As Dictionary In miList
		            mi.Value("tag") = miPrefix + "." + mi.Value("caption").StringValue.Lowercase.ReplaceAll(" ", "")
		          Next
		        End If
		      End If
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GenerateTag(parentCaption As String, itemCaption As String) As String
		  // Auto-generate a tag like "clipboard.paste" from group caption + item caption
		  Var parent As String = parentCaption.Lowercase.ReplaceAll(" ", "")
		  Var item As String = itemCaption.Lowercase.ReplaceAll(" ", "")
		  Return parent + "." + item
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadFromJSON(jsonString As String)
		  // Parse JSON and rebuild the ListBox
		  RibbonStructure.RemoveAllRows
		  SetInspectorState("none")
		  
		  Var root As New JSONItem(jsonString)
		  
		  // Restore project type
		  If root.Lookup("projectType", "desktop") = "web" Then
		    ProjectType.SelectedIndex = 1
		  Else
		    ProjectType.SelectedIndex = 0
		  End If
		  
		  Var tabs As JSONItem = root.Value("tabs")
		  For tabIdx As Integer = 0 To tabs.Count - 1
		    Var tabObj As JSONItem = tabs.ChildAt(tabIdx)
		    
		    RibbonStructure.AddRow(tabObj.Value("caption").StringValue)
		    Var tabRow As Integer = RibbonStructure.LastAddedRowIndex
		    RibbonStructure.CellTextAt(tabRow, 1) = "Tab"
		    RibbonStructure.CellTypeAt(tabRow, 0) = DesktopListBox.CellTypes.TextField
		    
		    Var td As New Dictionary
		    td.Value("type") = "tab"
		    td.Value("caption") = tabObj.Value("caption")
		    RibbonStructure.RowTagAt(tabRow) = td
		    
		    Var groups As JSONItem = tabObj.Value("groups")
		    For grpIdx As Integer = 0 To groups.Count - 1
		      Var grpObj As JSONItem = groups.ChildAt(grpIdx)
		      
		      Var insertAt As Integer = FindLastChildRow(tabRow) + 1
		      RibbonStructure.AddRowAt(insertAt, grpObj.Value("caption"), 1)
		      Var grpRow As Integer = RibbonStructure.LastAddedRowIndex
		      RibbonStructure.CellTextAt(grpRow, 1) = "Group"
		      RibbonStructure.CellTypeAt(grpRow, 0) = DesktopListBox.CellTypes.TextField
		      
		      Var gd As New Dictionary
		      gd.Value("type") = "group"
		      gd.Value("caption") = grpObj.Value("caption")
		      RibbonStructure.RowTagAt(grpRow) = gd
		      
		      Var items As JSONItem = grpObj.Value("items")
		      For itemIdx As Integer = 0 To items.Count - 1
		        Var itemObj As JSONItem = items.ChildAt(itemIdx)
		        
		        Var iInsertAt As Integer = FindLastChildRow(grpRow) + 1
		        RibbonStructure.AddRowAt(iInsertAt, itemObj.Value("caption"), 2)
		        Var itemRow As Integer = RibbonStructure.LastAddedRowIndex
		        Var iType As String = itemObj.Value("itemType")
		        If iType = "large" Then
		          RibbonStructure.CellTextAt(itemRow, 1) = "Large Button"
		        Else
		          RibbonStructure.CellTextAt(itemRow, 1) = "Small Button"
		        End If
		        RibbonStructure.CellTypeAt(itemRow, 0) = DesktopListBox.CellTypes.TextField
		        
		        Var id As New Dictionary
		        id.Value("type") = iType
		        id.Value("caption") = itemObj.Value("caption")
		        id.Value("tag") = itemObj.Lookup("tag", "")
		        id.Value("isEnabled") = itemObj.Lookup("isEnabled", True)
		        id.Value("tooltipText") = itemObj.Lookup("tooltipText", "")
		        
		        Var miArr() As Dictionary
		        Var menuItemsJSON As JSONItem = itemObj.Lookup("menuItems", Nil)
		        If menuItemsJSON <> Nil Then
		          For miIdx As Integer = 0 To menuItemsJSON.Count - 1
		            Var miObj As JSONItem = menuItemsJSON.ChildAt(miIdx)
		            Var mi As New Dictionary
		            mi.Value("caption") = miObj.Lookup("caption", "")
		            mi.Value("tag") = miObj.Lookup("tag", "")
		            miArr.Add(mi)
		          Next
		        End If
		        id.Value("menuItems") = miArr
		        
		        RibbonStructure.RowTagAt(itemRow) = id
		        UpdateDropdownColumn(itemRow)
		      Next
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadSampleRibbon()
		  // Load a sample ribbon to demonstrate the designer
		  Var json As String = "{""version"":""1.0"",""projectType"":""desktop"",""tabs"":[" _
		  + "{""caption"":""Home"",""groups"":[" _
		  + "{""caption"":""Clipboard"",""items"":[" _
		  + "{""caption"":""Paste"",""tag"":""clipboard.paste"",""itemType"":""large"",""isEnabled"":true,""tooltipText"":""Paste from clipboard (Cmd+V)"",""menuItems"":[]}," _
		  + "{""caption"":""Cut"",""tag"":""clipboard.cut"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Copy"",""tag"":""clipboard.copy"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}" _
		  + "]}," _
		  + "{""caption"":""Font"",""items"":[" _
		  + "{""caption"":""Bold"",""tag"":""font.bold"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Italic"",""tag"":""font.italic"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Underline"",""tag"":""font.underline"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}" _
		  + "]}," _
		  + "{""caption"":""Paragraph"",""items"":[" _
		  + "{""caption"":""Left"",""tag"":""para.left"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Center"",""tag"":""para.center"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Right"",""tag"":""para.right"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}" _
		  + "]}" _
		  + "]}," _
		  + "{""caption"":""Insert"",""groups"":[" _
		  + "{""caption"":""Tables"",""items"":[" _
		  + "{""caption"":""Table"",""tag"":""insert.table"",""itemType"":""large"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}" _
		  + "]}," _
		  + "{""caption"":""Illustrations"",""items"":[" _
		  + "{""caption"":""Picture"",""tag"":""insert.picture"",""itemType"":""large"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Shapes"",""tag"":""insert.shapes"",""itemType"":""large"",""isEnabled"":true,""tooltipText"":""Insert a shape"",""menuItems"":[{""caption"":""Rectangle"",""tag"":""shapes.rect""},{""caption"":""Circle"",""tag"":""shapes.circle""},{""caption"":""Arrow"",""tag"":""shapes.arrow""},{""caption"":""Line"",""tag"":""shapes.line""}]}," _
		  + "{""caption"":""Chart"",""tag"":""insert.chart"",""itemType"":""large"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}" _
		  + "]}" _
		  + "]}," _
		  + "{""caption"":""View"",""groups"":[" _
		  + "{""caption"":""Zoom"",""items"":[" _
		  + "{""caption"":""Zoom In"",""tag"":""view.zoomin"",""itemType"":""large"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Zoom Out"",""tag"":""view.zoomout"",""itemType"":""large"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""100%"",""tag"":""view.zoom100"",""itemType"":""large"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}" _
		  + "]}," _
		  + "{""caption"":""Show"",""items"":[" _
		  + "{""caption"":""Ruler"",""tag"":""view.ruler"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Grid"",""tag"":""view.grid"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}," _
		  + "{""caption"":""Guides"",""tag"":""view.guides"",""itemType"":""small"",""isEnabled"":true,""tooltipText"":"""",""menuItems"":[]}" _
		  + "]}" _
		  + "]}" _
		  + "]}"
		  
		  LoadFromJSON(json)
		  mIsDirty = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MarkDirty()
		  mIsDirty = True
		  UpdateTitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NewProject()
		  If Not PromptSaveIfDirty Then Return
		  
		  RibbonStructure.RemoveAllRows
		  SetInspectorState("none")
		  mCurrentFile = Nil
		  mIsDirty = False
		  ProjectType.SelectedIndex = 0
		  UpdateTitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OpenProject()
		  If Not PromptSaveIfDirty Then Return
		  
		  Var ft As New FileType
		  ft.Name = "Ribbon File"
		  ft.Extensions = "ribbon"
		  
		  Var dlg As New OpenFileDialog
		  dlg.Filter = ft
		  
		  Var f As FolderItem = dlg.ShowModal(Self)
		  If f = Nil Then Return
		  
		  Var tis As TextInputStream = TextInputStream.Open(f)
		  Var json As String = tis.ReadAll
		  tis.Close
		  
		  LoadFromJSON(json)
		  mCurrentFile = f
		  mIsDirty = False
		  UpdateTitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopulateInspector(row As Integer)
		  // Fill inspector fields from the selected row's RowTag
		  If row < 0 Or row >= RibbonStructure.RowCount Then
		    SetInspectorState("none")
		    Return
		  End If
		  
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d = Nil Then
		    SetInspectorState("none")
		    Return
		  End If
		  
		  Var rowType As String = d.Value("type")
		  SetInspectorState(rowType)
		  
		  mUpdatingInspector = True
		  
		  CaptionField.Text = d.Value("caption")
		  
		  If rowType = "large" Or rowType = "small" Then
		    TagField.Text = d.Lookup("tag", "")
		    If rowType = "large" Then
		      ItemTypeField.Text = "Large Button"
		    Else
		      ItemTypeField.Text = "Small Button"
		    End If
		    IsEnabled.Value = d.Lookup("isEnabled", True)
		    TooltipTextField.Text = d.Lookup("tooltipText", "")
		    
		    // Load menu items for large buttons
		    MenuItems.RemoveAllRows
		    If rowType = "large" Then
		      Var items() As Dictionary = d.Lookup("menuItems", Nil)
		      If items <> Nil Then
		        For Each mi As Dictionary In items
		          MenuItems.AddRow(mi.Lookup("caption", ""), mi.Lookup("tag", ""))
		          MenuItems.CellTypeAt(MenuItems.LastAddedRowIndex, 0) = DesktopListBox.CellTypes.TextField
		          MenuItems.CellTypeAt(MenuItems.LastAddedRowIndex, 1) = DesktopListBox.CellTypes.TextField
		        Next
		      End If
		    End If
		  Else
		    // Clear item-only fields for tab/group
		    TagField.Text = ""
		    ItemTypeField.Text = ""
		    IsEnabled.Value = False
		    TooltipTextField.Text = ""
		    MenuItems.RemoveAllRows
		  End If
		  
		  mUpdatingInspector = False
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PromptSaveIfDirty() As Boolean
		  // Returns True if OK to proceed, False if user cancelled
		  If Not mIsDirty Then Return True
		  
		  Var dlg As New MessageDialog
		  dlg.Message = "Save changes before closing?"
		  dlg.Explanation = "Your changes will be lost if you don't save them."
		  dlg.ActionButton.Caption = "Save"
		  dlg.AlternateActionButton.Caption = "Don't Save"
		  dlg.AlternateActionButton.Visible = True
		  dlg.CancelButton.Visible = True
		  
		  Var result As MessageDialogButton = dlg.ShowModal(Self)
		  If result = dlg.ActionButton Then
		    SaveToFile
		    Return True
		  ElseIf result = dlg.AlternateActionButton Then
		    Return True
		  Else
		    // Cancel
		    Return False
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveAsToFile()
		  Var ft As New FileType
		  ft.Name = "Ribbon File"
		  ft.Extensions = "ribbon"
		  
		  Var dlg As New SaveFileDialog
		  dlg.Filter = ft
		  dlg.SuggestedFileName = "Untitled.ribbon"
		  If mCurrentFile <> Nil Then
		    dlg.SuggestedFileName = mCurrentFile.Name
		  End If
		  
		  Var f As FolderItem = dlg.ShowModal(Self)
		  If f = Nil Then Return
		  
		  mCurrentFile = f
		  SaveToFile
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SaveToFile()
		  If mCurrentFile = Nil Then
		    SaveAsToFile
		    Return
		  End If
		  
		  Var json As String = BuildJSON
		  Var tos As TextOutputStream = TextOutputStream.Create(mCurrentFile)
		  tos.Write(json)
		  tos.Close
		  
		  mIsDirty = False
		  UpdateTitle
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetInspectorState(rowType As String)
		  // Enable/disable inspector fields based on selected row type
		  // "tab" or "group" = only Caption enabled
		  // "large" = all item fields + menu items enabled
		  // "small" = all item fields enabled, menu items disabled
		  // "none" = all disabled
		  
		  Var isTab As Boolean = (rowType = "tab")
		  Var isGroup As Boolean = (rowType = "group")
		  Var isItem As Boolean = (rowType = "large" Or rowType = "small")
		  Var isLarge As Boolean = (rowType = "large")
		  Var anythingSelected As Boolean = (rowType <> "none")
		  
		  // Caption enabled for all types
		  CaptionField.Enabled = anythingSelected
		  Label4.Enabled = anythingSelected
		  
		  // Tag, ItemType, IsEnabled, Tooltip — item only
		  TagField.Enabled = isItem
		  Label5.Enabled = isItem
		  ItemTypeField.Enabled = isItem
		  Label6.Enabled = isItem
		  IsEnabled.Enabled = isItem
		  TooltipTextField.Enabled = isItem
		  Label8.Enabled = isItem
		  
		  // Resource Name — always disabled (deferred)
		  ResourceNameField.Enabled = False
		  Label10.Enabled = False
		  
		  // Menu Items — large button only
		  MenuItems.Enabled = isLarge
		  AddMenuItem.Enabled = isLarge
		  Label11.Enabled = isLarge
		  
		  // Clear fields when nothing selected
		  If Not anythingSelected Then
		    CaptionField.Text = ""
		    TagField.Text = ""
		    ItemTypeField.Text = ""
		    IsEnabled.Value = False
		    TooltipTextField.Text = ""
		    ResourceNameField.Text = ""
		    MenuItems.RemoveAllRows
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SyncMenuItemsToRowTag()
		  // Write MenuItems listbox contents back to the selected row's RowTag
		  Var row As Integer = RibbonStructure.SelectedRowIndex
		  If row < 0 Then Return
		  
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d = Nil Then Return
		  
		  Var items() As Dictionary
		  For i As Integer = 0 To MenuItems.RowCount - 1
		    Var mi As New Dictionary
		    mi.Value("caption") = MenuItems.CellTextAt(i, 0)
		    mi.Value("tag") = MenuItems.CellTextAt(i, 1)
		    items.Add(mi)
		  Next
		  d.Value("menuItems") = items
		  UpdateDropdownColumn(row)
		  MarkDirty
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateDropdownColumn(row As Integer)
		  // Update the Dropdown column (col 2) with menu item count
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d = Nil Then Return
		  If d.Value("type") <> "large" Then
		    RibbonStructure.CellTextAt(row, 2) = ""
		    Return
		  End If
		  Var items() As Dictionary = d.Lookup("menuItems", Nil)
		  If items <> Nil And items.Count > 0 Then
		    RibbonStructure.CellTextAt(row, 2) = Str(items.Count)
		  Else
		    RibbonStructure.CellTextAt(row, 2) = ""
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UpdateTitle()
		  Var fileName As String = "Untitled"
		  If mCurrentFile <> Nil Then
		    fileName = mCurrentFile.Name.Replace(".ribbon", "")
		  End If
		  Var dirty As String = ""
		  If mIsDirty Then dirty = " *"
		  ProjectName.Text = """" + fileName + """ Structure" + dirty
		  Self.Title = "XjRibbon Designer — " + fileName + dirty
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mCurrentFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIsDirty As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUpdatingInspector As Boolean
	#tag EndProperty

	#tag Method, Flags = &h0
		Function GenerateCode() As String
		  Var eol As String = EndOfLine
		  Var code As String = ""
		  Var eventName As String = "Opening"
		  If ProjectType.SelectedIndex = 1 Then eventName = "Shown"

		  code = code + "// Generated by XjRibbon Designer v0.6.0" + eol
		  code = code + "// Paste into your XjRibbon's " + eventName + "() event" + eol + eol

		  Var i As Integer = 0
		  While i < RibbonStructure.RowCount
		    Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(i))
		    If d = Nil Or d.Value("type") <> "tab" Then
		      i = i + 1
		      Continue
		    End If

		    Var tabCaption As String = d.Value("caption")
		    Var tabVar As String = SanitizeVarName(tabCaption) + "Tab"
		    code = code + "// === " + tabCaption + " ===" + eol
		    code = code + "Var " + tabVar + " As XjRibbonTab = Me.AddTab(""" + tabCaption + """)" + eol + eol

		    Var j As Integer = i + 1
		    While j < RibbonStructure.RowCount
		      Var gd As Dictionary = Dictionary(RibbonStructure.RowTagAt(j))
		      If gd = Nil Then
		        j = j + 1
		        Continue
		      End If
		      If gd.Value("type") = "tab" Then Exit

		      If gd.Value("type") = "group" Then
		        Var grpCaption As String = gd.Value("caption")
		        Var grpVar As String = SanitizeVarName(grpCaption) + "Group"
		        code = code + "Var " + grpVar + " As XjRibbonGroup = " + tabVar + ".AddNewGroup(""" + grpCaption + """)" + eol

		        Var k As Integer = j + 1
		        While k < RibbonStructure.RowCount
		          Var id As Dictionary = Dictionary(RibbonStructure.RowTagAt(k))
		          If id = Nil Then
		            k = k + 1
		            Continue
		          End If
		          Var it As String = id.Value("type")
		          If it = "tab" Or it = "group" Then Exit

		          If it = "large" Or it = "small" Then
		            Var cap As String = id.Value("caption")
		            Var tag As String = id.Lookup("tag", "")
		            Var tip As String = id.Lookup("tooltipText", "")
		            Var enabled As Boolean = id.Lookup("isEnabled", True)
		            Var miList() As Dictionary = id.Lookup("menuItems", Nil)
		            Var hasMI As Boolean = (miList <> Nil And miList.Count > 0)
		            Var isDropdown As Boolean = (it = "large" And hasMI)
		            Var hasExtras As Boolean = (tip <> "" Or Not enabled Or isDropdown)
		            Var itemVar As String = SanitizeVarName(cap) + "Item"

		            If isDropdown Then
		              code = code + "Var " + itemVar + " As XjRibbonItem = " + grpVar + ".AddDropdownButton(""" + cap + """, """ + tag + """)" + eol
		            ElseIf hasExtras Then
		              If it = "large" Then
		                code = code + "Var " + itemVar + " As XjRibbonItem = " + grpVar + ".AddLargeButton(""" + cap + """, """ + tag + """)" + eol
		              Else
		                code = code + "Var " + itemVar + " As XjRibbonItem = " + grpVar + ".AddSmallButton(""" + cap + """, """ + tag + """)" + eol
		              End If
		            Else
		              If it = "large" Then
		                code = code + "Call " + grpVar + ".AddLargeButton(""" + cap + """, """ + tag + """)" + eol
		              Else
		                code = code + "Call " + grpVar + ".AddSmallButton(""" + cap + """, """ + tag + """)" + eol
		              End If
		            End If

		            If tip <> "" Then
		              code = code + itemVar + ".TooltipText = """ + tip + """" + eol
		            End If
		            If Not enabled Then
		              code = code + itemVar + ".IsEnabled = False" + eol
		            End If
		            If isDropdown Then
		              For Each mi As Dictionary In miList
		                code = code + itemVar + ".AddMenuItem(""" + mi.Value("caption").StringValue + """, """ + mi.Value("tag").StringValue + """)" + eol
		              Next
		            End If
		          End If
		          k = k + 1
		        Wend
		        code = code + eol
		        j = k
		      Else
		        j = j + 1
		      End If
		    Wend
		    i = j
		  Wend

		  Return code
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SanitizeVarName(caption As String) As String
		  Var result As String = ""
		  Var capitalizeNext As Boolean = False
		  For Each c As String In caption.Characters
		    If c >= "a" And c <= "z" Then
		      If capitalizeNext Then
		        result = result + c.Uppercase
		        capitalizeNext = False
		      Else
		        result = result + c
		      End If
		    ElseIf c >= "A" And c <= "Z" Then
		      If result = "" Then
		        result = result + c.Lowercase
		      Else
		        result = result + c
		      End If
		      capitalizeNext = False
		    ElseIf c >= "0" And c <= "9" Then
		      If result = "" Then result = "the"
		      result = result + c
		      capitalizeNext = False
		    ElseIf c = " " Or c = "-" Or c = "_" Then
		      capitalizeNext = True
		    End If
		  Next
		  If result = "" Then result = "item"
		  Return result
		End Function
	#tag EndMethod

#tag EndWindowCode

#tag Events CopyToolbarCode
	#tag Event
		Sub Pressed()
		  // Save first if dirty
		  If mIsDirty Then
		    If mCurrentFile = Nil Then
		      SaveAsToFile
		      If mCurrentFile = Nil Then Return
		    Else
		      SaveToFile
		    End If
		  End If

		  Var code As String = GenerateCode
		  Var cb As New Clipboard
		  cb.Text = code
		  cb.Close

		  StatusBar.Text = "Code copied to clipboard! Paste into your XjRibbon's " + If(ProjectType.SelectedIndex = 0, "Opening", "Shown") + "() event."
		End Sub
	#tag EndEvent
#tag EndEvents

#tag Events RibbonStructure
	#tag Event
		Sub SelectionChanged()
		  Var row As Integer = Me.SelectedRowIndex
		  PopulateInspector(row)
		End Sub
	#tag EndEvent
	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Forward Delete (Chr(127)) on Mac, Backspace (Chr(8)) or Delete on Windows
		  If key = Chr(127) Or key = Chr(8) Then
		    DeleteSelectedRow()
		    Return True
		  End If
		End Function
	#tag EndEvent
	#tag Event
		Sub CellAction(row As Integer, column As Integer)
		  // After inline edit, sync caption back to RowTag, inspector, and cascade tags
		  If column = 0 Then
		    Var d As Dictionary = Dictionary(Me.RowTagAt(row))
		    If d <> Nil Then
		      d.Value("caption") = Me.CellTextAt(row, 0)

		      // Sync inspector if this row is still selected
		      If Me.SelectedRowIndex = row Then
		        mUpdatingInspector = True
		        CaptionField.Text = d.Value("caption")
		        mUpdatingInspector = False
		      End If

		      // Cascade tag updates (same as inspector edit)
		      CascadeTagUpdate(row)
		      MarkDirty
		    End If
		  End If
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events AddItemPopup
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  #Pragma Unused item
		  // Skip the placeholder "-- select item --"
		  If Me.SelectedRowIndex <= 0 Then Return
		  
		  Var selectedText As String = Me.SelectedRowText
		  
		  Select Case selectedText
		  Case "Ribbon Tab"
		    // Tabs always add at root, after all existing rows
		    RibbonStructure.AddRow("New Tab")
		    Var addedRow As Integer = RibbonStructure.LastAddedRowIndex
		    RibbonStructure.CellTextAt(addedRow, 1) = "Tab"
		    RibbonStructure.CellTypeAt(addedRow, 0) = DesktopListBox.CellTypes.TextField
		    
		    Var d As New Dictionary
		    d.Value("type") = "tab"
		    d.Value("caption") = "New Tab"
		    RibbonStructure.RowTagAt(addedRow) = d
		    RibbonStructure.SelectedRowIndex = addedRow
		    
		  Case "Ribbon Group"
		    // Must have a Tab (or child of Tab) selected
		    Var selRow As Integer = RibbonStructure.SelectedRowIndex
		    If selRow < 0 Then
		      StatusBar.Text = "Select a Tab to add a Group inside it"
		      Me.SelectedRowIndex = 0
		      Return
		    End If
		    
		    // Find parent Tab — walk up if a Group or Item is selected
		    Var parentTabRow As Integer = FindParentOfType(selRow, "tab")
		    If parentTabRow < 0 Then
		      StatusBar.Text = "Select a Tab to add a Group inside it"
		      Me.SelectedRowIndex = 0
		      Return
		    End If
		    
		    // Insert after the last child of this tab
		    Var insertAt As Integer = FindLastChildRow(parentTabRow) + 1
		    RibbonStructure.AddRowAt(insertAt, "New Group", 1)
		    Var addedRow As Integer = RibbonStructure.LastAddedRowIndex
		    RibbonStructure.CellTextAt(addedRow, 1) = "Group"
		    RibbonStructure.CellTypeAt(addedRow, 0) = DesktopListBox.CellTypes.TextField
		    
		    Var d As New Dictionary
		    d.Value("type") = "group"
		    d.Value("caption") = "New Group"
		    RibbonStructure.RowTagAt(addedRow) = d
		    RibbonStructure.SelectedRowIndex = addedRow
		    
		  Case "Ribbon Large Button", "Ribbon Small Button"
		    // Must have a Group (or sibling Item) selected
		    Var selRow As Integer = RibbonStructure.SelectedRowIndex
		    If selRow < 0 Then
		      StatusBar.Text = "Select a Group to add a Button inside it"
		      Me.SelectedRowIndex = 0
		      Return
		    End If
		    
		    // Find parent Group — if an Item is selected, find its parent Group
		    Var parentGroupRow As Integer = FindParentOfType(selRow, "group")
		    If parentGroupRow < 0 Then
		      StatusBar.Text = "Select a Group to add a Button inside it"
		      Me.SelectedRowIndex = 0
		      Return
		    End If
		    
		    Var parentTag As Dictionary = Dictionary(RibbonStructure.RowTagAt(parentGroupRow))
		    
		    Var btnType As String
		    Var btnLabel As String
		    If selectedText = "Ribbon Large Button" Then
		      btnType = "large"
		      btnLabel = "Large Button"
		    Else
		      btnType = "small"
		      btnLabel = "Small Button"
		    End If
		    
		    // Insert after the last child of this group
		    Var insertAt As Integer = FindLastChildRow(parentGroupRow) + 1
		    RibbonStructure.AddRowAt(insertAt, "New Button", 2)
		    Var addedRow As Integer = RibbonStructure.LastAddedRowIndex
		    RibbonStructure.CellTextAt(addedRow, 1) = btnLabel
		    RibbonStructure.CellTypeAt(addedRow, 0) = DesktopListBox.CellTypes.TextField
		    
		    // Auto-generate tag from parent group caption
		    Var parentCaption As String = parentTag.Value("caption")
		    Var autoTag As String = GenerateTag(parentCaption, "New Button")
		    
		    Var d As New Dictionary
		    d.Value("type") = btnType
		    d.Value("caption") = "New Button"
		    d.Value("tag") = autoTag
		    d.Value("isEnabled") = True
		    d.Value("tooltipText") = ""
		    Var emptyMenuItems() As Dictionary
		    d.Value("menuItems") = emptyMenuItems
		    RibbonStructure.RowTagAt(addedRow) = d
		    RibbonStructure.SelectedRowIndex = addedRow
		    
		  End Select
		  
		  MarkDirty
		  
		  // Reset popup to placeholder
		  Me.SelectedRowIndex = 0
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events CaptionField
	#tag Event
		Sub TextChanged()
		  If mUpdatingInspector Then Return
		  
		  Var row As Integer = RibbonStructure.SelectedRowIndex
		  If row < 0 Then Return
		  
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d = Nil Then Return
		  
		  Var rowType As String = d.Value("type")
		  d.Value("caption") = Me.Text
		  RibbonStructure.CellTextAt(row, 0) = Me.Text
		  
		  // Cascade tag updates
		  CascadeTagUpdate(row)
		  
		  MarkDirty
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events IsEnabled
	#tag Event
		Sub ValueChanged()
		  If mUpdatingInspector Then Return
		  
		  Var row As Integer = RibbonStructure.SelectedRowIndex
		  If row < 0 Then Return
		  
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d = Nil Then Return
		  
		  d.Value("isEnabled") = Me.Value
		  MarkDirty
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TagField
	#tag Event
		Sub TextChanged()
		  If mUpdatingInspector Then Return
		  
		  Var row As Integer = RibbonStructure.SelectedRowIndex
		  If row < 0 Then Return
		  
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d = Nil Then Return
		  
		  d.Value("tag") = Me.Text
		  MarkDirty
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events TooltipTextField
	#tag Event
		Sub TextChanged()
		  If mUpdatingInspector Then Return
		  
		  Var row As Integer = RibbonStructure.SelectedRowIndex
		  If row < 0 Then Return
		  
		  Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(row))
		  If d = Nil Then Return
		  
		  d.Value("tooltipText") = Me.Text
		  MarkDirty
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events MenuItems
	#tag Event
		Sub CellAction(row As Integer, column As Integer)
		  // After inline edit, auto-update tag when caption changes
		  If column = 0 Then
		    // Auto-generate tag from the item's tag prefix + menu item caption
		    Var selRow As Integer = RibbonStructure.SelectedRowIndex
		    If selRow >= 0 Then
		      Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(selRow))
		      If d <> Nil Then
		        Var itemTag As String = d.Lookup("tag", "")
		        Var prefix As String = itemTag.NthField(".", 1)
		        If prefix = "" Then prefix = "item"
		        Var miCaption As String = Me.CellTextAt(row, 0)
		        Me.CellTextAt(row, 1) = prefix + "." + miCaption.Lowercase.ReplaceAll(" ", "")
		      End If
		    End If
		  End If
		  SyncMenuItemsToRowTag
		End Sub
	#tag EndEvent
	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Forward Delete (Chr(127)) on Mac, Backspace (Chr(8)) on Windows
		  If key = Chr(127) Or key = Chr(8) Then
		    Var row As Integer = Me.SelectedRowIndex
		    If row >= 0 Then
		      Me.RemoveRowAt(row)
		      If Me.RowCount > 0 Then
		        If row >= Me.RowCount Then row = Me.RowCount - 1
		        Me.SelectedRowIndex = row
		      End If
		      SyncMenuItemsToRowTag
		    End If
		    Return True
		  End If
		End Function
	#tag EndEvent
#tag EndEvents
#tag Events AddMenuItem
	#tag Event
		Sub Pressed()
		  // Auto-generate tag from parent item tag
		  Var autoTag As String = "item.newitem"
		  Var selRow As Integer = RibbonStructure.SelectedRowIndex
		  If selRow >= 0 Then
		    Var d As Dictionary = Dictionary(RibbonStructure.RowTagAt(selRow))
		    If d <> Nil Then
		      Var itemTag As String = d.Lookup("tag", "")
		      Var prefix As String = itemTag.NthField(".", 1)
		      If prefix = "" Then prefix = "item"
		      autoTag = prefix + ".newitem"
		    End If
		  End If
		  
		  MenuItems.AddRow("New Item", autoTag)
		  Var addedRow As Integer = MenuItems.LastAddedRowIndex
		  MenuItems.CellTypeAt(addedRow, 0) = DesktopListBox.CellTypes.TextField
		  MenuItems.CellTypeAt(addedRow, 1) = DesktopListBox.CellTypes.TextField
		  MenuItems.SelectedRowIndex = addedRow
		  
		  SyncMenuItemsToRowTag
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
