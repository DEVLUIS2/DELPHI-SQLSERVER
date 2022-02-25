object TGraficoProdutoSintetico: TTGraficoProdutoSintetico
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Gr'#225'fico Sint'#233'tico de Produto'
  ClientHeight = 440
  ClientWidth = 727
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
    Top = 0
    Width = 727
    Height = 405
    Align = alClient
    TabOrder = 0
    object DBChart1: TDBChart
      Left = 1
      Top = 1
      Width = 725
      Height = 403
      AllowPanning = pmNone
      Title.Font.Color = clBlack
      Title.Font.Height = -19
      Title.Font.Style = [fsBold]
      Title.Text.Strings = (
        'Gr'#225'fico Sint'#233'tico de Produtos')
      Legend.Alignment = laBottom
      Legend.Font.Height = -12
      Legend.Gradient.EndColor = clSilver
      Legend.Gradient.MidColor = clSilver
      Legend.Gradient.Visible = True
      Legend.Shadow.Visible = False
      Legend.Title.Font.Height = -13
      Legend.Title.Text.Strings = (
        'Legenda')
      Legend.Title.TextAlignment = taCenter
      Pages.AutoScale = True
      Pages.MaxPointsPerPage = 4
      View3DOptions.Elevation = 315
      View3DOptions.Orthogonal = False
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
      OnPageChange = DBChart1PageChange
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Series1: TPieSeries
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Style = smsPercent
        Marks.Visible = True
        DataSource = qProduto
        Title = 'ProdutoSintetico'
        XLabelsSource = 'STATUS'
        Gradient.Direction = gdRadial
        OtherSlice.Legend.Visible = False
        PieValues.Name = 'Pie'
        PieValues.Order = loNone
        PieValues.ValueSource = 'QUANTIDADE'
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 405
    Width = 727
    Height = 35
    Align = alBottom
    TabOrder = 1
    object LCount: TLabel
      AlignWithMargins = True
      Left = 87
      Top = 4
      Width = 16
      Height = 27
      Margins.Left = 10
      Margins.Right = 10
      Align = alLeft
      Alignment = taCenter
      Caption = '0/0'
      Layout = tlCenter
      ExplicitHeight = 13
    end
    object btnNext: TBitBtn
      AlignWithMargins = True
      Left = 116
      Top = 4
      Width = 70
      Height = 27
      Align = alLeft
      Caption = '>'
      TabOrder = 0
      OnClick = btnNextClick
      ExplicitTop = 5
    end
    object btnFechar: TBitBtn
      AlignWithMargins = True
      Left = 613
      Top = 4
      Width = 110
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
      TabOrder = 1
      OnClick = btnFecharClick
    end
    object btnPrev: TBitBtn
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 70
      Height = 27
      Align = alLeft
      Caption = '<'
      TabOrder = 2
      OnClick = btnPrevClick
    end
  end
  object qProduto: TADOQuery
    Connection = TDMPrincipal.Connection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT '#39'ATIVO'#39' AS STATUS,COUNT(COD_PROD)AS QUANTIDADE'
      'FROM PRODUTO'
      'WHERE ATIVO = 1'
      'UNION ALL'
      'SELECT '#39'INATICO'#39' AS STATUS, COUNT(COD_PROD)AS QUANTIDADE'
      'FROM PRODUTO'
      'WHERE ATIVO = 0')
    Left = 24
    Top = 360
  end
end