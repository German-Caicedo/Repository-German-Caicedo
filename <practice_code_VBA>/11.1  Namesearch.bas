Attribute VB_Name = "Módulo1"
Sub maria3()
' This subroutine filters cells containing the text "MARIA" and copies them into the adjacent column
Dim f As Integer ' f stores the row number in the worksheet
Dim c As Integer ' c stores the column number in the worksheet
Dim x(100) As String ' x is an array to store cell values
Dim i As Integer ' i is a counter variable for loops
Dim y() As String ' y is an array to store filtered cell values

f = ActiveCell.Row ' Get the active cell's row
c = ActiveCell.Column ' Get the active cell's column

' Clear the content of the column to the right of the active cell
Columns(c + 1).Clear
i = 0

' Assign cell values to the x array
Do
    x(i) = Cells(f, c)
    f = f + 1
    i = i + 1
Loop Until Cells(f, c) = ""

' Filter the x array to get cells containing the name "MARIA"
f = ActiveCell.Row ' Reset the row number to the active cell's row

y = Filter(x, "MARIA", True, vbTextCompare) ' Filter the x array and store the result in y array

' Copy the filtered cell values (from y array) to the adjacent column in the worksheet
For i = 0 To UBound(y) Step 1
    Cells(f, c + 1) = y(i)
    f = f + 1
Next i
End Sub