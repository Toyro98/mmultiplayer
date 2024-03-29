; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

; NOTE: The following variables must be set on the command line:
;    'AppNameOverride'
;    'AppPublisherOverride'
;    'AppURLOverride'
;    'AppExeNameOverride'
;    'ApplicationFilesPath'
;    'OutputPath'
;    'AppVersionOverride'
;    'OutputBaseFilenameOverride'
;    'LicenseFileOverride'

; NOTE: Use the following syntax on the command line to define a variable value:
; /DMyAppVersion=1.0.0

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{7D9BD81A-BD85-449C-8F08-1B46EE8CABC0}
ArchitecturesInstallIn64BitMode=x64
AppName={#AppNameOverride}
AppVersion={#AppVersionOverride}
VersionInfoVersion={#AppVersionOverride}
AppVerName={#AppNameOverride} {#AppVersionOverride}
AppPublisher={#AppPublisherOverride}
AppPublisherURL={#AppURLOverride}
AppSupportURL={#AppURLOverride}
AppUpdatesURL={#AppURLOverride}
DefaultDirName={pf}\{#AppNameOverride}
DisableDirPage=yes
DisableProgramGroupPage=yes
DefaultGroupName={#AppNameOverride}
AllowNoIcons=yes
;LicenseFile={#LicenseFileOverride}
OutputBaseFilename={#OutputBaseFilenameOverride}
Compression=lzma2/max
SolidCompression=yes
OutputDir={#OutputPath}
UninstallDisplayIcon={app}\{#AppExeNameOverride}
SetupLogging=yes
; Disable auto closing of application because the app handles it.
CloseApplications=no
; Makes Windows Explorer refresh all icons after installer finishes. Fixes missing icon in start menu.
; https://stackoverflow.com/questions/44076985/create-desktop-link-icon-after-the-run-section-of-inno-setup
ChangesAssociations=yes
SetupIconFile=images\icon256.ico
WizardImageFile=images\arland.bmp
WizardSmallImageFile=images\icon-small.bmp

[InstallDelete]
; Remove any previous versions of extracted applications from squibbles.
Type: filesandordirs; Name: "{app}\bin"

[Messages]
SetupAppTitle = {#AppNameOverride} {#AppVersionOverride}
SetupWindowTitle = {#AppNameOverride} {#AppVersionOverride}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
;Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "{#ApplicationFilesPath}\*"; DestDir: "{app}\bin"; AfterInstall: ExecSquibbles; Flags: ignoreversion createallsubdirs recursesubdirs

[Icons]
Name: "{autoprograms}\{#AppNameOverride}"; Filename: "{app}\bin\{#AppExeNameOverride}";
;Name: "{group}\{cm:UninstallProgram,{#AppNameOverride}}"; Filename: "{uninstallexe}"
;Name: "{commondesktop}\{#AppNameOverride}"; Filename: "{app}\{#AppExeNameOverride}"; Tasks: desktopicon

[UninstallRun]
; Refer to squibbles' documentation for more information.
Filename: "{app}\bin\squibbles.exe"; Parameters: "uninstall"; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}\bin"
Type: dirifempty; Name: "{app}"

; The following code implements an "AfterInstall" InnoSetup procedure that
; allows InnoSetup to learn if squibbles (our installer helper application)
; failed with a non-zero exit status.
;
; Normally, InnoSetup wants users to put helper programs in the "Run" section.
; The "Run" section does not check if any of the specified executables actually
; succeeded. This means that any non-zero exit status for a "Run" application
; is ignored.
;
; This code is mostly copied from StackOverflow user Martin Prikryl.
; Refer to: https://stackoverflow.com/a/63945787
[Code]
var CancelWithoutPrompt: boolean;

function InitializeSetup(): Boolean;
begin
  CancelWithoutPrompt := false;
  result := true;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  if CancelWithoutPrompt then
    Confirm := false; { hide confirmation prompt }
end;

procedure ExecSquibbles();
var
  resultCode: Integer;
  begin
    // Refer to squibbles's documentation for more information.
    Exec(ExpandConstant('{app}\bin\squibbles.exe'), 'install',
        '', SW_HIDE, ewWaitUntilTerminated, resultCode);

    if resultCode <> 0 then
    begin
      SuppressibleMsgBox(
      'Installer helper program failed, exit code ' + IntToStr(resultCode) + '. ' +
        'Aborting installation.',
	mbCriticalError, MB_OK, 0);

      CancelWithoutPrompt := true;
      WizardForm.Close;
    end;
end;
