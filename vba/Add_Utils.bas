Attribute VB_Name = "Add_Utils"
Const C_LIST_TYPE_SHEET = "list_types"
Const C_MODULE_NAME = "Add_Utils"
Const C_PREPS = "1,2,3,4,5"
Const C_GOBUTTON_ROW = 2
Const C_GOBUTTON_COL = 8

Enum FieldType
    Number = 1
    NumberFormula = 2
    Text = 3
    List = 4
End Enum

Enum ListType
    Students = 1
    Teachers = 2
End Enum

Enum NumberRangeType
    gt0lt100 = 1
    gt10lte20 = 2
End Enum

Enum ErrorType
    NotAnInteger = 1
    NotValidPrep = 2
End Enum

Enum FormType
    Add = 1
    Menu = 2
    View = 3
    ViewList = 4
End Enum

Const C_RGB_VALID = "0,255,0"
Const C_RGB_INVALID = "255,0,0"
Const C_RGB_ERROR = "242,242,242"

Const C_FORM_TYPE = "Add,Menu,View,ViewList"
Public dDefinitions As Dictionary

Function EnumFormType(i As Long) As String
    EnumFormType = Split(C_FORM_TYPE, COMMA)(i - 1)
End Function
Function GetFormTypeEnumFromValue(sValue As String) As Long
    GetFormTypeEnumFromValue = IndexArray(C_FORM_TYPE, sValue)
End Function

Const C_RGB_VALID = "0,255,0"
Const C_RGB_INVALID = "255,0,0"
Const C_RGB_ERROR = "242,242,242"

Public dDefinitions As Dictionary
Function IsEntryValid(sSheetName As String, rTarget As Range) As Boolean
Dim cRGB As RGBColor
    Set cRGB = GetBgColor(sSheetName, rTarget)
    If cRGB.AsString <> C_RGB_VALID Then
        IsEntryValid = False
        Exit Function
    End If

    IsEntryValid = True

End Function
Public Function SetEntryValue(sAction As String, sFieldName As String, vValue As Variant, _
    Optional wbTmp As Workbook) As Integer
Dim dDefnDetails As Dictionary
Dim sEntryKey As String
Dim sFuncName As String

setup:

    If IsSet(wbTmp) = False Then
        Set wbTmp = ActiveWorkbook
    End If
    
    sFuncName = C_MODULE_NAME & "." & "SetEntryValue"
    
    sEntryKey = GetEntryKey(sAction, sFieldName)
                
    If dDefinitions.Exists(sEntryKey) = False Then
        FuncLogIt sFuncName, "range [" & sEntryKey & "] does not exist in sheet [" & sAction & "]", C_MODULE_NAME, LogMsgType.Error
        SetEntryValue = -1
        Exit Function
    End If
    
    Set dDefnDetails = dDefinitions.Item(sEntryKey)
    With wbTmp.Sheets(sAction)
        .Range(dDefnDetails("address")).value = vValue
    End With
    
    SetEntryValue = 0
End Function
Public Function GetRecordValuesAsDict(wbSourceBook As Workbook, wbTargetbook As Workbook, _
                sSheetName As String) As Dictionary
Dim rEntryCell As Range
Dim sFuncName As String, sActionName As String, sFieldName As String
Dim dValues As New Dictionary

setup:
    sFuncName = C_MODULE_NAME & "." & "GetRecordValuesAsDict"

main:

    aNames = GetSheetNamedRanges(wbTargetbook, sSheetName)
    For Each name_ In aNames
        sActionName = Split(name_, "_")(0)
        If sActionName = "e" & sSheetName Then
            sFieldName = Split(name_, "_")(1)
            Set rEntryCell = wbTargetbook.Sheets(sSheetName).Range(name_)
            dValues.Add sFieldName, rEntryCell.value
            End If
    Next name_
    
    Set GetRecordValuesAsDict = dValues
End Function
Public Function IsRecordValid(wbSourceBook As Workbook, wbTargetbook As Workbook, _
                sSheetName As String, sSourceSheetName As String) As Boolean
Dim rEntryCell As Range
Dim cRGB As RGBColor
Dim sFuncName As String

setup:
    sFuncName = C_MODULE_NAME & "." & "IsRecordValid"

main:

    aNames = GetSheetNamedRanges(wbTargetbook, sSheetName)
    For Each name_ In aNames
        If Split(name_, "_")(0) = "e" & sSheetName Then
            Set rEntryCell = wbTargetbook.Sheets(sSheetName).Range(name_)
            Set cRGB = GetBgColor(sSheetName, rEntryCell)
            If cRGB.AsString <> C_RGB_VALID Then
                IsRecordValid = False
                FuncLogIt sFuncName, "Cell named [" & name_ & "] not valid", C_MODULE_NAME, LogMsgType.Info

                ChangeButton wbSourceBook, wbTargetbook, sSheetName, C_GOBUTTON_ROW, C_GOBUTTON_COL, CellState.Invalid, sSourceSheetName, bTakeFocus:=False

                Exit Function
            End If
        End If
    Next name_
    IsRecordValid = True
    FuncLogIt sFuncName, "Add Form  [" & sSheetName & "] is valid", C_MODULE_NAME, LogMsgType.Info

    ChangeButton wbSourceBook, wbTargetbook, sSheetName, C_GOBUTTON_ROW, C_GOBUTTON_COL, _
        CellState.Valid, sSourceSheetName, bTakeFocus:=True

End Function
Public Sub FormatCellInvalid(sSheetName As String, rCell As Range)
    SetBgColor sSheetName, rCell, 255, 0, 0
End Sub
Public Sub FormatCellValid(sSheetName As String, rCell As Range)
    SetBgColor sSheetName, rCell, 0, 255, 0
End Sub
Public Sub DoLoadDefinitions(Optional clsQuadRuntime As Quad_Runtime)
Dim rSource As Range
Dim wsTmp As Worksheet
Dim wbTmp As Workbook

    If IsSet(clsQuadRuntime) = True Then
        Set wbTmp = clsQuadRuntime.TemplateBook
        Set wsTmp = wbTmp.Sheets(clsQuadRuntime.DefinitionSheetName)
    Else
        Set wbTmp = ActiveWorkbook
        'Set wsTmp = wbTmp.Sheets("Definitions")
        Set wsTmp = wbTmp.Sheets(clsQuadRuntime.DefinitionSheetName)
    End If
    
    Set rSource = wsTmp.Range("Definitions")
    Set Add_Utils.dDefinitions = LoadDefinitions(wsTmp, rSource)
    
    End Sub
