﻿function Remove-vRAService {
<#
    .SYNOPSIS
    Remove a vRA Service
    
    .DESCRIPTION
    Remove a vRA Service

    .PARAMETER Id
    The id of the service

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    Remove-vRAService -Id "d00d3631-997c-40f7-90e8-7ccbc153c20c"       

    .EXAMPLE
    Get-vRAService -Id "d00d3631-997c-40f7-90e8-7ccbc153c20c" | Remove-vRAService

    .EXAMPLE
    Get-vRAService | Where-Object {$_.name -ne "Default Service"} | Remove-vRAService
    
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")]

    Param (
        
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$Id
          
    )    

    Begin {
    
    }
    
    Process {

        foreach ($ServiceId in $Id) {

            $URI = "/catalog-service/api/services/$($ServiceId)"
            
            $Service = Invoke-vRARestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

            Write-Verbose -Message "Removing service $($Service.name)"

            $Service.status = "DELETED"

            # --- Remove the service
            try {

                if ($PSCmdlet.ShouldProcess($Service.name)){
                
                    # --- Build the URI string for the service         
            
                    $URI = "/catalog-service/api/services/$($ServiceId)"
                
                    Invoke-vRARestMethod -Method PUT -URI $URI -Body ($Service | ConvertTo-Json -Compress) -Verbose:$VerbosePreference | Out-Null
                
                }

            }
            catch [Exception] {
            
                throw
            
            }

        }

    }

    End {

    }

}