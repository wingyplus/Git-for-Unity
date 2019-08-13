<#
.SYNOPSIS
	Packages a build of GitHub for Unity
.DESCRIPTION
	Packages a build of GitHub for Unity
.PARAMETER PathToPackage
	Path to the Package folder that contains all the binaries and meta files
	<root>\unity\PackageProject
.PARAMETER OutputFolder
	Folder to put the package files
.PARAMETER PackageName
	Name of the package (usually github-for-unity-[version]). The script will add
	the appropriate extensions to the generated files.
#>

[CmdletBinding()]

Param(
	[string]
	$Source,
	[string]
	$Out,
	[string]
	$Name,
	[string]
	$Version,
	[string]
	$Extra,
	[string]
	$Ignore,
	[string]
	$BaseInstall,
	[switch]
	$Skip,
	[switch]
	$SkipUnity,
	[switch]
	$SkipPackman,
	[string]
	$Tmp,
	[switch]
	$Trace = $false
)

Set-StrictMode -Version Latest
if ($Trace) {
	Set-PSDebug -Trace 1
}

. $PSScriptRoot\helpers.ps1 | out-null

Push-Location $scriptsDirectory

try {

	if (!(Test-Path 'node_modules')) {
		Run-Command -Fatal { & node ..\yarn.js -s install --prefer-offline }
	}

	$noPackage = ""
	$noUnity = ""
	$noPackman = ""

	if ($Skip) {
		$noPackage = "-k"
	}
	if ($SkipUnity) {
		$noUnity = "-u"
	}
	if ($SkipPackman) {
		$noPackman = "-p"
	}

	Run-Command -Fatal { & node ..\yarn.js -s start -o $Out -n $Name -v $Version -s $Source -i $Ignore -e $Extra -t $BaseInstall --tmp $Tmp $noPackage $noUnity $noPackman }

} finally {
	Pop-Location
}