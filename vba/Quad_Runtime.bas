VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Quad_Runtime"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Const C_MODULE_NAME = "Quad_Runtime"

Private pBookPath As String
Private pBookName As String
Private pBook As Workbook

Private pCacheBookName As String
Private pCacheBookPath As String
Private pCacheRangeName As String
Private pCacheBook As Workbook

Private pTemplateBookPath As String
Private pTemplateBookName As String
Private pTemplateSheetName As String
Private pTemplateCellSheetName As String
Private pTemplateBook As Workbook
Private pTemplateSheet As Worksheet
Private pTemplateCellSheet As Worksheet

Private pScheduleBook As Workbook
Private pScheduleBookPath As String
Private pScheduleBookName As String

Private pAddBook As Workbook
Private pAddBookPath As String
Private pAddBookName As String

Private pViewBook As Workbook
Private pViewBookPath As String
Private pViewBookName As String

Private pMenuBook As Workbook
Private pMenuBookPath As String
Private pMenuBookName As String

Private pDatabasePath As String
Private pResultFileName As String

Private pExecPath As String
Private pRuntimeDir As String
Private pFileName As String
Private pDayEnum As String
Private pPeriodEnum As String
Private pBookEnum As String
Private pNewBookPath As String

Private pCurrentSheetSource As Variant
Private pCurrentSheetColumns As Variant

Private pQuadRuntimeCacheFile As Object
Private pQuadRuntimeCacheFileName As String
Private pQuadRuntimeCacheFileArray() As String

Private pDefinitionSheetName As String

Private pWindowSettings As Quad_WindowSettings

Private cHomeDir As String
Private cAppDir As String
Private cExecPath  As String
Private cRuntimeDir  As String
Private cBookPath As String
Private cBookName As String
Private cNewBookPath As String
Private cCacheBookName  As String
Private cCacheBookPath  As String
Private cCacheRangeName  As String
Private cTemplateBookPath  As String
Private cTemplateBookName As String
Private cTemplateSheetName  As String
Private cTemplateCellSheetName  As String
Private cScheduleBookPath As String
Private cScheduleBookName As String
Private cAddBookPath As String
Private cAddBookName As String
Private cViewBookPath As String
Private cViewBookName As String
Private cMenuBookPath As String
Private cMenuBookName As String
Private cDefinitionSheetName   As String
Private cDatabasePath  As String
Private cResultFileName  As String
Private cFileName  As String
Private cQuadRuntimeEnum  As String
Private cDayEnum  As String
Private cPeriodEnum  As String
Private cQuadRuntimeCacheFileName  As String
Private cBookEnum As String

' Book -----------------------
Public Property Get Book() As Workbook
    Set Book = pBook
End Property
Public Property Let Book(value As Workbook)
    Set pBook = value
End Property
Public Property Get BookPath() As String
    BookPath = pBookPath
End Property
Public Property Let BookPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "BookPath"
    sConstValue = cBookPath
    
main:
    pBookPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) <> True Then
         err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    End If
    
End Property
Public Property Get BookName() As String
    BookName = pBookName
End Property

Public Property Get NewBookPath() As String
    NewBookPath = pNewBookPath
End Property
Public Property Let NewBookPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "NewBookPath"
    sConstValue = cNewBookPath
    
main:
    pNewBookPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) <> True Then
         err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    End If
    
End Property


Public Property Let BookName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "BookName"
    sConstValue = cBookName

main:

    pBookName = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If Me.BookPath = "" Then
         err.Raise ErrorMsgType.DEPENDENT_ATTR_NOT_SET, Description:="BookPath needs to be set before BookName"
    End If
    
    If FileExists(Me.BookPath & "\\" & pBookName) = False Then
        err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="BookName file does not exist [" & value & "]"
    End If
    
    Me.Book = OpenBook(pBookName, sPath:=Me.BookPath)
    
End Property
'END Book ----------------------


' Cache ----------------------
Public Property Get CacheBook() As Workbook
    Set CacheBook = pCacheBook
End Property
Public Property Let CacheBook(value As Workbook)
    Set pCacheBook = value
End Property

Public Property Get CacheBookPath() As String
    CacheBookPath = pCacheBookPath
End Property
Public Property Let CacheBookPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "CacheBookPath"
    sConstValue = cCacheBookPath
    
    'If DirExists(value) <> True Then
    '     err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    'End If
    
    pCacheBookPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    'If DirExists(value) <> True Then
    '     err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    'End If
    

