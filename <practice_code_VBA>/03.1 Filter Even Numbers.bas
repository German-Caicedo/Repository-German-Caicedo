Attribute VB_Name = "Módulo1"
Sub PARES()
' Declare variables
Dim F As Integer ' F stores the row number of the active cell
Dim C As Integer ' C stores the column number of the active cell
Dim Z As Integer ' Z stores the value of a cell
' Get the row and column of the active cell
F = ActiveCell.Row
C = ActiveCell.Column

' Loop through the cells in the same column until an empty cell is found
Do While Not IsEmpty(Cells(F, C))
    ' Get the value of the current cell
    Z = Cells(F, C)

    ' Check if the value is an even number
    If Z Mod 2 = 0 Then
        ' If the value is even, copy it to the cell in the same row and the next column
        Cells(F, C + 1) = Z
    End If

    ' Move to the next row
    F = F + 1
Loop

' Store the row number of the last non-empty cell
Dim lastRow As Integer
lastRow = F - 1

' Reset F to the row number of the active cell
F = ActiveCell.Row

' Declare a variable to store the destination row number
Dim destRow As Integer
destRow = F

' Loop through the rows from the active cell to the last non-empty cell
For i = F To lastRow
    ' Check if the cell in the next column is not empty
    If Not IsEmpty(Cells(i, C + 1)) Then
        ' If the current row number is not equal to the destination row number
        If i <> destRow Then
            ' Move the even number to the destination row in the next column
            Cells(destRow, C + 1) = Cells(i, C + 1)

            ' Clear the contents of the original cell
            Cells(i, C + 1).ClearContents
        End If

        ' Increment the destination row number
        destRow = destRow + 1
    End If
Next i
End Sub