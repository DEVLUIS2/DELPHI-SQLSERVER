object TGraficoTop10Fornecedores: TTGraficoTop10Fornecedores
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Gr'#225'fico Top 10 Fornecedores '
  ClientHeight = 444
  ClientWidth = 717
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 409
    Width = 717
    Height = 35
    Align = alBottom
    TabOrder = 0
    object LabPage: TLabel
      Left = 77
      Top = 1
      Width = 40
      Height = 33
      Align = alLeft
      Alignment = taCenter
      Caption = '    0/0    '
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnNext: TBitBtn
      AlignWithMargins = True
      Left = 120
      Top = 4
      Width = 70
      Height = 27
      Align = alLeft
      Caption = '>'
      TabOrder = 0
      OnClick = btnNextClick
    end
    object btnPrev: TBitBtn
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 70
      Height = 27
      Align = alLeft
      Caption = '<'
      TabOrder = 1
      OnClick = btnPrevClick
    end
    object btnFechar: TBitBtn
      AlignWithMargins = True
      Left = 613
      Top = 4
      Width = 100
      Height = 27
      Align = alRight
      Caption = 'Fechar [ESC]'
      Glyph.Data = {
        76080000424DB608000000000000B60000002800000020000000100000000100
        2000000000000008000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        800080008000800080000000FF00000000008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        80008000800080008000800080008000800080808000FFFFFF00800080008000
        80000000FF000000000080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080808000FFFFFF008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080000000
        FF000000FF000000FF0000000000800080008000800080008000800080008000
        8000800080000000FF0000000000800080008000800080008000800080008000
        800080008000808080008080800080808000FFFFFF0080008000800080008000
        800080008000800080008000800080808000FFFFFF0080008000800080000000
        FF000000FF000000FF0000000000800080008000800080008000800080008000
        80000000FF000000000080008000800080008000800080008000800080008000
        800080008000808080008080800080808000FFFFFF0080008000800080008000
        8000800080008000800080808000FFFFFF008000800080008000800080008000
        80000000FF000000FF000000FF00000000008000800080008000800080000000
        FF000000FF000000000080008000800080008000800080008000800080008000
        80008000800080008000808080008080800080808000FFFFFF00800080008000
        8000800080008080800080808000FFFFFF008000800080008000800080008000
        8000800080000000FF000000FF000000FF0000000000800080000000FF000000
        FF00000000008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000808080008080800080808000FFFFFF008000
        80008080800080808000FFFFFF00800080008000800080008000800080008000
        800080008000800080000000FF000000FF000000FF000000FF000000FF000000
        0000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008080800080808000808080008080
        800080808000FFFFFF0080008000800080008000800080008000800080008000
        80008000800080008000800080000000FF000000FF000000FF00000000008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080808000808080008080
        8000FFFFFF008000800080008000800080008000800080008000800080008000
        800080008000800080000000FF000000FF000000FF000000FF000000FF000000
        0000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008080800080808000808080008080
        800080808000FFFFFF0080008000800080008000800080008000800080008000
        8000800080000000FF000000FF000000FF0000000000800080000000FF000000
        0000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000808080008080800080808000FFFFFF008000
        800080808000FFFFFF0080008000800080008000800080008000800080000000
        FF000000FF000000FF000000FF00000000008000800080008000800080000000
        FF000000FF000000000080008000800080008000800080008000800080008000
        80008000800080808000808080008080800080808000FFFFFF00800080008000
        80008080800080808000FFFFFF008000800080008000800080000000FF000000
        FF000000FF000000FF0000000000800080008000800080008000800080008000
        80000000FF000000FF0000000000800080008000800080008000800080008000
        800080808000808080008080800080808000FFFFFF0080008000800080008000
        8000800080008080800080808000FFFFFF0080008000800080000000FF000000
        FF00000000008000800080008000800080008000800080008000800080008000
        8000800080000000FF000000FF00000000008000800080008000800080008000
        80008080800080808000FFFFFF00800080008000800080008000800080008000
        800080008000800080008080800080808000FFFFFF0080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000800080008000
        8000800080008000800080008000800080008000800080008000}
      NumGlyphs = 2
      TabOrder = 2
      OnClick = btnFecharClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 717
    Height = 409
    Align = alClient
    TabOrder = 1
    object DBChart1: TDBChart
      Left = 1
      Top = 1
      Width = 715
      Height = 407
      Title.Font.Color = clBlack
      Title.Font.Height = -19
      Title.Font.Style = [fsBold]
      Title.Text.Strings = (
        'Top 10 que mais forneceram')
      BottomAxis.LabelsSize = 25
      BottomAxis.Title.Caption = 'Fornecedores'
      BottomAxis.Title.Font.Height = -16
      BottomAxis.Title.Font.Style = [fsBold]
      BottomAxis.Title.Font.InterCharSize = 2
      LeftAxis.LabelsSize = 34
      LeftAxis.Title.Caption = 'Quantidade Fornecida'
      LeftAxis.Title.Font.Height = -16
      LeftAxis.Title.Font.Style = [fsBold]
      LeftAxis.Title.Font.InterCharSize = 2
      Legend.Alignment = laBottom
      Legend.Gradient.EndColor = clSilver
      Legend.Gradient.MidColor = clSilver
      Legend.Gradient.Visible = True
      Legend.Title.Font.Height = -13
      Legend.Title.Text.Strings = (
        'Legenda')
      Legend.Title.TextAlignment = taCenter
      Pages.AutoScale = True
      Pages.MaxPointsPerPage = 3
      OnPageChange = DBChart1PageChange
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Series1: TBarSeries
        ColorEachPoint = True
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Style = smsValue
        Marks.Visible = True
        DataSource = qTopFornecedores
        Title = 'TopFornecedores'
        XLabelsSource = 'NOME_FORNECEDOR'
        BarWidthPercent = 50
        DepthPercent = 75
        Gradient.Direction = gdTopBottom
        OffsetPercent = -10
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Bar'
        YValues.Order = loNone
        YValues.ValueSource = 'QUANTIDADE FORNECIDA'
      end
    end
  end
  object qTopFornecedores: TADOQuery
    Connection = TDMPrincipal.Connection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      ''
      
        'SELECT TOP(10) F.COD_FORNECEDOR,F.NOME_FORNECEDOR,SUM(P.ESTOQUE_' +
        'PROD)AS '#39'QUANTIDADE FORNECIDA'#39
      'FROM FORNECEDORES F'
      'INNER JOIN PRODUTO P ON P.COD_FORNECEDOR = F.COD_FORNECEDOR'
      'GROUP BY F.COD_FORNECEDOR,F.NOME_FORNECEDOR'
      'ORDER BY [QUANTIDADE FORNECIDA] DESC')
    Left = 40
    Top = 352
    object qTopFornecedoresCOD_FORNECEDOR: TAutoIncField
      FieldName = 'COD_FORNECEDOR'
      ReadOnly = True
    end
    object qTopFornecedoresNOME_FORNECEDOR: TStringField
      FieldName = 'NOME_FORNECEDOR'
      Size = 100
    end
    object qTopFornecedoresQUANTIDADEFORNECIDA: TFMTBCDField
      FieldName = 'QUANTIDADE FORNECIDA'
      ReadOnly = True
      Precision = 38
      Size = 0
    end
  end
end