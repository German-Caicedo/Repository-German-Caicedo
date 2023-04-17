Attribute VB_Name = "Módulo1"
Sub EJERCICIO()
' This subroutine analyzes the content of cells in the worksheet and categorizes them based on their type (string, integer, decimal) and sign (positive, negative)
Dim Z As String ' Z stores the cell value
Dim fila As Integer ' fila stores the row number in the worksheet
Dim columna As Integer ' columna stores the column number in the worksheet
fila = 5
columna = 4

' Get the cell value from the specified row and column
Z = Cells(fila, columna)

' Loop through the rows from 5 to 25 (inclusive) and analyze the content of the cell at the specified column
Do
    If Cells(fila, columna) = "" Then ' Check if the cell is empty
        Cells(fila, columna + 1) = "vacío"
    ElseIf Not IsNumeric(Cells(fila, columna)) Then ' Check if the cell contains a string
        Cells(fila, columna + 1) = "STRING"
    ElseIf Cells(fila, columna) = Int(Cells(fila, columna)) And Cells(fila, columna) > 0 Then ' Check if the cell contains a positive integer
        Cells(fila, columna + 1) = "entero,positivo"
    ElseIf Cells(fila, columna) = Int(Cells(fila, columna)) And Cells(fila, columna) < 0 Then ' Check if the cell contains a negative integer
        Cells(fila, columna + 1) = "entero,negativo"
    ElseIf Cells(fila, columna) <> Int(Cells(fila, columna)) And Cells(fila, columna) > 0 Then ' Check if the cell contains a positive decimal
        Cells(fila, columna + 1) = "decimal,positivo"
    ElseIf Cells(fila, columna) <> Int(Cells(fila, columna)) And Cells(fila, columna) < 0 Then ' Check if the cell contains a negative decimal
        Cells(fila, columna + 1) = "decimal,negativo"
    Else
    End If
    fila = fila + 1 ' Move to the next row
Loop Until fila = 26 And columna = 4 ' Continue looping until the 26th row is reached
End Sub 