object TGraficoProduto: TTGraficoProduto
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = ' Gr'#225'fico de Produtos'
  ClientHeight = 456
  ClientWidth = 795
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
    Top = 421
    Width = 795
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
      OnClick = BitBtn1Click
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
    object BitBtn3: TBitBtn
      AlignWithMargins = True
      Left = 691
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
      OnClick = BitBtn3Click
    end
  end
  object DBChart1: TDBChart
    Left = 0
    Top = 0
    Width = 795
    Height = 421
    Cursor = crArrow
    AllowPanning = pmNone
    Title.Font.Color = clBlack
    Title.Font.Height = -19
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      'Estoque de Produtos')
    BottomAxis.LabelsSeparation = 0
    BottomAxis.LabelsSize = 15
    BottomAxis.Title.Caption = 'Produto'
    BottomAxis.Title.Font.Height = -17
    BottomAxis.Title.Font.Style = [fsBold]
    BottomAxis.Title.Font.InterCharSize = 1
    DepthAxis.Automatic = False
    DepthAxis.AutomaticMaximum = False
    DepthAxis.AutomaticMinimum = False
    DepthAxis.Maximum = 0.500000000000000000
    DepthAxis.Minimum = -0.710000000000002600
    DepthAxis.MinorTickCount = 4
    DepthTopAxis.Automatic = False
    DepthTopAxis.AutomaticMaximum = False
    DepthTopAxis.AutomaticMinimum = False
    DepthTopAxis.Maximum = 0.289999999999992300
    DepthTopAxis.Minimum = -0.710000000000002600
    LeftAxis.MaximumOffset = 6
    LeftAxis.MinorTickCount = 4
    LeftAxis.Title.Caption = 'Estoque'
    LeftAxis.Title.Font.Height = -17
    LeftAxis.Title.Font.Style = [fsBold]
    LeftAxis.Title.Font.InterCharSize = 1
    Legend.Alignment = laBottom
    Legend.Gradient.EndColor = 14145495
    Legend.Gradient.MidColor = 14145495
    Legend.Gradient.StartColor = 14145495
    Legend.Gradient.Visible = True
    Legend.Shadow.Visible = False
    Legend.Symbol.Gradient.EndColor = clBlue
    Legend.Symbol.Shadow.Visible = False
    Legend.Symbol.Squared = True
    Legend.Title.Font.Height = -13
    Legend.Title.Text.Strings = (
      'Legenda')
    Legend.Title.TextAlignment = taCenter
    Legend.TopPos = 35
    Pages.AutoScale = True
    Pages.MaxPointsPerPage = 4
    RightAxis.Automatic = False
    RightAxis.AutomaticMaximum = False
    RightAxis.AutomaticMinimum = False
    OnPageChange = DBChart1PageChange
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = -2
    PrintMargins = (
      15
      23
      15
      23)
    object Series1: TBarSeries
      ColorEachPoint = True
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Style = smsValue
      Marks.Visible = True
      DataSource = qProduto
      Title = 'Produto'
      XLabelsSource = 'DESCRICAO_PROD'
      BarStyle = bsBevel
      Gradient.Direction = gdTopBottom
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
      YValues.ValueSource = 'ESTOQUE_PROD'
    end
  end
  object qProduto: TADOQuery
    Connection = TDMPrincipal.Connection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT DESCRICAO_PROD,ESTOQUE_PROD'
      'FROM PRODUTO'
      'ORDER BY ESTOQUE_PROD')
    Left = 32
    Top = 360
    object qProdutoDESCRICAO_PROD: TStringField
      FieldName = 'DESCRICAO_PROD'
      Size = 100
    end
    object qProdutoESTOQUE_PROD: TBCDField
      FieldName = 'ESTOQUE_PROD'
      Precision = 10
      Size = 0
    end
  end
end