'Public Function IsValidInteger(ByVal iValue As Variant) As Boolean
Public Function IsValidInteger(ParamArray args()) As Boolean
Dim sFuncName As String
Dim iValueTmp As Integer
Dim iValue As Variant

setup:
    sFuncName = C_MODULE_NAME & "." & "IsValidInteger"
    iValue = args(1)

main:
    On Error GoTo err
    iValueTmp = Int(iValue)
    On Error GoTo 0
    IsValidInteger = True
    FuncLogIt sFuncName, "Value [" & CStr(iValue) & "] is valid", C_MODULE_NAME, LogMsgType.OK

    Exit Function
err:
    IsValidInteger = False
    FuncLogIt sFuncName, "Value [" & CStr(iValue) & "] is invalid ", C_MODULE_NAME, LogMsgType.OK

End Function
Public Function IsValidString(ParamArray args()) As Boolean
    IsValidString = True
End Function
Public Function IsValidPrep(ParamArray args()) As Boolean
Dim sFuncName As String
Dim aPreps() As String
Dim iValue As Variant
 
setup:
    sFuncName = C_MODULE_NAME & "." & "IsValidPrep"
    iValue = args(1)
main:
    aPreps = Split(C_PREPS, ",")
    'If IsValidInteger(iValue) = True Then
    If IsValidInteger(args(0), args(1)) = True Then
    'If IsValidInteger(args(0), args(1), args(2)) = True Then
    
        If InArray(aPreps, iValue) = True Then
            IsValidPrep = True
            FuncLogIt sFuncName, "Value [" & CStr(iValue) & "] is valid", C_MODULE_NAME, LogMsgType.OK
            Exit Function
        End If
    End If
err:
    IsValidPrep = False
    FuncLogIt sFuncName, "Value [" & CStr(iValue) & "] is invalid", C_MODULE_NAME, LogMsgType.OK

End Function
Public Function UpdateForm(ParamArray args()) As Boolean
Dim dValues As Dictionary, dDetailDefn As Dictionary
Dim sTableName As String, sValue As String, sRangeName As String, sRecordID As String, sFieldName As String
Dim clsQuadRuntime As Quad_Runtime
Dim sKey As Variant
Dim rTarget As Range

    Set clsQuadRuntime = args(0)
    sValue = args(1)
    sRangeName = args(2)
    sTableName = Split(sRangeName, BANG)(0)
    
    clsQuadRuntime.InitProperties bInitializeCache:=False
    
    sRecordID = GetTableRecordID(sValue, "sStudentFirstNm")
    Set dValues = GetTableRecord("person_student", CInt(sRecordID) - 1, wbTmp:=clsQuadRuntime.CacheBook)
    
    For Each sKey In dDefinitions.Keys
        If Split(sKey, UNDERSCORE)(0) = "t" & sTableName Then
            Set dDetailDefn = dDefinitions.Item(sKey)
            sFieldName = Split(sKey, UNDERSCORE)(1)
            Set rTarget = clsQuadRuntime.ViewBook.Sheets(sTableName).Range(sKey)
            rTarget.value = dValues.Item(sFieldName)
        End If
    Next sKey
    
End Function
Public Function IsMember(ParamArray args()) As Boolean
Dim sColumnRange As String, sLookUpTableName As String, sLookUpColumnName As String, sValue As String
Dim vValid2DValues() As Variant
Dim vValidValues() As String
Dim clsQuadRuntime As New Quad_Runtime
Dim wsCache As Worksheet

    Set clsQuadRuntime = args(0)
    sValue = args(1)
    sLookUpTableName = args(2)(0)
    sLookUpColumnName = args(2)(1)

    sColumnRange = GetDBColumnRange(sLookUpTableName, sLookUpColumnName)
    
    If Left(sLookUpTableName, 1) = "&" Then
        Set wsCache = Application.Run(Right(sLookUpTableName, Len(sLookUpTableName) - 1), clsQuadRuntime)
        vValidValues = ListFromRange(wsCache, sColumnRange)
    Else
        vValidValues = ListFromRange(clsQuadRuntime.CacheBook.Sheets(sLookUpTableName), sColumnRange)
    End If
    
    If InArray(vValidValues, sValue) = False Then
        IsMember = False
        Exit Function
    End If
    
    IsMember = True
End Function
Public Function IsMemberOrig(ParamArray args()) As Boolean
Dim sFuncName As String, sTableName As String, sColRange As String
Dim aValues() As String
Dim iValue As Variant
Dim vParams As Variant
setup:
            
    sFuncName = C_MODULE_NAME & "." & "IsMember"
    
    If UBound(args) < 1 Then
        FuncLogIt sFuncName, "Requires at least 2 parameters ]" & CStr(UBound(args) + 1) & "] given", C_MODULE_NAME, LogMsgType.OK
        Exit Function
    End If
    iValue = args(0)
    sTableName = args(1)
    If UBound(args) > 1 Then
        ' col needs to be passed to do lookup in a "Table"
        vParams = args(2)
        sColRange = GetDBColumnRange(vParams(0), vParams(1))
    Else
        ' this is the old pre-table range name
        sColRange = "l" & sTableName
    End If
    
main:

    aValues = ListFromRange(ActiveWorkbook.Sheets(vParams(0)), sColRange)
    
    If InArray(aValues, iValue) = True Then
        IsMember = True
        Exit Function
    End If
    
    IsMember = False
err:

