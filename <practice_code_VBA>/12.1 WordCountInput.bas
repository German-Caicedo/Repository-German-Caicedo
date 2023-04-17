Attribute VB_Name = "Módulo1"
Sub WordCountInput()
WordCountInput
Dim f As Integer ' f stores the row number in the worksheet
Dim c As Integer ' c stores the column number in the worksheet
Dim x As String ' x stores the input phrase
Dim y() As String ' y is an array to store the split words

f = ActiveCell.Row ' Get the active cell's row
c = ActiveCell.Column ' Get the active cell's column

' Prompt the user to input a phrase
x = InputBox("inserte una frase ", "cuantas palabras tengo", "Palabras")
Cells(f, c) = x ' Store the input phrase in the active cell

' Split the input phrase into words
y = Split(x)

' Count the number of words and display it in the cell below the active cell
Cells(f + 1, c) = UBound(y) + 1
End Sub