#Create MDT deployment share Simple format copied from view script option in Deployment Workbench after creating mannually
#Run this script if you want to simply create a Deployment share with deployment workbench with the name of MDT Production 
#Assuming that you have a folder in "E:\MDTProduction"
New-SmbShare -Name "MDT Production$" -Path "E:\MDTProduction" -FullAccess Administrators
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
new-PSDrive -Name "DS002" -PSProvider "MDTProvider" -Root "E:\MDTProduction" -Description "MDT Production" -NetworkPath "\\MDT01\MDT Production$" -Verbose | add-MDTPersistentDrive -Verbose

# Create MDT deployment share advanced from Deployment research dot com (Do not run this if you want to mannually configure options in Deployment workbench GUI.
$MDTServer = (get-wmiobject win32_computersystem).Name
$InstallDrive = "C:"
New-Item -Path $InstallDriveMDTProduction -ItemType directory
New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "$InstallDriveMDTProduction" -Description "MDT Production" -NetworkPath "$MDTServerMDTProduction$" | add-MDTPersistentDrive
New-SmbShare -Name MDTProduction$ -Path "$InstallDriveMDTProduction" -ChangeAccess EVERYONE

# Create optional MDT Media content
New-Item -Path $InstallDriveMEDIA001 -ItemType directory
New-PSDrive -Name "DS002" -PSProvider MDTProvider -Root "$InstallDriveMDTProduction"
New-Item -Path "DS002:Media" -enable "True" -Name "MEDIA001" -Comments "" -Root "$InstallDriveMEDIA001" -SelectionProfile "Nothing" -SupportX86 "False" -SupportX64 "True" -GenerateISO "False" -ISOName "LiteTouchMedia.iso" -Force -Verbose
New-PSDrive -Name "MEDIA001" -PSProvider "MDTProvider" -Root "$InstallDriveMEDIA001ContentDeploy" -Description "MDT Production Media" -Force -Verbose

# Update the MDT Media (and another round of creation because of a bug in MDT internal processing)
Update-MDTMedia -path "DS002:MediaMEDIA001" -Verbose
Remove-Item -path "DS002:MediaMEDIA001" -force -verbose
New-Item -path "DS002:Media" -enable "True" -Name "MEDIA001" -Comments "" -Root "$InstallDriveMEDIA001" -SelectionProfile "Everything" -SupportX86 "False" -SupportX64 "True" -GenerateISO "False" -ISOName "LiteTouchMedia.iso" -Verbose -Force
New-PSDrive -Name "MEDIA001" -PSProvider "MDTProvider" -Root "$InstallDriveMEDIA001ContentDeploy" -Description "MDT Production Media" -Force -Verbose