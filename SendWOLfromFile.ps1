<# 
  .SYNOPSIS  
    Send a WOL packet to a broadcast address  Usage: SendWOL [filename.txt]

  .PARAMETER
   The path of a text file containing MAC addresses (one per line)

  .EXAMPLE
  .\SendWOL MAC-list.txt
#>

[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$file
	)

Get-Content $file | ForEach-Object {

	$mac = $_

	## Construct the Magic Packet
	$MacByteArray = $mac -split "[:-]" | ForEach-Object { [Byte] "0x$_"}
	[Byte[]] $MagicPacket = (,0xFF * 6) + ($MacByteArray  * 16)

	## Create UDP client instance
	$UdpClient = New-Object System.Net.Sockets.UdpClient
	$UdpClient.Connect(([System.Net.IPAddress]::Broadcast),7) 

	## Broadcast the Packet
	$UdpClient.Send($MagicPacket,$MagicPacket.Length)
	Write-Host "Magic Packet sent to: $mac"

	## Close the resource
	$UdpClient.Close()

}
