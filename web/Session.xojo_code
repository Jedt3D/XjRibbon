#tag Class
Protected Class Session
Inherits WebSession
	#tag Event
		Sub HashTagChanged(hashTag As String)
		  // Handle dropdown menu selection callback from JavaScript
		  If hashTag.BeginsWith("xjdd:") Then
		    Var parts() As String = hashTag.Split(":")
		    If parts.Count >= 3 Then
		      Var itemTag As String = parts(1)
		      Var menuTag As String = parts(2)
		      // Find the XjRibbon on the current page and fire the event
		      If MainWebPage <> Nil Then
		        MainWebPage.XjRibbon1.HandleDropdownSelection(itemTag, menuTag)
		      End If
		    End If
		    Self.HashTag = ""
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
