Attribute VB_Name = "Quad_Schedule_Update"
Option Explicit

Const C_MODULE_NAME = "Quad_Schedule_Update"

Public Sub UpdateListViewScheduleLessonForm(ParamArray args())

setup:
    ChDir "C:\Users\burtnolej\Documents\runtime"
    sFuncName = C_MODULE_NAME & "." & "UpdateListViewScheduleLessonForm"

main:
    Set clsAppRuntime = args(0)
    sValue = args(1)
    sLookUpIdRangeName = args(2)
    
    AddArgs dArgs, False, "clsAppRuntime", clsAppRuntime, "iStudentID", CInt(sValue)
    Application.Run C_GENERATE_SCHEDULE_LESSON_LIST_VIEW, dArgs
    
cleanup:
    FuncLogIt sFuncName, "[sValue=" & sValue & "] [sLookUpIdRangeName=" & sLookUpIdRangeName & "]", C_MODULE_NAME, LogMsgType.DEBUGGING
    FuncLogIt sFuncName, "", C_MODULE_NAME, LogMsgType.OUTFUNC, lLastTick:=lStartTick

End Sub

Public Sub UpdateViewStudentScheduleForm(ParamArray args())
'<<<
'purpose:
'param  :
'       :
'param  :
'rtype  :
'>>>
Dim clsAppRuntime As App_Runtime
Dim lStartTick As Long
Dim eWidgetType As WidgetType
Dim eFormType As FormType
Dim sSubDataType As String, sView As String, sFuncName As String, sValue As String, sLookUpIdRangeName As String, sTableName As String

setup:
    sFuncName = C_MODULE_NAME & "." & "UpdateViewStudentScheduleForm"
    lStartTick = FuncLogIt(sFuncName, "", C_MODULE_NAME, LogMsgType.INFUNC)
    
main:
    Set clsAppRuntime = args(0)
    sValue = args(1)
    sLookUpIdRangeName = args(2)
    
    
    'its an update Student view function
    sSubDataType = "Student"
    eWidgetType = WidgetType.Text
    'its an update view function
    eFormType = FormType.ViewList
    
    'UpdateForm clsAppRuntime, sValue, sLookUpIdRangeName, sSubDataType, eWidgetType, eFormType

cleanup:
    FuncLogIt sFuncName, "[sValue=" & sValue & "] [sLookUpIdRangeName=" & sLookUpIdRangeName & "]", C_MODULE_NAME, LogMsgType.DEBUGGING
    FuncLogIt sFuncName, "", C_MODULE_NAME, LogMsgType.OUTFUNC, lLastTick:=lStartTick


End Sub
