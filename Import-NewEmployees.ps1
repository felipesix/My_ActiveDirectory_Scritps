. 'C:\Users\Administrator\Documents\Powershell Scripts\AdAccountManagementAutomator.ps1'

$Employees = Import-CSV -Path 'C:\users\Administrator\Documents\Powershell Scripts\new_employees.csv'

foreach($Employee in $Employees){    
# Create the AD user accounts
    try { 
        $NewUserParams   = @{
            'FirstName'  = $Employee.FirstName        
            'LastName'   = $Employee.LastName
            'Title'      = $Employee.Title        
        }
            if($Employee.MiddleName){
                $NewUserParams.MiddleName = $Employee.MiddleName
            }
            if($Employee.Group){
                $NewUserParams.Group = $Employee.Group
            }
# Grab the username created to use for Set-MyAdUser    
        $username = NewADUser @NewUserParams

# Create the employee's AD computer account
        NewADcomputer -computername $Employee.ComputerName
    
# Set The description for the employee's computer account
        Set-MyADcomputer -computername $Employee.ComputerName -Attributes @{
            'Description' = "$($Employee.FirstName) $($Employee.Lastname)'s computer"
        }
    
#Set the department the employee is in
        Set-MyAdUser -username $username -attributes @{
            'Department' = $Employee.Department
        }
         
    } 
    catch{
        Write-Error "$($_.Execption.Message) - Line Number : $($_.InvocationInfo.ScriptLineNumber)"
    }
} 
