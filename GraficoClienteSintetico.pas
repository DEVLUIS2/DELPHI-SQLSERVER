unit GraficoClienteSintetico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, TeeProcs, TeEngine, Chart, DBChart, DB,
  ADODB, Series;

type
  TTGraficoClienteSintetico = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    B1: TBitBtn;
    btnFechar: TBitBtn;
    LContador: TLabel;
    B3: TBitBtn;
    DBChart1: TDBChart;
    qCliente: TADOQuery;
    Series1: TPieSeries;
    procedure B1Click(Sender: TObject);
    procedure B3Click(Sender: TObject);
    procedure DBChart1PageChange(Sender: TObject);
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
  TGraficoClienteSintetico: TTGraficoClienteSintetico;

implementation

uses
  DMPrincipal;

{$R *.dfm}

procedure TTGraficoClienteSintetico.B1Click(Sender: TObject);
begin
  DBChart1.PreviousPage;
  B3.Enabled := True;
end;

procedure TTGraficoClienteSintetico.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoClienteSintetico.B3Click(Sender: TObject);
begin
  DBChart1.NextPage;
  B1.Enabled := True;
end;

procedure TTGraficoClienteSintetico.ChamaTela;
begin
  TGraficoClienteSintetico := TTGraficoClienteSintetico.Create(Application);
  with TGraficoClienteSintetico do
  begin
    GraficoSintetico;
    ShowModal;
    FreeAndNil(TGraficoClienteSintetico);
  end;
end;

procedure TTGraficoClienteSintetico.DBChart1PageChange(Sender: TObject);
begin
  LContador.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
  if DBChart1.Page <= 1 then
  begin
    B1.Enabled := False;
  end;
  if DBChart1.Page = DBChart1.NumPages then
  begin
    B3.Enabled := False;
  end;
end;

procedure TTGraficoClienteSintetico.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnFechar.Click;
  end;
end;

procedure TTGraficoClienteSintetico.GraficoSintetico;
begin
  with qCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT '+QuotedStr('ATIVO')+'AS STATUS, COUNT(COD_CLI)AS QUANTIDADE');
    SQL.Add('FROM CLIENTE');
    SQL.Add('WHERE ATIVO = 1');
    SQL.Add('UNION ALL');
    SQL.Add('SELECT '+QuotedStr('INATIVO')+' AS STATUS, COUNT(COD_CLI)AS QUANTIDADE');
    SQL.Add('FROM CLIENTE');
    SQL.Add('WHERE ATIVO = 0');
    Open;
    LContador.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
    if DBChart1.Page <= 1 then
    begin
      B1.Enabled := False;
    end;
    if DBChart1.Page = DBChart1.NumPages then
    begin
      B3.Enabled := False;
    end;
  end;
end;

end.