End Function
Public Sub DumpDefinitions(Optional bLog As Boolean = True)
Dim sKey As Variant
Dim vDetail As Variant
Dim sFuncName As String, sDetail As String
Dim dDefnDetail As Dictionary
Dim v

    sFuncName = C_MODULE_NAME & "." & "DumpDefinitions"
    
    For Each sKey In dDefinitions.Keys
        If sKey <> "actions" And sKey <> "tables" Then
            Set dDefnDetail = dDefinitions.Item(sKey)
            Debug.Print vbNewLine
            Debug.Print sKey
            For Each vDetail In dDefnDetail.Keys
                If MyVarType(dDefnDetail.Item(vDetail)) = 46 Then
                    sDetail = "[" & Join(dDefnDetail.Item(CStr(vDetail)), COMMA) & "]"
                Else
                    sDetail = dDefnDetail.Item(vDetail)
                End If
                Debug.Print PadStr(CStr(vDetail), "left", 20, " ") & " = " & PadStr(sDetail, "right", 20, " ")
            Next vDetail
        End If
    Next sKey
End Sub
Function GetKey(sSheetName As String, sFieldName As String, Optional eCellType As CellType = CellType.Entry) As String
Dim sKeySuffix As String
    If eCellType = CellType.Entry Then
        eKeySuffix = "e"
    ElseIf eCellType = CellType.Button Then
        eKeySuffix = "b"
    ElseIf eCellType = CellType.Text Then
        eKeySuffix = "t"
    ElseIf eCellType = CellType.ListText Then
        eKeySuffix = "l"
    ElseIf eCellType = CellType.Selector Then
        eKeySuffix = "s"
    End If
    
    GetKey = eKeySuffix & sSheetName & "_" & sFieldName
    
End Function
Function GetEntryKey(sSheetName As String, sFieldName As String) As String
Dim sKey As String

    sKey = "e" & sSheetName & "_" & sFieldName
    GetEntryKey = sKey
End Function

Public Function GenerateEntryCell(sKey As String, iLabelRow As Integer, iLabelCol As Integer, _
                                  sAction As String, sSheetName As String, _
                         Optional iEntryRowOffset As Integer = 0, _
                         Optional iEntryColOffset As Integer = -1, _
                         Optional wbTmp As Workbook) As Range
'<<<
'purpose: generate a specific entry cell
'param  : sKey, String, named range to be applied to the new cell (like eNewLesson_SFirstName)
'param  : iLabelCol, iLabelRow as integer, location of the entry cell label (the actual entry is
'param  : iEntryRowOffset,iEntryColOffset as integer; where is the entry in relation to the label
'param  : sAction, String; user action that entrys need to be generated for (like NewLesson)
'>>>
Dim rCell As Range, rLabel As Range
Dim sFieldName As String
Dim sFuncName As String

setup:
    On Error GoTo err
    sFuncName = C_MODULE_NAME & "." & "GenerateEntryCell"
    
main:

    If IsSet(wbTmp) = False Then
        Set wbTmp = ActiveWorkbook
    End If
    
    With wbTmp.Sheets(sSheetName)
        Set rCell = .Range(.Cells(iLabelRow, iLabelCol), .Cells(iLabelRow, iLabelCol))
        CreateNamedRange wbTmp, rCell.Address, CStr(sAction), CStr(sKey), "True"
        
        Set rLabel = rCell.Offset(iEntryRowOffset, iEntryColOffset)
        sFieldName = Split(sKey, "_")(1)
        rLabel.value = sFieldName
    End With

    Set GenerateEntryCell = rCell
    
cleanup:
    On Error GoTo 0
    Exit Function

err:
    FuncLogIt sFuncName, "Error [ " & err.Description & "]  [sKey=" & sKey & "] [sAction=" & sAction & "]", C_MODULE_NAME, LogMsgType.Error
    err.Raise err.Number, err.Source, err.Description ' cannot recover from this
    
End Function


Private Sub UpdateDefaultValues(sKey As String, dDefaultValues As Dictionary, sAction As String, rCell As Range)
Dim sDBColName As String
    If IsSet(dDefaultValues) = True Then ' add default value if one exists
        If dDefaultValues.Exists(sAction) = True Then
            sDBColName = Split(sKey, "_")(1)
            If dDefaultValues.Item(sAction).Exists(sDBColName) = True Then
                rCell.value = dDefaultValues.Item(sAction).Item(sDBColName)
            End If
        End If
    End If
End Sub

Public Function GenerateForm(clsQuadRuntime As Quad_Runtime, _
                              sAction As String, _
                     Optional dDefaultValues As Dictionary, _
                     Optional vValues As Variant, _
                     Optional wbTmp As Workbook, _
                     Optional eCellType As CellType = CellType.Entry, _
                     Optional sFormType As String = "Add") As String()
'<<<
'purpose: given a set of definition (taken from the global variable dDefinitions, generate
'       : all the entry widgets (labels and entry cells)
'param  : clsQuadRuntime, Quad_Runtime; all config controlling names of books, sheets, ranges for
'       :                 also contains any variables that need to be passed continually
'param  : sAction, String; user action that entrys need to be generated for (like NewLesson)
'rtype  : a list of the keys from the widgets that were created
'>>>
Dim sFuncName As String, sSheetName As String, sCellTypeSuffix As String
Dim iRow As Integer, iCol As Integer, iWidth As Integer, iHeight As Integer, iEntryCount As Integer, iParentRowOffset As Integer, iParentColOffset As Integer, iListWidth As Integer
Dim rCell As Range, rFormat As Range, rListHeader As Range, rListRow As Range, rListColumn As Range
Dim vDefinedEntryNamesRanges() As String, vKeySplits() As String, vGenerated() As String
Dim wbTarget As Workbook
Dim dDefnDetail As Dictionary

setup:
    'On Error GoTo err
    sFuncName = C_MODULE_NAME & "." & "GenerateForm"
    ReDim vGenerated(0 To 20)
    
    sSheetName = sAction  'assume the Sheet name is equal to the Action (like NewLesson)
    
    If IsSet(wbTmp) = False Then
        Set wbTmp = ActiveWorkbook
    End If
        
    If sFormType = "ViewList" Then
        Set wbTarget = CallByName(clsQuadRuntime, "ViewBook", VbGet)
    Else
        Set wbTarget = CallByName(clsQuadRuntime, sFormType & "Book", VbGet)
    End If
    
