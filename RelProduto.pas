unit RelProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, jpeg, DB, ADODB, DateUtils,IniFiles, ExtCtrls;

type
  TTRelProduto = class(TForm)
    RLReport1: TRLReport;
    qProduto: TADOQuery;
    dsProduto: TDataSource;
    RLBand3: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel1: TRLLabel;
    BandTitulo: TRLBand;
    RLBand1: TRLBand;
    rlpnl11: TRLPanel;
    TRLDBDPrecoCOD_PROD: TRLDBText;
    rlpnl12: TRLPanel;
    rlpnl13: TRLPanel;
    TRLDBDPrecoPRECO_PROD: TRLDBText;
    rlpnl14: TRLPanel;
    TRLDBDPrecoESTOQUE_PROD: TRLDBText;
    RLBand4: TRLBand;
    rlpnl5: TRLPanel;
    rlpnl7: TRLPanel;
    rlbl3: TRLLabel;
    rlpnl8: TRLPanel;
    rlbl1: TRLLabel;
    rlpnl9: TRLPanel;
    rlbl2: TRLLabel;
    rlpnl10: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel2: TRLPanel;
    RLPanel3: TRLPanel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLPanel4: TRLPanel;
    RLPanel5: TRLPanel;
    RLDBText1: TRLDBText;
    RLBand2: TRLBand;
    RLPanel6: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLPanel7: TRLPanel;
    RLLabel6: TRLLabel;
    RLBand5: TRLBand;
    RLPanel8: TRLPanel;
    RLLabel7: TRLLabel;
    RLPanel9: TRLPanel;
    RLLabel8: TRLLabel;
    RLBand6: TRLBand;
    RLPanel10: TRLPanel;
    RLDBText3: TRLDBText;
    RLPanel11: TRLPanel;
    RLDBText4: TRLDBText;
    RLPanel12: TRLPanel;
    rlpnl4: TRLPanel;
    rlbl7: TRLLabel;
    RLPanel13: TRLPanel;
    TLogo: TImage;
    rlpnl3: TRLPanel;
    rlbl6: TRLLabel;
    rlpnl2: TRLPanel;
    RLLabel5: TRLLabel;
    rlpnl1: TRLPanel;
    RLDBMemo1: TRLDBMemo;
    RLDBMemo2: TRLDBMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure qProdutoPRECO_PRODGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ArquivoI: TIniFile;
    OrdenaStatus,OrdenaCampo,OrdenaFornecedor,RecebeRelatorio,RecebeProduto:Integer;
    DataInicial,DataFim:TDateTime;
    procedure DadosRelatorio;
    procedure BlockRelatorio;
    procedure RelatorioSintetico;
  public
    { Public declarations }
    procedure ChamaTela(status,Ordenar,Relatorio,Produto:Integer;Inicial,Fim:TDateTime);
  end;

var
  TRelProduto: TTRelProduto;

implementation

uses
  DMPrincipal, FiltroProduto, FuncoesDB, Funcoes;

{$R *.dfm}


{ TTRProduto }

procedure TTRelProduto.BlockRelatorio;
begin
  case RecebeRelatorio of
    0:
    begin
      RLBand5.Visible := False;
      RLBand6.Visible := False;
    end;
    1:
    begin
      RLBand4.Visible := False;
      RLBand1.Visible := False;
    end;
  end;
end;

procedure TTRelProduto.RelatorioSintetico;
begin
  with qProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT '+QuotedStr('ATIVO')+'AS STATUS, COUNT(COD_PROD) AS COD_PROD');
    SQL.Add('FROM PRODUTO');
    SQL.Add('WHERE ATIVO = 1');
    SQL.Add('UNION ALL');
    SQL.Add('SELECT '+QuotedStr('INATIVO')+ 'AS STATUS, COUNT(COD_PROD)AS COD_PROD');
    SQL.Add('FROM PRODUTO');
    SQL.Add('WHERE ATIVO = 0');
    SQL.Add('AND DATA_VALIDADE BETWEEN '+dateTextSql(DataInicial)+' AND '+dateTextSql(DataFim)+'');
    RLLabel1.Caption := ' Focus Desenvolvimento de Sistemas - Gerado em '+ FormatDateTime('dd/mm/yyyy hh:MM:ss',Now) +'.';
    Open;
    rlbl7.Caption := ' Per?odo: De: '+DateToStr(DataInicial)+' At?: '+DateToStr(DataFim)+'';
  end;