End Property
Public Property Get CacheBookName() As String
    
    CacheBookName = pCacheBookName
End Property
Public Property Let CacheBookName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "CacheBookName"
    sConstValue = cCacheBookName
    
    'If Me.CacheBookPath = "" Then
    '     err.Raise ErrorMsgType.DEPENDENT_ATTR_NOT_SET, Description:="CacheBookPath needs to be set before CacheBookName"
    'End If
    
    'If FileExists(Me.CacheBookPath & "\\" & value) = False Then
    '    err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="CacheBookName file does not exist [" & value & "]"
    'End If
    pCacheBookName = GetUpdatedValue(sFuncName, sConstValue, value)
    
    'Me.CacheBook = OpenBook(Me.CacheBookName, sPath:=Me.CacheBookPath)
    
End Property
Public Property Get CacheRangeName() As String
    CacheRangeName = pCacheRangeName
End Property
Public Property Let CacheRangeName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "CacheRangeName"
    sConstValue = cCacheRangeName
    
    pCacheRangeName = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If Me.CacheBookName = "" Then
         err.Raise ErrorMsgType.DEPENDENT_ATTR_NOT_SET, Description:="CacheBookName needs to be set before CacheBookRangeName"
    End If
    
    
    
End Property
' END Cache ------------------

' Template ----------------------
Public Property Get TemplateSheet() As Worksheet
    Set TemplateSheet = pTemplateSheet
End Property
Public Property Let TemplateSheet(value As Worksheet)
    Set pTemplateSheet = value
End Property
Public Property Get TemplateCellSheet() As Worksheet
    Set TemplateCellSheet = pTemplateCellSheet
End Property
Public Property Let TemplateCellSheet(value As Worksheet)
    Set pTemplateCellSheet = value
End Property
Public Property Get TemplateBook() As Workbook
    Set TemplateBook = pTemplateBook
End Property
Public Property Let TemplateBook(value As Workbook)
    Set pTemplateBook = value
End Property
Public Property Get TemplateBookPath() As String
    TemplateBookPath = pTemplateBookPath
End Property
Public Property Let TemplateBookPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "TemplateBookPath"
    sConstValue = cTemplateBookPath
    
    pTemplateBookPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) <> True Then
         err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    End If
    

End Property
Public Property Get TemplateBookName() As String
    
    TemplateBookName = pTemplateBookName
End Property
Public Property Let TemplateBookName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "TemplateBookName"
    sConstValue = cTemplateBookName
    
    pTemplateBookName = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If Me.TemplateBookPath = "" Then
         err.Raise ErrorMsgType.DEPENDENT_ATTR_NOT_SET, Description:="TemplateBookPath needs to be set before CacheBookName"
    End If
    
    If FileExists(Me.TemplateBookPath & "\\" & value) = False Then
        err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="TemplateBookName file does not exist [" & value & "]"
    End If
    
    
    Me.TemplateBook = OpenBook(Me.TemplateBookName, sPath:=Me.TemplateBookPath)
    
End Property
Public Property Get TemplateSheetName() As String
    TemplateSheetName = pTemplateSheetName
End Property
Public Property Let TemplateSheetName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "TemplateSheetName"
    sConstValue = cTemplateSheetName
    
    If Me.TemplateBookName = "" Then
         err.Raise ErrorMsgType.DEPENDENT_ATTR_NOT_SET, Description:="TemplateBookName needs to be set before CacheBookRangeName"
    End If
    
    pTemplateSheetName = GetUpdatedValue(sFuncName, sConstValue, value)
    
    Me.TemplateSheet = GetSheet(Me.TemplateBook, TemplateSheetName)
    
End Property
Public Property Get TemplateCellSheetName() As String
    TemplateCellSheetName = pTemplateCellSheetName
End Property
Public Property Let TemplateCellSheetName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "TemplateCellSheetName"
    sConstValue = cTemplateCellSheetName
    
    If Me.TemplateBookName = "" Then
         err.Raise ErrorMsgType.DEPENDENT_ATTR_NOT_SET, Description:="TemplateBookName needs to be set before CacheBookRangeName"
    End If
    
    pTemplateCellSheetName = GetUpdatedValue(sFuncName, sConstValue, value)
    
    Me.TemplateCellSheet = GetSheet(Me.TemplateBook, TemplateCellSheetName)
    
