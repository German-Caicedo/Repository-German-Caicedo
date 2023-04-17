Attribute VB_Name = "Módulo1"
Sub frasesecreta()
' Declare variables
Dim f As Integer ' f stores the row number
Dim c As Integer ' c stores the column number
Dim x As String ' x stores the input phrase from the user
Dim y(1000) As String ' y stores the characters of the input phrase
Dim i As Integer ' i is used for loop iteration
Dim p As Integer ' p is used for loop iteration
Dim e(1000) As String ' e stores the alphabets A to Z
Dim k(1000) As String ' k stores the alphabets Z to A
Dim v(1000) As String ' v stores the characters of the encoded phrase
' Clear the content of all cells in the active sheet
Cells.Clear

' Get the row and column of the active cell
f = ActiveCell.Row
c = ActiveCell.Column

' Display an input box to get a phrase from the user
x = InputBox("ingrese una frase", "frase", "FRASE SECRETA")

' Write the input phrase to the cell with row f and column c
Cells(f, c) = x

' Loop through the input phrase and store each character in y array
For i = 1 To Len(x) Step 1
    y(i - 1) = Mid(x, i, 1)
    Cells(f, c + 1) = y(i - 1)
    f = f + 1
Next i

' Reset the row number and initialize the counter
f = ActiveCell.Row
p = 0

' Fill e array with alphabets from A to Z
For i = 65 To 90 Step 1
    e(p) = Chr(i)
    Cells(f, c + 2) = e(p)
    f = f + 1
    p = p + 1
Next i

' Reset the row number and counter
p = 0
f = ActiveCell.Row

' Fill k array with alphabets from Z to A
For i = 90 To 65 Step -1
    k(p) = Chr(i)
    Cells(f, c + 3) = k(p)
    f = f + 1
    p = p + 1
Next i

' Reset the row number, initialize counters and set the first elements of e and k arrays to space
f = ActiveCell.Row
p = 0
i = 0
k(p) = " "
e(p) = " "

' Write the length of the input phrase to the cell
Cells(f + 1, c) = Len(x)

' Encode the input phrase using the e and k arrays
For i = 0 To Len(x) Step 1
    Do
        If y(i) = e(p) Then
            v(i) = k(p)
        Else
        End If
        p = p + 1
    Loop Until y(i) = e(p) Or y(i) = "A" Or y(i) = " "

    v(i) = k(p)
    Cells(f, c + 4) = v(i)
    p = 0
    f = f + 1
Next i

' Join the encoded characters and write the result to the cell
Cells(f + 2, c) = Join(v, "")
End Sub
