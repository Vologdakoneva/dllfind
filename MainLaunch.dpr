program MainLaunch;

uses
  Vcl.Forms,
  TestForms in 'TestForms.pas' {Form1},
  fresultfind in 'fresultfind.pas' {fFindEzec};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);

  Application.Run;
end.
