unit GraficoCompraPeriodo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, ADODB, TeeProcs, TeEngine, Chart,
  DBChart, Series;

type
  TTGraficoCompraPeriodo = class(TForm)
    Panel1: TPanel;
    LabPage: TLabel;
    B1: TBitBtn;
    B2: TBitBtn;
    btnFechar: TBitBtn;
    Panel2: TPanel;
    DBChart1: TDBChart;
    qFornecedor: TADOQuery;
    Series1: TBarSeries;
    qFornecedorNOME_CLI: TStringField;
    qFornecedorQUNATIDADEDEPRODUTOSDACOMPRA: TIntegerField;
    procedure btnFecharClick(Sender: TObject);
    procedure DBChart1PageChange(Sender: TObject);
    procedure B2Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure Grafico;
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TGraficoCompraPeriodo: TTGraficoCompraPeriodo;

implementation

uses
  Funcoes, FuncoesDB, DMPrincipal;

{$R *.dfm}

procedure TTGraficoCompraPeriodo.B1Click(Sender: TObject);
begin
  DBChart1.NextPage;
  B2.Enabled := True;
end;

procedure TTGraficoCompraPeriodo.B2Click(Sender: TObject);
begin
  DBChart1.PreviousPage;
  B1.Enabled := True;
end;

procedure TTGraficoCompraPeriodo.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoCompraPeriodo.ChamaTela;
begin
  TGraficoCompraPeriodo := TTGraficoCompraPeriodo.Create(Application);
  with TGraficoCompraPeriodo do
  begin
    Grafico;
    if qFornecedor.IsEmpty then
    begin
      enviaMensagem('Sem registro','Informação...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      ShowModal;
    FreeAndNil(TGraficoCompraPeriodo);
  end;
end;

procedure TTGraficoCompraPeriodo.DBChart1PageChange(Sender: TObject);
begin
  LabPage.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
  if DBChart1.Page <= 1 then
  begin
    B2.Enabled := False;
  end;
  if DBChart1.Page = DBChart1.NumPages then
  begin
    B1.Enabled := False;
  end;
end;

procedure TTGraficoCompraPeriodo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnFechar.Click;
  end;
end;

procedure TTGraficoCompraPeriodo.Grafico;
begin
  with qFornecedor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT C.NOME_CLI,SUM(CP.QUANTIDADE_COMPRA)AS '+QuotedStr('QUNATIDADE DE PRODUTOS DA COMPRA')+'');
    SQL.Add('FROM CLIENTE C');
    SQL.Add('INNER JOIN COMPRA CP ON CP.COD_CLI = C.COD_CLI');
    SQL.Add('GROUP BY C.NOME_CLI');
    SQL.Add('ORDER BY [QUNATIDADE DE PRODUTOS DA COMPRA] DESC');
    Open;
    LabPage.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
    if DBChart1.Page <= 1 then
    begin
      B2.Enabled := False;
    end;
    if DBChart1.Page = DBChart1.NumPages then
    begin
      B1.Enabled := False;
    end;
  end;
end;

end.
