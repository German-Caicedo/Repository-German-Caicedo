Attribute VB_Name = "Módulo1"
Sub phrase()
' This subroutine reads a list of words from an Excel worksheet and joins them into a single phrase.
Dim F As Integer ' F stores the row number
Dim C As Integer ' C stores the column number
Dim Y(100) As String ' Y is an array that stores up to 100 words from the worksheet
Dim A As String ' A stores the concatenated phrase
Dim I As Integer ' I is an index variable for the loop

I = 0 ' Initialize index variable
F = ActiveCell.Row ' Get the active cell row
C = ActiveCell.Column ' Get the active cell column

' Read words from the worksheet and store them in the array Y
Do
    Y(I) = Cells(F, C)
    I = I + 1
    F = F + 1
Loop Until Cells(F, C) = ""

' Join the words from the array Y into a single phrase
A = Join(Y)

' Write the concatenated phrase in the worksheet, one column to the right of the last word
Cells(F, C + 1) = A
End Sub