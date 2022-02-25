unit GraficoTop10Fornecedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, TeeProcs, TeEngine, Chart, DBChart, DB,
  ADODB, Series;

type
  TTGraficoTop10Fornecedores = class(TForm)
    Panel1: TPanel;
    LabPage: TLabel;
    btnNext: TBitBtn;
    btnPrev: TBitBtn;
    btnFechar: TBitBtn;
    Panel2: TPanel;
    DBChart1: TDBChart;
    qTopFornecedores: TADOQuery;
    Series1: TBarSeries;
    qTopFornecedoresCOD_FORNECEDOR: TAutoIncField;
    qTopFornecedoresNOME_FORNECEDOR: TStringField;
    qTopFornecedoresQUANTIDADEFORNECIDA: TFMTBCDField;
    procedure btnFecharClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure DBChart1PageChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure Grafico;
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TGraficoTop10Fornecedores: TTGraficoTop10Fornecedores;

implementation

uses
  DMPrincipal, Funcoes;

{$R *.dfm}

procedure TTGraficoTop10Fornecedores.btnNextClick(Sender: TObject);
begin
  DBChart1.NextPage;
  btnPrev.Enabled := True;
end;

procedure TTGraficoTop10Fornecedores.btnPrevClick(Sender: TObject);
begin
  DBChart1.PreviousPage;
  btnNext.Enabled := True;
end;

procedure TTGraficoTop10Fornecedores.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoTop10Fornecedores.ChamaTela;
begin
  TGraficoTop10Fornecedores := TTGraficoTop10Fornecedores.Create(Application);
  with TGraficoTop10Fornecedores do
  begin
    Grafico;
    if qTopFornecedores.IsEmpty then
    begin
      enviaMensagem('Sem registros','Informação...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      ShowModal;
    FreeAndNil(TGraficoTop10Fornecedores);
  end;
end;

procedure TTGraficoTop10Fornecedores.DBChart1PageChange(Sender: TObject);
begin
  LabPage.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
  if DBChart1.Page <= 1 then
  begin
    btnPrev.Enabled := False;
  end;
  if DBChart1.Page = DBChart1.NumPages then
  begin
    btnNext.Enabled := False;
  end;
end;

procedure TTGraficoTop10Fornecedores.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnFechar.Click;
  end;
end;

procedure TTGraficoTop10Fornecedores.Grafico;
begin
  with qTopFornecedores do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP(10) F.COD_FORNECEDOR,F.NOME_FORNECEDOR,');
    SQL.Add('SUM(P.ESTOQUE_PROD)AS '+QuotedStr('QUANTIDADE FORNECIDA')+'');
    SQL.Add('FROM FORNECEDORES F');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_FORNECEDOR = F.COD_FORNECEDOR');
    SQL.Add('GROUP BY F.COD_FORNECEDOR,F.NOME_FORNECEDOR');
    SQL.Add('ORDER BY [QUANTIDADE FORNECIDA] DESC');
    Open;
    LabPage.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
    if DBChart1.Page <= 1 then
      btnPrev.Enabled := False;
    if DBChart1.Page = DBChart1.NumPages then
      btnNext.Enabled := False;
  end;
end;

end.