End Property
' END Template ------------------

' Schedule -----------------------------------------
Public Property Get ScheduleBook() As Workbook
    Set ScheduleBook = pScheduleBook
End Property
Public Property Let ScheduleBook(value As Workbook)
    Set pScheduleBook = value
End Property
Public Property Get ScheduleBookPath() As String
    ScheduleBookPath = pScheduleBookPath
End Property
Public Property Let ScheduleBookPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "ScheduleBookPath"
    sConstValue = cScheduleBookPath
    
    pScheduleBookPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) <> True Then
         err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    End If
    
End Property
Public Property Get ScheduleBookName() As String
    ScheduleBookName = pScheduleBookName
End Property
Public Property Let ScheduleBookName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "ScheduleBookName"
    sConstValue = cScheduleBookName
    
    pScheduleBookName = GetUpdatedValue(sFuncName, sConstValue, value)
End Property
' END schedule -------------------------------------


' View -----------------------------------------
Public Property Get ViewBook() As Workbook
    Set ViewBook = pViewBook
End Property
Public Property Let ViewBook(value As Workbook)
    Set pViewBook = value
End Property
Public Property Get ViewBookPath() As String
    ViewBookPath = pViewBookPath
End Property
Public Property Let ViewBookPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "ViewBookPath"
    sConstValue = cViewBookPath
    
    pViewBookPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) <> True Then
         err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    End If
    
End Property
Public Property Get ViewBookName() As String
    ViewBookName = pViewBookName
End Property
Public Property Let ViewBookName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "ViewBookName"
    sConstValue = cViewBookName
    
    pViewBookName = GetUpdatedValue(sFuncName, sConstValue, value)
End Property
' END View -------------------------------------

' Menu -----------------------------------------
Public Property Get MenuBook() As Workbook
    Set MenuBook = pMenuBook
End Property
Public Property Let MenuBook(value As Workbook)
    Set pMenuBook = value
End Property
Public Property Get MenuBookPath() As String
    MenuBookPath = pMenuBookPath
End Property
Public Property Let MenuBookPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "MenuBookPath"
    sConstValue = cMenuBookPath
    
    pMenuBookPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) <> True Then
         err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    End If
    
End Property
Public Property Get MenuBookName() As String
    
    MenuBookName = pMenuBookName
End Property
Public Property Let MenuBookName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "MenuBookName"
    sConstValue = cMenuBookName
    
    pMenuBookName = GetUpdatedValue(sFuncName, sConstValue, value)
End Property
' END Menu -------------------------------------


' Add -----------------------------------------
Public Property Get AddBook() As Workbook
    Set AddBook = pAddBook
End Property
Public Property Let AddBook(value As Workbook)
    Set pAddBook = value
End Property
Public Property Get AddBookPath() As String
    AddBookPath = pAddBookPath
End Property
Public Property Let AddBookPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "AddBookPath"
    sConstValue = cAddBookPath
    
    pAddBookPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) <> True Then
         err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="workbook [" & value & "] does not exist"
    End If
    
End Property
Public Property Get AddBookName() As String
    
    AddBookName = pAddBookName
End Property
Public Property Let AddBookName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "AddBookName"
    sConstValue = cAddBookName
    
    pAddBookName = GetUpdatedValue(sFuncName, sConstValue, value)
End Property
' END Add -------------------------------------

' misc ---------------------------------------------
Public Property Get BookEnum() As String
    BookEnum = pBookEnum
