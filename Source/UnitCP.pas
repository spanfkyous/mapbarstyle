unit UnitCP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Image1: TImage;
    lbl_Red: TLabel;
    lbl_Green: TLabel;
    lbl_Blue: TLabel;
    bvl2: TBevel;
    edt_Hex: TEdit;
    pnl_Color: TPanel;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Hotykey(var msg: TMessage); message WM_HOTKEY;
  end;

var
  Form1 : TForm1;
  HotKey: Integer;

implementation

{$R *.dfm}

procedure TForm1.Hotykey(var msg: TMessage); // �ȼ���Ӧ�¼�
begin
  if (msg.LParamLo = 0) and (msg.LParamHi = VK_ESCAPE) then
  begin
    Timer1.Enabled := not Timer1.Enabled;
  end;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
  UnRegisterHotKey(handle, HotKey);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
  HotKey         := GlobalAddAtom('HotKey');    // ȫ���ȼ�ID
  RegisterHotKey(handle, HotKey, 0, VK_ESCAPE); // ע��ȫ���ȼ�
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  dc                        : HDC;
  aCanvas                   : TCanvas;
  pt                        : TPoint;
  max_X, max_Y, mid_X, mid_Y: LongInt;
  aColor                    : TColor;
  R, G, B                   : Byte;
  DesktopDC                 : HDC;
begin
  GetCursorPos(pt); // �õ���������

  DesktopDC         := GetWindowDC(GetDesktopWindow);
  aColor            := GetPixel(DesktopDC, pt.X, pt.Y);
  R                 := GetRvalue(aColor);
  G                 := GetGvalue(aColor);
  B                 := GetBvalue(aColor);
  lbl_Red.Caption   := '��:' + inttostr(R);
  lbl_Green.Caption := '��:' + inttostr(G);
  lbl_Blue.Caption  := '��:' + inttostr(B);
  edt_Hex.Text := { '#'+ } IntToHex(R, 2) + IntToHex(G, 2) + IntToHex(B, 2);
  pnl_Color.Color := RGB(R, G, B);

  dc      := Getdc(0); // �õ������DC
  aCanvas := TCanvas.Create;
  try
    aCanvas.handle := dc; // ��һ����Ļ�Ķ���
    // ������괦��һС��ͼ��Image1��ȥ����Ҫ�ı�Ŵ�ı�����
    // ֻ��ı�Ŀ��ͼ������Ĵ�С����Image1�ؼ��Ĵ�С�Ϳ�����
    Image1.Canvas.CopyRect(                    // ��ʼ����
      Rect(0, 0, Image1.Width, Image1.Height), // Ŀ������
      aCanvas,                                 // ����ͼ���Canvas
      Rect(pt.X - 20, pt.Y - 20,               // Ҫ��ȡ��ͼ������
      pt.X + 20, pt.Y + 20));
  finally
    aCanvas.Free;
    ReleaseDC(0, dc);
  end;

  mid_X                   := Image1.Width div 2;
  mid_Y                   := Image1.Height div 2;
  Image1.Canvas.Pen.Color := clblack;
  Image1.Canvas.Pen.Width := 1;
  Image1.Canvas.MoveTo(mid_X - 15, mid_Y); // �ڷŴ���ͼ���л�һ��ʮ�ּ���״�Ĺ��
  Image1.Canvas.LineTo(mid_X + 15, mid_Y);
  Image1.Canvas.MoveTo(mid_X, mid_Y - 15);
  Image1.Canvas.LineTo(mid_X, mid_Y + 15);

  max_X := Screen.Width;  // �õ���Ļ�ֱ���X
  max_Y := Screen.Height; // �õ���Ļ�ֱ���Y
  mid_X := max_X div 2;
  mid_Y := max_Y div 2;

  // if pt.X<mid_X then
  // Self.Left := pt.X+20
  // else
  // Self.Left := pt.X-self.Width-20;
  //
  // if pt.Y<mid_Y then
  // Self.Top := pt.Y+70
  // else
  // Self.Top := pt.Y-self.Height-50;
  //
  // if (Self.Left+Self.Width>max_X) then
  // Self.Left:=max_X-self.Width-20;
  //
  // if Self.Top+Self.Height>max_Y-50 then
  // Self.Top:=max_Y-self.Height-50;

  ReleaseDC(0, dc);
end;

end.
