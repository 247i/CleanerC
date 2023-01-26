${SegmentFile}

Var bolCustomRegistryExists
Var bolCustomCCleanerSkipUACTaskExists
Var strCustomCurrentUsername

${SegmentPrePrimary}
	StrCpy $bolCustomRegistryExists false
    ${If} $Bits == 64
		SetRegView 64
		ReadRegStr $0 HKLM "SOFTWARE\Piriform\CCleaner" "(Cfg)LastUpdate"
		${If} $0 != ""
			StrCpy $bolCustomRegistryExists true
		${EndIf}
		SetRegView 32
	${EndIf}
	
	System::Call "advapi32::GetUserName(t .r0, *i ${NSIS_MAX_STRLEN} r1) i.r2"
	StrCpy $strCustomCurrentUsername $0
	
	${If} ${FileExists} "$SYSDIR\Tasks\CCleanerSkipUAC - $strCustomCurrentUsername"
		StrCpy $bolCustomCCleanerSkipUACTaskExists true
	${EndIf}
!macroend

${SegmentPostPrimary}
    ${If} $Bits == 64
	${AndIf} $bolCustomRegistryExists == false
		SetRegView 64
			DeleteRegKey HKLM "SOFTWARE\Piriform\CCleaner"
			DeleteRegKey /ifempty HKLM "SOFTWARE\Piriform"
		SetRegView 32
	${EndIf}
	${If} $bolCustomCCleanerSkipUACTaskExists != true
		nsExec::Exec /TIMEOUT=10000 `"schtasks.exe" /delete /tn "CCleanerSkipUAC - $strCustomCurrentUsername" /f`
		Pop $0
	${EndIf}
!macroend