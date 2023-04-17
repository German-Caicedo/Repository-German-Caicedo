Attribute VB_Name = "Módulo1"
Sub SEPARAR_PALABRAS_DE_UNA_FRASE()
' This subroutine separates a given phrase into words and letters
' Declare variables
Dim X As String ' X stores the input phrase
Dim F As Integer ' F stores the row number in the worksheet
Dim C As Integer ' C stores the column number in the worksheet
Dim Y() As String ' Y stores an array of words in the input phrase
Dim Z(100) As String ' Z stores an array of letters in the input phrase

Dim i As Integer ' i is an index variable used in loops
i = 0

' Get the row and column of the active cell
F = ActiveCell.Row
C = ActiveCell.Column

' Clear the content of all cells in the active sheet
Cells.Clear

' Get the input phrase from the user
X = InputBox("INGRESE UNA FRASE", "FRASE", "MAÑANA ES MIERCOLES")

' Write the input phrase to the worksheet
Cells(F, C) = X

' Split the input phrase into an array of words
Y = Split(X)

' Write each word of the input phrase to the worksheet in a separate row
For i = 0 To UBound(Y) Step 1
    Cells(F, C + 1) = Y(i)
    F = F + 1
Next i

i = 1

' Reset the row number to the row of the active cell
F = ActiveCell.Row

' Write each letter of the input phrase to the worksheet in a separate row
For i = 1 To Len(X) Step 1
    Z(i - 1) = Mid(X, i, 1)
    Cells(F, C + 2) = Z(i - 1)
    F = F + 1
Next i
End Sub