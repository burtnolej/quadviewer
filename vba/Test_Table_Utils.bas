Attribute VB_Name = "Test_Table_Utils"
Option Explicit
Const CsModuleName = "Test_Table_Utils"
Function TestAddTableRecordManual() As TestResult
' From a definition, create entry forms, fill out values for a record, manually call function
' to add the single record (dont validate and use button) and then retreive the record
Dim sFuncName As String
Dim sSheetName As String
Dim sResultStr As String
Dim sExpectedResultStr As String
Dim vSource() As String
Dim wsTmp As Worksheet
Dim rTarget As Range
Dim dDefinitions As Dictionary
Dim dRecord As Dictionary
Dim eTestResult As TestResult
setup:

    sFuncName = CsModuleName & "." & "AddTableRecordManual"
    sSheetName = "test"
    Set wsTmp = CreateSheet(ActiveWorkbook, sSheetName, bOverwrite:=True)
    vSource = Init2DStringArray([{"NewFoo","Foo","FooName","List","IsMember";"NewFoo","Foo","FooAge","Integer","IsValidInteger";"NewBar","Bar","BarName","List","IsMember";"NewBar","Bar","BarAge","Integer","IsValidInteger"}])
    Set rTarget = RangeFromStrArray(vSource, wsTmp, 0, 1)

main:

    Set Entry_Utils.dDefinitions = LoadDefinitions(wsTmp, rSource:=rTarget)
    CreateTables
    GenerateEntryForms
    
    SetEntryValue "NewFoo", "FooAge", 123
    SetEntryValue "NewFoo", "FooName", "blahblah"
    
    AddTableRecord "Foo"
    
    Set dRecord = GetTableRecord("Foo", 1)
    
    If dRecord.Exists("FooAge") = False Then
         eTestResult = TestResult.Failure
         GoTo teardown
    End If

    If dRecord.Exists("FooName") = False Then
         eTestResult = TestResult.Failure
         GoTo teardown
    End If
    
    If dRecord.Item("FooName") <> "blahblah" Then
         eTestResult = TestResult.Failure
         GoTo teardown
    End If
    
    If dRecord.Item("FooAge") <> "123" Then
        eTestResult = TestResult.Failure
    Else
        eTestResult = TestResult.OK
    End If
    On Error GoTo 0
    GoTo teardown
    
err:
    eTestResult = TestResult.Error
    
teardown:
    TestAddTableRecordManual = eTestResult
    DeleteSheet ActiveWorkbook, sSheetName
    DeleteSheet ActiveWorkbook, "Foo"
    DeleteSheet ActiveWorkbook, "Bar"
    DeleteEntryForms

End Function


Function TestCreateTables() As TestResult
Dim sFuncName As String
Dim sSheetName As String
Dim sResultStr As String
Dim sExpectedResultStr As String
Dim vSource() As String
Dim wsTmp As Worksheet
Dim rTarget As Range
Dim dDefinitions As Dictionary
Dim dDefnDetails As Dictionary
Dim eTestResult As TestResult
setup:

    sFuncName = CsModuleName & "." & "CreateTables"
    sSheetName = "test"
    Set wsTmp = CreateSheet(ActiveWorkbook, sSheetName, bOverwrite:=True)
    vSource = Init2DStringArray([{"NewFoo","Foo","FooName","List","IsMember";"NewFoo","Foo","FooAge","Integer","IsValidInteger";"NewBar","Bar","BarName","List","IsMember";"NewBar","Bar","BarAge","Integer","IsValidInteger"}])
    Set rTarget = RangeFromStrArray(vSource, wsTmp, 0, 1)

main:

    Set Entry_Utils.dDefinitions = LoadDefinitions(wsTmp, rSource:=rTarget)
  
    CreateTables
    
    If SheetExists(ActiveWorkbook, "foo") = False Then
         eTestResult = TestResult.Failure
         GoTo teardown
    End If
    
    If SheetExists(ActiveWorkbook, "bar") = False Then
         eTestResult = TestResult.Failure
         GoTo teardown
    End If
    
    If NamedRangeExists(ActiveWorkbook, "foo", "dbFooFooAge") = False Then
         eTestResult = TestResult.Failure
         GoTo teardown
    End If
    
    If NamedRangeExists(ActiveWorkbook, "bar", "dbBarBarName") = False Then
         eTestResult = TestResult.Failure
         GoTo teardown
    End If
    
    If NamedRangeExists(ActiveWorkbook, "bar", "iBarNextFree") = False Then
        eTestResult = TestResult.Failure
    Else
        eTestResult = TestResult.OK
    End If
    On Error GoTo 0
    GoTo teardown
    
