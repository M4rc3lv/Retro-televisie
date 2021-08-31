unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes,SysUtils,Forms,Controls,Graphics,Dialogs,StdCtrls,ExtCtrls,Buttons,
  BCButton,BGRAResizeSpeedButton,BGRASpeedButton,BCMaterialDesignButton,
  BCImageButton;

type

		{ TForm1 }

  TForm1 = class(TForm)
    Image1:TImage;
    Image2:TImage;
    imgJournaal:TImage;
    imgNL1:TImage;
    imgNL2:TImage;
    imgNL3:TImage;
    imgRuis3:TImage;
    imgRuis2:TImage;
    imgRuis1:TImage;
    imgRuis8:TImage;
    imgTv:TImage;
    Label2:TLabel;
    Label3:TLabel;
    Label4:TLabel;
    Label5:TLabel;
    pNl2:TPanel;
    pNl1:TPanel;
    pNl3:TPanel;
    pNl4:TPanel;

    procedure Image1Click(Sender:TObject);
    procedure imgJournaalClick(Sender:TObject);
    procedure NL1Click(Sender:TObject);
    procedure NL2Click(Sender:TObject);
    procedure NL3Click(Sender:TObject);
				procedure btnShutdownClick(Sender:TObject);
				procedure FormCreate(Sender:TObject);
    procedure FormPaint(Sender:TObject);
  private

  public
   procedure Run(Exe:string; Params:array of string);
   procedure Enable(OK:boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
uses
 Process,Unix;

type
TPinger = class(TThread)
 private
  _Aan: boolean;
  procedure ShowAan;
  procedure ShowUit;
 protected
  procedure Execute; override;
 public
  constructor Create(CreateSuspended : boolean);
  var Pinger:TPinger; static;
  property Aan:boolean read _Aan;
 end;

constructor TPinger.Create(CreateSuspended : boolean);
begin
 inherited Create(CreateSuspended);
 FreeOnTerminate := True;
end;

procedure TPinger.ShowAan;
// Runt in UI-thread
begin
 Form1.imgTv.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'tvaan.png');
 Form1.Enable(True);
end;

procedure TPinger.ShowUit;
// Runt in UI-thread
begin
 Form1.imgTv.Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+'tvuit.png');
 Form1.Enable(False);

end;

procedure TPinger.Execute;
var
 i:integer;
begin
 while (not Terminated) do begin
  i:=ExecuteProcess(ExtractFilePath(Application.ExeName)+'doping',[]);
  _Aan:=i=0;
  if _Aan then Synchronize(@ShowAan) else Synchronize(@ShowUit);
 end;

end;

procedure TForm1.Run(Exe:string; Params:array of string);
var
 AProcess: TProcess;
 i: integer;
begin
 AProcess := TProcess.Create(nil);
 AProcess.Executable:=Exe;
 for i:=0 to Length(Params)-1 do
  AProcess.Parameters.Add(Params[i]);

 //AProcess.Options := AProcess.Options + [poWaitOnExit];
 AProcess.Execute;
 //AProcess.Free;
end;

procedure TForm1.NL1Click(Sender:TObject);
begin
 if TPinger.Pinger.Aan then
  Run('sshpass',['-p','''tv''','ssh','pi@televisie.local','/home/pi/tv/nl1']);
end;

procedure TForm1.Image1Click(Sender:TObject);
begin
 if TPinger.Pinger.Aan then
  Run('sshpass',['-p', '''tv''', 'ssh', 'pi@televisie.local', '/home/pi/tv/pauze']);
end;

procedure TForm1.imgJournaalClick(Sender:TObject);
begin
 if TPinger.Pinger.Aan then
  Run('sshpass',['-p','''tv''','ssh','pi@televisie.local','/home/pi/tv/8uur']);
end;

procedure TForm1.NL2Click(Sender:TObject);
begin
 if TPinger.Pinger.Aan then
  Run('sshpass',['-p','''tv''','ssh','pi@televisie.local','/home/pi/tv/nl2']);
end;

procedure TForm1.NL3Click(Sender:TObject);
begin
 if TPinger.Pinger.Aan then
  Run('sshpass',['-p','''tv''','ssh','pi@televisie.local','/home/pi/tv/nl3']);
end;

procedure TForm1.btnShutdownClick(Sender:TObject);
begin
 Run('sshpass',['-p','''tv''','ssh','pi@televisie.local','sudo','shutdown','now']);
end;

procedure TForm1.FormCreate(Sender:TObject);
begin
 Enable(false);
end;

procedure TForm1.FormPaint(Sender:TObject);
begin
 if TPinger.Pinger=nil then
  TPinger.Pinger := TPinger.Create(false);
end;

procedure Size(Bron:TImage; Target:TImage);
begin
 Target.Left:=Bron.Left;
 Target.Top:=Bron.Top;
 Target.Width:=Bron.Width;
 Target.Height:=Bron.Height;
end;

procedure TForm1.Enable(OK:boolean);
begin
 writeln(1);
 imgJournaal.Visible:=OK;
 imgRuis8.Visible:=not OK;
 Size(imgJournaal, imgRuis8);
 imgNL1.Visible:=OK;
 imgRuis1.Visible:=not OK;
 Size(imgNL1, imgRuis1);
 imgNL2.Visible:=OK;
 imgRuis2.Visible:=not OK;
 Size(imgNL2, imgRuis2);
 imgNL3.Visible:=OK;
 imgRuis3.Visible:=not OK;
 Size(imgNL3, imgRuis3);
  writeln(2);
// imgNL1.Visible:=OK;
// imgNL2.Visible:=OK;
// imgNL3.Visible:=OK;
// imgJournaal.Visible:=OK;
end;

end.

