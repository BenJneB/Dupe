; Inno Setup installer for Dupe (Windows).
; On Windows, from the project root:
;   flutter build windows --release --dart-define-from-file=env.json
;   "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" /DAppVersion=1.2.3 packaging\windows\dupe.iss
; Output: build\installer\Dupe-<version>-setup.exe (the CI passes the tag version)

#define AppName "Dupe"
#ifndef AppVersion
  #define AppVersion "1.0.0"
#endif
#define AppExe "dupe.exe"
#define BuildDir "..\..\build\windows\x64\runner\Release"

[Setup]
; Fixed id: lets a new version upgrade the installed one.
AppId={{6F1D9C2E-4B7A-4D55-9A0E-3C8B2F71D5A4}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=Dupe
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes
; Per-user install by default: no administrator rights needed.
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=..\..\build\installer
OutputBaseFilename={#AppName}-{#AppVersion}-setup
SetupIconFile=..\..\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#AppExe}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
; The whole Flutter bundle: exe, DLLs and data\ (assets, ICU, AOT code).
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExe}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExe}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExe}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent
