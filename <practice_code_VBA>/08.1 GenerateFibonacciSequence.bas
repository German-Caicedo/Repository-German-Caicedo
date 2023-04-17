Attribute VB_Name = "Módulo1"
Sub fobonacci()
' Declare variables
Dim n As Integer ' n stores the current number in the Fibonacci sequence
Dim fila As Integer ' fila stores the row number in the worksheet
Dim columna As Integer ' columna stores the column number in the worksheet
' Clear the content of all cells in the active sheet
Cells.Clear

' Initialize the row and column numbers
fila = 4
columna = 3

' Initialize the first number in the Fibonacci sequence
n = 1

' Calculate the Fibonacci sequence until a number greater than 56 is reached
Do
    ' Write the current number in the Fibonacci sequence to the cell with row fila and column columna
    Cells(fila, columna) = n

    ' Update the current number in the Fibonacci sequence by adding the number in the cell above it
    n = n + Cells(fila - 1, columna)

    ' Move to the next row
    fila = fila + 1

Loop Until n > 56 ' Continue the loop until the current number in the Fibonacci sequence is greater than 56
End Sub
