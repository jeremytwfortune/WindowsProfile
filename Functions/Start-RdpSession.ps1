function Start-RdpSession {
	[CmdletBinding()] param (
		[Parameter( Mandatory )]
		[System.Management.Automation.Runspaces.PSSession[]] $Session,

		[Parameter( Mandatory )]
		[PSCredential] $Credential
	)

	$Targets = ( $Session ).ComputerName

	if ( ! $Targets ) {
		throw "Target list is empty."
	}
	$Targets | %{
		Write-Verbose "Setting credential for $_"
		$pass = $Credential.GetNetworkCredential().Password -Replace "'", "''"
		Invoke-Expression "cmdkey /generic:TERMSRV/$_ /user:$($Credential.UserName) /pass:'$pass'" 1>$Null

		Write-Verbose "Starting connection for $_"
		Invoke-Expression "mstsc /v:$_"
	}
}
