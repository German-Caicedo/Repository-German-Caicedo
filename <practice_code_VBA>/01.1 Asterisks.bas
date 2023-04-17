Attribute VB_Name = "Módulo1"
Sub asterisco()
' Declare variables
Dim f As Integer ' f stores the row number of the active cell
Dim c As Integer ' c stores the column number of the active cell
Dim x As String ' x stores the input phrase from the user
Dim y(1000) As String ' y is an array of strings with 1000 elements
Dim i As Integer ' i is used for loop iteration
Cells.Clear ' Clear the content of all cells in the active sheet
' Get the row and column of the active cell
f = ActiveCell.Row
c = ActiveCell.Column

' Display an input box to get a phrase from the user
x = InputBox("ingrese una frase", "frase", "esta es una frase")

' Loop through each character of the input phrase
For i = 1 To Len(x) Step 1
    ' If the character is a space, leave it unchanged
    If Mid(x, i, 1) = " " Then
        Mid(x, i, 1) = " "
    ' If the character is not empty, replace it with an asterisk (*)
    Else
        If Mid(x, i, 1) <> "" Then
            Mid(x, i, 1) = "*"
        Else
            ' If the character is empty, do nothing
            End If
    End If
Next i

' Write the modified phrase to the cell with row f and column c
Cells(f, c) = x
End Sub 
