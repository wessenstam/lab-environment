# Script to build the AD objects in thylab.local

# Create the OUs
$AD_OUs_array=@("DemoAccounts","SecretServer","SecurityGroups")
foreach($OU in $AD_OUs_array){
    New-ADOrganizationalUnit -Name $OU -Path "DC=thylab.local"
}

# Create the needed groups
$ADgrpnames_array=@("IT - Database Team","IT - Desktop Team","IT - Server Team","IT - Unix Team","Secret Server Administrators", `
                    "Development Team","Finance Team","IT Engineering Team","Privilege Manager Administrators","Sales Team" ` 
                    )

foreach($ADgrpname in $ADgrpnames_array){
    New-ADGroup -Name $ADgrpname -SamAccountName $ADgrpname -GroupCategory Security -GroupScope Global -Path "OU=SecurityGroups,DC=thylab.local"
}


# Create users and put them in the correct ADGroup
$user_list=Import-CSV "users-secretserver.csv"

# Start the loop
foreach($user in $user_list){
    # Build the variables for clean reading
    $firstname=$user.First_name
    $lastname=$user.last_name
    $account=$user.Account
    $grps=$user.Groups
    $user_name=$firstname+" "+$lastname
    $UPN=$account+"@greensafe.lab"
    $OU=$user.OU
    # If No OU given, then in Users
    if ($OU.Length -eq 0){
        New-ADUser -Name $user_name -GivenName $firstname -Surname $lastname `
                   -SamAccountName $account -UserPrincipalName $UPN  -Path "CN=Users,DC=thylab.local" `
                   -Enabled $true -AccountPassword ("Centr1fy"| ConvertTo-SecureString -AsPlainText -Force) `
                   -ChangePasswordAtLogon $false -PasswordNeverExpires $true
    # OU is not empty
    }else{
        New-ADUser -Name $user_name -GivenName $firstname -Surname $lastname `
                   -SamAccountName $account -UserPrincipalName $UPN -Path "OU=$OU,DC=thylab.local" `
                   -Enabled $true -AccountPassword ("Centr1fy"| ConvertTo-SecureString -AsPlainText -Force) `
                   -ChangePasswordAtLogon $false -PasswordNeverExpires $true
    }

    echo "Account $account created"

    # Remove the leading and ending ( ) chars from the field
    $UsrGrps=$grps.replace(')','')
    $UsrGrps=$UsrGrps.replace('(','')
    
    # Put the rest of the file in a array
    $UsrGRP_Array=@($UsrGrps.split(';'))

    # Check if the size of the array[0] is >0 otherwise we get an error
    if ($UsrGRP_Array[0].Length -gt 0){
        foreach($UsrGroup in $UsrGRP_Array){
            if ([int]$UsrGroup.Length -eq 1) {
                Add-ADGroupMember -Identity $ADgrpnames_array[$UsrGroup] -Members $account
                echo $ADgrpnames_array[$UsrGroup]+" has member $account added"
            }else{
                Add-ADGroupMember -Identity $UsrGroup.replace('"','') -Members $account
                echo "$UsrGroup has member $account added"
            }
        } 
    }else{ 
        echo "No groups found for $account"
    }
}