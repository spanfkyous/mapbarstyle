unit UnitMap;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, HotSpotEditorComp, Vcl.Imaging.pngimage,
  HotSpotImage, Vcl.StdCtrls;

type
  TFormMap = class(TForm)
    HotSpotImage1: THotSpotImage;
    HotSpotEditor1: THotSpotEditor;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMap: TFormMap;

implementation

{$R *.dfm}

procedure TFormMap.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to HotSpotImage1.HotSpots.Count - 1 do
    if HotSpotImage1.HotSpots.Items[I].Name = 'major' then
      HotSpotImage1.HotSpots.Items[I].Selected := True;
end;

procedure TFormMap.FormShow(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to HotSpotImage1.HotSpots.Count - 1 do
  begin
    HotSpotImage1.HotSpots.Items[I].HoverColor := clNone;
    HotSpotImage1.HotSpots.Items[I].ClickColor := clNone;
    HotSpotImage1.HotSpots.Items[I].BlinkColor := clNone;
    HotSpotImage1.Enabled:= False;
  end;
end;

end.