end;

procedure TTRelProduto.ChamaTela(status,Ordenar,Relatorio,Produto:Integer;Inicial,Fim:TDateTime);
begin
  TRelProduto := TTRelProduto.Create(Application);
  with TRelProduto do
  begin
    RecebeRelatorio := Relatorio;
    RecebeProduto := Produto;
    OrdenaCampo := ordenar;
    OrdenaStatus := status;
    DataInicial := Inicial;
    DataFim := Fim;
    BlockRelatorio;

    case Relatorio  of
      0:
      begin
        DadosRelatorio;
      end;
      1:
      begin
        RelatorioSintetico;
      end;
    end;

    if qProduto.IsEmpty then
    begin
      enviaMensagem('N?o existe informa??o referente a pesquisa efetuada!','Informa??o...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      RLReport1.PreviewModal;
  end;
  FreeAndNil(TRelProduto);
end;

procedure TTRelProduto.DadosRelatorio;
  function FiltroSQL:string;
  begin
    if RLReport1.Tag = 0 then
    begin
      RLReport1.Tag := 1;
      Result := ' WHERE ';
    end
    else
      Result := ' AND ';
  end;
begin
  with qProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT P.COD_PROD,P.DESCRICAO_PROD,P.ESTOQUE_PROD,P.PRECO_PROD,F.NOME_FORNECEDOR');
    SQL.Add(', CONVERT(VARCHAR(10),P.DATA_VALIDADE,103)AS DATA_VALIDADE');
    SQL.Add('FROM PRODUTO P');
    SQL.Add('INNER JOIN FORNECEDORES F ON F.COD_FORNECEDOR = P.COD_FORNECEDOR');
    if RecebeProduto > 0 then
      SQL.Add(FiltroSQL + ' COD_PROD =  ' +IntToStr(RecebeProduto));
    case OrdenaStatus of
      0:
      begin
        RLLabel5.Caption := 'Listagem de Todos os Produto';
      end;
      1:
      begin
        SQL.Add(FiltroSQL + ' P.ATIVO = 1');
        RLLabel5.Caption := 'Listagem dos Produtos Ativos';
      end;
      2:
      begin
        SQL.Add(FiltroSQL +' P.ATIVO = 0');
        RLLabel5.Caption := 'Listagem dos Produtos Inativos';
      end;
    end;
    SQL.Add(FiltroSQL + ' P.DATA_VALIDADE BETWEEN '+dateTextSql(DataInicial) +' AND '+ dateTextSql(DataFim));
    case OrdenaCampo of
      1:
      begin
        SQL.Add('ORDER BY P.COD_PROD ASC');
        rlbl6.Caption := 'Ordenado pelo C?digo';
      end;
      2:
      begin
        SQL.Add('ORDER BY P.DESCRICAO_PROD ASC');
        rlbl6.Caption := 'Ordenado pela Descri??o';
      end;
      3:
      begin
        SQL.Add('ORDER BY P.PRECO_PROD ASC');
        rlbl6.Caption := 'Ordenado pelo Pre?o';
      end;
      4:
      begin
        SQL.Add('ORDER BY P.ESTOQUE_PROD ASC');
        rlbl6.Caption := 'Ordenado pelo Estoque';
      end;
    end;
    RLLabel1.Caption := ' Focus Desenvolvimento de Sistemas - Gerado em '+ FormatDateTime('dd/mm/yyyy hh:MM:ss',Now) +'.';
    rlbl7.Caption := 'Per?odo: De ' + DateToStr(DataInicial) + ' At? ' + DateToStr(DataFim);
    Open;
    qProduto.FieldByName('PRECO_PROD').OnGetText := qProdutoPRECO_PRODGetText;
  end;
end;

procedure TTRelProduto.FormCreate(Sender: TObject);
  var Estoque: Boolean;
begin
  ArquivoI := TIniFile.Create('D:\FOCUS\Ini\config.ini');
  Estoque := StrToBool(ArquivoI.ReadString('PRODUTO','ESTOQUE',''));
  ArquivoI.Free;
  if Estoque = False then
  begin
    rlpnl7.Visible := False;
    rlpnl14.Visible := False;
  end;
end;

procedure TTRelProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      Close;
  end;
end;

procedure TTRelProduto.qProdutoPRECO_PRODGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  Text := 'R$' + FormatFloat('0.00',qProduto.FieldByName('PRECO_PROD').AsFloat);
end;

end.
