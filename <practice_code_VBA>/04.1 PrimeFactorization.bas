Attribute VB_Name = "Módulo1"
Sub factores()
Dim z As String ' z stores the input number from the user
Dim fila As Integer ' fila stores the row number for displaying factors
Dim a As Integer ' a is used to iterate through the factors
' Clear the content of all cells in the active sheet
Cells.Clear

' Loop until a valid input is entered
Do
    ' Display an input box to get a number from the user
    z = InputBox("ingrese un valor entero y positivo menor que cien", "numero", 28)

    ' Check if the input is empty
    If z = "" Then
        MsgBox "ingrese un numero"
    ' Check if the input contains a decimal point
    ElseIf InStr(z, ".") <> 0 Then
        MsgBox "error no se acepta punto en el dato"
    ' Check if the input is not a numeric value
    ElseIf Not IsNumeric(z) Then
        MsgBox "ingrese un valor numerico"
    ' Check if the input is not an integer
    ElseIf Not Int(z) = z Then
        MsgBox "el dato no es entero"
    ' Check if the input is not within the specified range
    ElseIf z < 1 Or z >= 100 Then
        MsgBox "el dato no esta en el rango establecido"
    Else
        ' If the input is valid, display the number in cell C5 and labels in C4 and C6
        Range("c5") = z
        Range("c4") = "numero"
        Range("c6") = "factores"
    End If
Loop Until Range("c5") = z And z <> ""

' Get factors of the input number
fila = 7
a = 1

' Populate the cells in column C with numbers from 1 to z
Do
    Cells(fila, 3) = a
    a = a + 1
    fila = fila + 1
Loop Until a > z

' Reset fila to the starting row
fila = 7

' Check if the number in the cell is a factor of z
Do
    If (z) / (Cells(fila, 3)) = Int(z / (Cells(fila, 3))) Then
        ' If the number is a factor, move to the next row
        fila = fila + 1
    Else
        ' If the number is not a factor, delete the cell content
        Cells(fila, 3).Delete
    End If
Loop Until Cells(fila, 3) = 0
End Sub 