main:
    ' get location opf entry screens
        
    vDefinedAddNamesRanges = GetSheetNamedRanges(clsQuadRuntime.TemplateBook, "FormStyles", "f" & sFormType & EnumCellType(eCellType))
    
    ' get location of parent format
    With clsQuadRuntime.TemplateSheet.Range("f" & sFormType)
        iParentRowOffset = .Rows(1).Row - 1
        iParentColOffset = .Columns(1).Column - 1
    End With
    
    If IsEmptyArray(vDefinedAddNamesRanges) = True Then
        FuncLogIt sFuncName, "No formats defined for [CellType" & EnumCellType(eCellType) & "]  [sAction=" & sAction & "]", C_MODULE_NAME, LogMsgType.Error
        GoTo cleanup
    End If

    ' for each entry in the definition generate a input field
    With wbTmp.Sheets(sSheetName)
        .Range(.Cells(1, 1), .Cells(1, 1)).value = UCase(sAction)
     
        For Each sKey In dDefinitions.Keys()
        
            ' only go further if the definition matches the cell type specified by passed param
            Set dDefnDetail = dDefinitions.Item(sKey)
            If dDefnDetail.Item("cell_type") <> eCellType Then
                GoTo nextdefn
            End If
            
            vKeySplits = Split(sKey, "_")
            sCellTypeSuffix = Left(vKeySplits(0), 1)

            If Right(vKeySplits(0), Len(vKeySplits(0)) - 1) <> sAction Then
                GoTo nextdefn
            End If
            
            If InArray(Array("actions", "tables"), sKey) Then
                GoTo nextdefn
            End If
            
            Set rFormat = clsQuadRuntime.TemplateSheet.Range(vDefinedAddNamesRanges(iEntryCount))
            iRow = rFormat.Row - iParentRowOffset
            iCol = rFormat.Column - iParentColOffset
            iWidth = rFormat.Columns.Count
            iHeight = rFormat.Rows.Count
            
            If iEntryCount > UBound(vDefinedAddNamesRanges) Then
                err.Raise ErrorMsgType.FORMAT_NOT_DEFINED, Description:="cannot find a format for number [" & CStr(iEntryCount) * "]"
            End If
            
            If sCellTypeSuffix = "e" Then
                Set rCell = GenerateEntryCell(CStr(sKey), iRow, iCol, sAction, sSheetName, wbTmp:=wbTmp)
                FormatCell clsQuadRuntime.TemplateBook, wbTarget, CStr(sAction), rCell, CellState.Invalid, sSourceSheetName:=clsQuadRuntime.TemplateCellSheetName, eCellType:=CellType.Entry
                dDefinitions.Item(sKey).Add "address", rCell.Address
                UpdateDefaultValues CStr(sKey), dDefaultValues, sAction, rCell
            ElseIf sCellTypeSuffix = "s" Then
                GenerateSelector clsQuadRuntime.TemplateBook, wbTarget, sAction, iRow, iCol, CellState.Invalid, clsQuadRuntime.TemplateCellSheetName, CStr(sKey)
            ElseIf sCellTypeSuffix = "b" Then
                GenerateButton clsQuadRuntime.TemplateBook, wbTarget, sAction, iRow, iCol, CellState.Invalid, clsQuadRuntime.TemplateCellSheetName, CStr(sKey)
            ElseIf sCellTypeSuffix = "t" Then
                Set rCell = GenerateView(clsQuadRuntime.TemplateBook, wbTarget, sAction, iRow, iCol, clsQuadRuntime.TemplateCellSheetName, CStr(sKey))
                dDefinitions.Item(sKey).Add "address", rCell.Address
                UpdateDefaultValues CStr(sKey), dDefaultValues, sAction, rCell
            ElseIf sCellTypeSuffix = "l" Then
                Set rListColumn = GenerateViewList(clsQuadRuntime.TemplateBook, wbTarget, sAction, iRow, iCol, clsQuadRuntime.TemplateCellSheetName, CStr(sKey), iHeight:=iHeight)

                For iRow = 1 To UBound(vValues)
                        On Error Resume Next
                        rListColumn.Rows(iRow).value = vValues(iRow, iEntryCount)
                        On Error GoTo 0
                Next iRow
            Else
                err.Raise 999, Description:="CellType suffix [" & sCellTypeSuffix & "] not implemented"
            End If
            
            ' will only get here if an entry has been added
            vGenerated(iEntryCount) = sKey
            iEntryCount = iEntryCount + 1

nextdefn:
        Next sKey
     End With

cleanup:
    If iEntryCount = 0 Then
        ReDim vGenerated(0)
    Else
        ReDim Preserve vGenerated(iEntryCount - 1)
    End If
    On Error GoTo 0
    GenerateForm = vGenerated
    Exit Function

err:
    FuncLogIt sFuncName, "Error [ " & err.Description & "]  [sKey=" & sKey & "] [sAction=" & sAction & "]", C_MODULE_NAME, LogMsgType.Error
    err.Raise err.Number, err.Source, err.Description ' cannot recover from this
    
End Function
Public Sub DeleteEntry(sSheetName As String, sKey As Variant, Optional wbTmp As Workbook)
Dim sFuncName As String

    If IsSet(wbTmp) = False Then
        Set wbTmp = ActiveWorkbook
    End If
    
    sFuncName = C_MODULE_NAME & "." & "DeleteEntry"
    If Left(sKey, Len("e" & sSheetName)) = "e" & sSheetName Then
        DeleteNamedRange wbTmp, sSheetName, CStr(sKey)
    End If
        
End Sub

Public Function GenerateViewList(wbSourceBook As Workbook, wbTargetbook As Workbook, _
                               sSheetName As String, iRow As Integer, iCol As Integer, _
                               sViewFormatSheetName As String, _
                               sKey As String, _
                         Optional iEntryRowOffset As Integer = 0, _
                         Optional iEntryColOffset As Integer = -1, _
                         Optional iHeight As Integer = 0) As Range
