'This script is used to change the connection of tables ODBC-linked
Attribute VB_Name = "modRefreshODBCLinks"
Option Compare Database

Public Sub RefreshODBCLinks(newConnectionString As String)
    Dim db As DAO.Database
    Dim tb As DAO.TableDef
    Dim originalname, tempname, sourcename As String
    Dim i, count As Integer

    Set db = CurrentDb
    ' Get a list of all ODBC tables '
    Dim tables As New Collection
    For Each tb In db.TableDefs
        If (Left(tb.Connect, 4) = "ODBC") Then
            tables.Add Item:=tb.NAME, Key:=tb.NAME
        End If
    Next tb

    ' Create new tables using the given DSN after moving the old ones '
    count = tables.count
    For i = count To 1 Step -1
            originalname = tables(i)
            tempname = "~" & originalname & "~"
            sourcename = db.TableDefs(originalname).SourceTableName
            Debug.Print sourcename, tempname, originalname
            
            ' Create the replacement table '
            db.TableDefs(originalname).NAME = tempname
            
            Set tb = db.CreateTableDef(originalname)
            tb.SourceTableName = sourcename
            tb.Connect = newConnectionString
            
            On Error Resume Next
            db.TableDefs.Append tb
            db.TableDefs.Refresh
            
            ' delete the old table '
            DoCmd.DeleteObject acTable, tempname
            db.TableDefs.Refresh
            tables.Remove originalname
            Debug.Print "Refreshed ODBC table " & originalname
            
    Next i
    db.Close
    Set db = Nothing
End Sub

