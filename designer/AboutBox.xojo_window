#tag DesktopWindow
Begin DesktopWindow AboutBox
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   False
   HasMinimizeButton=   False
   HasTitleBar     =   True
   Height          =   377
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   ""
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   False
   Title           =   "About"
   Type            =   1
   Visible         =   True
   Width           =   276
   Begin DesktopImageViewer AppIcon
      Active          =   False
      AllowAutoDeactivate=   True
      AllowTabStop    =   True
      Enabled         =   True
      Height          =   150
      Image           =   0
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   63
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      PanelIndex      =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      Tooltip         =   ""
      Top             =   53
      Transparent     =   False
      Visible         =   True
      Width           =   150
      _mIndex         =   0
      _mInitialParent =   ""
      _mName          =   ""
      _mPanelIndex    =   0
   End
   Begin DesktopLabel CopyrightLabel
      AllowAutoDeactivate=   True
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   142
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      Multiline       =   True
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "XjRibbon Designer\nversion 2.0.0\n\nCopyright\nWorajedt Sitthidumrong\n2026\nsjedt@3ddaily.com"
      TextAlignment   =   2
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   215
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   236
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Function KeyDown(key As String) As Boolean
		  // Close on Escape key
		  If key = Chr(27) Then
		    Self.Close
		    Return True
		  End If
		End Function
	#tag EndEvent

	#tag Event
		Function MouseDown(x As Integer, y As Integer) As Boolean
		  #Pragma Unused x
		  #Pragma Unused y
		  // Close on click anywhere
		  Self.Close
		  Return True
		End Function
	#tag EndEvent

	#tag Event
		Sub Opening()
		  If Color.IsDarkMode Then
		    AppIcon.Image = AppIconDarkSketch
		  Else
		    AppIcon.Image = AppIconLightSketch
		  End If
		End Sub
	#tag EndEvent


#tag EndWindowCode

