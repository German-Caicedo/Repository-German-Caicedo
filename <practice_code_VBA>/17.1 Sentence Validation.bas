Attribute VB_Name = "Módulo1"
Sub prueba()
' This subroutine prompts the user to input a phrase with at least four words,
' validates the input, and displays the phrase in the active cell
Dim f As Integer ' f stores the active cell row
Dim c As Integer ' c stores the active cell column
Dim x As String ' x stores the user's input
Dim y() As String ' y is an array that will store the words in the phrase

' Clear the sheet
Cells.Clear

' Get the active cell row and column
f = ActiveCell.Row
c = ActiveCell.Column

' Prompt the user to input a phrase with at least four words
x = InputBox("ingrese una frase de al menos 4 palabras", "frase", "frase de cuatro palabras")

' Split the input phrase into words and store them in the array y
y = Split(x)

' Check if the user input is empty
If x = "" Then
    MsgBox "error ingrese una frase"
Else
    ' Check if the phrase has less than 4 words and display an error message accordingly
    If UBound(y) = 2 Then
        MsgBox "error la frase solo tiene tres palabras"
    ElseIf UBound(y) = 1 Then
        MsgBox "error la frase solo tiene dos palabras"
    ElseIf UBound(y) = 0 Then
        MsgBox "error la frase solo tiene una palabra"
    End If
End If

' Write the input phrase in the active cell if it is not empty
Cells(f, c) = x
End Sub