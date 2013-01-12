; Define KISS application name and version number
!define APPNAME "KISS Platform"
!define APPMAJORVERSION "4"
!define APPMINORVERSION "0"
!define BUILDNUMBER "0"
!define APPVERSIONSTRING "Oxygen"

!define VERSION "${APPMAJORVERSION}.${APPMINORVERSION}.${BUILDNUMBER}"
!define INSTALL_FILENAME "KISS Platform ${APPMAJORVERSION}.${APPMINORVERSION}.${BUILDNUMBER}"

!define APPNAMEANDVERSION "${APPNAME} ${VERSION}"

!define MINGW_DIR "C:\MinGW"
!define KISS_PLATFORM_DIR "${MINGW_DIR}\msys\1.0\home\kipr\kiss-platform"

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

!define KISS_IDE_DIR "${KISS_PLATFORM_DIR}\common\kiss\deploy"
!define KS2_DIR "${KISS_PLATFORM_DIR}\common\ks2\deploy"

Section "KISS Platform ${VERSION} ${APPVERSIONSTRING}" KISSPLATFORM
	; Set Section properties
	SetOverwrite on  ; yes, we want to overwrite existing files
	SectionIn RO     ; no, we don't want people to be able to uncheck this section   
	
	SetOutPath "$INSTDIR\kiss\interfaces"
	File "${KISS_IDE_DIR}\interfaces\libkovan_interface.dll"
	File "${KISS_IDE_DIR}\interfaces\libkovan_serial_interface.dll"
	
	SetOutPath "$INSTDIR\kiss\lexers"
	File "${KISS_IDE_DIR}\lexers\libC_lexer.dll"
	File "${KISS_IDE_DIR}\lexers\libcpp_lexer.dll"
	File "${KISS_IDE_DIR}\lexers\libjava_lexer.dll"
	File "${KISS_IDE_DIR}\lexers\libpython_lexer.dll"
	
	SetOutPath "$INSTDIR\kiss"
	File "${KISS_IDE_DIR}\KISS.exe"
	File "${KISS_IDE_DIR}\libgcc_s_dw2-1.dll"
	File "${KISS_IDE_DIR}\mingwm10.dll"
	File "${KISS_IDE_DIR}\QtCore4.dll"
	File "${KISS_IDE_DIR}\QtWebKit4.dll"
	File "${KISS_IDE_DIR}\QtNetwork4.dll"
	File "${KISS_IDE_DIR}\QtGui4.dll"
	File "${KISS_IDE_DIR}\qscintilla2.dll"
	File "${KISS_IDE_DIR}\libkovanserial.dll"
	File "${KISS_IDE_DIR}\libpcompiler.dll"
	File "${KISS_IDE_DIR}\libkar.dll"
	File "${KISS_IDE_DIR}\qscintilla2.dll"
	File "${KISS_IDE_DIR}\QtScript4.dll"
	File "${KISS_IDE_DIR}\QtSql4.dll"
	File "${KISS_IDE_DIR}\QtXml4.dll"
	File "${KISS_IDE_DIR}\QtXmlPatterns4.dll"
	File "${KISS_IDE_DIR}\QtDeclarative4.dll"
	File "${KISS_IDE_DIR}\libstdc++-6.dll"
	
	SetOutPath "$INSTDIR\kiss"
	File "${KS2_DIR}\ks2.exe"
	File "${KISS_IDE_DIR}\libgcc_s_dw2-1.dll"
	File "${KISS_IDE_DIR}\mingwm10.dll"
	File "${KISS_IDE_DIR}\QtCore4.dll"
	File "${KISS_IDE_DIR}\QtNetwork4.dll"
	File "${KISS_IDE_DIR}\QtGui4.dll"
	File "${KISS_IDE_DIR}\libkovanserial.dll"
	File "${KISS_IDE_DIR}\libpcompiler.dll"
	File "${KISS_IDE_DIR}\libkar.dll"
	File "${KISS_IDE_DIR}\libstdc++-6.dll"
	
	File /r "${KS2_DIR}\prefix"
	
	SetOutPath "$INSTDIR"
	File /r "C:\Redist\MinGW"
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;End of KISS Files 
	
	
	; The change log isn't in the deploy directory so I'd probably forget it
	; File "..\doc\ChangeLog.txt"

	; Set the dlls and frameworks to hidden files on Windows
	SetFileAttributes "$INSTDIR\kiss\QtCore4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\QtGui4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\QtWebKit4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\QtNetwork4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\mingwm10.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\libgcc_s_dw2-1.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\qscintilla2.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\libkovanserial.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\libpcompiler.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\libkar.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\qscintilla2.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\QtScript4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\QtSql4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\QtXml4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\QtXmlPatterns4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\QtDeclarative4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\kiss\libstdc++-6.dll" FILE_ATTRIBUTE_HIDDEN
	
	SetFileAttributes "$INSTDIR\ks2\QtCore4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\QtGui4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\QtNetwork4.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\mingwm10.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\libgcc_s_dw2-1.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\libkovanserial.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\libpcompiler.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\libkar.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\qscintilla2.dll" FILE_ATTRIBUTE_HIDDEN
	SetFileAttributes "$INSTDIR\ks2\libstdc++-6.dll" FILE_ATTRIBUTE_HIDDEN
	
	; Set Up Start Menu Entry and Desktop Short Cut
	
	; Shortcuts
	CreateShortCut "$DESKTOP\KISS IDE ${VERSION}.lnk" "$INSTDIR\kiss\KISS.exe"
	CreateShortCut "$DESKTOP\KIPR's 2D Simulator ${VERSION}.lnk" "$INSTDIR\ks2\ks2.exe"
	CreateDirectory  "$SMPROGRAMS\${INSTALL_FILENAME}"
	CreateShortCut "$SMPROGRAMS\${INSTALL_FILENAME}\KISS IDE ${VERSION}.lnk" "$INSTDIR\kiss\KISS.exe"
	CreateShortCut "$SMPROGRAMS\${INSTALL_FILENAME}\KIPR's 2D Simulator ${VERSION}.lnk" "$INSTDIR\ks2\ks2.exe"
SectionEnd

; TODO: THIS IS BROKEN ON WINDOWS.
Section "KIPR Link Driver" LINK
	SetOutPath "$WINDIR\KIPRLinkDriver"
	
	File "${KISS_IDE_DIR}\..\scripts\kiprlink.inf"
	
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
!insertmacro MUI_DESCRIPTION_TEXT ${KISSPLATFORM} "KISS Platform ${VERSION} ${APPVERSIONSTRING}"
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
	Delete "$DESKTOP\${APPNAMEANDVERSION}.lnk"
	Delete "$SMPROGRAMS\${APPNAMEANDVERSION}\${APPNAMEANDVERSION}.lnk"
  RMDir  "$SMPROGRAMS\${APPNAMEANDVERSION}"

	; Clean up KISS-C
	RMDir /r "$INSTDIR\"

SectionEnd

BrandingText "KISS Institute For Practical Robotics"