Dim sViewRangeName As String, sFieldName As String

   With wbTargetbook.Sheets(sSheetName)
        Set rCell = .Range(.Cells(iRow, iCol), .Cells(iRow + iHeight, iCol))
        sViewRangeName = sKey
        CreateNamedRange wbTargetbook, rCell.Address, sSheetName, sViewRangeName, "True"
        
        'Set rLabel = rCell.Offset(iEntryRowOffset, iEntryColOffset)
        'sFieldName = Split(sKey, "_")(1)
        'rLabel.value = sFieldName
        
    End With
    
    Set GenerateViewList = rCell
    
    FormatCell wbSourceBook, wbTargetbook, sSheetName, GenerateViewList, CellState.Invalid, sViewFormatSheetName, _
        CellType.ListText
    
End Function
Public Function GenerateView(wbSourceBook As Workbook, wbTargetbook As Workbook, _
                               sSheetName As String, iRow As Integer, iCol As Integer, _
                               sViewFormatSheetName As String, _
                               sKey As String, _
                         Optional iEntryRowOffset As Integer = 0, _
                         Optional iEntryColOffset As Integer = -1) As Range
Dim sViewRangeName As String, sFieldName As String

   With wbTargetbook.Sheets(sSheetName)
        Set rCell = .Range(.Cells(iRow, iCol), .Cells(iRow, iCol))
        sViewRangeName = sKey
        CreateNamedRange wbTargetbook, rCell.Address, sSheetName, sViewRangeName, "True"
        
        Set rLabel = rCell.Offset(iEntryRowOffset, iEntryColOffset)
        sFieldName = Split(sKey, "_")(1)
        rLabel.value = sFieldName
        
    End With
    
    Set GenerateView = rCell
    
    FormatCell wbSourceBook, wbTargetbook, sSheetName, GenerateView, CellState.Invalid, sViewFormatSheetName, _
        CellType.Text
    
End Function

Public Function GenerateButton(wbSourceBook As Workbook, wbTargetbook As Workbook, _
                               sSheetName As String, iRow As Integer, iCol As Integer, _
                               eButtonState As CellState, sButtonFormatSheetName As String, _
                               sKey As String) As Range
Dim sButtonRangeName As String

   With wbTargetbook.Sheets(sSheetName)
        Set rCell = .Range(.Cells(iRow, iCol), .Cells(iRow, iCol))
        'sButtonRangeName = "b" & sSheetName
        ' 4/25/18 to accomodate multi and dynamically defined buttons
        sButtonRangeName = sKey
        CreateNamedRange wbTargetbook, rCell.Address, sSheetName, sButtonRangeName, "True"
    End With
    
    Set GenerateButton = rCell
    
    FormatCell wbSourceBook, wbTargetbook, sSheetName, GenerateButton, eButtonState, sButtonFormatSheetName
    
End Function

Public Function GenerateSelector(wbSourceBook As Workbook, wbTargetbook As Workbook, _
                               sSheetName As String, iRow As Integer, iCol As Integer, _
                               eSelectorState As CellState, sSelectorFormatSheetName As String, _
                               sKey As String) As Range
Dim sSelectorRangeName As String

   With wbTargetbook.Sheets(sSheetName)
        Set rCell = .Range(.Cells(iRow, iCol), .Cells(iRow, iCol))
        sSelectorRangeName = sKey
        CreateNamedRange wbTargetbook, rCell.Address, sSheetName, sSelectorRangeName, "True"
    End With
    
    Set GenerateSelector = rCell
    
    FormatCell wbSourceBook, wbTargetbook, sSheetName, GenerateSelector, eSelectorState, sSelectorFormatSheetName, CellType.Selector
    
End Function


Public Sub ChangeButton(wbSourceBook As Workbook, wbTargetbook As Workbook, _
                        sSheetName As String, iRow As Integer, iCol As Integer, _
                        eCellState As CellState, sButtonFormatSheetName As String, _
                        Optional bTakeFocus As Boolean = False)
Dim sButtonRangeName As String
Dim rCurrentFocus As Range
Dim rCell As Range

    EventsToggle False
    With wbTargetbook.Sheets(sSheetName)
        Set rCurrentFocus = Selection
        Set rCell = .Range(.Cells(iRow, iCol), .Cells(iRow, iCol))
    End With

    FormatCell wbSourceBook, wbTargetbook, sSheetName, rCell, eCellState, sButtonFormatSheetName
    
    If bTakeFocus = False Then
        rCurrentFocus.Select
    End If
    EventsToggle True
    
End Sub
Public Sub ShowForm(sTableName As String)
Dim wsTmp As Worksheet

    Set wsTmp = ShowSheet(ActiveWorkbook, "Add" & sTableName)
    wsTmp.Activate
End Sub

Public Sub HideForm(sSheetName As String)

    If SheetIsVisible(ActiveWorkbook, sSheetName) = True Then
        HideSheet ActiveWorkbook, sSheetName
    End If
    
End Sub
Public Sub HideForms()
Dim sAction As Variant
Dim sKey As Variant

    If dDefinitions Is Nothing Then
        DoLoadDefinitions
    End If
    
    Set dActions = dDefinitions.Item("actions")
    For Each sAction In dActions.Keys()
        If SheetIsVisible(ActiveWorkbook, CStr(sAction)) = True Then
            HideSheet ActiveWorkbook, CStr(sAction)
        End If
    Next sAction
    
End Sub

Public Sub DeleteForms(Optional wbTmp As Workbook)
Dim sAction As Variant
Dim sKey As Variant

    If IsSet(wbTmp) = False Then
        Set wbTmp = ActiveWorkbook
    End If
    
    If dDefinitions Is Nothing Then
        DoLoadDefinitions
    End If
    
    Set dActions = dDefinitions.Item("actions")
    For Each sAction In dActions.Keys()
        For Each sKey In dDefinitions.Keys()
            DeleteEntry CStr(sAction), sKey, wbTmp:=wbTmp
        Next sKey
        DeleteSheet wbTmp, CStr(sAction)
    Next sAction
    
End Sub

Public Sub FormatAddForm(clsQuadRuntime As Quad_Runtime, _
                           sTargetSheetName As String, _
                  Optional sFormType As String = "Add", _
                           Optional iFirstCol As Integer = 1, _
                           Optional iFirstRow As Integer = 1)
