unit GraficoProdutoSintetico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, TeeProcs, TeEngine, Chart, DBChart, DB,
  ADODB, Series;

type
  TTGraficoProdutoSintetico = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    qProduto: TADOQuery;
    DBChart1: TDBChart;
    btnNext: TBitBtn;
    btnFechar: TBitBtn;
    btnPrev: TBitBtn;
    LCount: TLabel;
    Series1: TPieSeries;
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure DBChart1PageChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnFecharClick(Sender: TObject);
  private
    procedure GraficoSintetico;
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TGraficoProdutoSintetico: TTGraficoProdutoSintetico;

implementation

uses
  DMPrincipal;

{$R *.dfm}

procedure TTGraficoProdutoSintetico.btnNextClick(Sender: TObject);
begin
  DBChart1.NextPage;
  btnPrev.Enabled := True;
end;

procedure TTGraficoProdutoSintetico.btnPrevClick(Sender: TObject);
begin
  DBChart1.PreviousPage;
  btnNext.Enabled := True;
end;

procedure TTGraficoProdutoSintetico.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoProdutoSintetico.ChamaTela;
begin
  TGraficoProdutoSintetico := TTGraficoProdutoSintetico.Create(Application);
  with TGraficoProdutoSintetico do
  begin
    GraficoSintetico;
    ShowModal;
    FreeAndNil(TGraficoProdutoSintetico);
  end;
end;

procedure TTGraficoProdutoSintetico.DBChart1PageChange(Sender: TObject);
begin
  LCount.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
  if DBChart1.Page <= 1 then
  begin
    btnPrev.Enabled := False;
  end;
  if DBChart1.Page = DBChart1.NumPages then
  begin
    btnNext.Enabled := False;
  end;
end;

procedure TTGraficoProdutoSintetico.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnFechar.Click;
  end;
end;

procedure TTGraficoProdutoSintetico.GraficoSintetico;
begin
  with qProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT '+QuotedStr('ATIVO')+'AS STATUS, COUNT(COD_PROD)AS QUANTIDADE');
    SQL.Add('FROM PRODUTO');
    SQL.Add('WHERE ATIVO = 1');
    SQL.Add('UNION ALL');
    SQL.Add('SELECT '+QuotedStr('INATIVO')+'AS STATUS, COUNT(COD_PROD)AS QUANTIDADE');
    SQL.Add('FROM PRODUTO');
    SQL.Add('WHERE ATIVO = 0');
    Open;
    LCount.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
    if DBChart1.Page <= 1 then
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

