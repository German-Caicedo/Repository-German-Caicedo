Attribute VB_Name = "Módulo1"
Sub numeros()
' This subroutine generates a list of consecutive numbers from 1 to 10, excluding 3, 4, and 5
Dim FILA As Integer ' FILA stores the current row number in the loop
Dim COLUMNA As Integer ' COLUMNA stores the current column number
Dim NUMERO As Integer ' NUMERO stores the current number in the loop

Cells.Clear ' Clear the sheet
Range("b2") = "SUBRUTINA PARA COLOCAR NUMEROS CONSECUTIVOS DEL 1 AL 10, EXCLUYENDO 3, 4, Y 5"

' Initialize the loop to generate numbers from 1 to 10, excluding 3, 4, and 5
NUMERO = 1
FILA = ActiveCell.Row ' Get the active cell's row number
COLUMNA = ActiveCell.Column ' Get the active cell's column number

' Loop through numbers from 1 to 10
For NUMERO = 1 To 10
    ' Check if the current number is not 3, 4, or 5
    If NUMERO <> 3 And NUMERO <> 4 And NUMERO <> 5 Then
        Cells(FILA, COLUMNA) = NUMERO ' Write the number in the current cell
        FILA = FILA + 1 ' Increment the row number
    End If
Next NUMERO

' Display the last row number in cell A1
Range("A1") = "FILA=" & FILA
End Sub