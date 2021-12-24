# Script to build the AD objects in greensafe.lab

# Create the OU Staff
New-ADOrganizationalUnit -Name "Staff" -Path "DC=greensafe,DC=lab"

# Create the needed groups
$ADgrpnames_array=@("Team_IT","Team_Security","Team_Helpdesk","Team_Sales","Team_Auditors","Team_Contractors","Team_Finance","Team_UNIXAdmins","Team_UNIXDBA","Team_WindowsDBA")

foreach($ADgrpname in $ADgrpnames_array){
    New-ADGroup -Name $ADgrpname -SamAccountName $ADgrpname -GroupCategory Security -GroupScope Global -Path "OU=Staff,DC=greensafe,DC=lab"
}

# Create users and put them in the correct ADGroup
$user_list=Import-CSV "users.csv"

# Start the loop
foreach($user in $user_list){
    # Build the variables for clean reading
    $firstname=$user.First_name
    $lastname=$user.last_name
    $account=$user.Account
    $grps=$user.Groups
    $user_name=$firstname+" "+$lastname
    $UPN=$account+"@greensafe.lab"
    # If we have an admin account (-a) it needs to go into the Users OU. Rest in Staff OU
    if ($account -like "*-a"){
        New-ADUser -Name $user_name -GivenName $firstname -Surname $lastname `
                   -SamAccountName $account -UserPrincipalName $UPN  -Path "CN=Users,DC=greensafe,DC=lab" `
                   -Enabled $true -AccountPassword ("Centr1fy"| ConvertTo-SecureString -AsPlainText -Force) `
                   -ChangePasswordAtLogon $false -PasswordNeverExpires $true
        echo "Admin account $account created"
     }else{
        New-ADUser -Name $user_name -GivenName $firstname -Surname $lastname `
                   -SamAccountName $account -UserPrincipalName $UPN  -Path "OU=Staff,DC=greensafe,DC=lab" `
                   -Enabled $true -AccountPassword ("Centr1fy"| ConvertTo-SecureString -AsPlainText -Force) `
                   -ChangePasswordAtLogon $false -PasswordNeverExpires $true
        echo "Normal account $account created"
    }

    # Remove the leading and ending ( ) chars from the field
    $UsrGrps=$grps.replace(')','')
    $UsrGrps=$UsrGrps.replace('(','')
    
    # Put the rest of the file in a array
    $UsrGRP_Array=@($UsrGrps.split(';'))

    # Check if the size of the array[0] is >0 otherwise we get an error
    if ($UsrGRP_Array[0].Length -gt 0){
        foreach($UsrGroup in $UsrGRP_Array){
            if ([int]$UsrGroup.Length -eq 1) {
                #echo $ADgrpnames_array[$UsrGroup]
                Add-ADGroupMember -Identity $ADgrpnames_array[$UsrGroup] -Members $account
                echo $ADgrpnames_array[$UsrGroup]+" has member $account added"
            }else{
                echo $UsrGroup
                Add-ADGroupMember -Identity $UsrGroup.replace('"','') -Members $account
                echo "$UsrGroup has member $account added"
            }
        } 
    }else{ 
        echo "No groups found for $account"
    }
}