Dim sFormFormatRangeName As String
Dim rFormFormatRange As Range, rFormFormatTargetRange As Range
Dim iFormatWidth As Integer, iFormatHeight As Integer
Dim wsForm As Worksheet
Dim wbTarget As Workbook

    sFormFormatRangeName = "f" & sFormType
    If sFormType = "ViewList" Then
        Set wbTarget = CallByName(clsQuadRuntime, "ViewBook", VbGet)
    Else
        Set wbTarget = CallByName(clsQuadRuntime, sFormType & "Book", VbGet)
    End If
    'If sFormType = "Menu" Then
    '    Set wbTarget = clsQuadRuntime.MenuBook
    'ElseIf sFormType = "View" Then
    '    Set wbTarget = clsQuadRuntime.ViewBook
    'Else
    '    Set wbTarget = clsQuadRuntime.AddBook
    'End If
    
    Set wsForm = wbTarget.Sheets(sTargetSheetName)
    
    With clsQuadRuntime.TemplateSheet
        .Range(sFormFormatRangeName).Copy
        iFormatWidth = .Range(sFormFormatRangeName).Columns.Count
        iFormatHeight = .Range(sFormFormatRangeName).Rows.Count
    End With
    
    wsForm.Visible = True
    With wsForm
        wsForm.Range(.Cells(iFirstRow, iFirstCol), _
                     .Cells(iFirstRow + iFormatHeight - 1, _
                            iFirstCol + iFormatWidth - 1)).PasteSpecial Paste:=xlPasteFormats, _
                                                                               operation:=xlNone, _
                                                                               SkipBlanks:=False, _
                                                                               Transpose:=False
    End With

    FormatColRowSize clsQuadRuntime.TemplateBook, wbTarget, _
            wsForm.Name, clsQuadRuntime.TemplateSheetName, sFormFormatRangeName
End Sub

Function GetCallerModuleCode() As String
' add a caller module so can simulate change events more reliably
    GetCallerModuleCode = "Public Sub Invoke_Worksheet_SelectionChange(sSheetName As String, rTarget As Range)" & vbNewLine & _
                "Dim ws As Worksheet" & vbNewLine & _
                "set ws = Sheets(sSheetName)" & vbNewLine & _
                "Application.Run ws.CodeName & " & DOUBLEQUOTE & ".Worksheet_SelectionChange" & DOUBLEQUOTE & ", rTarget" & vbNewLine & _
                "End Sub"
End Function
        
Function GetEntryCallbackCode(clsQuadRuntime As Quad_Runtime, sAction As String, sTargetBookName As String, _
        Optional eCellType As CellType = CellType.Entry) As String
    GetEntryCallbackCode = "Private Sub Worksheet_Change(ByVal Target As Range)" & vbNewLine & _
            "dim wbTarget as Workbook, wbSource as Workbook" & vbNewLine & _
            "dim sSourceSheetName as string" & vbNewLine & _
            "dim sSheetName as string" & vbNewLine & _
            "sSheetName=" & DOUBLEQUOTE & sAction & DOUBLEQUOTE & vbNewLine & _
            "set wbSource= Workbooks(" & DOUBLEQUOTE & clsQuadRuntime.TemplateBookName & DOUBLEQUOTE & ")" & vbNewLine & _
            "set wbTarget= Workbooks(" & DOUBLEQUOTE & sTargetBookName & DOUBLEQUOTE & ")" & vbNewLine & _
            "sSourceSheetName = " & DOUBLEQUOTE & clsQuadRuntime.TemplateCellSheetName & DOUBLEQUOTE & vbNewLine & _
            "Application.Run " & DOUBLEQUOTE & clsQuadRuntime.TemplateBook.Name & "!Validate" & DOUBLEQUOTE & ",wbTarget,sSheetName, Target" & vbNewLine
            
    If eCellType = CellType.Entry Then
        GetEntryCallbackCode = GetEntryCallbackCode & "Application.Run " & DOUBLEQUOTE & clsQuadRuntime.TemplateBook.Name & "!IsRecordValid" & DOUBLEQUOTE & ",wbSource,wbTarget,sSheetName,sSourceSheetName" & vbNewLine
    End If
    
    GetEntryCallbackCode = GetEntryCallbackCode & "End Sub"
            
End Function
Function GenerateCallbackCode(clsQuadRuntime As Quad_Runtime, vButtons() As String, sActionName As String, _
                Optional sCurrentCode As String, _
                Optional wbTmp As Workbook) As String
Dim i As Integer, iRow As Integer, iColumn As Integer
Dim sCallback As String, sCallbackCode As String
Dim dDetail As Dictionary
Dim rButton As Range

    If IsSet(wbTmp) = False Then
        Set wbTmp = ActiveWorkbook
    End If
    
    For i = 0 To UBound(vButtons)
        Set dDetail = dDefinitions.Item(vButtons(i))
        sCallback = dDetail.Item("validation_args")(0)
        Set rButton = wbTmp.Sheets(sActionName).Range(vButtons(i))
        sCallbackCode = sCallbackCode & GetButtonCallbackCode(clsQuadRuntime, rButton.Column, rButton.Row, sCallback) & vbNewLine
    Next i
    
    GenerateCallbackCode = sCurrentCode & vbNewLine & _
         "Public Sub Worksheet_SelectionChange(ByVal Target As Range)" & vbNewLine & _
         sCallbackCode & vbNewLine & _
        "End Sub"

End Function
Function GetButtonCallbackCode(clsQuadRuntime As Quad_Runtime, _
    iButtonCol As Integer, iButtonRow As Integer, sCallbackFunc As String) As String
    GetButtonCallbackCode = _
                    "If Target.Column = " & CStr(iButtonCol) & " And Target.Row = " & CStr(iButtonRow) & " Then" & vbNewLine & _
                    "Application.Run " & DOUBLEQUOTE & clsQuadRuntime.TemplateBook.Name & "!" & sCallbackFunc & DOUBLEQUOTE & vbNewLine & _
                    "End If" & vbNewLine
End Function
Public Sub GenerateForms(clsQuadRuntime As Quad_Runtime, _
                     Optional bLoadRefData As Boolean = False, _
                     Optional sOverideButtonCallback As String, _
                     Optional sFormName As String, _
                     Optional dDefaultValues As Dictionary, _
                     Optional vValues As Variant, _
                     Optional bSetAsValid As Boolean = False)
