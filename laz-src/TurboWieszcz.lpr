program TurboWieszcz;

{$mode objfpc}{$H+}

uses
  Forms,
  Interfaces,
  TWMainUnit in 'TWMainUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormTW, FormTW);
  Application.Run;
end.
