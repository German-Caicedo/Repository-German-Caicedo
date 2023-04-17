Attribute VB_Name = "Módulo1"
Sub ESPACIOS()
' Declare variables
Dim x As String ' x stores the input phrase from the user
Dim i As Integer ' i is used for loop iteration through the words in the input phrase
Dim y() As String ' y stores the words in the input phrase after splitting it
Dim f As Integer ' f stores the row number for output
Dim c As Integer ' c stores the column number for output
Dim s As String ' s stores the processed phrase with extra spaces removed
' Clear the content of all cells in the active sheet
Cells.Clear

' Display an input box to get a phrase from the user
x = InputBox("Inserte una frase", "Frase", "    No       puedo     hacer esta cosa      ")

' Remove leading and trailing spaces from the input phrase
x = Trim(x)

' Write the input phrase to cell A1
Range("a1") = x

' Split the input phrase into words using space as the delimiter
y = Split(x)

' Initialize the row and column for output
f = 1
c = 2

' Initialize an empty string for the processed phrase
s = ""

' Loop through the words in the input phrase
For i = 0 To UBound(y)
    ' Check if the current word is empty
    If y(i) = "" Then
        ' If the word is empty, do nothing
        s = s
    Else
        ' If the word is not empty, add the word followed by a space to the processed phrase
        s = s & y(i) & " "
    End If
Next i

' Write the processed phrase with extra spaces removed to cell A2
Range("a2") = s
End Sub
