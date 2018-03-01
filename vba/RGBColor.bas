VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "RGBColor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private pRed As Integer
Private pGreen As Integer
Private pBlue As Integer

Public Property Get Red() As Integer
    Red = pRed
End Property

Public Property Let Red(Value As Integer)
    pRed = Value
End Property

Public Property Get Green() As Integer
    Green = pGreen
End Property

Public Property Let Green(Value As Integer)
    pGreen = Value
End Property

Public Property Get Blue() As Integer
    Blue = pBlue
End Property

Public Property Let Blue(Value As Integer)
    pBlue = Value
End Property

Public Sub InitProperties(iRed As Integer, iGreen As Integer, iBlue As Integer)
    Me.Blue = iBlue
    Me.Red = iRed
    Me.Green = iGreen
End Sub

Public Function AsString(Optional sDelim As String) As String
Dim aTmp() As String

    If sDelim = "" Then
        sDelim = ","
    End If
    
    ReDim aTmp(0 To 2)
    aTmp(0) = Me.Red
    aTmp(1) = Me.Green
    aTmp(2) = Me.Blue
    
    AsString = Join(aTmp, sDelim)
End Function