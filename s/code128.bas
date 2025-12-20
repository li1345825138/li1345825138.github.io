Attribute VB_Name = "code128"
'
' Code128 Barcode Generator for Excel VBA
' This module provides functions to generate Code128 barcodes that can be displayed
' using the Libre Barcode 128 font and scanned by barcode readers.
'

'
' Generates a Code 128 barcode string that can be displayed with the Libre Barcode 128 font
' @param inputData The string to encode into a barcode
' @return A string formatted for use with Code 128 barcode font
'
Public Function GenerateCode128Barcode(inputData As String) As String
    Dim i As Long
    Dim checksum As Long
    Dim charValue As Long
    
    ' Check for empty input
    If Len(inputData) = 0 Then
        GenerateCode128Barcode = ""
        Exit Function
    End If
    
    ' Validate input
    If Not IsValidCode128Input(inputData) Then
        GenerateCode128Barcode = "ERROR: Invalid characters"
        Exit Function
    End If
    
    ' Start character for Code 128B
    Dim barcodeString As String
    barcodeString = Chr(204)
    
    ' Calculate checksum - start with value of start character (104 for Start Code B)
    checksum = 104
    
    ' Process each character
    For i = 1 To Len(inputData)
        charValue = Asc(Mid(inputData, i, 1)) - 32  ' Adjust for Code B (starts at ASCII 32)
        
        ' Add character to barcode string
        barcodeString = barcodeString & Mid(inputData, i, 1)
        
        ' Add to checksum with weighting (starting at 1)
        checksum = checksum + (charValue * i)
    Next i
    
    ' Calculate final checksum value
    checksum = checksum Mod 103
    
    ' Add checksum character
    If checksum >= 0 And checksum <= 95 Then
        barcodeString = barcodeString & Chr(32 + checksum)
    ElseIf checksum >= 96 And checksum <= 105 Then
        barcodeString = barcodeString & Chr(100 + checksum)
    Else
        ' Handle special codes
        Select Case checksum
            Case 96: barcodeString = barcodeString & Chr(194)
            Case 97: barcodeString = barcodeString & Chr(195)
            Case 98: barcodeString = barcodeString & Chr(196)
            Case 99: barcodeString = barcodeString & Chr(197)
            Case 100: barcodeString = barcodeString & Chr(198)
            Case 101: barcodeString = barcodeString & Chr(199)
            Case 102: barcodeString = barcodeString & Chr(200)
            Case Else: barcodeString = barcodeString & Chr(201 + (checksum - 103))
        End Select
    End If
    
    ' Add stop character
    barcodeString = barcodeString & Chr(206)
    
    ' Add termination bar
    barcodeString = barcodeString & Chr(205)
    
    GenerateCode128Barcode = barcodeString
End Function

'
' Helper function to check if the input contains only valid ASCII characters for Code 128
' @param inputData The string to validate
' @return True if all characters are valid, False otherwise
'
Public Function IsValidCode128Input(inputData As String) As Boolean
    Dim i As Long
    
    For i = 1 To Len(inputData)
        ' Code 128 B supports ASCII values from 32 to 127 (printable characters)
        If Asc(Mid(inputData, i, 1)) < 32 Or Asc(Mid(inputData, i, 1)) > 127 Then
            IsValidCode128Input = False
            Exit Function
        End If
    Next i
    
    IsValidCode128Input = True
End Function

'
' Function to demonstrate usage in Excel worksheet
' Example: =Code128Example("12345678")
'
Public Function Code128Example(inputText As String) As String
    Code128Example = GenerateCode128Barcode(inputText)
End Function