unit GraficoCompraPeriodoSintetico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, TeeProcs, TeEngine, Chart, DBChart, DB,
  ADODB, Series;

type
  TTGraficoCompraPeriodoSintetico = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnPrev: TBitBtn;
    LCount: TLabel;
    btnFechar: TBitBtn;
    btnNext: TBitBtn;
    DBChart1: TDBChart;
    qCompra: TADOQuery;
    Series2: TBarSeries;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure DBChart1PageChange(Sender: TObject);
  private
    RIni,RFim:TDateTime;
    procedure GraficoSintetico;
    { Private declarations }
  public
    procedure ChamaTela(Ini,Fim:TDateTime);
    { Public declarations }
  end;

var
  TGraficoCompraPeriodoSintetico: TTGraficoCompraPeriodoSintetico;

implementation

uses
  DMPrincipal, FuncoesDB, Funcoes;

{$R *.dfm}

procedure TTGraficoCompraPeriodoSintetico.btnPrevClick(Sender: TObject);
begin
  DBChart1.PreviousPage;
  btnNext.Enabled := True;
end;

procedure TTGraficoCompraPeriodoSintetico.btnNextClick(Sender: TObject);
begin
  DBChart1.NextPage;
  btnPrev.Enabled := True;
end;

procedure TTGraficoCompraPeriodoSintetico.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoCompraPeriodoSintetico.ChamaTela(Ini,Fim:TDateTime);
begin
  TGraficoCompraPeriodoSintetico := TTGraficoCompraPeriodoSintetico.Create(Application);
  with TGraficoCompraPeriodoSintetico do
  begin
    RIni := Ini;
    RFim := Fim;
    GraficoSintetico;
    if qCompra.IsEmpty then
    begin
      enviaMensagem('Sem registro','Informação...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      ShowModal;
    FreeAndNil(TGraficoCompraPeriodoSintetico);
  end;
end;

procedure TTGraficoCompraPeriodoSintetico.DBChart1PageChange(Sender: TObject);
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

procedure TTGraficoCompraPeriodoSintetico.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnFechar.Click;
  end;
end;

procedure TTGraficoCompraPeriodoSintetico.GraficoSintetico;
begin
  with qCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT CONVERT(VARCHAR(10),DATA_COMPRA,103)AS DATA_COMPRA,');
    SQL.Add('SUM(QUANTIDADE_COMPRA)AS QUANTIDADE');
    SQL.Add('FROM COMPRA');
    SQL.Add('WHERE DATA_COMPRA BETWEEN '+dateTextSql(RIni)+' AND '+dateTextSql(RFim)+'');
    SQL.Add('GROUP BY DATA_COMPRA');
    SQL.Add('ORDER BY DATA_COMPRA');
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
