Option Explicit

' Main function: Generate barcode string for Code128 font (includes start character, data, checksum, and stop character)
Public Function Code128(SourceString As String) As String
    If SourceString = "" Then
        Code128 = ""
        Exit Function
    End If

    ' Validate that input contains only valid ASCII characters (32–126, compatible with Code128B)
    If Not IsValidCode128Input(SourceString) Then
        MsgBox "Invalid character in barcode string." & vbCrLf & _
               "Only standard ASCII characters (32–126) are allowed.", vbCritical
        Code128 = ""
        Exit Function
    End If

    Dim result As String
    Dim i As Long
    Dim useTableB As Boolean

    result = ""
    useTableB = True
    i = 1

    Do While i <= Len(SourceString)
        If useTableB Then
            ' Decide whether to switch to Code128C (consecutive even digits)
            Dim switchToC As Boolean
            switchToC = ShouldSwitchToCodeC(SourceString, i)

            If switchToC Then
                If i = 1 Then
                    result = Chr$(205) ' Start C
                Else
                    result = result & Chr$(199) ' Code C
                End If
                useTableB = False
            Else
                If i = 1 Then
                    result = Chr$(204) ' Start B
                End If
            End If
        End If

        If Not useTableB Then
            ' Try to continue using Code128C
            If i + 1 <= Len(SourceString) And IsNumeric(Mid$(SourceString, i, 2)) Then
                Dim pair As String: pair = Mid$(SourceString, i, 2)
                Dim val As Integer: val = CInt(pair)
                Dim mappedChar As Integer
                mappedChar = IIf(val < 95, val + 32, val + 100)
                result = result & Chr$(mappedChar)
                i = i + 2
            Else
                ' Cannot continue with C, switch back to B
                result = result & Chr$(200) ' Code B
                useTableB = True
            End If
        End If

        If useTableB Then
            result = result & Mid$(SourceString, i, 1)
            i = i + 1
        End If
    Loop

    ' Calculate checksum (based on Code128 specification)
    Dim checksum As Long
    checksum = ComputeCode128Checksum(result)

    Dim checksumChar As Integer
    checksumChar = IIf(checksum < 95, checksum + 32, checksum + 100)

    ' Add checksum + Stop
    result = result & Chr$(checksumChar) & Chr$(206)

    Code128 = result
End Function

' Validate that input contains only ASCII 32–126
Private Function IsValidCode128Input(s As String) As Boolean
    Dim i As Long
    For i = 1 To Len(s)
        Dim ch As String: ch = Mid$(s, i, 1)
        Dim code As Integer: code = Asc(ch)
        If code < 32 Or code > 126 Then
            IsValidCode128Input = False
            Exit Function
        End If
    Next i
    IsValidCode128Input = True
End Function

' Determine whether to switch to Code128C from current position (at least 4 digits, or 3 digits at the end)
Private Function ShouldSwitchToCodeC(s As String, pos As Long) As Boolean
    Dim remaining As Long: remaining = Len(s) - pos + 1
    If remaining < 4 Then
        ShouldSwitchToCodeC = False
        Exit Function
    End If

    ' Special: If at the beginning or 3 digits remain at the end, allow switching with 4 digits
    Dim minDigits As Long
    If pos = 1 Or remaining = 4 Then
        minDigits = 4
    Else
        minDigits = 6
    End If

    ' Check if there are minDigits consecutive digits starting from pos
    Dim i As Long
    For i = 0 To minDigits - 1
        If pos + i > Len(s) Then
            ShouldSwitchToCodeC = False
            Exit Function
        End If
        If Not IsNumeric(Mid$(s, pos + i, 1)) Then
            ShouldSwitchToCodeC = False
            Exit Function
        End If
    Next i

    ShouldSwitchToCodeC = True
End Function

' Calculate checksum according to Code128 specification (input is the mapped internal string)
Private Function ComputeCode128Checksum(encoded As String) As Long
    Dim total As Long: total = 0
    Dim i As Long

    For i = 1 To Len(encoded)
        Dim ch As String: ch = Mid$(encoded, i, 1)
        Dim value As Long
        Dim asciiVal As Integer: asciiVal = Asc(ch)
        If asciiVal < 127 Then
            value = asciiVal - 32
        Else
            value = asciiVal - 100
        End If

        If i = 1 Then
            total = value ' Start character as initial value
        Else
            total = (total + (i - 1) * value) Mod 103
        End If
    Next i

    ComputeCode128Checksum = total Mod 103
End Function