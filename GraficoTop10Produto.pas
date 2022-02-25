unit GraficoTop10Produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, ADODB, TeeProcs, TeEngine, Chart,
  DBChart, Series;

type
  TTGraficoTop10Produto = class(TForm)
    Panel1: TPanel;
    LabPage: TLabel;
    btnNext: TBitBtn;
    btnPrev: TBitBtn;
    btnFechar: TBitBtn;
    Panel2: TPanel;
    DBChart1: TDBChart;
    qGraficoProduto: TADOQuery;
    Series1: TBarSeries;
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure DBChart1PageChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnFecharClick(Sender: TObject);
  private
    RIni,RFim:TDateTime;
    procedure Grafico;
    { Private declarations }
  public
    procedure ChamaTela(Ini,Fim:TDateTime);
    { Public declarations }
  end;

var
  TGraficoTop10Produto: TTGraficoTop10Produto;

implementation

uses
  DMPrincipal, Funcoes, FuncoesDB;

{$R *.dfm}

procedure TTGraficoTop10Produto.btnNextClick(Sender: TObject);
begin
  DBChart1.NextPage;
  btnPrev.Enabled := True;
end;

procedure TTGraficoTop10Produto.btnPrevClick(Sender: TObject);
begin
  DBChart1.PreviousPage;
  btnNext.Enabled := True;
end;

procedure TTGraficoTop10Produto.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoTop10Produto.ChamaTela(Ini,Fim:TDateTime);
begin
  TGraficoTop10Produto := TTGraficoTop10Produto.Create(Application);
  with TGraficoTop10Produto do
  begin
    RIni := Ini;
    RFim := Fim;
    Grafico;
    if qGraficoProduto.IsEmpty then
    begin
      enviaMensagem('Sem registro!','Informa��o...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      ShowModal;
    FreeAndNil(TGraficoTop10Produto);
  end;
end;

procedure TTGraficoTop10Produto.DBChart1PageChange(Sender: TObject);
begin
  LabPage.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
  if DBChart1.Page = 1 then
  begin
    btnPrev.Enabled := False;
  end;
  if DBChart1.Page = DBChart1.NumPages then
  begin
    btnNext.Enabled := False;
  end;
end;

procedure TTGraficoTop10Produto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnfechar.Click;
  end;
end;

procedure TTGraficoTop10Produto.Grafico;
begin
  with qGraficoProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 10 SUM(CI.QUANTIDADE_ITENS) AS '+QuotedStr('Produtos Comprados')+',');
    SQL.Add('P.COD_PROD,P.DESCRICAO_PROD,F.NOME_FORNECEDOR ');
    SQL.Add('FROM FORNECEDORES F');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_FORNECEDOR = F.COD_FORNECEDOR');
    SQL.Add('INNER JOIN COMPRA_ITENS CI ON CI.COD_PROD = P.COD_PROD');
    SQL.Add('INNER JOIN COMPRA C ON C.COD_COMPRA = CI.COD_COMPRA');
    SQL.Add('WHERE C.DATA_COMPRA BETWEEN '+dateTextSql(RIni)+' AND '+dateTextSql(RFim)+'');
    SQL.Add('GROUP BY P.DESCRICAO_PROD,P.COD_PROD,F.NOME_FORNECEDOR');
    SQL.Add('ORDER BY SUM(CI.QUANTIDADE_ITENS) DESC');
    Open;
    LabPage.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
    if DBChart1.Page = 1 then
    begin
      btnPrev.Enabled := False;
    end;
    if DBChart1.Page = DBChart1.NumPages then
    begin
      btnNext.Enabled := False;
    end;
  end;
end;

end.
