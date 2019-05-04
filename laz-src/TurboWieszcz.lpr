program TurboWieszcz;

{$mode objfpc}{$H+}

uses
  Forms,
  Interfaces,
  TWMainUnit in 'TWMainUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
