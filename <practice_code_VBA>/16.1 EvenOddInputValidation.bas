Attribute VB_Name = "Módulo1"
Sub prueba()
' This subroutine prompts the user to input a positive integer, validates the input,
' and displays the integer and whether it is even or odd in cells B4 and C4
Dim z As String ' z stores the user's input

' Clear the sheet
Cells.Clear

' Begin a loop to validate the user input
Do
    ' Prompt the user to input a positive integer
    z = InputBox("Ingrese un valor entero y positivo", "Valor", 25)

    ' Check if the user input is empty
    If z = "" Then
        MsgBox "Error: No ingresó ningún dato" ' Display an error message if the input is empty
    ' Check if the user input contains a decimal point or is not numeric
    ElseIf InStr(z, ".") <> 0 Or Not IsNumeric(z) Then
        MsgBox "Error: El dato no es numérico" ' Display an error message if the input is not numeric
    ' Check if the user input is not an integer or not positive
    ElseIf z <> Int(z) Or z <= 0 Then
        MsgBox "Error: El dato no es un entero positivo" ' Display an error message if the input is not a positive integer
    Else
        ' If the input is valid, write the positive integer in cell B4
        Range("B4") = z

        ' Check if the positive integer is even or odd and write the result in cell C4
        If z Mod 2 = 0 Then
            Range("C4") = "par" ' Even
        Else
            Range("C4") = "impar" ' Odd
        End If
    End If
' Continue the loop until a valid positive integer is entered
Loop Until Range("B4") = z And z <> ""
End Sub
