unit RelatorioTop10Fornecedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, DB, ADODB, jpeg, ExtCtrls;

type
  TTRelatorioTop10Fornecedores = class(TForm)
    RLReport1: TRLReport;
    BandTitulo: TRLBand;
    RLBand4: TRLBand;
    rlpnl5: TRLPanel;
    rlpnl8: TRLPanel;
    rlbl1: TRLLabel;
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
    qTopFornecedores: TADOQuery;
    dsTopFornecedores: TDataSource;
    RLPanel3: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel4: TRLPanel;
    RLPanel8: TRLPanel;
    RLLabel4: TRLLabel;
    RLLabel7: TRLLabel;
    RLPanel9: TRLPanel;
    qTopFornecedoresProdutosComprados: TIntegerField;
    qTopFornecedoresCOD_FORNECEDOR: TAutoIncField;
    qTopFornecedoresDESCRICAO_PROD: TStringField;
    qTopFornecedoresNOME_FORNECEDOR: TStringField;
    RLPanel10: TRLPanel;
    rlpnl1: TRLPanel;
    rlpnl2: TRLPanel;
    RLLabel5: TRLLabel;
    rlpnl4: TRLPanel;
    rlbl7: TRLLabel;
    RLPanel11: TRLPanel;
    Image1: TImage;
    RLDBMemo1: TRLDBMemo;
    RLDBMemo2: TRLDBMemo;
  private
    DataI,DataF: TDateTime;
    procedure Relatorio;
    { Private declarations }
  public
    procedure ChamaTela(Data,Data2:TDateTime);
    { Public declarations }
  end;

var
  TRelatorioTop10Fornecedores: TTRelatorioTop10Fornecedores;

implementation

uses
  DMPRINCIPAL, Funcoes, FuncoesDB;

{$R *.dfm}

{ TForm1 }

procedure TTRelatorioTop10Fornecedores.ChamaTela(Data,Data2:TDateTime);
begin
  TRelatorioTop10Fornecedores := TTRelatorioTop10Fornecedores.Create(Application);
  with TRelatorioTop10Fornecedores do
  begin
    DataI := Data;
    DataF := Data2;
    Relatorio;
    if qTopFornecedores.IsEmpty then
    begin
      enviaMensagem('Nenhum registro encontrado','Informa??o',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      RLReport1.PreviewModal;
    FreeAndNil(TRelatorioTop10Fornecedores);
  end;
end;

procedure TTRelatorioTop10Fornecedores.Relatorio;
begin
  with qTopFornecedores do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 10 SUM(CI.QUANTIDADE_ITENS) AS '+QuotedStr('Produtos Comprados')+' ,F.COD_FORNECEDOR,P.DESCRICAO_PROD,F.NOME_FORNECEDOR');
    SQL.Add('FROM FORNECEDORES F');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_FORNECEDOR = F.COD_FORNECEDOR');
    SQL.Add('INNER JOIN COMPRA_ITENS CI ON CI.COD_PROD = P.COD_PROD');
    SQL.Add('INNER JOIN COMPRA C ON C.COD_COMPRA = CI.COD_COMPRA');
    sql.Add('WHERE C.DATA_COMPRA BETWEEN '+dateTextSql(DataI)+' AND '+dateTextSql(DataF)+'');
    SQL.Add('GROUP BY P.DESCRICAO_PROD,F.COD_FORNECEDOR,F.NOME_FORNECEDOR');
    SQL.Add('ORDER BY SUM(CI.QUANTIDADE_ITENS) DESC');
    rlbl7.Caption := ' Per?odo: De: '+DateToStr(DataI)+' At?: '+DateToStr(DataF)+' ';
    RLLabel1.Caption := ' Focus Desenvolvimento de Sistemas - Gerado em '+FormatDateTime('dd/mm/yyyy hh:mm:ss',Now)+' .';
    Open;
  end;
end;

end.