End Property
Public Property Let BookEnum(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "BookEnum"
    sConstValue = cBookEnum
main:
    pBookEnum = GetUpdatedValue(sFuncName, sConstValue, value)
End Property
Public Property Get DayEnum() As String
    DayEnum = pDayEnum
End Property
Public Property Let DayEnum(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "DayEnum"
    sConstValue = cDayEnum
main:
    pDayEnum = GetUpdatedValue(sFuncName, sConstValue, value)
End Property
Public Property Get PeriodEnum() As String
    PeriodEnum = pPeriodEnum
End Property
Public Property Let PeriodEnum(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "PeriodEnum"
    sConstValue = cPeriodEnum
main:
    pPeriodEnum = GetUpdatedValue(sFuncName, sConstValue, value)
End Property
Public Property Get DefinitionSheetName() As String
    DefinitionSheetName = pDefinitionSheetName
End Property
Public Property Let DefinitionSheetName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "DefinitionSheetName"
    sConstValue = cDefinitionSheetName
    
main:
    pDefinitionSheetName = GetUpdatedValue(sFuncName, sConstValue, value)
End Property
Public Property Get FileName() As String
    FileName = pFileName
End Property
Public Property Let FileName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String
Dim sFuncName As String

setup:
    sFuncName = "FileName"
    sConstValue = cFileName
    
    pFileName = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If FileExists(value) = False Then
        FuncLogIt "Let_FileName", "file currently does not exist to [" & value & "]", C_MODULE_NAME, LogMsgType.INFO
    End If
main:
    
End Property
Public Property Get DatabasePath() As String
    DatabasePath = pDatabasePath
End Property
Public Property Let DatabasePath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String, sTmpValue As String
Dim sFuncName As String

setup:
    sFuncName = "DatabasePath"
    sConstValue = cDatabasePath
    
    pDatabasePath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If Right(pDatabasePath, 6) <> ".sqlite" Then
        sTmpValue = pDatabasePath & ".sqlite"
    End If
    
    If FileExists(sTmpValue) = False Then
        err.Raise ErrorMsgType.BAD_ARGUMENT, Description:="Database file does not exist [" & pDatabasePath & "]"
    End If
main:

End Property
Public Property Get ResultFileName() As String
    ResultFileName = pResultFileName
End Property
Public Property Let ResultFileName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String, sTmpValue As String
Dim sFuncName As String
setup:
    sFuncName = "ResultFileName"
    sConstValue = cResultFileName
    
    pResultFileName = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If FileExists(pResultFileName) = False Then
        FuncLogIt "Let_ResultFileName", "file currently does not exist to [" & value & "]", C_MODULE_NAME, LogMsgType.INFO
    End If
main:
    
End Property
Public Property Get QuadRuntimeCacheFileName() As String
    QuadRuntimeCacheFileName = pQuadRuntimeCacheFileName
End Property
Public Property Let QuadRuntimeCacheFileName(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String, sTmpValue As String
Dim sFuncName As String
setup:
    sFuncName = "QuadRuntimeCacheFileName"
    sConstValue = cQuadRuntimeCacheFileName
main:
    pQuadRuntimeCacheFileName = GetUpdatedValue(sFuncName, sConstValue, value)
    
End Property
Public Property Get QuadRuntimeCacheFile() As Object
    Set QuadRuntimeCacheFile = pQuadRuntimeCacheFile
End Property
Public Property Let QuadRuntimeCacheFile(value As Object)
    Set pQuadRuntimeCacheFile = value
End Property
' END Misc -------------------------------------------

' runtime variables ----------------------------------
Public Property Get CurrentSheetSource() As Variant
    CurrentSheetSource = pCurrentSheetSource
End Property
Public Property Let CurrentSheetSource(value As Variant)
    pCurrentSheetSource = value
End Property
Public Property Get CurrentSheetColumns() As Variant
    CurrentSheetColumns = pCurrentSheetColumns
End Property
Public Property Let CurrentSheetColumns(value As Variant)
    pCurrentSheetColumns = value
End Property
' END runtime variables

' default directories
Public Property Get RuntimeDir() As String
    RuntimeDir = pRuntimeDir
End Property
Public Property Let RuntimeDir(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String, sTmpValue As String
Dim sFuncName As String
setup:
    sFuncName = "RuntimeDir"
    sConstValue = cRuntimeDir
    
    pRuntimeDir = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) = False Then
        FuncLogIt "Let_RuntimeDir", "file currently does not exist to [" & value & "]", C_MODULE_NAME, LogMsgType.INFO
    End If
main:
    

End Property
Public Property Get ExecPath() As String
    ExecPath = pExecPath
End Property
Public Property Let ExecPath(value As String)
Dim sCachedValue As String, sOrigValue As String, sConstValue As String, sTmpValue As String
Dim sFuncName As String
setup:
    sFuncName = "ExecPath"
    sConstValue = cExecPath
    
    pExecPath = GetUpdatedValue(sFuncName, sConstValue, value)
    
    If DirExists(value) = False Then
        FuncLogIt "Let_ExecPath", "file currently does not exist to [" & value & "]", C_MODULE_NAME, LogMsgType.INFO
    End If
main:
    

End Property
' END default directories


Function GetUpdatedValue(sFuncName As String, sConstValue As String, value As String) As Variant
'<<<
' purpose: parses passed value, with default (stored as Const) and any prev update retreived from
'        : from cache to calc current value (cached val > passed arg > default const val)
' param  : sFuncName, String
' param  : sConstValue, String
' param  : Value, String
' returns: value to set member attr to , variant
'>>>
Dim sCachedValue As String, sOrigValue As String

    sCachedValue = RetreiveOverride(sFuncName)
    If sCachedValue <> " " Then
        sOrigValue = value
        value = sCachedValue
        FuncLogIt "Let_" & sFuncName, "retreived value from overide cache file to [" & sCachedValue & "] instead of [" & sOrigValue & "]", C_MODULE_NAME, LogMsgType.INFO
    Else
        If value = "" Then
            'using default value
            value = sConstValue
        ElseIf value <> sConstValue Then
            FuncLogIt "Let_" & sFuncName, "overidden to [" & value & "] default was [" & sConstValue & "]", C_MODULE_NAME, LogMsgType.INFO
            PersistOverride sFuncName, value
        End If
    End If
    
    GetUpdatedValue = value
End Function

Function GetAttrEnum(sAttrName As String) As Integer
    GetAttrEnum = IndexArray(Split(cQuadRuntimeEnum, COMMA), sAttrName)
    If GetAttrEnum = -1 Then
        err.Raise ErrorMsgType.BAD_ENUM, Description:="value [" & sAttrName & "] is not a member of enum [cQuadRuntimeEnum]"
    End If
End Function

Public Property Get QuadRuntimeCacheFileArray() As String()
    QuadRuntimeCacheFileArray = pQuadRuntimeCacheFileArray
End Property
Public Property Let QuadRuntimeCacheFileArray(value() As String)
    pQuadRuntimeCacheFileArray = value
End Property


Sub PersistOverride(sFuncName As String, sValue As String)
Dim iRow As Integer
Dim vCurrentState() As String
Dim sCurrentValue As String

    iRow = GetAttrEnum(sFuncName)
    vCurrentState = ReadFile2Array(Me.QuadRuntimeCacheFileName, bSingleCol:=True)
    sCurrentValue = vCurrentState(iRow)
    vCurrentState(iRow) = sValue
    WriteArray2File vCurrentState, Me.QuadRuntimeCacheFileName

    FuncLogIt "PersistOverride", "updated QuadRuntime persist file [" & Me.QuadRuntimeCacheFileName & "] for [" & sFuncName & "] from [" & sCurrentValue & "] to [" & sValue & "]", C_MODULE_NAME, LogMsgType.INFO

End Sub

'write some tests for this
'then put into each Letter
'then create a rehydrate option for QuadRuntime
'then call rehydrate from validate
Function RetreiveOverride(sFuncName As String) As String
Dim iRow As Integer
Dim vResults() As String

    iRow = GetAttrEnum(sFuncName)
    vResults = Me.QuadRuntimeCacheFileArray
    RetreiveOverride = vResults(iRow)
End Function

Sub InitOveride(Optional bRecover As Boolean = True)
Dim vResults() As String
'purpose: if bRecover is True, parse and store cache file contents, otherwise
'       : initialize; each Let'er will use cached value if not explicitly overidden
    
    If bRecover = False Then
        Me.QuadRuntimeCacheFile = InitFileArray(cQuadRuntimeCacheFileName, 30)
    End If
    
    If FileExists(cQuadRuntimeCacheFileName) = False Then
        Me.QuadRuntimeCacheFile = InitFileArray(cQuadRuntimeCacheFileName, 30)
    Else
        'Me.QuadRuntimeCacheFile = OpenFile(cQuadRuntimeCacheFileName, 8)
    End If

    vResults = ReadFile2Array(cQuadRuntimeCacheFileName, bSingleCol:=True)
    Me.QuadRuntimeCacheFileArray = vResults

End Sub
Public Function IsAQuadRuntime() As Boolean
    IsAQuadRuntime = True
End Function

Sub SetDefaults()
    cHomeDir = GetHomePath
    cAppDir = cHomeDir & "\GitHub\quadviewer\"
    cExecPath = cAppDir & "app\\quad\utils\excel\"
    cRuntimeDir = cHomeDir & "\runtime\"
    cBookPath = cRuntimeDir
    cBookName = "cache.xlsm"
    cCacheBookName = "cache.xlsm"
    cCacheBookPath = cRuntimeDir
    cCacheRangeName = "data"
    cNewBookPath = cRuntimeDir & "archive\"
    
    cTemplateBookPath = cAppDir
    cTemplateBookName = "vba_source_new.xlsm"

    cTemplateSheetName = "FormStyles"
    cTemplateCellSheetName = "CellStyles"
    
    cScheduleBookPath = cRuntimeDir
    cScheduleBookName = "schedule.xlsm"
    
    cMenuBookPath = cRuntimeDir
    cMenuBookName = "menu.xlsm"
    
    cAddBookPath = cRuntimeDir
    cAddBookName = "add.xlsm"
    
    cViewBookPath = cRuntimeDir
    cViewBookName = "view.xlsm"
    
    cDefinitionSheetName = "Definitions"
    cDatabasePath = cAppDir & "app\quad\utils\excel\test_misc\QuadQA.db"
    cResultFileName = cRuntimeDir & "pyshell_results.txt"
    cFileName = cRuntimeDir & "uupyshell.args.txt"
    cQuadRuntimeEnum = "BookPath,BookName,CacheBookName,CacheBookPath,CacheRangeName,TemplateBookPath,TemplateBookName,TemplateSheetName,TemplateCellSheetName,DatabasePath,ResultFileName,ExecPath,RuntimeDir,FileName,DayEnum,PeriodEnum,CurrentSheetSource,CurrentSheetColumns,QuadRuntimeCacheFileName,DefinitionSheetName,ScheduleBookPath,ScheduleBookName,AddBookPath,AddBookName,MenuBookPath,MenuBookName,ViewBookPath,ViewBookName,BookEnum,NewBookPath"
    cDayEnum = "M,T,W,R,F"
    cPeriodEnum = "1,2,3,4,5,6,7,8,9,10,11"
    cQuadRuntimeCacheFileName = cHomeDir & "\quad_runtime_cache.txt"
    cBookEnum = Join(Array(cCacheBookName, cScheduleBookName, cMenuBookName, cAddBookName, cViewBookName), COMMA)
    
End Sub

Sub SetWindows()
Dim vWindowNames As Variant, vWindow As Variant
Dim vWindowCol1() As String, vWindowCol2() As String
Dim winsetTmp As Quad_WindowSettings
Dim dWindows As New Dictionary
Dim sBookName As Variant

    ReDim vWindowCol1(0 To 1)
    ReDim vWindowCol2(0 To 1)
    ReDim vWindow(0 To 1)
    
    vWindowNames = Array(Me.BookName, Me.ScheduleBookName, Me.CacheBookName, Me.AddBookName)
    
    For Each sBookName In vWindowNames
        Set winsetTmp = New Quad_WindowSettings
        winsetTmp.InitProperties
        If dWindows.Exists(sBookName) = False Then
            dWindows.Add sBookName, winsetTmp
        End If
    Next sBookName
    
    vWindowCol1(0) = Me.BookName
    vWindowCol1(1) = Me.ScheduleBookName
    vWindowCol2(0) = Me.CacheBookName
    vWindowCol2(1) = Me.AddBookName
    vWindow(0) = vWindowCol1 'row 1
    vWindow(1) = vWindowCol2 'row 1
    
    SetWindowScheme dWindows, vWindow
End Sub
    
Public Sub InitProperties( _
                 Optional sBookPath As String, _
                 Optional sBookName As String, _
                 Optional sCacheBookPath As String, _
                 Optional sCacheBookName As String, _
                 Optional sCacheRangeName As String, _
                 Optional sTemplateBookPath As String, Optional sTemplateBookName As String, _
                 Optional sTemplateSheetName As String, Optional sTemplateCellSheetName As String, _
                 Optional sScheduleBookPath As String, Optional sScheduleBookName As String, _
                 Optional sMenuBookPath As String, Optional sMenuBookName As String, _
                 Optional sAddBookPath As String, Optional sAddBookName As String, _
                 Optional sViewBookPath As String, Optional sViewBookName As String, _
                 Optional sNewBookPath As String, Optional sDatabasePath As String, _
                 Optional sResultFileName As String, Optional sExecPath As String, Optional sRuntimeDir As String, _
                 Optional sFileName As String, Optional sDayEnum As String, Optional sPeriodEnum As String, _
                 Optional sBookEnum As String, _
                 Optional sDefinitionSheetName As String, Optional sQuadRuntimeCacheFileName As String, _
                 Optional bInitializeCache As Boolean = True, _
                 Optional bInitializeOveride As Boolean = True, _
                 Optional bHydrateFromCache As Boolean = False, _
                 Optional bSetWindows = False)

    FuncLogIt "Quad_Runtime.InitProperties", "", C_MODULE_NAME, LogMsgType.INFUNC
    
    SetDefaults
    
    If bInitializeOveride = True Then
        Me.InitOveride
    End If
    
    Me.QuadRuntimeCacheFileName = sQuadRuntimeCacheFileName
    
    Me.CacheBookPath = sCacheBookPath
    Me.CacheBookName = sCacheBookName
    Me.CacheRangeName = sCacheRangeName
    Me.ScheduleBookPath = sScheduleBookPath
    Me.ScheduleBookName = sScheduleBookName
    Me.AddBookPath = sAddBookPath
    Me.AddBookName = sAddBookName
    Me.MenuBookPath = cMenuBookPath
    Me.MenuBookName = cMenuBookName
    Me.ViewBookName = cViewBookName
    Me.ViewBookPath = cViewBookPath
    
    Me.BookEnum = sBookEnum
    Me.RuntimeDir = sRuntimeDir

    Me.NewBookPath = sNewBookPath
    
    If bInitializeCache = True Then
        Me.OpenBooks
    Else
        If BookExists(Me.CacheBookPath & "\" & Me.CacheBookName) = False Then
            Me.OpenBooks
        End If
    End If
    
    Me.CacheBook = OpenBook(Me.CacheBookName, sPath:=Me.CacheBookPath)
    Me.ScheduleBook = OpenBook(Me.ScheduleBookName, sPath:=Me.ScheduleBookPath)
    Me.AddBook = OpenBook(Me.AddBookName, sPath:=Me.AddBookPath)
    Me.MenuBook = OpenBook(Me.MenuBookName, sPath:=Me.MenuBookPath)
    Me.ViewBook = OpenBook(Me.ViewBookName, sPath:=Me.ViewBookPath)
    
    Me.BookPath = sBookPath
    Me.BookName = sBookName

    Me.TemplateBookPath = sTemplateBookPath
    Me.TemplateBookName = sTemplateBookName
    Me.TemplateSheetName = sTemplateSheetName
    Me.TemplateCellSheetName = sTemplateCellSheetName
    
    Me.DefinitionSheetName = sDefinitionSheetName
    
    Me.DatabasePath = sDatabasePath
    Me.ResultFileName = sResultFileName
    Me.ExecPath = sExecPath

    Me.FileName = sFileName
    Me.DayEnum = sDayEnum
    Me.PeriodEnum = sPeriodEnum

    If bSetWindows = True Then
        SetWindows
    End If
    
    ' added on 4/17/18 to get dynamic menus to work
    Me.TemplateBook.Activate

End Sub

Public Sub CloseRuntimeCacheFile()
Dim oFile As Object
    Set oFile = Me.QuadRuntimeCacheFile
    On Error Resume Next
    oFile.Close
    On Error GoTo 0
End Sub
Public Sub CleanUpTmpBooks()
Dim sBook As Variant
Dim wbTmp As Workbook
Dim sBookName As String, sBookPath As String

    For Each sBook In Split(Me.BookEnum, COMMA)
        sBook = Split(sBook, PERIOD)(0)
        sBook = UCase(Left(sBook, 1)) & Right(sBook, Len(sBook) - 1)
        Set wbTmp = CallByName(Me, sBook & "Book", VbGet)
        CloseBook wbTmp
        sBookName = CallByName(Me, sBook & "BookName", VbGet)
        sBookPath = CallByName(Me, sBook & "BookPath", VbGet)
        DeleteBook sBookName, sBookPath
    Next sBook
    
End Sub
Public Sub Delete()
    Me.CloseRuntimeCacheFile
    DeleteFile Me.QuadRuntimeCacheFileName
    Me.CleanUpTmpBooks
End Sub
Public Sub OpenBooks()
Dim sBook As Variant
    For Each sBook In Split(Me.BookEnum, COMMA)
        sBook = Split(sBook, PERIOD)(0)
        sBook = UCase(Left(sBook, 1)) & Right(sBook, Len(sBook) - 1)
        FileCopy CallByName(Me, sBook & "BookName", VbGet), CallByName(Me, "NewBookPath", VbGet), Me.RuntimeDir
    Next sBook
End Sub