err:
    eTestResult = TestResult.Error
    
teardown:
    TestCreateTables = eTestResult
    DeleteSheet ActiveWorkbook, sSheetName
    DeleteSheet ActiveWorkbook, "foo"
    DeleteSheet ActiveWorkbook, "bar"

End Function


Function TestAddTableMultipleRecordManual() As TestResult
' From a definition, create entry forms, fill out values for a record, manually call function
' to add the single record (dont validate and use button) and then retreive the record
Dim sFuncName As String
Dim sSheetName As String
Dim sResultStr As String
Dim sExpectedResultStr As String
Dim vSource() As String
Dim wsTmp As Worksheet
Dim rTarget As Range
Dim dDefinitions As Dictionary
Dim dRecord As Dictionary
Dim eTestResult As TestResult
setup:

    sFuncName = CsModuleName & "." & "TestAddTableMultipleRecordManual"
    sSheetName = "test"
    Set wsTmp = CreateSheet(ActiveWorkbook, sSheetName, bOverwrite:=True)
    vSource = Init2DStringArray([{"NewFoo","Foo","FooName","List","IsMember";"NewFoo","Foo","FooAge","Integer","IsValidInteger";"NewBar","Bar","BarName","List","IsMember";"NewBar","Bar","BarAge","Integer","IsValidInteger"}])
    Set rTarget = RangeFromStrArray(vSource, wsTmp, 0, 1)

main:

    Set Entry_Utils.dDefinitions = LoadDefinitions(wsTmp, rSource:=rTarget)
    CreateTables
    GenerateEntryForms
    
    SetEntryValue "NewFoo", "FooAge", 123
    SetEntryValue "NewFoo", "FooName", "blahblah"
    
    AddTableRecord "Foo"
    
    SetEntryValue "NewFoo", "FooAge", 666
    SetEntryValue "NewFoo", "FooName", "foofoo"
    
    AddTableRecord "Foo"
    
    SetEntryValue "NewFoo", "FooAge", 444
    SetEntryValue "NewFoo", "FooName", "barbar"
    
    AddTableRecord "Foo"
    
    Set dRecord = GetTableRecord("Foo", 1)
    
    If dRecord.Exists("FooAge") = False Then
        eTestResult = TestResult.Failure
        GoTo teardown
    End If

    If dRecord.Item("FooAge") <> 123 Then
        eTestResult = TestResult.Failure
        GoTo teardown
    End If
    
    Set dRecord = GetTableRecord("Foo", 2)
    
    If dRecord.Exists("FooAge") = False Then
        eTestResult = TestResult.Failure
        GoTo teardown
    End If

    If dRecord.Item("FooAge") <> 666 Then
        eTestResult = TestResult.Failure
        GoTo teardown
    End If
    
    Set dRecord = GetTableRecord("Foo", 3)
    
    If dRecord.Exists("FooAge") = False Then
        eTestResult = TestResult.Failure
        GoTo teardown
    End If

    If dRecord.Item("FooAge") <> 444 Then
        eTestResult = TestResult.Failure
    Else
        eTestResult = TestResult.OK
    End If
    On Error GoTo 0
    GoTo teardown
    
err:
    eTestResult = TestResult.Error
    
teardown:
    TestAddTableMultipleRecordManual = eTestResult
    DeleteSheet ActiveWorkbook, sSheetName
    DeleteSheet ActiveWorkbook, "Foo"
    DeleteSheet ActiveWorkbook, "Bar"
    DeleteEntryForms

End Function

Function TestAddTableMultipleRecordMultiTableManual() As TestResult
' From a definition, create entry forms, fill out values for a record, manually call function
' to add the single record (dont validate and use button) and then retreive the record
Dim sFuncName As String
Dim sSheetName As String
Dim sResultStr As String
Dim sExpectedResultStr As String
Dim vSource() As String
Dim wsTmp As Worksheet
Dim rTarget As Range
Dim dDefinitions As Dictionary
Dim dRecord As Dictionary
Dim eTestResult As TestResult
setup:

    sFuncName = CsModuleName & "." & "TestAddTableMultipleRecordMultiTableManual"
    sSheetName = "test"
    Set wsTmp = CreateSheet(ActiveWorkbook, sSheetName, bOverwrite:=True)
    vSource = Init2DStringArray([{"NewFoo","Foo","FooName","List","IsMember";"NewFoo","Foo","FooAge","Integer","IsValidInteger";"NewBar","Bar","BarName","List","IsMember";"NewBar","Bar","BarAge","Integer","IsValidInteger"}])
    Set rTarget = RangeFromStrArray(vSource, wsTmp, 0, 1)

