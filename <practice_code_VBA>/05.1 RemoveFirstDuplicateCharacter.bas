Attribute VB_Name = "Módulo1"
Sub deletreo()
' Declare variables
Dim F As Integer ' F stores the row number of the active cell
Dim C As Integer ' C stores the column number of the active cell
Dim X As String ' X stores the input phrase from the user
Dim Y As String ' Y stores the current character in the input phrase
Dim I As Integer ' I is used for loop iteration through the input phrase
Dim P As Integer ' P stores the position of a character found in the input phrase
' Clear the content of all cells in the active sheet
Cells.Clear

' Get the row and column of the active cell
F = ActiveCell.Row
C = ActiveCell.Column

' Display an input box to get a phrase from the user
X = InputBox("INGRESE UNA FRASE", "LA LLANURA VERDE")

' Write the input phrase to the cell with row F and column C
Cells(F, C) = X

' Initialize I to 1
I = 1

' Loop through each character of the input phrase
Do
    ' Get the current character from the input phrase
    Y = Mid(X, I, 1)

    ' Find the position of the current character in the input phrase
    Do
        P = InStr(I + 1, X, Y)

        ' Write the position to the cell with row F and column C + 1
        Cells(F, C + 1) = P

        ' Check if the character was found in the input phrase
        If P <> 0 Then
            ' Remove the character from the input phrase
            X = Left(X, P - 1) & Mid(X, P + 1)

            ' Write the modified input phrase to the cell with row F and column C + 2
            Cells(F, C + 2) = X
        Else
            ' If the character was not found, do nothing
        End If
    Loop Until P = 0 ' Continue looping until no more occurrences of the character are found

    ' Move to the next character in the input phrase
    I = I + 1
Loop Until I = Len(X) ' Continue looping until all characters in the input phrase have been processed
End Sub 
