object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'ColorPick'
  ClientHeight = 104
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 100
    Height = 100
    Shape = bsFrame
  end
  object Image1: TImage
    Left = 1
    Top = 1
    Width = 97
    Height = 97
  end
  object lbl_Red: TLabel
    Left = 109
    Top = 46
    Width = 24
    Height = 13
    Caption = #32418#65306
    Transparent = True
  end
  object lbl_Green: TLabel
    Left = 152
    Top = 46
    Width = 24
    Height = 13
    Caption = #32511#65306
    Transparent = True
  end
  object lbl_Blue: TLabel
    Left = 196
    Top = 46
    Width = 24
    Height = 13
    Caption = #34013#65306
    Transparent = True
  end
  object bvl2: TBevel
    Left = 106
    Top = 0
    Width = 140
    Height = 40
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 109
    Top = 68
    Width = 24
    Height = 13
    Caption = 'RGB:'
  end
  object Label2: TLabel
    Left = 109
    Top = 87
    Width = 130
    Height = 13
    Caption = #25552#31034#65306'ESC'#65306#26242#20572'/'#32487#32493
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edt_Hex: TEdit
    Left = 144
    Top = 65
    Width = 100
    Height = 21
    TabOrder = 0
  end
  object pnl_Color: TPanel
    Left = 107
    Top = 2
    Width = 137
    Height = 36
    BevelOuter = bvNone
    TabOrder = 1
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 32
    Top = 40
  end
end
