﻿function Submit-Request($uri, $header, $method = $($resources.Method) , $body) {
    # The Submit-Request function is used to send data to an endpoint and then format the response for further use
    # $uri = The endpoint's URI
    # $header = The header containing authentication details
    # $method = The action (method) to perform on the endpoint
    # $body = Any optional body data being submitted to the endpoint

    if ($PSCmdlet.ShouldProcess($id, $resources.Description)) {
        try {
            Write-Verbose -Message 'Submitting the request'
            # Because some calls require more than the default payload limit of 2MB, ExpandPayload dynamically adjusts the payload limit
            $result = ExpandPayload -response (Invoke-WebRequest -Uri $uri -Headers $header -Method $method -Body $body)
        }
        catch {
            switch -Wildcard ($_) {
                'Route not defined.' {
                    Write-Warning -Message "The endpoint supplied to Rubrik is invalid. Likely this is due to an incompatible version of the API or references pointing to a non-existent endpoint. The URI passed was: $uri" -Verbose
                    throw $_.Exception 
                }
                'Invalid ManagedId*' {
                    Write-Warning -Message "The endpoint supplied to Rubrik is invalid. Likely this is due to an incompatible version of the API or references pointing to a non-existent endpoint. The URI passed was: $uri" -Verbose
                    throw $_.Exception 
                }
                '{"errorType":*' {
                    # Parses the Rubrik generated JSON warning into something a bit more human readable
                    # Fields are: errorType, message, and cause
                    [Array]$rubrikWarning = ConvertFrom-Json $_.ErrorDetails.Message
                    if ($rubrikWarning.errorType) {Write-Warning -Message $rubrikWarning.errorType}
                    if ($rubrikWarning.message) {Write-Warning -Message $rubrikWarning.message}
                    if ($rubrikWarning.cause) {Write-Warning -Message $rubrikWarning.cause}
                    throw $_.Exception
                }
                default {
                    throw $_
                }
            }
        }
    
        return $result
    }
}
