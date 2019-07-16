#$test = "String em variavel"
[int32]$Num = 40
#-----------------------------------
#array
$list_serv = @("gowacd01", "gowacd02")
echo $list_serv 
#substituir echo por write-Output
#-----------------------------------
$list_attrib = @{Server="gowacd01"; IP="10.62.1.23"}
$list_attrib.IP
#-----------------------------------
Get-Service | Where-Object{$_.DependentServices -ne $null}
Get-Service | ? DependentServices -ne $null
#-----------------------------------
$pc = Get-ComputerInfo
'{0} é o computador com processador {1}' -f $pc.CsName, $pc.CsProcessors
#-----------------------------------
$var01 = @("Carlos", "Garcia")
'Hello! {0} {1}' -f $var01
#-----------------------------------
$data = (Get-Date).AddDays(-45)
"{0:dd/MM/yyyy}" -f $data
#-----------------------------------
Get-ChildItem -Filter "*old*" -Recurse | Rename-Item -NewName {$_.Name -replace 'old','new'} -WhatIf
#-----------------------------------
1..5 | ForEach-Object { "The number is $_" }
#-----------------------------------
#Using ScriptBlock with Begin, Processing and End sections
$ProcessingSB = {
begin { '[Begin ] Starting' }
process { "[Process] $_" }
end { Write-Output '[End ] Finished' }
}
1, 2, 3 | & $ProcessingSB
#-----------------------------------
$p = Get-Process
$p | Where-Object { $_.WorkingSet -gt 20mb } 
#this is one way to show the process by WorkingSet
$p | Where-Object { $_.WorkingSet -gt 20mb } | Measure-Object WorkingSet -Sum -Average
#-----------------------------------
Write-Host "I am logged on as $env:USERDOMAIN\$env:USERNAME" -ForegroundColor Green
#-----------------------------------
#Working with variable chages
$n = "Carlos"
"I am $n" #Here the shell will change the variable for my name
'I am $n' #Here the shell will´t change the variable for my name
"The value of `$n is $n" #Here just the second variable will be changed by my name
"I am $n on computer $env:COMPUTERNAME"
#-----------------------------------
$s = Get-Service BITS
$s.DisplayName
"The $s.Displayname is $s.Status" #This will´t work
"The $($s.DisplayName) is $($s.Status)" #Use this insted the example above
#-----------------------------------
# Closing specfic objects that are open
Get-Process Calculator | foreach { Write-Host "Closing process $($_.id)" -ForegroundColor Yellow $_.CloseMainWindow() }
#-----------------------------------
$processes = Get-WmiObject Win32_Process -Filter "executablepath like '%'"
$paths = foreach ($process in $processes) {Get-Acl $process.executablepath}
$paths
#-----------------------------------
#Redirect errors to a text file
Get-WmiObject Win32_logicaldisk -ComputerName "FOO",$env:COMPUTERNAME 2>err.text 3>warn.txt 4>verbose.txt
#It´s possible to merge errors and succesfully output
Get-WmiObject Win32_logicaldisk -ComputerName "FOO",$env:COMPUTERNAME 2>&1 1>log.text 
#-----------------------------------
#Comparison, it´s possible to be Case Sensitive if you put letter "c" befor the Operators like this
-eq #equal
-ne #not equal
-gt #greater than
-ge #greater than or eequal
-Lt #less than
-le #less than or equal to
-Like #string comparison
-NotLike #string comparison
-Match #expression comparison ex.: $name -match "shell$"
-Contains #contain a value
-in #is a value in a array
-NotIn #isn´t a value in a array
#Turn on case sensitive
-ceq, -cne, -clike
#-----------------------------------
# Operators
= #assign a value
+= #add a value
-= #subtract a value
*= #multiply a value
/= #divide a value
++ #increase a value by 1
-- # derease a value by 1
#----------------------------------- 
#using operators
5 -gt 3
"jeff" -eq "JEFF"
"carlos" -ceq "CARLOS"
$arr = "a", "b", "c", "d"
$arr -contains "e"
$arr -contains "d"
$arr -notcontains "f"
#----------------------------------- 
$df = {(Get-CimInstance Win32_LogicalDisk -Filter "deviceid='c: '" -Property FreeSpace).FreeSpace/1gb}
&$df
#----------------------------------- 
Function Get-ComputerInformation {
[CmdletBinding()]
PARAM ($ComputerName)
$CompSystem = Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName
$Properties = @{
ComputerName = $ComputerName
Manufacturer = $ComputerName.Manufacturer
}
New-Object -TypeName Psobject -Property $Properties
}
#-----------------------------------
Get-Alias | Where-Object {$_.definition -match "Get-childitem"}
Get-Service | Where-Object {$_.status -eq 'running'} | Select-Object displayname
Get-Process | Format-List
Get-ChildItem C:\Windows | Where-Object {$_.Length -gt 50000} | Sort-Object -Property Length -Descending
Get-Process | Where-Object {($_.Handles -gt 500) -and ($_.PM -ne 0)}
Get-Process | Where-Object {($_.Handles -gt 500) -or ($_.PM -ne 0)}
Get-Process | Where-Object {($_.Handles -gt 100) -and -not ($_.Company -eq "Microsoft Corporation")}
#-----------------------------------

