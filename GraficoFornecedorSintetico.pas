unit GraficoFornecedorSintetico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, ADODB, TeeProcs, TeEngine, Chart,
  DBChart, Series;

type
  TTGraficoSinteticoFornecedor = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnPrev: TBitBtn;
    btnNext: TBitBtn;
    btnFechar: TBitBtn;
    LContador: TLabel;
    DBChart1: TDBChart;
    qFornecedor: TADOQuery;
    Series1: TPieSeries;
    procedure DBChart1PageChange(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure GraficoSintetico;
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TGraficoSinteticoFornecedor: TTGraficoSinteticoFornecedor;

implementation

uses
  DMPrincipal;

{$R *.dfm}

procedure TTGraficoSinteticoFornecedor.btnPrevClick(Sender: TObject);
begin
  DBChart1.PreviousPage;
  btnNext.Enabled := True;
end;

procedure TTGraficoSinteticoFornecedor.btnNextClick(Sender: TObject);
begin
  DBChart1.NextPage;
  btnPrev.Enabled := True;
end;

procedure TTGraficoSinteticoFornecedor.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoSinteticoFornecedor.ChamaTela;
begin
  TGraficoSinteticoFornecedor := TTGraficoSinteticoFornecedor.Create(Application);
  with TGraficoSinteticoFornecedor do
  begin
    GraficoSintetico;
    ShowModal;
    FreeAndNil(TGraficoSinteticoFornecedor);
  end;
end;

procedure TTGraficoSinteticoFornecedor.DBChart1PageChange(Sender: TObject);
begin
  LContador.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
  if DBChart1.Page <= 1 then
  begin
    btnPrev.Enabled := False;
  end;
  if DBChart1.Page = DBChart1.NumPages then
  begin
    btnNext.Enabled := False;
  end;
end;

procedure TTGraficoSinteticoFornecedor.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnFechar.Click;
  end;
end;

procedure TTGraficoSinteticoFornecedor.GraficoSintetico;
begin
  with qFornecedor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT '+QuotedStr('ATIVO')+'AS STATUS, COUNT(COD_FORNECEDOR)AS QUANTIDADE');
    SQL.Add('FROM FORNECEDORES');
    SQL.Add('WHERE ATIVO = 1');
    SQL.Add('UNION ALL');
    SQL.Add('SELECT '+QuotedStr('INATIVO')+'AS STATUS,COUNT(COD_FORNECEDOR)AS QUANTIDADE');
    SQL.Add('FROM FORNECEDORES');
    SQL.Add('WHERE ATIVO = 0');
    Open;
    LContador.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
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
