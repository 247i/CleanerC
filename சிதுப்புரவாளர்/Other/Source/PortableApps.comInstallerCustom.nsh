!macro CustomCodePreInstall
	${If} ${FileExists} "$INSTDIR\App\AppInfo\appinfo.ini"
	${AndIf} ${FileExists} "$INSTDIR\Data\ccleaner.ini"
		ReadINIStr $0 "$INSTDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${VersionCompare} $0 "5.77.0.0" $R0
		${If} $R0 == 2
			WriteINIStr "$INSTDIR\Data\ccleaner.ini" "Options" "UpdateBackground" "0"
			WriteINIStr "$INSTDIR\Data\ccleaner.ini" "Options" "UpdateCheck" "0"
		${EndIf}
	${EndIf}
!macroend