main:

    Set Entry_Utils.dDefinitions = LoadDefinitions(wsTmp, rSource:=rTarget)
    CreateTables
    GenerateEntryForms
    
    ' Table Foo
    SetEntryValue "NewFoo", "FooAge", 123
    SetEntryValue "NewFoo", "FooName", "blahblah"
    
    AddTableRecord "Foo"
    
    SetEntryValue "NewFoo", "FooAge", 666
    SetEntryValue "NewFoo", "FooName", "foofoo"
    
    AddTableRecord "Foo"
    
    SetEntryValue "NewFoo", "FooAge", 444
    SetEntryValue "NewFoo", "FooName", "barbar"
    
    AddTableRecord "Foo"
    
    ' Table Bar
    SetEntryValue "NewBar", "BarAge", 123
    SetEntryValue "NewBar", "BarName", "blahblah"
    
    AddTableRecord "Bar"
    
    SetEntryValue "NewBar", "BarAge", 666
    SetEntryValue "NewBar", "BarName", "foofoo"
    
    AddTableRecord "Bar"
    
    SetEntryValue "NewBar", "BarAge", 444
    SetEntryValue "NewBar", "BarName", "barbar"
    
    AddTableRecord "Bar"
    
    Set dRecord = GetTableRecord("Foo", 3)
    
    If dRecord.Exists("FooAge") = False Then
        eTestResult = TestResult.Failure
        GoTo teardown
    End If

    If dRecord.Item("FooAge") <> 444 Then
        eTestResult = TestResult.Failure
        GoTo teardown
    End If
    
    Set dRecord = GetTableRecord("Bar", 3)
    
    If dRecord.Exists("BarAge") = False Then
        eTestResult = TestResult.Failure
        GoTo teardown
    End If

    If dRecord.Item("BarAge") <> 444 Then
        eTestResult = TestResult.Failure
    Else
        eTestResult = TestResult.OK
    End If
    On Error GoTo 0
    GoTo teardown
    
err:
    eTestResult = TestResult.Error
    
teardown:
    TestAddTableMultipleRecordMultiTableManual = eTestResult
    DeleteSheet ActiveWorkbook, sSheetName
    DeleteSheet ActiveWorkbook, "Foo"
    DeleteSheet ActiveWorkbook, "Bar"
    DeleteEntryForms

End Function

Function TestAddTableRecordFail() As TestResult
Dim sFuncName As String
Dim sSheetName As String
Dim sResultStr As String
Dim sExpectedResultStr As String
Dim vSource() As String
Dim wsTmp As Worksheet
Dim rTarget As Range
Dim dDefinitions As Dictionary
Dim dRecord As Dictionary
Dim eTestResult As TestResult
Dim iResultCode As Integer

setup:

    sFuncName = CsModuleName & "." & "AddTableRecordFail"
    sSheetName = "test"
    Set wsTmp = CreateSheet(ActiveWorkbook, sSheetName, bOverwrite:=True)
    vSource = Init2DStringArray([{"NewFoo","Foo","FooName","List","IsMember";"NewFoo","Foo","FooAge","Integer","IsValidInteger";"NewBar","Bar","BarName","List","IsMember";"NewBar","Bar","BarAge","Integer","IsValidInteger"}])
    Set rTarget = RangeFromStrArray(vSource, wsTmp, 0, 1)

main:

    Set Entry_Utils.dDefinitions = LoadDefinitions(wsTmp, rSource:=rTarget)
    CreateTables
    GenerateEntryForms
    
    iResultCode = SetEntryValue("NewFoo", "BadFieldName", 123)
    
    If iResultCode <> -1 Then
        eTestResult = TestResult.Failure
    Else
        eTestResult = TestResult.OK
    End If
    On Error GoTo 0
    GoTo teardown
    
err:
    eTestResult = TestResult.Error
    
teardown:
    TestAddTableRecordFail = eTestResult
    
    DeleteSheet ActiveWorkbook, sSheetName
    DeleteSheet ActiveWorkbook, "Foo"
    DeleteSheet ActiveWorkbook, "Bar"
    DeleteEntryForms

End Function


