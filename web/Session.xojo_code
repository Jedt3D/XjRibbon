#tag Class
Protected Class Session
Inherits WebSession
	#tag Event
		Sub HashtagChanged(name As String, data As String)
		  #Pragma Unused data

		  // Handle dropdown menu selection
		  If name.BeginsWith("xjdd:") Then
		    Var parts() As String = name.Split(":")
		    If parts.Count >= 3 Then
		      Var itemTag As String = parts(1)
		      Var menuTag As String = parts(2)
		      If MainWebPage <> Nil Then
		        MainWebPage.XjRibbon1.HandleDropdownSelection(itemTag, menuTag)
		      End If
		    End If
		    Self.HashTag = ""
		    Return
		  End If

		  // Handle mouse move on ribbon
		  If name.BeginsWith("xjmm:") Then
		    Var parts() As String = name.Split(":")
		    If parts.Count >= 3 Then
		      Var mx As Integer = CType(Val(parts(1)), Integer)
		      Var my As Integer = CType(Val(parts(2)), Integer)
		      If MainWebPage <> Nil Then
		        MainWebPage.XjRibbon1.HandleMouseMove(mx, my)
		      End If
		    End If
		    Self.HashTag = ""
		    Return
		  End If

		  // Handle mouse leave on ribbon
		  If name = "xjml" Then
		    If MainWebPage <> Nil Then
		      MainWebPage.XjRibbon1.HandleMouseLeave
		    End If
		    Self.HashTag = ""
		    Return
		  End If
		End Sub
	#tag EndEvent

#tag Session
  interruptmessage=We are having trouble communicating with the server. Please wait a moment while we attempt to reconnect.
  disconnectmessage=You have been disconnected from this application.
  confirmmessage=
  AllowTabOrderWrap=True
  ColorMode=0
  SendEventsInBatches=False
  LazyLoadDependencies=False
#tag EndSession
End Class
#tag EndClass
