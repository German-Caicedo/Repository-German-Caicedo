Attribute VB_Name = "Módulo1"

Sub romano()
' This subroutine converts a Roman numeral string to its corresponding integer value
Dim x As String ' x stores the input Roman numeral string
Dim A(6) As String ' A array to store the Roman numeral symbols
Dim B(6) As Integer ' B array to store the corresponding integer values of the Roman numerals
Dim C(20) As Integer ' C array to store the integer values of the input Roman numeral string
Dim I As Integer ' I is a loop counter
Dim J As Integer ' J is a loop counter
Dim S As Integer ' S stores the integer value of the input Roman numeral string
Dim F As Integer ' F stores the row number for the worksheet

' Initialize the Roman numeral symbols and their corresponding integer values
A(0) = "I": B(0) = 1
A(1) = "V": B(1) = 5
A(2) = "X": B(2) = 10
A(3) = "L": B(3) = 50
A(4) = "C": B(4) = 100
A(5) = "D": B(5) = 500
A(6) = "M": B(6) = 1000

S = 0 ' Initialize the sum to 0
x = Range("A1") ' Get the input Roman numeral string from cell A1
x = UCase(x) ' Convert the input string to uppercase
F = 1 ' Initialize the row number for the worksheet

' Loop through the input string and map the Roman numerals to their integer values
For I = 1 To Len(x) Step 1
    For J = 0 To 6 Step 1
        If Mid(x, I, 1) = A(J) Then
            C(I - 1) = B(J)
            Cells(F, 2) = B(J)
            F = F + 1
        Else
            ' Do nothing
        End If
    Next J
Next I

' Calculate the sum of the integer values, taking into account the Roman numeral rules
For I = 0 To Len(x) - 1 Step 1
    If C(I) < C(I + 1) Then
        S = S - C(I)
    Else
        S = S + C(I)
    End If
Next I

Range("A2") = S ' Output the integer value in cell A2
End Sub
