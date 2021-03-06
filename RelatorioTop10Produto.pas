unit RelatorioTop10Produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, DB, ADODB, jpeg, ExtCtrls;

type
  TTRelatorioTop10Produto = class(TForm)
    RLReport1: TRLReport;
    BandTitulo: TRLBand;
    RLBand4: TRLBand;
    rlpnl5: TRLPanel;
    rlpnl8: TRLPanel;
    rlbl1: TRLLabel;
    rlpnl9: TRLPanel;
    rlbl2: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel3: TRLLabel;
    RLBand1: TRLBand;
    rlpnl11: TRLPanel;
    TRLDBDPrecoCOD_PROD: TRLDBText;
    rlpnl12: TRLPanel;
    RLPanel5: TRLPanel;
    RLDBText2: TRLDBText;
    RLBand2: TRLBand;
    RLPanel6: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLPanel7: TRLPanel;
    RLLabel6: TRLLabel;
    RLBand3: TRLBand;
    RLPanel1: TRLPanel;
    RLLabel1: TRLLabel;
    dsTopProduto: TDataSource;
    qTopProduto: TADOQuery;
    RLPanel3: TRLPanel;
    rlpnl1: TRLPanel;
    rlpnl2: TRLPanel;
    RLLabel5: TRLLabel;
    rlpnl3: TRLPanel;
    rlbl6: TRLLabel;
    rlpnl4: TRLPanel;
    rlbl7: TRLLabel;
    RLPanel4: TRLPanel;
    Image1: TImage;
    RLDBMemo1: TRLDBMemo;
  private
    RecebeI,RecebeF :TDateTime;
    procedure RelatorioTop10;
    { Private declarations }
  public
    { Public declarations }
    procedure ChamaTela(dtIni,dtFim:TDateTime);
  end;

var
  TRelatorioTop10Produto: TTRelatorioTop10Produto;

implementation

uses
  DMPRINCIPAL, FuncoesDB, Funcoes;

{$R *.dfm}

{ TForm1 }

procedure TTRelatorioTop10Produto.ChamaTela(dtIni,dtFim:TDateTime);
begin
  TRelatorioTop10Produto := TTRelatorioTop10Produto.Create(Application);
  with TRelatorioTop10Produto do
  begin
    RecebeI := dtIni;
    RecebeF := dtFim;
    RelatorioTop10;
    if qTopProduto.IsEmpty then
      enviaMensagem('N?o existem registros','Informa??o',mtConfirmation,[mbOK])
    else
      RLReport1.PreviewModal;
    FreeAndNil(TRelatorioTop10Produto);
  end;
end;

procedure TTRelatorioTop10Produto.RelatorioTop10;
begin
  with qTopProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 10 SUM(CI.QUANTIDADE_ITENS) AS '+QuotedStr('Produtos Comprados')+'');
    SQL.Add(',P.COD_PROD,P.DESCRICAO_PROD');
    SQL.Add('FROM FORNECEDORES F');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_FORNECEDOR = F.COD_FORNECEDOR');
    SQL.Add('INNER JOIN COMPRA_ITENS CI ON CI.COD_PROD = P.COD_PROD');
    SQL.Add('INNER JOIN COMPRA C ON C.COD_COMPRA = CI.COD_COMPRA');
    SQL.Add('WHERE C.DATA_COMPRA BETWEEN '+dateTextSql(RecebeI)+' AND '+dateTextSql(RecebeF)+'');
    SQL.Add('GROUP BY P.DESCRICAO_PROD,P.COD_PROD');
    SQL.Add('ORDER BY SUM(CI.QUANTIDADE_ITENS) DESC');
    Open;
    rlbl7.Caption := ' Per?odo: De: '+DateToStr(RecebeI)+' At?: '+DateToStr(RecebeF)+'';
    RLLabel1.Caption := ' Focus Desenvolvimento de Sistemas - Gerado em '+ FormatDateTime('dd/mm/yyyy hh:MM:ss',Now)+' .';
  end;
end;

end.
