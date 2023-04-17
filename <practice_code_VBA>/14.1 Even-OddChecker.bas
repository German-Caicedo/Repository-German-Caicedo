Attribute VB_Name = "Módulo2"
Sub lista()
' This subroutine checks if the numbers in a column are even or odd and writes the result in the adjacent column
Dim z As Integer ' z stores the value of the current cell in the loop
Dim FILA As Integer ' FILA stores the current row number in the loop
Dim COLUMNA As Integer ' COLUMNA stores the current column number

FILA = ActiveCell.Row ' Get the active cell's row number
COLUMNA = ActiveCell.Column ' Get the active cell's column number

' Loop through the rows until an empty cell is found in the previous column
Do Until Cells(FILA, COLUMNA - 1) = ""
    z = Cells(FILA, COLUMNA - 1) ' Get the value of the cell in the previous column

    ' Check if the value is zero, even, or odd, and write the result in the current cell
    If z = 0 Then
        Cells(FILA, COLUMNA) = ""
    ElseIf z Mod 2 = 0 Then
        Cells(FILA, COLUMNA) = "PAR"
    Else
        Cells(FILA, COLUMNA) = "IMPAR"
    End If

    FILA = FILA + 1 ' Increment the row number
Loop
End Sub