'<<<
'purpose: based on Definitions, create a set of sheets that serve as entry screens;
'       : add callback code to the sheets so that user entries are processed immediately
'       : add buttons, that can be used to submit completed records
'       : cache reference data for use in validations when user enters data
'       :
'param  : clsQuadRuntime, Quad_Runtime; all config controlling names of books, sheets, ranges for
'       :                 also contains any variables that need to be passed continually
'param  : bLoadRefData, Boolean; when true will force loading of ref data from db
'>>>
Dim dActions As Dictionary, dDefnDetails As Dictionary
Dim sAction As Variant, sKey As Variant, vFormType As Variant
Dim sCode As String, sFieldName As String, sFuncName As String, sCallbackFunc As String, sDBColName As String, sFormType As String
Dim rCell As Range, rButton As Range
Dim vGenerated() As String
Dim wbTmp As Workbook, wbTarget As Workbook
Dim eCellType As CellType

setup:
    sFuncName = C_MODULE_NAME & "." & "GenerateForms"

    If IsSet(dDefinitions) = False Then
        DoLoadDefinitions
    End If
    
    Set dActions = dDefinitions.Item("actions")
    For Each sAction In dActions.Keys()
    
        If sFormName <> "" Then
            If sAction <> sFormName Then
                GoTo nextaction
            End If
        End If
                
        If sOverideButtonCallback <> "" Then
            sCallbackFunc = sOverideButtonCallback
        Else
            'sCallbackFunc = "Add" & sAction
            sCallbackFunc = sAction
        End If
        
        ' create the Add sheet and add call back code
        For Each vFormType In Split(C_FORM_TYPE, COMMA)
            If CStr(sAction) Like vFormType & ASTERISK Then
                If vFormType = "ViewList" Then
                    Set wbTarget = CallByName(clsQuadRuntime, "ViewBook", VbGet)
                Else
                    Set wbTarget = CallByName(clsQuadRuntime, vFormType & "Book", VbGet)
                End If
                sFormType = CStr(vFormType)
                
            End If
        Next vFormType
        
        If IsSet(wbTarget) = False Then
            FuncLogIt sFuncName, "invalid formtype  [" & CStr(sAction) & "]", C_MODULE_NAME, LogMsgType.Failure
            GoTo nextaction
            'err.Raise ErrorMsgType.INVALID_FORMTYPE, Description:="form type needs to be New or Menu"
        End If
    
        Set wsTmp = CreateSheet(wbTarget, CStr(sAction), bOverwrite:=True)
        
        For i = 1 To UBound(Split(C_CELL_TYPE, COMMA)) + 1
            eCellType = i

            sCode = GetEntryCallbackCode(clsQuadRuntime, CStr(sAction), wbTarget.Name, eCellType:=eCellType)
            FormatAddForm clsQuadRuntime, CStr(sAction), sFormType:=sFormType
            
            If eCellType = CellType.ListText Then
                GenerateForm clsQuadRuntime, CStr(sAction), wbTmp:=wbTarget, vValues:=vValues, eCellType:=eCellType, sFormType:=sFormType
            ElseIf eCellType = CellType.Text Then
                GenerateForm clsQuadRuntime, CStr(sAction), wbTmp:=wbTarget, dDefaultValues:=dDefaultValues, eCellType:=eCellType, sFormType:=sFormType
            ElseIf eCellType = CellType.Button Then
                vGenerated = GenerateForm(clsQuadRuntime, CStr(sAction), wbTmp:=wbTarget, dDefaultValues:=dDefaultValues, eCellType:=eCellType, sFormType:=sFormType)
                If IsEmptyArray(vGenerated) = False Then
                    sCode = GenerateCallbackCode(clsQuadRuntime, vGenerated, CStr(sAction), sCurrentCode:=sCode, wbTmp:=wbTarget)
                End If
                AddCode2Module wbTarget, wsTmp.CodeName, sCode
            ElseIf eCellType = CellType.Selector Then
                GenerateForm clsQuadRuntime, CStr(sAction), wbTmp:=wbTarget, dDefaultValues:=dDefaultValues, eCellType:=eCellType, sFormType:=sFormType
            ElseIf eCellType = CellType.Entry Then
                GenerateForm clsQuadRuntime, CStr(sAction), wbTmp:=wbTarget, dDefaultValues:=dDefaultValues
            End If
            
            If eCellType = CellType.Button Or eCellType = CellType.Entry Then
                sCode = GetCallerModuleCode
                ' will already exist if more than 1 entry
                If ModuleExists(wbTarget, "change_event_invoker") = False Then
                    CreateModule wbTarget, "change_event_invoker", sCode
                End If
            End If
        Next i
        HideForm CStr(sAction)
        FuncLogIt sFuncName, "Generated Form for action [" & sAction & "]", C_MODULE_NAME, LogMsgType.Info
nextaction:
    Next sAction
End Sub
Public Function LoadDefinitions(wsTmp As Worksheet, _
                       Optional rSource As Range = Nothing, _
                       Optional bIgnoreCellType As Boolean = False) As Dictionary
Dim dDefinitions As New Dictionary, dDefnDetail As Dictionary
Dim dDefnActions As New Dictionary 'holds a discrete list of actions that have been defined
Dim dDefnTables As New Dictionary 'holds a discrete list of tables that have been defined
Dim rRow As Range
Dim sTableName As String, sFieldName As String, sActionName As String, sValidationType As String, sActionFunc As String
Dim eCellType As CellType
Dim sValidationParam As String, sFuncName As String, sKey As String
Dim vValidationParams() As String
Dim iCol As Integer, iValidationParamCount As Integer

setup:

    sFuncName = C_MODULE_NAME & "." & "LoadDefinitions"
