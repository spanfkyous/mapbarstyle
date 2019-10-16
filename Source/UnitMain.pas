unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QJson,
  QString, Editors, UnitMap, Vcl.StdCtrls, VirtualTrees, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Mask, RzEdit, System.StrUtils,
  Vcl.Imaging.pngimage, HotSpotImage, HotSpotEditorComp, RzCmboBx, UnitCP;

const
  // Helper message to decouple node change handling from edit handling.
  WM_STARTEDITING = WM_USER + 778;

type
  TFormMain = class(TForm)
    Buttonkkk: TButton;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Button2: TButton;
    Panel2: TPanel;
    pnlHint: TPanel;
    vstJson: TVirtualStringTree;
    HotSpotEditor1: THotSpotEditor;
    HotSpotImage1: THotSpotImage;
    RadioGroup1: TRadioGroup;
    chk_Override: TCheckBox;
    SaveDialog1: TSaveDialog;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    btn_ColorPick: TButton;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure vstJsonFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure vstJsonGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstJsonInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode;
      var ChildCount: Cardinal);
    procedure vstJsonInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure vstJsonNodeClick(Sender: TBaseVirtualTree;
      const [Ref] HitInfo: THitInfo);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonkkkClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    // procedure RzColorEdit1Change(Sender: TObject);
    procedure vstJsonKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure vstJsonCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstJsonChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstJsonEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure vstJsonBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstJsonFocusChanging(Sender: TBaseVirtualTree;
      OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_ColorPickClick(Sender: TObject);
  private
    { Private declarations }
    FJson: TQJson;
    procedure WMStartEditing(var Message: TMessage); message WM_STARTEDITING;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  SrcFile : string;

function RGBandBGR(cSrc: DWORD): DWORD;

implementation

{$R *.dfm}

function GetFileSize(AFileName: String): Int64;
var
  sr     : TSearchRec;
  AHandle: Integer;
begin
  AHandle := FindFirst(AFileName, faAnyFile, sr);
  if AHandle = 0 then
  begin
    Result := sr.Size;
    FindClose(sr);
  end
  else
    Result := 0;
end;

function RGBandBGR(cSrc: DWORD): DWORD;
begin
  Result := { (cSrc and $FF000000) + } ((cSrc and $00FF0000) shr 16) +
    (cSrc and $0000FF00) + ((cSrc and $000000FF) shl 16);
end;

procedure TFormMain.btn_ColorPickClick(Sender: TObject);
begin
  Form1.Show;
end;

procedure TFormMain.Button1Click(Sender: TObject);
var
  T        : Cardinal;
  AFileSize: Int64;
begin
  if OpenDialog1.Execute then
  begin
    T := GetTickCount;
    try
      SrcFile := OpenDialog1.FileName;
      FJson.LoadFromFile(SrcFile);
    except
      FJson.Clear;
      Application.MessageBox('加载主题文件出错。', PChar(Application.Title),
        MB_OK + MB_ICONSTOP);
      exit;
    end;
    T         := GetTickCount - T;
    AFileSize := GetFileSize(OpenDialog1.FileName);

    Caption := '图吧配色工具 ' + #9 + OpenDialog1.FileName + ' - 大小' +
      RollupSize(AFileSize) + ', 用时:' + IntToStr(T) + 'ms';
    vstJson.RootNodeCount := 0;
    vstJson.RootNodeCount := FJson.Count;
  end;
  vstJson.FullExpand();

  // FormMap.Show;
end;

procedure TFormMain.ButtonkkkClick(Sender: TObject);
var
  svfile: string;
begin
  if chk_Override.Checked then
    FJson.SaveToFile(SrcFile, teAnsi, False, True)
  else
  begin
    if SaveDialog1.Execute then
    begin
      svfile := SaveDialog1.FileName;
      if SameText(RightStr(svfile, 4), '.txt') then
        FJson.SaveToFile(svfile, teAnsi, False, True)
      else
        FJson.SaveToFile(svfile + '.txt', teAnsi, False, True);
    end;

  end;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  FJson.Free;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FJson                := TQJson.Create;
  vstJson.NodeDataSize := SizeOf(Pointer);
end;

procedure TFormMain.FormShow(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to HotSpotImage1.HotSpots.Count - 1 do
  begin
    HotSpotImage1.HotSpots.Items[I].HoverColor := clNone;
    HotSpotImage1.HotSpots.Items[I].ClickColor := clNone;
    HotSpotImage1.HotSpots.Items[I].BlinkColor := clNone;
    HotSpotImage1.Enabled                      := False;
  end;
end;

procedure TFormMain.RadioGroup1Click(Sender: TObject);
begin
  // case RadioGroup1.ItemIndex of
  // 0:
  // HotSpotImage1.Picture.LoadFromFile('.\0_day.png');
  // 1:
  // HotSpotImage1.Picture.LoadFromFile('.\0_night.png');
  // 2:
  // HotSpotImage1.Picture.LoadFromFile('.\1_day.png');
  // 3:
  // HotSpotImage1.Picture.LoadFromFile('.\1_night.png');
  // end;
  case RadioGroup1.ItemIndex of
    0:
      HotSpotImage1.Picture.Assign(Image1.Picture);
    1:
      HotSpotImage1.Picture.Assign(Image2.Picture);
    2:
      HotSpotImage1.Picture.Assign(Image3.Picture);
    3:
      HotSpotImage1.Picture.Assign(Image4.Picture);
  end;
end;
//
// procedure TFormMain.RzColorEdit1Change(Sender: TObject);
// var
// pNode: PVirtualNode;
// AJson: PQJson;
// begin
// // ShowMessage(IntToHex(RGBandBGR(RzColorEdit1.SelectedColor), 6));
// pNode := vstJson.GetFirstSelected(False);
// AJson := PQJson(vstJson.GetNodeData(pNode));
// if (pNode.ChildCount = 0) and SameText(Copy(AJson.Path, 1, 5), 'color') then
// begin
// if Length(AJson.Value) = 6 then
// begin
// AJson.AsString := IntToHex(RGBandBGR(RzColorEdit1.SelectedColor), 6);
// end;
// OutputDebugString(PChar(AJson.Value));
// end;
// end;

procedure TFormMain.vstJsonBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  AJson: TQJson;
begin
  if Column = 2 then
  begin
    AJson := PQJson(vstJson.GetNodeData(Node))^;
    if (Node.ChildCount = 0) and SameText(Copy(AJson.Path, 1, 5), 'color') then
    begin
      if Length(AJson.Value) = 6 then
      begin
        TargetCanvas.Brush.Color := RGBandBGR(StrToInt('$' + AJson.Value));
        TargetCanvas.FillRect(TargetCanvas.ClipRect);
      end;

      OutputDebugString(PChar(AJson.Value));
    end;
  end;
end;

procedure TFormMain.vstJsonChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  with Sender do
  begin
    // Start immediate editing as soon as another node gets focused.
    if Assigned(Node) and (Node.Parent <> RootNode) and
      not(tsIncrementalSearching in TreeStates) then
    begin
      // We want to start editing the currently selected node. However it might well happen that this change event
      // here is caused by the node editor if another node is currently being edited. It causes trouble
      // to start a new edit operation if the last one is still in progress. So we post us a special message and
      // in the message handler we then can start editing the new node. This works because the posted message
      // is first executed *after* this event and the message, which triggered it is finished.
      PostMessage(Self.Handle, WM_STARTEDITING, WPARAM(Node), 0);
    end;
  end;
end;

procedure TFormMain.vstJsonCreateEditor(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  EditLink := TPropertyEditLink.Create;
end;

procedure TFormMain.vstJsonEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; var Allowed: Boolean);
var
  // Data: PPropertyData;
  AJson: PQJson;
begin
  with Sender do
  begin
    AJson   := GetNodeData(Node);
    Allowed := (Node.Parent <> RootNode) and (Column >= 1) and
      not(AJson.DataType in [jdtArray, jdtObject]);
  end;
end;

procedure TFormMain.vstJsonFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  AJson: PQJson;
begin
  if Assigned(Node) then
  begin
    AJson := vstJson.GetNodeData(Node);
    if AJson^ <> nil then
      pnlHint.Caption := ' 路径: ' + AJson.Path;
  end;
end;

procedure TFormMain.vstJsonFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TFormMain.vstJsonGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  AJson: PQJson;
begin
  case Column of
    0:
      begin
        AJson := vstJson.GetNodeData(Node);
        if AJson^ <> nil then
          CellText := AJson.Name;
      end;
    1:
      begin
        AJson := vstJson.GetNodeData(Node);
        if not(AJson.DataType in [jdtArray, jdtObject]) and (AJson^ <> nil) then
          CellText := AJson.AsString;
      end;
  end;

  // AJson := vstJson.GetNodeData(Node);
  // if AJson^ <> nil then
  // begin
  // if AJson.DataType in [jdtArray, jdtObject] then
  // CellText := AJson.Name
  // else if AJson.DataType = jdtString then
  // begin
  // if AJson.IsDateTime then
  // CellText := AJson.Name + ' = ' + AJson.AsString + ' (' +
  // FormatDateTime(JsonDateTimeFormat, AJson.AsDateTime) + ')'
  // else
  // begin
  // CellText := AJson.Name + ' = ' + AJson.AsString;
  // end;
  // end
  // else
  // CellText := AJson.Name + ' = ' + AJson.AsString;
  // end;
end;

procedure TFormMain.vstJsonInitChildren(Sender: TBaseVirtualTree;
  Node: PVirtualNode; var ChildCount: Cardinal);
begin
  ChildCount := PQJson(vstJson.GetNodeData(Node)).Count;
end;

procedure TFormMain.vstJsonInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var
  AJsonParent: TQJson;
  AJson      : TQJson;
begin
  if ParentNode <> nil then
    AJsonParent := PQJson(vstJson.GetNodeData(ParentNode))^
  else
    AJsonParent                      := FJson;
  AJson                              := AJsonParent.Items[Node.Index];
  PQJson(vstJson.GetNodeData(Node))^ := AJson;
  if AJson.Count > 0 then
    InitialStates := InitialStates + [ivsHasChildren];
end;

procedure TFormMain.vstJsonKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
// var
// pNode       : PVirtualNode;
// AJson: TQJson;
begin
  // case Key of
  // VK_UP, VK_DOWN:
  // begin
  // if vstJson.SelectedCount = 1 then
  // begin
  // pNode := vstJson.GetFirstSelected(False);
  //
  // AJson := PQJson(vstJson.GetNodeData(pNode))^;
  // if (pNode.ChildCount = 0) and SameText(Copy(AJson.Path, 1, 5), 'color')
  // then
  // begin
  // if Length(AJson.Value) = 6 then
  // begin
  // RzColorEdit1.SelectedColor :=
  // RGBandBGR(StrToInt('$' + AJson.Value));
  // end;
  //
  // OutputDebugString(PChar(AJson.Value));
  // end
  // else
  // RzColorEdit1.SelectedColor := clNone;
  // end;
  //
  // end;
  // end;
end;

procedure TFormMain.vstJsonNodeClick(Sender: TBaseVirtualTree;
  const [Ref] HitInfo: THitInfo);
// var
// AJson: TQJson;
begin
  // AJson := PQJson(vstJson.GetNodeData(HitInfo.HitNode))^;
  // if (HitInfo.HitNode.ChildCount = 0) and SameText(Copy(AJson.Path, 1, 5),
  // 'color') then
  // begin
  // if Length(AJson.Value) = 6 then
  // begin
  // RzColorEdit1.SelectedColor := RGBandBGR(StrToInt('$' + AJson.Value));
  // end;
  // OutputDebugString(PChar(AJson.Value));
  // end
  // else
  // RzColorEdit1.SelectedColor := clNone;
end;

procedure TFormMain.WMStartEditing(var Message: TMessage);
// This message was posted by ourselves from the node change handler above to decouple that change event and our
// intention to start editing a node. This is necessary to avoid interferences between nodes editors potentially created
// for an old edit action and the new one we start here.

var
  Node: PVirtualNode;
begin
  Node := Pointer(Message.WPARAM);
  // Note: the test whether a node can really be edited is done in the OnEditing event.
  vstJson.EditNode(Node, vstJson.FocusedColumn);
end;

// ----------------------------------------------------------------------------------------------------------------------

initialization
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown:= True;
{$ENDIF}

end.
