program mbs;

uses
  Vcl.Forms,
  UnitMap in 'UnitMap.pas' {FormMap},
  QJson in 'QJson.pas',
  QString in 'QString.pas',
  UnitMain in 'UnitMain.pas' {FormMain},
  Editors in 'Editors.pas',
  UnitCP in 'UnitCP.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormMap, FormMap);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
