<# 
  .SYNOPSIS  
    Send a WOL packet to a broadcast address  Usage: SendWOL [MAC address]

  .PARAMETER
   The MAC address of the device that need to wake up (will accept either : or - separators)

  .EXAMPLE
  .\SendWOL 74:D0:2B:7C:8E:B3
#>

[CmdletBinding()]
Param(
	[Parameter(Mandatory=$True,Position=1)]
	[string]$mac
	)

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
