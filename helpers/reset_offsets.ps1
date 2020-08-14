#!/usr/bin/env pwsh

# Go into the parent folder of application
# this is where the install.sql file is located
# Then run below commands or call this file

$fileName = Get-ChildItem "./application/*.sql" -Recurse 
$filename | %{ 
    (gc $_) -replace "p_default_id_offset.*","p_default_id_offset=>0" |Set-Content $_.fullname 
} 
