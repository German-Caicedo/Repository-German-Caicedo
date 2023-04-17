Attribute VB_Name = "Módulo1"
Sub VUELTA()
' Invert a given phrase
' Declare variables
Dim Z As String ' Z stores the input phrase from the user
Dim F As Integer ' F stores the row number of the active cell
Dim C As Integer ' C stores the column number of the active cell
Dim A As String ' A stores the reversed phrase
Dim Y() As String ' Y is a dynamic array that will store the reversed words
Dim I As Integer ' I is used for loop iteration

' Clear the content of all cells in the active sheet
Cells.Clear

' Get the row and column of the active cell
F = ActiveCell.Row
C = ActiveCell.Column

' Display an input box to get a phrase from the user
Z = InputBox("INGRESE UNA FRASE", "FRASE", "ESCRIBA UNA FRASE")

' Write the input phrase to the cell with row F and column C
Cells(F, C) = Z

' Reverse the input phrase
A = StrReverse(Z)

' Split the reversed phrase into words
Y = Split(A)

' Loop through each word in the reversed phrase
For I = 0 To UBound(Y) Step 1
    ' Reverse each word back to its original order
    Y(I) = StrReverse(Y(I))

    ' Write the word to the cell in the next row and the same column
    Cells(F + 1, C) = Y(I)

    ' Increment the row number
    F = F + 1
Next I

' Join the words back into a single string
A = Join(Y)

' Write the final phrase to the cell in the same row as the active cell and the next column
Cells(ActiveCell.Row, C + 1) = A
End Sub '
