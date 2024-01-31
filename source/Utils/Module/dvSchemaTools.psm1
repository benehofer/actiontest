function Get-entityDefinitionAuthHeader() {
    param(
        $envUrl,
        $solutionName=""
    )
    $r=Get-AccessToken -resourceURI $envUrl
    if ($r.Success) {
        $dvToken=$r.Value
        $additionalHeaderAttributes=@(
            @{"name"="Accept";"value"="application/json"},
            @{"name"="Content-Type";"value"="application/json; charset=utf-8"},
            @{"name"="OData-MaxVersion";"value"="4.0"},
            @{"name"="OData-Version";"value"="4.0"}
        )
        if ($solutionName.length -gt 0) {
            $additionalHeaderAttributes+=@{"name"="MSCRM.SolutionUniqueName";"value"=$solutionName}
        }
        $r=Get-AuthHeader -accessToken $dvToken -additionalHeaderAttributes $additionalHeaderAttributes
    }
    $r
}
Function Get-labelDefinitionObject() {
    param(
        $definitionObject,
        [Validateset("Description","DisplayName","DisplayCollectionName","Label")]$labelType,
        [switch]$noAnnotations
    )
    $lbl=@()
    $definitionObject.psobject.Properties | ? {$_.name -like "$($labelType)_*"} | select -ExpandProperty name | %{
        $slabel=$($definitionObject.$($_))
        if ($noAnnotations) {
            $lbl+=[PSCustomObject]@{"Label"=$slabel;"LanguageCode"=$([int]$($_.split("_")[1]))}
        } else {
            $lbl+=[PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.LocalizedLabel";"Label"=$slabel;"LanguageCode"=$([int]$($_.split("_")[1]))}
        }
    }
    if ($noAnnotations) {
        $([PSCustomObject]@{LocalizedLabels=$lbl})
    } else {
        $([PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.Label";LocalizedLabels=$lbl})
    }
}
function Get-attributeDefinitionObject() {
    param(
        $attribute,
        $publisherPrefix
    )
    $att=[PSCustomObject]@{}
    $att | Add-Member -MemberType NoteProperty -Name "SchemaName" -value "$($publisherPrefix)_$($attribute.schemaName.ToLower())"
    $att | Add-Member -MemberType NoteProperty -Name "RequiredLevel" -value $([PSCustomObject]@{"Value"=$attribute.RequiredLevel;"CanBeChanged"=$true;"ManagedPropertyLogicalName"="canmodifyrequirementlevelsettings"})
    $att | Add-Member -MemberType NoteProperty -Name "IsPrimaryName" -value $($attribute.IsPrimaryName -eq 1)

    $att | Add-Member -MemberType NoteProperty -Name "Description" -value $(Get-labelDefinitionObject -definitionObject $attribute -labelType Description)
    $att | Add-Member -MemberType NoteProperty -Name "DisplayName" -value $(Get-labelDefinitionObject -definitionObject $attribute -labelType DisplayName)

    $att | Add-Member -MemberType NoteProperty -Name "@odata.type" -value "Microsoft.Dynamics.CRM.$($attribute.Type)AttributeMetadata"
    $att | Add-Member -MemberType NoteProperty -Name "AttributeType" -value $($attribute.Type)
    $att | Add-Member -MemberType NoteProperty -Name "AttributeTypeName" -value $([PSCustomObject]@{Value = "$($attribute.Type)Type"})

    switch ($attribute.Type.tolower()) {
        "string" {
            $att | Add-Member -MemberType NoteProperty -Name "FormatName" -value $([PSCustomObject]@{Value = "Text"})
            $att | Add-Member -MemberType NoteProperty -Name "MaxLength" -value $([int]$(if ($attribute.MaxLength) {$attribute.MaxLength} else {200}))
            $att | Add-Member -MemberType NoteProperty -Name "SourceType" -value $([int]$(if ($attribute.SourceType) {$attribute.SourceType} else {0}))
            break;
        }
        "memo" {
            $att | Add-Member -MemberType NoteProperty -Name "FormatName" -value $([PSCustomObject]@{Value = "Text"})
            $att | Add-Member -MemberType NoteProperty -Name "MaxLength" -value $([int]$(if ($attribute.MaxLength) {$attribute.MaxLength} else {2000}))
            break;
        }        
        "money" {
            $att | Add-Member -MemberType NoteProperty -Name "MaxValue" -value $([decimal]$(if ($attribute.MaxValue) {$attribute.MaxValue} else {1000000000}))
            $att | Add-Member -MemberType NoteProperty -Name "MinValue" -value $([decimal]$(if ($attribute.MinValue) {$attribute.MinValue} else {-1000000000}))
            $att | Add-Member -MemberType NoteProperty -Name "PrecisionSource" -value $([int]$(if ($attribute.PrecisionSource) {$attribute.PrecisionSource} else {2}))
            $att | Add-Member -MemberType NoteProperty -Name "SourceType" -value $([int]$(if ($attribute.SourceType) {$attribute.SourceType} else {0}))
            break;
        }
        "datetime" {
            $att | Add-Member -MemberType NoteProperty -Name "Format" -value $($(if ($attribute.Format) {$attribute.Format} else {'DateOnly'}))
            $att | Add-Member -MemberType NoteProperty -Name "SourceType" -value $([int]$(if ($attribute.SourceType) {$attribute.SourceType} else {0}))
            break;
        }
        "boolean" {
            $att | Add-Member -MemberType NoteProperty -Name "DefaultValue" -value $($(if ($attribute.DefaultValue) {$attribute.DefaultValue} else {"False"}))
            $att | Add-Member -MemberType NoteProperty -Name "SourceType" -value $([int]$(if ($attribute.SourceType) {$attribute.SourceType} else {0}))
            if (!($attribute.Optionset)) {$attribute | Add-Member -MemberType NoteProperty -Name "Optionset" -Value "1033-Yes-No,1031-Ja-Nein,1036-Oui-Non,1040-Si-No"}
            if (!($attribute.OptionsetValues)) {$attribute | Add-Member -MemberType NoteProperty -Name "OptionsetValues" -Value "1,0"}
            $trueValue=$attribute.OptionsetValues.split(",")[0]
            $falseValue=$attribute.OptionsetValues.split(",")[1]
            $lblTrue=@()
            $lblFalse=@()
            $attribute.Optionset.split(",") | ? {$null -ne $_} | %{
                $languageOption=$_.split("-")
                $lblTrue+=[PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.LocalizedLabel";"Label"=$($languageOption[1]);"LanguageCode"=$($languageOption[0])}
                $lblFalse+=[PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.LocalizedLabel";"Label"=$($languageOption[2]);"LanguageCode"=$($languageOption[0])}
            }
            $att | Add-Member -MemberType NoteProperty -Name "OptionSet" -value $([PSCustomObject]@{
                "TrueOption"=[PSCustomObject]@{"Value"=$($trueValue);"Label"=$([PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.Label";LocalizedLabels=$lblTrue})}
                "FalseOption"=[PSCustomObject]@{"Value"=$($falseValue);"Label"=$([PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.Label";LocalizedLabels=$lblFalse})}
                "OptionSetType"="Boolean"
            })
            break
        }
        "integer" {
            $att | Add-Member -MemberType NoteProperty -Name "MaxValue" -value $([int]$(if ($attribute.MaxValue) {$attribute.MaxValue} else {2147483647}))
            $att | Add-Member -MemberType NoteProperty -Name "MinValue" -value $([int]$(if ($attribute.MinValue) {$attribute.MinValue} else {-2147483648}))
            $att | Add-Member -MemberType NoteProperty -Name "SourceType" -value $([int]$(if ($attribute.SourceType) {$attribute.SourceType} else {0}))
            break
        }
        "decimal" {
            $att | Add-Member -MemberType NoteProperty -Name "MaxValue" -value $([decimal]$(if ($attribute.MaxValue) {$attribute.MaxValue} else {100000000000}))
            $att | Add-Member -MemberType NoteProperty -Name "MinValue" -value $([decimal]$(if ($attribute.MinValue) {$attribute.MinValue} else {-100000000000}))
            $att | Add-Member -MemberType NoteProperty -Name "Precision" -value $([int]$(if ($attribute.Precision) {$attribute.Precision} else {2}))
            $att | Add-Member -MemberType NoteProperty -Name "SourceType" -value $([int]$(if ($attribute.SourceType) {$attribute.SourceType} else {0}))
            break
        }
        "double" {
            $att | Add-Member -MemberType NoteProperty -Name "MaxValue" -value $([decimal]$(if ($attribute.MaxValue) {$attribute.MaxValue} else {1000000000}))
            $att | Add-Member -MemberType NoteProperty -Name "MinValue" -value $([decimal]$(if ($attribute.MinValue) {$attribute.MinValue} else {0}))
            $att | Add-Member -MemberType NoteProperty -Name "Precision" -value $([int]$(if ($attribute.Precision) {$attribute.Precision} else {2}))
            $att | Add-Member -MemberType NoteProperty -Name "SourceType" -value $([int]$(if ($attribute.SourceType) {$attribute.SourceType} else {0}))
            break
        }
        "picklist" {
            $att | Add-Member -MemberType NoteProperty -Name "GlobalOptionSet" -value $([PSCustomObject]@{
                "@odata.type" = "Microsoft.Dynamics.CRM.OptionSetMetadata"
                "Name" = "$($publisherPrefix)_$(($attribute.GlobalOptionSet).tolower())"
                "IsGlobal" = $true
            })
            break
        }
        "multiselectpicklist" {
            $att | Add-Member -MemberType NoteProperty -Name "GlobalOptionSet" -value $([PSCustomObject]@{
                "@odata.type" = "Microsoft.Dynamics.CRM.OptionSetMetadata"
                "Name" = "$($publisherPrefix)_$(($attribute.GlobalOptionSet).tolower())"
                "IsGlobal" = $true
            })
            break
        }
        "file" {
            $att | Add-Member -MemberType NoteProperty -Name "AttributeType" -value "Virtual" -Force
            $att | Add-Member -MemberType NoteProperty -Name "MaxSizeInKB" -value $([decimal]$(if ($attribute.MaxSizeInKB) {$attribute.MaxSizeInKB} else {32768}))
            break
        }
    }
    $att
}
function Get-keyDefinitionObject() {
    param(
        $key,
        $publisherPrefix
    )
    $keydef=[PSCustomObject]@{}
    $keydef | Add-Member -MemberType NoteProperty -Name "SchemaName" -value "$($publisherPrefix)_$($key.schemaName.ToLower())"
    $keydef | Add-Member -MemberType NoteProperty -Name "KeyAttributes" -value $key.KeyAttributes
    $keydef | Add-Member -MemberType NoteProperty -Name "DisplayName" -value $(Get-labelDefinitionObject -definitionObject $key -labelType DisplayName)
    $keydef
}
function Get-BooleanOptionSetDefinitionObjectTrue() {
    param(
        $attribute,
        $publisherPrefix
    )
    $att=[PSCustomObject]@{}
    $att | Add-Member -MemberType NoteProperty -Name "AttributeLogicalName" -value "$($publisherPrefix)_$($attribute.schemaName.ToLower())"
    $att | Add-Member -MemberType NoteProperty -Name "EntityLogicalName" -value "$($publisherPrefix)_$($attribute.Entity.ToLower())"
    if ($attribute.Type.tolower() -eq "boolean") {
        if (!($attribute.Optionset)) {$attribute | Add-Member -MemberType NoteProperty -Name "Optionset" -Value "1033-Yes-No,1031-Ja-Nein,1036-Oui-Non,1040-Si-No"}
        if (!($attribute.OptionsetValues)) {$attribute | Add-Member -MemberType NoteProperty -Name "OptionsetValues" -Value "1,0"}
        $trueValue=$attribute.OptionsetValues.split(",")[0]
        $falseValue=$attribute.OptionsetValues.split(",")[1]

        $att | Add-Member -MemberType NoteProperty -Name "Value" -value 1
        $lblTrue=@()
        $lblFalse=@()

        $attribute.Optionset.split(",") | ? {$null -ne $_} | %{
            $languageOption=$_.split("-")
            $lblTrue+=[PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.LocalizedLabel";"Label"=$($languageOption[1]);"LanguageCode"=$($languageOption[0])}
            $lblFalse+=[PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.LocalizedLabel";"Label"=$($languageOption[2]);"LanguageCode"=$($languageOption[0])}
        }
        $att | Add-Member -MemberType NoteProperty -Name "Label" -value $([PSCustomObject]@{
            "@odata.type"="Microsoft.Dynamics.CRM.Label"
            "LocalizedLabels"=$lblTrue
        })
    }
    $att | Add-Member -MemberType NoteProperty -Name "MergeLabels" -value $true
    $att
}
function Get-BooleanOptionSetDefinitionObjectFalse() {
    param(
        $attribute,
        $publisherPrefix
    )
    $att=[PSCustomObject]@{}
    $att | Add-Member -MemberType NoteProperty -Name "AttributeLogicalName" -value "$($publisherPrefix)_$($attribute.schemaName.ToLower())"
    $att | Add-Member -MemberType NoteProperty -Name "EntityLogicalName" -value "$($publisherPrefix)_$($attribute.Entity.ToLower())"
    if ($attribute.Type.tolower() -eq "boolean") {
        if (!($attribute.Optionset)) {$attribute | Add-Member -MemberType NoteProperty -Name "Optionset" -Value "1033-Yes-No,1031-Ja-Nein,1036-Oui-Non,1040-Si-No"}
        if (!($attribute.OptionsetValues)) {$attribute | Add-Member -MemberType NoteProperty -Name "OptionsetValues" -Value "1,0"}
        $trueValue=$attribute.OptionsetValues.split(",")[0]
        $falseValue=$attribute.OptionsetValues.split(",")[1]

        $att | Add-Member -MemberType NoteProperty -Name "Value" -value 0
        $lblTrue=@()
        $lblFalse=@()

        $attribute.Optionset.split(",") | ? {$null -ne $_} | %{
            $languageOption=$_.split("-")
            $lblTrue+=[PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.LocalizedLabel";"Label"=$($languageOption[1]);"LanguageCode"=$($languageOption[0])}
            $lblFalse+=[PSCustomObject]@{"@odata.type"="Microsoft.Dynamics.CRM.LocalizedLabel";"Label"=$($languageOption[2]);"LanguageCode"=$($languageOption[0])}
        }
        $att | Add-Member -MemberType NoteProperty -Name "Label" -value $([PSCustomObject]@{
            "@odata.type"="Microsoft.Dynamics.CRM.Label"
            "LocalizedLabels"=$lblFalse
        })
    }
    $att | Add-Member -MemberType NoteProperty -Name "MergeLabels" -value $true
    $att
}
function Get-entityDefinitionObject() {
    param(
        $entity,
        $attributes,
        $publisherPrefix
    )
    $ent=[PSCustomObject]@{}
    $ent | Add-Member -MemberType NoteProperty -Name "@odata.type" -Value "Microsoft.Dynamics.CRM.EntityMetadata"
    $ent | Add-Member -MemberType NoteProperty -Name "HasActivities" -Value $($entity.hasActivities -eq 1)
    $ent | Add-Member -MemberType NoteProperty -Name "HasNotes" -Value $($entity.hasNotes -eq 1)
    $ent | Add-Member -MemberType NoteProperty -Name "IsActivity" -Value $($entity.IsActivity -eq 1)
    $ent | Add-Member -MemberType NoteProperty -Name "SchemaName" -Value "$($publisherPrefix)_$($entity.schemaName.ToLower())"
    $ent | Add-Member -MemberType NoteProperty -Name "OwnershipType" -Value $entity.OwnershipType
    $ent | Add-Member -MemberType NoteProperty -Name "Description" -value $(Get-labelDefinitionObject -definitionObject $entity -labelType Description)
    $ent | Add-Member -MemberType NoteProperty -Name "DisplayName" -value $(Get-labelDefinitionObject -definitionObject $entity -labelType DisplayName)
    $ent | Add-Member -MemberType NoteProperty -Name "DisplayCollectionName" -value $(Get-labelDefinitionObject -definitionObject $entity -labelType DisplayCollectionName)

    $atts=@()
    $attributes | ? {$_.Entity -eq $entity.schemaName} | ? {$null -ne $_} | % {
        $atts+=Get-attributeDefinitionObject -attribute $_ -publisherPrefix $publisherPrefix
    }
    $ent | Add-Member -MemberType NoteProperty -Name "Attributes" -Value $atts
    $ent
}
function Get-relationshipDefinitionObject() {
    param(
        $relationship,
        $entities,
        $attributes,
        $publisherPrefix
    )
    $referencingEntity=$entities | ? {$_.schemaname -eq "$($relationship.Entity)"}
    $rel=[PSCustomObject]@{}
    $lookup=[PSCustomObject]@{}
    $lookup | Add-Member -MemberType NoteProperty -Name "SchemaName" -value "$($publisherPrefix)_$($relationship.schemaName.ToLower())"
    $lookup | Add-Member -MemberType NoteProperty -Name "RequiredLevel" -value $([PSCustomObject]@{"Value"=$relationship.RequiredLevel;"CanBeChanged"=$true;"ManagedPropertyLogicalName"="canmodifyrequirementlevelsettings"})
    $lookup | Add-Member -MemberType NoteProperty -Name "@odata.type" -value "Microsoft.Dynamics.CRM.LookupAttributeMetadata"
    $lookup | Add-Member -MemberType NoteProperty -Name "AttributeType" -value "Lookup"
    $lookup | Add-Member -MemberType NoteProperty -Name "AttributeTypeName" -value $([PSCustomObject]@{Value = "LookupType"})
    $lookup | Add-Member -MemberType NoteProperty -Name "Description" -value $(Get-labelDefinitionObject -definitionObject $relationship -labelType Description)
    $lookup | Add-Member -MemberType NoteProperty -Name "DisplayName" -value $(Get-labelDefinitionObject -definitionObject $relationship -labelType DisplayName)

    $menuConfig=[PSCustomObject]@{}
    $menuConfig | Add-Member -MemberType NoteProperty -Name "Behavior" -value "UseCollectionName"
    $menuConfig | Add-Member -MemberType NoteProperty -Name "Group" -value "Details"
    $menuConfig | Add-Member -MemberType NoteProperty -Name "Label" -value $(Get-labelDefinitionObject -definitionObject $referencingEntity -labelType DisplayCollectionName)

    $rel | Add-Member -MemberType NoteProperty -Name "Lookup" -Value $lookup
    $rel | Add-Member -MemberType NoteProperty -Name "AssociatedMenuConfiguration" -Value $menuConfig

    if ($relationship.ReferencedEntity -in @($entities | select -expandproperty schemaname)) {
        $rel | Add-Member -MemberType NoteProperty -Name "SchemaName" -value "$($publisherPrefix)_$($relationship.entity.ToLower())_$($publisherPrefix)_$($relationship.ReferencedEntity.ToLower())_$($relationship.schemaName.ToLower())"
        $rel | Add-Member -MemberType NoteProperty -Name "ReferencedEntity" -Value "$($publisherPrefix)_$($relationship.ReferencedEntity.ToLower())"
        $rel | Add-Member -MemberType NoteProperty -Name "ReferencedAttribute" -Value "$($publisherPrefix)_$($relationship.ReferencedAttribute.ToLower())"
    } else {
        $rel | Add-Member -MemberType NoteProperty -Name "SchemaName" -value "$($publisherPrefix)_$($relationship.entity.ToLower())_$($relationship.ReferencedEntity.ToLower())_$($relationship.schemaName.ToLower())"
        $rel | Add-Member -MemberType NoteProperty -Name "ReferencedEntity" -Value "$($relationship.ReferencedEntity.ToLower())"
        $rel | Add-Member -MemberType NoteProperty -Name "ReferencedAttribute" -Value "$($relationship.ReferencedAttribute.ToLower())"
    }
    $rel | Add-Member -MemberType NoteProperty -Name "@odata.type" -value "Microsoft.Dynamics.CRM.OneToManyRelationshipMetadata"   
    $rel | Add-Member -MemberType NoteProperty -Name "ReferencingEntity" -Value "$($publisherPrefix)_$($relationship.Entity.ToLower())"
    $rel
}
function Get-optionDefinitionObject() {
    param(
        $option,
        [switch]$singleOption,
        [switch]$forUpdateOptionValue,
        $publisherPrefix
    )
    $opt=[PSCustomObject]@{}
    if (!($singleOption)) {$opt | Add-Member -MemberType NoteProperty -Name "@odata.type" -Value "#Microsoft.Dynamics.CRM.OptionMetadata"}
    $opt | Add-Member -MemberType NoteProperty -Name "Value" -Value $option.Value
    $opt | Add-Member -MemberType NoteProperty -Name "Label" -Value $(Get-labelDefinitionObject -definitionObject $option -labelType Label -noAnnotations:$singleOption)
    $opt | Add-Member -MemberType NoteProperty -Name "Description" -Value $(Get-labelDefinitionObject -definitionObject $option -labelType Description -noAnnotations:$singleOption)
    if ($singleOption) {
        $opt | Add-Member -MemberType NoteProperty -Name "OptionSetName" -Value "$($publisherPrefix)_$($option.OptionSetName.ToLower())"
    }
    if ($forUpdateOptionValue) {
        $opt | Add-Member -MemberType NoteProperty -Name "MergeLabels" -Value $true
    }
    $opt
}
function Get-optionsetDefinitionObject() {
    param(
        $optionset,
        $options,
        $publisherPrefix
    )
    $optset=[PSCustomObject]@{}
    $optset | Add-Member -MemberType NoteProperty -Name "@odata.type" -Value "#Microsoft.Dynamics.CRM.OptionSetMetadata"
    $optset | Add-Member -MemberType NoteProperty -Name "IsGlobal" -Value $true
    $optset | Add-Member -MemberType NoteProperty -Name "IsCustomOptionSet" -Value $true
    $optset | Add-Member -MemberType NoteProperty -Name "Name" -Value "$($publisherPrefix)_$($optionset.Name.ToLower())"
    $optset | Add-Member -MemberType NoteProperty -Name "OptionSetType" -Value "Picklist"
    $optset | Add-Member -MemberType NoteProperty -Name "Description" -value $(Get-labelDefinitionObject -definitionObject $optionset -labelType Description)
    $optset | Add-Member -MemberType NoteProperty -Name "DisplayName" -value $(Get-labelDefinitionObject -definitionObject $optionset -labelType DisplayName)

    $opts=@()
    $options | ? {$_.OptionSetName -eq $optionset.Name} | ? {$null -ne $_} | % {
        $opts+=Get-optionDefinitionObject -option $_ -publisherPrefix $publisherPrefix
    }
    $optset | Add-Member -MemberType NoteProperty -Name "Options" -Value $opts
    $optset
}
function Set-SchemaParameters() {
    param(
        [Parameter(Mandatory=$True,ValuefromPipeline=$True)]$schemaObject
    )
    Begin {}
    Process{
        $schemaObject | ? {$null -ne $_.parameters} | %{
            $e=$_;$e.parameters.split(";") | ? {$null -ne $_} | % {
                $e | Add-Member -MemberType NoteProperty -Name $_.split(":")[0] -Value $_.split(":")[1]
            }
        }
        $schemaObject
    }
    End{}
}
function Get-Schema() {
    param(
        $excelPath,
        $publisherPrefix
    )
    try {
        $schema=[PSCustomObject]@{
            entities=Import-Excel -Path $excelPath -WorksheetName "Entities" | Set-SchemaParameters
            attributes=Import-Excel -Path $excelPath -WorksheetName "Attributes" | Set-SchemaParameters
            relationships=Import-Excel -Path $excelPath -WorksheetName "Relationships" | Set-SchemaParameters
            optionsets=Import-Excel -Path $excelPath -WorksheetName "Optionsets" | Set-SchemaParameters
            options=Import-Excel -Path $excelPath -WorksheetName "Options" | Set-SchemaParameters
        }

        $keys=@()
        $schema.entities  | ? {$null -ne $_} | %{
            $entity=$_
            $key=$null
            $schema.attributes | ? {$_.entity -eq $entity.schemaName -and $_.Key -ne $null} | group key | %{
                $keyAttribute=$_
                $key=[PSCustomObject]@{
                    entity=$entity.schemaName
                    schemaName = $keyAttribute.Name.ToLower()
                }
                $keyAttribute.Group[0].psobject.Properties | ? {$_.Name -like "DisplayName*" -or $_.Name -like "Description*"} | %{
                    $prop=$_
                    $key | Add-Member -MemberType NoteProperty -Name $prop.name -Value "Key [$(($keyAttribute.Group | select -ExpandProperty $prop.Name) -join ',')]"
                }
                $key | Add-Member -MemberType NoteProperty -Name "KeyAttributes" -Value @()
                [array]@($($keyAttribute.Group | select -ExpandProperty schemaName)) | % {
                    $key.KeyAttributes+="$($publisherPrefix)_$(($_).ToLower())"
                }
            }
            if ($null -ne $key) {$keys+=$key}
        }
        $schema | Add-Member -MemberType NoteProperty -Name "keys" -Value $keys

        $schema.entities | ? {$null -ne $_} | %{
            $entity=$_
            $entity | Add-Member -MemberType NoteProperty -Name "_definitionObject" -Value $(Get-entityDefinitionObject -entity $entity -attributes $schema.attributes -publisherPrefix $publisherPrefix)
        }
        $schema.attributes | ? {$null -ne $_} | %{
            $attribute=$_
            $attribute | Add-Member -MemberType NoteProperty -Name "_definitionObject" -Value $(Get-attributeDefinitionObject -attribute $attribute -publisherPrefix $publisherPrefix)
            if ($attribute.Type -eq "Boolean") {
                $attribute | Add-Member -MemberType NoteProperty -Name "_definitionObjectOptionTrue" -Value $(Get-BooleanOptionSetDefinitionObjectTrue -attribute $attribute -publisherPrefix $publisherPrefix)
                $attribute | Add-Member -MemberType NoteProperty -Name "_definitionObjectOptionFalse" -Value $(Get-BooleanOptionSetDefinitionObjectFalse -attribute $attribute -publisherPrefix $publisherPrefix)
            }
        }
        $schema.keys | ? {$null -ne $_} | %{
            $key=$_
            $key | Add-Member -MemberType NoteProperty -Name "_definitionObject" -Value $(Get-keyDefinitionObject -key $key -publisherPrefix $publisherPrefix)
        }
        $schema.relationships | ? {$null -ne $_} | %{
            $relationship=$_
            $relationship | Add-Member -MemberType NoteProperty -Name "_definitionObject" -Value $(Get-relationshipDefinitionObject -relationship $relationship -entities $schema.entities -attributes $schema.attributes -publisherPrefix $publisherPrefix)
        }
        $schema.optionsets | ? {$null -ne $_} | %{
            $optionset=$_
            $optionset | Add-Member -MemberType NoteProperty -Name "_definitionObject" -Value $(Get-optionsetDefinitionObject -optionset $optionset -options $schema.options -publisherPrefix $publisherPrefix)
        }
        $schema.options | ? {$null -ne $_} | %{
            $option=$_
            $option | Add-Member -MemberType NoteProperty -Name "_definitionObject" -Value $(Get-optionDefinitionObject -option $option -singleOption -publisherPrefix $publisherPrefix)
            $option | Add-Member -MemberType NoteProperty -Name "_definitionObjectUpdate" -Value $(Get-optionDefinitionObject -option $option -singleOption -forUpdateOptionValue -publisherPrefix $publisherPrefix)
        }
        $r=New-Result -success $true -message "Successfully loaded schema definition from excel" -value $schema
    } catch {
        $r=New-Result -success $false -message "Error loading excel definition" -exception $_.exception -logLevel "Error"
    }
    $r
}
Function Get-DVEntityDefinitions() {
    param(
        $entityName,
        $dvHeader,
        $searchField="",
        $envUrl,
        $publisherPrefix
    )
    try {
        $response=Invoke-WebRequest -uri "$($envUrl)/api/data/v9.0/$($entityName)" -Headers $dvHeader -Method Get -UseBasicParsing
        $dvEntities=$($response.Content | ConvertFrom-Json) | select -ExpandProperty value
        if ($searchField.length -gt 0) {
            $dvEntities=$dvEntities | ? {$_.$($searchField) -like "$($publisherPrefix)_*"}
        }
        $r=New-Result -success $true -message "Successfully retrieved DVEntityDefinitions $($entityName)" -value $dvEntities -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error retrieving DVEntityDefinitions $($entityName)" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-DVEntityDefinition() {
    param(
        $entityName,
        $metadataId,
        $definitionObject,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.0/$($entityName)($($metadataId))" -Headers $dvHeader -Method Put -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully set DVEntityDefinition [$($entityName)] $($definitionObject.schemaname)$($definitionObject.name)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error setting DVEntityDefinition [$($entityName)] $($definitionObject.schemaname)$($definitionObject.name): $($_.Exception.Response.StatusDescription)" -exception $_.exception -logLevel Error
    }
    $r
}
function Add-DVEntityDefinition() {
    param(
        $entityName,
        $definitionObject,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.0/$($entityName)" -Headers $dvHeader -Method Post -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully added DVEntityDefinition [$($entityName)] $($definitionObject.schemaname)$($definitionObject.name)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error adding DVEntityDefinition [$($entityName)] $($definitionObject.schemaname)$($definitionObject.name): $($_.Exception.Response)" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-DVEntityOptionSetValue() {
    param(
        $definitionObject,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.0/UpdateOptionValue" -Headers $dvHeader -Method Post -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully set DVEntityOptionSetValue for $($definitionObject.optionsetname)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error setting DVEntityOptionSetValue for $($definitionObject.optionsetname)" -exception $_.exception -logLevel Error
    }
    $r
}
function Add-DVEntityOptionSetValue() {
    param(
        $definitionObject,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.0/InsertOptionValue" -Headers $dvHeader -Method Post -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully added DVEntityOptionSetValue for $($definitionObject.optionsetname)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error adding DVEntityOptionSetValue for $($definitionObject.optionsetname)" -exception $_.exception -logLevel Error
    }
    $r
}
function Add-DVEntityAttribute() {
    param(
        $definitionObject,
        $entityMetadataID,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.0/EntityDefinitions($($entityMetadataID))/Attributes" -Headers $dvHeader -Method Post -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully added DVEntityAttribute $($definitionObject.schemaname)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error adding DVEntityAttribute $($definitionObject.schemaname)" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-DVEntityAttribute() {
    param(
        $definitionObject,
        $entityMetadataID,
        $attributeMetadataID,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.0/EntityDefinitions($($entityMetadataID))/Attributes($attributeMetadataID)/$($definitionObject.'@odata.type')" -Headers $dvHeader -Method Put -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully set DVEntityAttribute $($definitionObject.schemaname)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error setting DVEntityAttribute $($definitionObject.schemaname)" -exception $_.exception -logLevel Error
    }
    $r
}
function Add-DVEntityKey() {
    param(
        $definitionObject,
        $entityMetadataID,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.0/EntityDefinitions($($entityMetadataID))/Keys" -Headers $dvHeader -Method Post -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully added DVEntityKey $($definitionObject.schemaname)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error adding DVEntityKey $($definitionObject.schemaname)" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-DVEntityKey() {
    param(
        $definitionObject,
        $entityMetadataID,
        $keyMetadataID,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.0/EntityDefinitions($($entityMetadataID))/Keys($keyMetadataID)/$($definitionObject.'@odata.type')" -Headers $dvHeader -Method Put -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully set DVEntityKey $($definitionObject.schemaname)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error setting DVEntityKey $($definitionObject.schemaname)" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-DVEntityAttributeBooleanOptionValue() {
    param(
        $defintionObject,
        $dvHeader,
        $envUrl
    )
    try {
        $response=Invoke-WebRequest -Uri "$($envUrl)/api/data/v9.2/UpdateOptionValue" -Headers $dvHeader -Method Post -Body $($definitionObject | ConvertTo-Json -Depth 100) -ContentType "application/json; charset=utf-8" -UseBasicParsing
        $r=New-Result -success $true -message "Successfully set DVEntityAttributeBooleanOptionValue for $($defintionObject.AttributeLogicalName)" -value $response -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Error setting DVEntityAttributeBooleanOptionValue for $($defintionObject.AttributeLogicalName)" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-SchemaDVOptionsets() {
    param(
        $dvHeader,
        $schema,
        [switch]$onlyNewOptionSets,
        [switch]$onlyNewOptions,
        $envUrl,
        $publisherPrefix
    )
    try {
        $r=Get-DVEntityDefinitions -entityName "GlobalOptionSetDefinitions" -searchField "name" -dvHeader $dvHeader -envUrl $envUrl -publisherPrefix $publisherPrefix | Write-Result
        if ($r.Success) {
            $dvOptionSets=$r.Value
            $schema.optionsets | ? {$null -ne $_} | % {
                $schemaOptionSet=$_
                if ($schemaOptionSet._definitionObject.Name -in $($dvOptionSets | select -ExpandProperty name)) {
                    #option set exists
                    if (!($onlyNewOptionSets)) {
                        $dvOptionSet=$dvOptionSets | ? {$_.name -eq $schemaOptionSet._definitionObject.Name}
                        $r=Set-DVEntityDefinition -envUrl $envUrl -entityName "GlobalOptionSetDefinitions" -metadataId $dvOptionSet.MetadataId -definitionObject $schemaOptionSet._definitionObject -dvHeader $dvHeader | Write-Result
                        $schema.options | ? {$_.optionsetname -eq $schemaOptionSet.Name} | %{
                            $schemaOption=$_
                            if ($schemaOption._definitionObject.Value -in $($dvOptionSet.Options | select -ExpandProperty value)) {
                                #option exists; must use _definitionObjectUpdate because of "mergelabels"-attribute
                                if (!($onlyNewOptions)) {
                                    $r=Set-DVEntityOptionSetValue -envUrl $envUrl -definitionObject $schemaoption._definitionObjectUpdate -dvHeader $dvHeader | Write-Result
                                }
                            } else {
                                #new option
                                $r=Add-DVEntityOptionSetValue -envUrl $envUrl -definitionObject $schemaoption._definitionObject -dvHeader $dvHeader | Write-Result
                            }
                        }
                    }
                } else {
                    #new option set
                    $r=Add-DVEntityDefinition -envUrl $envUrl -entityName "GlobalOptionSetDefinitions" -definitionObject $schemaOptionSet._definitionObject -dvHeader $dvHeader | Write-Result                    
                }          
            }
            $r=New-Result -success $true -message "Finished applying optionsets to dataverse" -logLevel Information
        }
    } catch {
        $r=New-Result -success $false -message "Generic error applying optionsets to dataverse" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-SchemaDVEntities() {
    param(
        $dvHeader,
        $schema,
        $filter=@(),
        [switch]$onlyNewAttributes,
        [switch]$onlyNewKeys,
        $envUrl,
        $publisherPrefix
    )
    try {
        $r=Get-DVEntityDefinitions -entityName "EntityDefinitions" -searchField "schemaName" -dvHeader $dvHeader -envUrl $envUrl -publisherPrefix $publisherPrefix | Write-Result
        if ($r.Success) {
            $dvEntities=$r.Value
            $schema.entities | ? {$null -ne $_} | % {
                $schemaEntity=$_
                if ($filter.length -eq 0 -or $schemaEntity.schemaName -in $filter) {      
                    if ($schemaEntity._definitionObject.SchemaName -in $($dvEntities | select -ExpandProperty SchemaName)) {
                        #entity exists
                        $dvEntity=$dvEntities | ? {$_.SchemaName -eq $schemaEntity._definitionObject.SchemaName}
                        $r=Set-DVEntityDefinition -envUrl $envUrl -entityName "EntityDefinitions" -metadataId $dvEntity.MetadataId -definitionObject $schemaEntity._definitionObject -dvHeader $dvHeader | Write-Result                    
                        #must load entity attributes separately
                        $r=Get-DVEntityDefinitions -entityName "EntityDefinitions($($dventity.MetadataId))/Attributes" -searchField "schemaName" -dvHeader $dvHeader -envUrl $envUrl -publisherPrefix $publisherPrefix | Write-Result
                        $dvAttributes=$r.Value
                        $schema.attributes | ? {$_.entity -eq $schemaEntity.schemaName} | %{
                            $schemaAttribute=$_
                            if ($schemaAttribute._definitionObject.schemaname -in $($dvAttributes | select -ExpandProperty schemaname)) {
                                #attribute exists
                                if (!($onlyNewAttributes)) {
                                    $dvAttribute=$dvAttributes | ? {$_.schemaName -eq $schemaAttribute._definitionObject.SchemaName}                            
                                    $r=Set-DVEntityAttribute -envUrl $envUrl -definitionObject $schemaAttribute._definitionObject -entityMetadataID $dvEntity.MetadataId -attributeMetadataID $dvAttribute.MetadataId -dvHeader $dvHeader | Write-Result
                                }
                            } else {
                                #new attribute
                                $r=Add-DVEntityAttribute -envUrl $envUrl -definitionObject $schemaAttribute._definitionObject -entityMetadataID $dvEntity.MetadataId -dvHeader $dvHeader | Write-Result
                            }
                        }


                        #load entity keys
                        $r=Get-DVEntityDefinitions -entityName "EntityDefinitions($($dventity.MetadataId))/Keys" -searchField "schemaName" -dvHeader $dvHeader -envUrl $envUrl -publisherPrefix $publisherPrefix | Write-Result
                        $dvKeys=$r.Value
                        $schema.keys | ? {$_.entity -eq $schemaEntity.schemaName} | %{
                            $schemaKey=$_
                            if ($schemaKey._definitionObject.schemaname -in $($dvKeys | select -ExpandProperty schemaname)) {
                                #key exists --> updating keys is not supported
                                #if (!($onlyNewKeys)) {
                                #    $dvKey=$dvKeys | ? {$_.schemaName -eq $schemaKey._definitionObject.SchemaName}                            
                                #    $r=Set-DVEntityKey -envUrl $envUrl -definitionObject $schemaKey._definitionObject -entityMetadataID $dvEntity.MetadataId -keyMetadataID $dvKey.MetadataId -dvHeader $dvHeader | Write-Result
                                #}
                            } else {
                                #new attribute
                                $r=Add-DVEntityKey -envUrl $envUrl -definitionObject $schemaKey._definitionObject -entityMetadataID $dvEntity.MetadataId -dvHeader $dvHeader | Write-Result
                            }
                        }
                    } else {
                        #new entity
                        $r=Add-DVEntityDefinition -envUrl $envUrl -entityName "EntityDefinitions" -definitionObject $schemaEntity._definitionObject -dvHeader $dvHeader | Write-Result                    
                    }               
                }
            }
            $r=New-Result -success $true -message "Finished applying entities to dataverse" -logLevel Information
        }
    } catch {
        $r=New-Result -success $false -message "Generic error applying entities to dataverse" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-SchemaDVRelationShips() {
    param(
        $dvHeader,
        $schema,
        $envUrl,
        $publisherPrefix
    )
    try {
        $r=Get-DVEntityDefinitions -entityName "RelationshipDefinitions" -searchField "schemaName" -dvHeader $dvHeader -envUrl $envUrl -publisherPrefix $publisherPrefix | Write-Result
        if ($r.Success) {
            $dvRelationships=$r.Value
            $schema.relationships | ? {$null -ne $_} | % {
                $schemaEntity=$_
                if ($schemaEntity._definitionObject.SchemaName -in $($dvRelationships | select -ExpandProperty SchemaName)) {
                    #entity exists
                    $dvRelationship=$dvRelationships | ? {$_.SchemaName -eq $schemaEntity._definitionObject.SchemaName}
                    $r=Set-DVEntityDefinition -envUrl $envUrl -entityName "RelationshipDefinitions" -metadataId $dvRelationship.MetadataId -definitionObject $schemaEntity._definitionObject -dvHeader $dvHeader | Write-Result
                } else {
                    #new entity
                    $r=Add-DVEntityDefinition -envUrl $envUrl -entityName "RelationshipDefinitions" -definitionObject $schemaEntity._definitionObject -dvHeader $dvHeader | Write-Result                    
                }               
            }
            $r=New-Result -success $true -message "Finished applying relationships to dataverse" -logLevel Information
        }
    } catch {
        $r=New-Result -success $false -message "Generic error applying relationships to dataverse" -exception $_.exception -logLevel Error
    }
    $r
}
function Set-SchemaDVBooleanOptionSets() {
    param(
        $schema,
        $dvHeader,
        $envUrl,
        $publisherPrefix
    )
    try {
        $schema.attributes | ? {$_.type -eq "Boolean"} |  %{
            $schemaattribute=$_
            $r=Set-DVEntityAttributeBooleanOptionValue -envUrl $envUrl -defintionObject $schemaattribute._definitionObjectOptionTrue -dvHeader $dvHeader | Write-Result
            $r=Set-DVEntityAttributeBooleanOptionValue -envUrl $envUrl -defintionObject $schemaattribute._definitionObjectOptionFalse -dvHeader $dvHeader | Write-Result
        }
        $r=New-Result -success $true -message "Finished applying boolean optionsets to dataverse" -logLevel Information
    } catch {
        $r=New-Result -success $false -message "Generic error applying boolean optionsets to dataverse" -exception $_.exception -logLevel Error
    }
    $r
}
