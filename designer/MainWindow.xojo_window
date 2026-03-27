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
      ColumnCount     =   2
      ColumnWidths    =   "*,25%"
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
      InitialValue    =   "Caption	Type"
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
   Begin DesktopPopupMenu NewItem
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
      Text            =   "XjToolbar Designer version 0.4.0"
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
		Sub Opening()
		  ProjectName.Text = """Untitled"" Structure"
		  Self.Title = "XjRibbon Designer — Untitled"

		  // Disable all inspector fields initially
		  SetInspectorState("none")
		End Sub
	#tag EndEvent

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
		Sub DeleteSelectedRow()
		  Var row As Integer = RibbonStructure.SelectedRowIndex
		  If row < 0 Then Return

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
		End Sub
	#tag EndMethod

	#tag Property, Flags = &h21
		Private mUpdatingInspector As Boolean
	#tag EndProperty

	#tag MenuHandler
		Function HelpAbout() As Boolean Handles HelpAbout.Action
		  Var about As New AboutBox
		  about.ShowModal
		  Return True
		End Function
	#tag EndMenuHandler

#tag EndWindowCode

#tag Events NewItem
	#tag Event
		Sub SelectionChanged(item As DesktopMenuItem)
		  #Pragma Unused item
		  // Skip the placeholder "-- select item --"
		  If Me.SelectedRowIndex <= 0 Then Return

		  Var selectedText As String = Me.SelectedRowText

		  Select Case selectedText
		  Case "Ribbon Tab"
		    // Tabs always add at root
		    Var newRow As Integer = RibbonStructure.LastAddedRowIndex + 1
		    If RibbonStructure.RowCount = 0 Then
		      newRow = 0
		    Else
		      // Add after the last root-level row (skip all children of last tab)
		      newRow = RibbonStructure.RowCount
		    End If

		    RibbonStructure.AddExpandableRow("New Tab")
		    Var addedRow As Integer = RibbonStructure.LastAddedRowIndex
		    RibbonStructure.CellTextAt(addedRow, 1) = "Tab"
		    RibbonStructure.CellTypeAt(addedRow, 0) = DesktopListBox.CellTypes.TextField
		    RibbonStructure.RowExpandedAt(addedRow) = True

		    Var d As New Dictionary
		    d.Value("type") = "tab"
		    d.Value("caption") = "New Tab"
		    RibbonStructure.RowTagAt(addedRow) = d
		    RibbonStructure.SelectedRowIndex = addedRow

		  Case "Ribbon Group"
		    // Must have a Tab selected
		    Var selRow As Integer = RibbonStructure.SelectedRowIndex
		    If selRow < 0 Then
		      StatusBar.Text = "Select a Tab to add a Group inside it"
		      Me.SelectedRowIndex = 0
		      Return
		    End If

		    Var selTag As Dictionary = Dictionary(RibbonStructure.RowTagAt(selRow))
		    If selTag = Nil Or selTag.Value("type") <> "tab" Then
		      StatusBar.Text = "Select a Tab to add a Group inside it"
		      Me.SelectedRowIndex = 0
		      Return
		    End If

		    // Insert after the last child of this tab
		    Var insertAt As Integer = FindLastChildRow(selRow) + 1
		    RibbonStructure.AddExpandableRowAt(insertAt, "New Group", 1)
		    Var addedRow As Integer = RibbonStructure.LastAddedRowIndex
		    RibbonStructure.CellTextAt(addedRow, 1) = "Group"
		    RibbonStructure.CellTypeAt(addedRow, 0) = DesktopListBox.CellTypes.TextField
		    RibbonStructure.RowExpandedAt(addedRow) = True

		    Var d As New Dictionary
		    d.Value("type") = "group"
		    d.Value("caption") = "New Group"
		    RibbonStructure.RowTagAt(addedRow) = d
		    RibbonStructure.SelectedRowIndex = addedRow

		  Case "Ribbon Large Button", "Ribbon Small Button"
		    // Must have a Group selected
		    Var selRow As Integer = RibbonStructure.SelectedRowIndex
		    If selRow < 0 Then
		      StatusBar.Text = "Select a Group to add a Button inside it"
		      Me.SelectedRowIndex = 0
		      Return
		    End If

		    Var selTag As Dictionary = Dictionary(RibbonStructure.RowTagAt(selRow))
		    If selTag = Nil Or selTag.Value("type") <> "group" Then
		      StatusBar.Text = "Select a Group to add a Button inside it"
		      Me.SelectedRowIndex = 0
		      Return
		    End If

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
		    Var insertAt As Integer = FindLastChildRow(selRow) + 1
		    RibbonStructure.AddRowAt(insertAt, "New Button", 2)
		    Var addedRow As Integer = RibbonStructure.LastAddedRowIndex
		    RibbonStructure.CellTextAt(addedRow, 1) = btnLabel
		    RibbonStructure.CellTypeAt(addedRow, 0) = DesktopListBox.CellTypes.TextField

		    Var d As New Dictionary
		    d.Value("type") = btnType
		    d.Value("caption") = "New Button"
		    d.Value("tag") = ""
		    d.Value("isEnabled") = True
		    d.Value("tooltipText") = ""
		    Var emptyMenuItems() As Dictionary
		    d.Value("menuItems") = emptyMenuItems
		    RibbonStructure.RowTagAt(addedRow) = d
		    RibbonStructure.SelectedRowIndex = addedRow

		  End Select

		  // Reset popup to placeholder
		  Me.SelectedRowIndex = 0
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
		  // After inline edit, sync caption back to RowTag and inspector
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
		    End If
		  End If
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

		  d.Value("caption") = Me.Text
		  RibbonStructure.CellTextAt(row, 0) = Me.Text
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
		End Sub
	#tag EndEvent
#tag EndEvents

#tag Events AddMenuItem
	#tag Event
		Sub Pressed()
		  // Add a new menu item row
		  MenuItems.AddRow("New Item", "")
		  Var addedRow As Integer = MenuItems.LastAddedRowIndex
		  MenuItems.CellTypeAt(addedRow, 0) = DesktopListBox.CellTypes.TextField
		  MenuItems.CellTypeAt(addedRow, 1) = DesktopListBox.CellTypes.TextField
		  MenuItems.SelectedRowIndex = addedRow

		  // Sync back to RowTag
		  SyncMenuItemsToRowTag
		End Sub
	#tag EndEvent
#tag EndEvents

#tag Events MenuItems
	#tag Event
		Sub CellAction(row As Integer, column As Integer)
		  #Pragma Unused row
		  #Pragma Unused column
		  // After inline edit, sync back to RowTag
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
