; Define KISS application name and version number
!define APPNAME "KISS Platform"
!define APPMAJORVERSION "4"
!define APPMINORVERSION "0"
!define BUILDNUMBER "3"
!define APPVERSIONSTRING "Oxygen"

!define VERSION "${APPMAJORVERSION}.${APPMINORVERSION}.${BUILDNUMBER}"
!define INSTALL_FILENAME "KISS Platform ${APPMAJORVERSION}.${APPMINORVERSION}.${BUILDNUMBER}"

!define APPNAMEANDVERSION "${APPNAME} ${VERSION}"

!define MINGW_DIR "C:\MinGW"
!define KISS_PLATFORM_DIR "${MINGW_DIR}\msys\1.0\home\kipr\kiss-platform"

!define MINGW_DLLS_DIR "${MINGW_DIR}\bin"
!define QT_DLLS_DIR "C:\Qt\lib"

;Files driver installer utility files
!include "nsis-lib\winver.nsh"
!include "nsis-lib\drvsetup.nsh"
!include "nsis-lib\windrvinstall.nsh"

; Main Install settings

;; What do we call the installer?
Name "${APPNAMEANDVERSION}"

;; Where should the installer put files when it runs?
InstallDir "$PROGRAMFILES\${APPNAMEANDVERSION}"

;; where do we put the installer after building it?
OutFile "..\releases\${INSTALL_FILENAME}.exe"

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "gpl-3.0.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

!define LOCAL_DLL_DIR "${KISS_PLATFORM_DIR}\common\prefix\lib"

!define KISS_IDE_DIR "${KISS_PLATFORM_DIR}\common\package\kiss"
!define KS2_DIR "${KISS_PLATFORM_DIR}\common\package\ks2"
!define COMPUTER_DIR "${KISS_PLATFORM_DIR}\common\package\computer"

Section "KISS IDE ${VERSION} ${APPVERSIONSTRING}" KISSIDE
	SetOverwrite on
	SectionIn RO
	
	SetOutPath "$INSTDIR"
	File /r "${KISS_IDE_DIR}"
	SetOutPath "$INSTDIR\kiss"
	File "${QT_DLLS_DIR}\QtCore4.dll"
	File "${QT_DLLS_DIR}\QtGui4.dll"
	File "${QT_DLLS_DIR}\QtSql4.dll"
	File "${QT_DLLS_DIR}\QtScript4.dll"
	File "${QT_DLLS_DIR}\QtDeclarative4.dll"
	File "${QT_DLLS_DIR}\QtNetwork4.dll"
	File "${QT_DLLS_DIR}\QtScriptTools4.dll"
	File "${QT_DLLS_DIR}\QtXml4.dll"
	File "${QT_DLLS_DIR}\QtXmlPatterns4.dll"
	File "${QT_DLLS_DIR}\qscintilla2.dll"
	
	File "${MINGW_DLLS_DIR}\mingwm10.dll"
	File "${MINGW_DLLS_DIR}\libgcc_s_dw2-1.dll"
	File "${MINGW_DLLS_DIR}\libstdc++-6.dll"
	
	
	CreateShortCut "$DESKTOP\KISS IDE ${VERSION}.lnk" "$INSTDIR\kiss\KISS.exe"
	CreateDirectory  "$SMPROGRAMS\${INSTALL_FILENAME}"
	CreateShortCut "$SMPROGRAMS\${INSTALL_FILENAME}\KISS IDE ${VERSION}.lnk" "$INSTDIR\kiss\KISS.exe"
SectionEnd

Section "MinGW Compiler" MINGW_COMPILER
	SectionIn RO
	SetOutPath "$INSTDIR"
	File /r "C:\Redist\MinGW"
SectionEnd

