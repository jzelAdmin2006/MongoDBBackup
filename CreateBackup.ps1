$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$BackupRootPath = Join-Path -Path $ScriptPath -ChildPath "db_backup"

if (-not (Test-Path $BackupRootPath -PathType Container)) {
    New-Item -ItemType Directory -Path $BackupRootPath | Out-Null
}

$DateString = (Get-Date).ToString("yyyyMMddHHmmss")

$BackupPath = Join-Path -Path $BackupRootPath -ChildPath ($DateString + "_db_restaurant")

$Password = Get-Content (Join-Path $PSScriptRoot "Password.txt")

mongodump --uri="mongodb+srv://cluster0.9cilpzg.mongodb.net" --db=db_restaurant --username=jzelAdmin --password=$Password --out=$BackupPath 2>&1 > $null

Get-ChildItem -Directory $BackupRootPath | Sort-Object CreationTime | Select-Object -SkipLast 10 | Remove-Item -Recurse -Force