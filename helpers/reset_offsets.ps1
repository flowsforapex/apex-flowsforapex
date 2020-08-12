# Go into the parent folder of application
# this is where the install.sql file is located
# Then run these commands

$fileName = Get-ChildItem "./application/*.sql" -Recurse 
$filename | %{ 
    (gc $_) -replace "p_default_id_offset.*","p_default_id_offset=>0" |Set-Content $_.fullname 
} 