main:
    If rSource Is Nothing Then
        Set rSource = Range("rDefinitions")
    End If
    
    With wsTmp
        For Each rRow In rSource.Rows
            ReDim vValidationParams(0 To 3)
            'rSource.Select
            iValidationParamCount = 0
            sActionName = rRow.Columns(1)
            sTableName = rRow.Columns(2)
            sFieldName = rRow.Columns(3)
            sValidationType = rRow.Columns(4)
            sValidationParam = rRow.Columns(5)
            sActionFunc = rRow.Columns(8)
            
            If bIgnoreCellType = False Then
                eCellType = GetCellTypeFromValue(rRow.Columns(9))
            Else
                eCellType = CellType.Entry
            End If
            
            Set dDefnDetail = New Dictionary
            dDefnDetail.Add "validation_type", sValidationType
            dDefnDetail.Add "validation_param", sValidationParam
            dDefnDetail.Add "db_table_name", sTableName
            dDefnDetail.Add "db_field_name", sFieldName
            dDefnDetail.Add "cell_type", eCellType
            dDefnDetail.Add "action_func", sActionFunc
            
            For iCol = 6 To 7
                If rRow.Columns(iCol).value <> "" Then
                    vValidationParams(iValidationParamCount) = rRow.Columns(iCol).value
                    iValidationParamCount = iValidationParamCount + 1
                End If
            Next iCol
            
            If iValidationParamCount > 0 Then
                ReDim Preserve vValidationParams(0 To iValidationParamCount - 1)
                dDefnDetail.Add "validation_args", vValidationParams
            End If
            
            sKey = GetKey(sActionName, sFieldName, eCellType)
            
            If dDefinitions.Exists(sKey) = True Then
                FuncLogIt sFuncName, "definition for [" & sKey & "] already loaded", C_MODULE_NAME, LogMsgType.Info
            Else
                dDefinitions.Add sKey, dDefnDetail
            End If
            
            If dDefnActions.Exists(sActionName) = False Then
                'rRow.Select
                dDefnActions.Add sActionName, Nothing
            End If

            If dDefnTables.Exists(sTableName) = False Then
                dDefnTables.Add sTableName, Nothing
            End If
            
        Next rRow
    End With
    
    dDefinitions.Add "actions", dDefnActions
    dDefinitions.Add "tables", dDefnTables
    
exitfunc:
    Set LoadDefinitions = dDefinitions
    FuncLogIt sFuncName, "Loaded in [" & CStr(UBound(dDefinitions.Keys())) & "] definitions", C_MODULE_NAME, LogMsgType.OK
    Exit Function

err:
    Set LoadDefinitions = Nothing
    FuncLogIt sFuncName, "loading in definitions in [" & err.Description & "] definitions", C_MODULE_NAME, LogMsgType.Failure

End Function
Public Function Validate(wbBook As Workbook, sSheetName As String, rTarget As Range) As Boolean
Dim sFuncName As String, sDefnName As String, sActionFuncName As String, sValidType As String
Dim dDefnDetail As Dictionary
Dim vValidParams() As String
Dim bValid As Boolean
Dim eThisErrorType As ErrorType
Dim mThisModule As VBComponent
Dim clsQuadRuntime As New Quad_Runtime

setup:
    clsQuadRuntime.InitProperties bInitializeCache:=False
    
    EventsToggle False
    'On Error GoTo err_name

    If UBound(Split(rTarget.Name.Name, "!")) = 1 Then
        sDefnName = Split(rTarget.Name.Name, "!")(1)
    Else
        sDefnName = rTarget.Name.Name
    End If
    On Error GoTo 0
    
    sFuncName = C_MODULE_NAME & "." & "Validate"
    
    If dDefinitions Is Nothing Then
        ' when called from a callback and dDefinitons needs to be reconstituted
        FuncLogIt sFuncName, "Definitions not loaded so reloading", C_MODULE_NAME, LogMsgType.Info
        DoLoadDefinitions clsQuadRuntime:=clsQuadRuntime
    End If
    
    If dDefinitions.Exists(sDefnName) = False Then
        ' usually called from tests, where dDefinitions is already set
        FuncLogIt sFuncName, "Loading definition for  in [" & sDefnName & "]", C_MODULE_NAME, _
            LogMsgType.Failure
    Else
        Set dDefnDetail = dDefinitions.Item(sDefnName)
        sValidType = dDefnDetail.Item("validation_type")
        sFuncName = dDefnDetail.Item("validation_param")
        If IsSet(dDefnDetail.Item("validation_args")) = True Then
            vValidParams = dDefnDetail.Item("validation_args")
        End If
        
        FuncLogIt sFuncName, "Using validation  [" & sValidType & "] [" & sFuncName & "]", C_MODULE_NAME, _
            LogMsgType.OK
        
        On Error GoTo err
        If IsSet(clsQuadRuntime) Then
            'first passed arg now needs to be clsQuadRuntime if IsSet
            Validate = Application.Run(sFuncName, clsQuadRuntime, rTarget.value, vValidParams)
        Else
            Validate = Application.Run(sFuncName, rTarget.value, dDefnDetail.Item("db_table_name"), vValidParams)
        End If
        On Error GoTo 0
        
        If Validate = True Then
            'SetBgColorFromString sSheetName, rTarget, C_RGB_VALID, wbTmp:=clsQuadRuntime.AddBook
            SetBgColorFromString sSheetName, rTarget, C_RGB_VALID, wbTmp:=wbBook
            
            If dDefnDetail.Item("action_func") <> "" Then
                sActionFuncName = Right(dDefnDetail.Item("action_func"), Len(dDefnDetail.Item("action_func")) - 1)
                Application.Run sActionFuncName, clsQuadRuntime, rTarget.value, rTarget.Name.Name
            End If
            
            Exit Function
        End If
    End If
    
    SetBgColorFromString sSheetName, rTarget, C_RGB_INVALID, wbTmp:=clsQuadRuntime.AddBook
    Validate = False
    EventsToggle True
    
    Exit Function

err:
    SetBgColorFromString sSheetName, rTarget, C_RGB_ERROR, wbTmp:=clsQuadRuntime.AddBook
    FuncLogIt sFuncName, "Error [" & err.Description & "]", C_MODULE_NAME, _
            LogMsgType.Failure
    Exit Function

err_name:
    FuncLogIt sFuncName, "Error with range name for [" & rTarget.Address & "} [" & err.Description & "]", C_MODULE_NAME, _
            LogMsgType.Failure
End Function


