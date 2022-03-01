#################################################################################
# Check for a DVD drive and change its drive letter
#################################################################################
$dvdDrive = Get-WmiObject win32_volume -filter DriveType=5
if ($dvdDrive -and $dvdDrive.DriveLetter -eq "D:")
{
    $dvdDrive.DriveLetter = "G:"
    $dvdDrive.Put()
}

#################################################################################
# Create the D: volume, let it fill the the rest of the disk
#################################################################################
Get-Disk | where partitionstyle -eq \"raw\" | Initialize-Disk -PartitionStyle GPT -PassThru

if (!(Test-Path D:))
{
    new-partition -DriveLetter D -DiskNumber 1 -UseMaximumSize
}

Format-Volume D -Confirm:$false -NewFileSystemLabel "Data"

if (!(Test-Path P:))
{
    new-partition -DriveLetter P -DiskNumber 2 -UseMaximumSize
}

Format-Volume D -Confirm:$false -NewFileSystemLabel "PageFile"