Section "KIPR's 2D Simulator" KS2
	SectionIn RO
	SetOutPath "$INSTDIR\"
	
	File /r "${KS2_DIR}"
	SetOutPath "$INSTDIR\ks2"
	
	File "${QT_DLLS_DIR}\QtCore4.dll"
	File "${QT_DLLS_DIR}\QtGui4.dll"
	File "${QT_DLLS_DIR}\QtNetwork4.dll"
	File "${MINGW_DLLS_DIR}\mingwm10.dll"
	File "${MINGW_DLLS_DIR}\libgcc_s_dw2-1.dll"
	File "${MINGW_DLLS_DIR}\libstdc++-6.dll"
	File "${MINGW_DLLS_DIR}\libgmp-10.dll"
	File "${MINGW_DLLS_DIR}\libmpc-2.dll"
	File "${MINGW_DLLS_DIR}\libmpfr-1.dll"
	File "${MINGW_DLLS_DIR}\libiconv-2.dll"
	File "${MINGW_DLLS_DIR}\pthreadGC2.dll"

	CreateShortCut "$DESKTOP\KIPR's 2D Simulator ${VERSION}.lnk" "$INSTDIR\ks2\ks2.exe"
	CreateShortCut "$SMPROGRAMS\${INSTALL_FILENAME}\KIPR's 2D Simulator ${VERSION}.lnk" "$INSTDIR\ks2\ks2.exe"
SectionEnd

Section "KISS IDE Computer Target" COMPUTER
	SectionIn RO
	SetOutPath "$INSTDIR\"
	
	File /r "${COMPUTER_DIR}"
	SetOutPath "$INSTDIR\computer"
	
	File /r "${COMPUTER_DIR}\prefix"
	
	File "${QT_DLLS_DIR}\QtCore4.dll"
	File "${QT_DLLS_DIR}\QtGui4.dll"
	File "${QT_DLLS_DIR}\QtNetwork4.dll"

	CreateShortCut "$DESKTOP\KISS IDE ${VERSION} Computer Target.lnk" "$INSTDIR\computer\computer.exe"
	CreateShortCut "$SMPROGRAMS\${INSTALL_FILENAME}\KISS IDE ${VERSION} Computer Target.lnk" "$INSTDIR\computer\computer.exe"
SectionEnd

Section "KIPR Link Driver" LINK
	SetOutPath "$WINDIR\KIPRLinkDriver"
	
	File "${KISS_PLATFORM_DIR}\common\kiss\scripts\kiprlink.inf"
	
	Push "$WINDIR\KIPRLinkDriver"
	;  -- the directory of the .inf file
	Push "$WINDIR\KIPRLinkDriver\kiprlink.inf"
	;  -- the filepath of the .inf file (directory + filename)
	Push "USB\VID_0525&PID_A4A7"
	;  -- the HID (Hardware ID) of your device
  
	Call InstallUpgradeDriver
SectionEnd

Section -FinishSection
	WriteRegStr HKLM "Software\${APPNAMEANDVERSION}" "" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAMEANDVERSION}" "DisplayName" "${APPNAMEANDVERSION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAMEANDVERSION}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteUninstaller "$INSTDIR\uninstall.exe"
SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${KISSIDE} "KISS IDE ${VERSION} ${APPVERSIONSTRING}"
!insertmacro MUI_DESCRIPTION_TEXT ${LINK} "KIPR Link Driver"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstall section
Section Uninstall
	;Remove from registry...
	DeleteRegKey HKLM "SOFTWARE\${APPNAMEANDVERSION}"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAMEANDVERSION}"

	; Delete self
	Delete "$INSTDIR\uninstall.exe"

	; Delete Desktop Short Cut and Start Menu Entry
	Delete "$DESKTOP\KISS IDE*.lnk"
	Delete "$SMPROGRAMS\${APPNAMEANDVERSION}\${APPNAMEANDVERSION}.lnk"
	RMDir  "$SMPROGRAMS\${APPNAMEANDVERSION}"

	; Clean up KISS Platform
	RMDir /r "$INSTDIR\"
SectionEnd

BrandingText "KISS Institute For Practical Robotics"
