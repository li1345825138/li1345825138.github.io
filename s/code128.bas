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
    
    ' Validate input - using Code 128B which supports ASCII 32-126
    If Not IsValidCode128Input(inputData) Then
        GenerateCode128Barcode = "ERROR: Invalid characters"
        Exit Function
    End If
    
    ' Start character for Code 128B (value 104)
    Dim barcodeString As String
    barcodeString = Chr(204)  ' Start B character (Code128 value 104)
    
    ' Calculate checksum - start with value of start character (104 for Start Code B)
    checksum = 104
    
    ' Process each character
    For i = 1 To Len(inputData)
        ' Get ASCII value and convert to Code 128B value (ASCII - 32)
        charValue = Asc(Mid(inputData, i, 1)) - 32
        
        ' Add to checksum with weighting (position * character value)
        ' Weight starts at 1 for first data character
        checksum = checksum + (charValue * i)
    Next i
    
    ' Calculate final checksum value (0-102)
    checksum = checksum Mod 103
    
    ' Add checksum character
    ' According to IDAutomation manual example, the checksum character mapping is:
    ' checksum value N -> ASCII (32 + N)
    ' Example: checksum value 71 -> ASCII 103 (character 'g')
    ' For values 96-102, this produces ASCII 128-134 which are extended ASCII characters
    ' that are supported by Code128 fonts
    barcodeString = barcodeString & Chr(32 + checksum)
    
    ' Add stop character (Code128 value 106, ASCII 206)
    barcodeString = barcodeString & Chr(206)
    
    ' Add termination bar (ASCII 205)
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
        ' Code 128 B supports ASCII values from 32 to 126 (printable characters)
        If Asc(Mid(inputData, i, 1)) < 32 Or Asc(Mid(inputData, i, 1)) > 126 Then
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