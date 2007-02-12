; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=PamSoft Grid Component
AppVerName=PamSoft Grid Component 3.8
AppPublisher=PamGene International BV
DefaultDirName=C:\Program Files\BioNavigator\AX
DisableDirPage=yes
DefaultGroupName=BioNavigator
DisableProgramGroupPage=yes
OutputDir=C:\PamSoft\DataAnalysis\com\PamSoft_Grid\distrib
OutputBaseFilename=setup PamSoft Grid Component
SetupIconFile=C:\PamSoft\DataAnalysis\PamGrid7_3\Evolve.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "C:\PamSoft\DataAnalysis\com\PamSoft_Grid\distrib\PamSoft_Grid_3_8.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\PamSoft\DataAnalysis\com\PamSoft_Grid\distrib\PamSoft_Grid.ctf"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:UninstallProgram,PamSoft Grid Component}"; Filename: "{uninstallexe}"

