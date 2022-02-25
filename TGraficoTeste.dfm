object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 472
  ClientWidth = 773
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 437
    Width = 773
    Height = 35
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 440
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 345
    Height = 437
    Align = alLeft
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 343
      Height = 56
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 144
        Top = 21
        Width = 31
        Height = 13
        Caption = 'Label1'
      end
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 57
      Width = 343
      Height = 343
      Align = alClient
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object Panel5: TPanel
      Left = 1
      Top = 400
      Width = 343
      Height = 36
      Align = alBottom
      TabOrder = 2
      object Label2: TLabel
        Left = 82
        Top = 1
        Width = 179
        Height = 34
        Align = alClient
        Alignment = taCenter
        Caption = '0/0'
        Layout = tlCenter
        ExplicitWidth = 16
        ExplicitHeight = 13
      end
      object BitBtn1: TBitBtn
        AlignWithMargins = True
        Left = 264
        Top = 4
        Width = 75
        Height = 28
        Align = alRight
        Caption = '>>'
        TabOrder = 0
        ExplicitLeft = 136
        ExplicitTop = 6
        ExplicitHeight = 25
      end
      object BitBtn2: TBitBtn
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 75
        Height = 28
        Align = alLeft
        Caption = '<<'
        TabOrder = 1
        ExplicitLeft = 136
        ExplicitTop = 6
        ExplicitHeight = 25
      end
    end
  end
  object Panel3: TPanel
    Left = 345
    Top = 0
    Width = 428
    Height = 437
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 393
    ExplicitWidth = 385
    object DBChart1: TDBChart
      Left = 1
      Top = 1
      Width = 426
      Height = 435
      Title.Text.Strings = (
        'TDBChart')
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 16
      ExplicitTop = 96
      ExplicitWidth = 400
      ExplicitHeight = 250
    end
  end
  object qGrafico: TADOQuery
    Parameters = <>
    Left = 24
    Top = 344
  end
  object dsGrafico: TDataSource
    Left = 96
    Top = 344
  end
end
