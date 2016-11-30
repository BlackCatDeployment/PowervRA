﻿function Get-vRAConsumerResourceType {
<#
    .SYNOPSIS
    Get a consumer resource type
    
    .DESCRIPTION
    A Resource type is a type assigned to resources. The types are defined by the provider types. 
    It allows similar resources to be grouped together.
    
    .PARAMETER Id
    The id of the resource type
    
    .PARAMETER Name
    The Name of the resource type

    .PARAMETER Limit
    The number of entries returned per page from the API. This has a default value of 100.

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject.

    .EXAMPLE
    Get-vRAConsumerResourceType
    
    .EXAMPLE
    Get-vRAConsumerResourceType -Id "Infrastructure.Machine"
    
    .EXAMPLE
    Get-vRAConsumerResourceType -Name "Machine"
    
#>
[CmdletBinding(DefaultParameterSetName="Standard")][OutputType('System.Management.Automation.PSObject')]

    Param (

    [parameter(Mandatory=$false, ParameterSetName="ById")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Id,
    
    [parameter(Mandatory=$false, ParameterSetName="ByName")]
    [ValidateNotNullOrEmpty()]
    [String[]]$Name,         
    
    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [String]$Limit = "100"
    )

    Write-Warning -Message "This command is deprecated and will be removed in a future release. Please use Get-vRAResourceType instead."

    try {

        switch ($PsCmdlet.ParameterSetName) {

            # --- Get Resource Type by id
            'ById' {
            
                foreach ($ResourceTypeId in $Id) { 
            
                    $URI = "/catalog-service/api/consumer/resourceTypes/$($ResourceTypeId)"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"

                    [pscustomobject] @{

                        Id = $Response.id
                        Callbacks = $Response.callbacks
                        CostFeatures = $Response.costFeatures
                        Description = $Response.description
                        Forms = $Response.forms
                        ListView = $Response.listView
                        Name = $Response.name
                        PluralizedName = $Response.pluralizedName
                        Primary = $Response.primary
                        ProviderTypeId = $Response.providerTYpeId
                        Schema = $Response.schema
                        ListDescendantTypesSeparately = $Response.listDescendantTypesSeparately
                        ShowChildrenOutsideParent = $Response.ShowChildrenOutsideParent
                        Status = $Response.status

                    }

                }

                break
            }        
            # --- Get Resource Type by name
            'ByName' {

                foreach ($ResourceTypeName in $Name) {
            
                    $URI = "/catalog-service/api/consumer/resourceTypes?`$filter=name%20eq%20'$($ResourceTypeName)'"

                    Write-Verbose -Message "Preparing GET to $($URI)"

                    $Response = Invoke-vRARestMethod -Method GET -URI $URI

                    Write-Verbose -Message "SUCCESS"
            
                    if ($Response.content.Length -eq 0) {

                        throw "Could not find resource type item with name: $($ResourceTypeName)"

                    }        
            
                    [pscustomobject] @{

                        Id = $Response.content.id
                        Callbacks = $Response.content.callbacks
                        CostFeatures = $Response.content.costFeatures
                        Description = $Response.content.description
                        Forms = $Response.content.forms
                        ListView = $Response.content.listView
                        Name = $Response.content.name
                        PluralizedName = $Response.content.pluralizedName
                        Primary = $Response.content.primary
                        ProviderTypeId = $Response.content.providerTYpeId
                        Schema = $Response.content.schema
                        ListDescendantTypesSeparately = $Response.content.listDescendantTypesSeparately
                        ShowChildrenOutsideParent = $Response.content.ShowChildrenOutsideParent
                        Status = $Response.content.status

                    }
                    
                }
                
                break                                
            
            }        
            # --- No parameters passed so return all resource types
            'Standard' {
            
                $URI = "/catalog-service/api/consumer/resourceTypes?limit=$($Limit)&`$orderby=name%20asc"

                Write-Verbose -Message "Preparing GET to $($URI)"

                $Response = Invoke-vRARestMethod -Method GET -URI $URI

                Write-Verbose -Message "SUCCESS"

                Write-Verbose -Message "Response contains $($Response.content.Length) records"

                foreach ($ResourceType in $Response.content) {

                    [pscustomobject] @{

                        Id = $ResourceType.id
                        Callbacks = $ResourceType.callbacks
                        CostFeatures = $ResourceType.costFeatures
                        Description = $ResourceType.description
                        Forms = $ResourceType.forms
                        ListView = $ResourceType.listView
                        Name = $ResourceType.name
                        PluralizedName = $ResourceType.pluralizedName
                        Primary = $ResourceType.primary
                        ProviderTypeId = $ResourceType.providerTYpeId
                        Schema = $ResourceType.schema
                        ListDescendantTypesSeparately = $ResourceType.listDescendantTypesSeparately
                        ShowChildrenOutsideParent = $ResourceType.ShowChildrenOutsideParent
                        Status = $ResourceType.status

                    }

                }

                break

            }

        }
    }
    catch [Exception]{

        throw
    }
}