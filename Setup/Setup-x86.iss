; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Zemna Name Copier"
#define MyAppVersion "2.0"
#define MyAppPublisher "ZemnaSoft"
#define MyAppURL "http://sw.zemna.net"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{7024342B-5483-43CB-BFB5-DCF9543E9A59}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\ZemnaSoft\Zemna Name Copier
DefaultGroupName=ZemnaSoft\Zemna Name Copier
OutputBaseFilename=zemna-name-copier-setup-v{#MyAppVersion}-x86
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin
UninstallDisplayName={#MyAppName}
UninstallDisplayIcon={app}\ZemnaNameCopier.dll

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "D:\Projects\ZemnaNameCopier\ZemnaNameCopier\bin\Release\SharpShell.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\ZemnaNameCopier\ZemnaNameCopier\bin\Release\ZemnaNameCopier.dll"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "D:\Projects\ZemnaNameCopier\Setup\Help.url"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\ZemnaNameCopier\Setup\hyperlink.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\ZemnaNameCopier\Setup\zemnasoft.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\ZemnaNameCopier\Setup\ZemnaSoft.url"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{group}\Help"; Filename: "{app}\Help.url"; IconFilename: "{app}\hyperlink.ico"; IconIndex: 0
Name: "{group}\ZemnaSoft Website"; Filename: "{app}\ZemnaSoft.url"; IconFilename: "{app}\zemnasoft.ico"; IconIndex: 0

[Run]
Filename: "{dotnet40}\RegAsm.exe"; Parameters: "/unregister ZemnaNameCopier.dll"; WorkingDir: "{app}"; Flags: runhidden; StatusMsg: "Registering shell extension..."
Filename: "{dotnet40}\RegAsm.exe"; Parameters: "/codebase ZemnaNameCopier.dll"; WorkingDir: "{app}"; Flags: runhidden; StatusMsg: "Registering shell extension..."

[UninstallRun]
Filename: "{dotnet40}\RegAsm.exe"; Parameters: "/unregister ZemnaNameCopier.dll"; WorkingDir: "{app}"; Flags: runhidden

[Code]
function IsDotNetDetected(version: string; service: cardinal): boolean;
// Indicates whether the specified version and service pack of the .NET Framework is installed.
//
// version -- Specify one of these strings for the required .NET Framework version:
//    'v1.1.4322'     .NET Framework 1.1
//    'v2.0.50727'    .NET Framework 2.0
//    'v3.0'          .NET Framework 3.0
//    'v3.5'          .NET Framework 3.5
//    'v4\Client'     .NET Framework 4.0 Client Profile
//    'v4\Full'       .NET Framework 4.0 Full Installation
//    'v4.5'          .NET Framework 4.5
//
// service -- Specify any non-negative integer for the required service pack level:
//    0               No service packs required
//    1, 2, etc.      Service pack 1, 2, etc. required
var
    key: string;
    install, release, serviceCount: cardinal;
    check45, success: boolean;
begin
    // .NET 4.5 installs as update to .NET 4.0 Full
    if version = 'v4.5' then begin
        version := 'v4\Full';
        check45 := true;
    end else
        check45 := false;

    // installation key group for all .NET versions
    key := 'SOFTWARE\Microsoft\NET Framework Setup\NDP\' + version;

    // .NET 3.0 uses value InstallSuccess in subkey Setup
    if Pos('v3.0', version) = 1 then begin
        success := RegQueryDWordValue(HKLM, key + '\Setup', 'InstallSuccess', install);
    end else begin
        success := RegQueryDWordValue(HKLM, key, 'Install', install);
    end;

    // .NET 4.0/4.5 uses value Servicing instead of SP
    if Pos('v4', version) = 1 then begin
        success := success and RegQueryDWordValue(HKLM, key, 'Servicing', serviceCount);
    end else begin
        success := success and RegQueryDWordValue(HKLM, key, 'SP', serviceCount);
    end;

    // .NET 4.5 uses additional value Release
    if check45 then begin
        success := success and RegQueryDWordValue(HKLM, key, 'Release', release);
        success := success and (release >= 378389);
    end;

    result := success and (install = 1) and (serviceCount >= service);
end;


function InitializeSetup(): Boolean;
begin
    if not IsDotNetDetected('v4.5', 0) then begin
        MsgBox('Zemna Name Copier requires Microsoft .NET Framework 4.5.'#13#13
            'Please use Windows Update to install this version,'#13
            'and then re-run the Zemna Name Copier setup program.', mbInformation, MB_OK);
        result := false;
    end else
        result := true;
end;