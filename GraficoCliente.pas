unit GraficoCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, RLReport, Series, DB, ADODB,
  DBChart, jpeg, StdCtrls, Buttons;

type
  TTGraficoCliente = class(TForm)
    qCliente: TADOQuery;
    DBChart1: TDBChart;
    Series2: TBarSeries;
    Panel1: TPanel;
    LabPage: TLabel;
    btnPreview: TBitBtn;
    btnNext: TBitBtn;
    BitBtn3: TBitBtn;
    qClienteCOD_CLI: TAutoIncField;
    qClienteNOME_CLI: TStringField;
    qClienteValorTotal: TFMTBCDField;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnNextClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure DBChart1PageChange(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
  private
    RIni,RFim:TDateTime;
    procedure Grafico;
    { Private declarations }
  public
    procedure ChamaTela(Ini,Fim:TDateTime);
    { Public declarations }
  end;

var
  TGraficoCliente: TTGraficoCliente;

implementation

uses
  DMPrincipal, Funcoes, FuncoesDB;

{$R *.dfm}

{ TTGraficoCliente }

procedure TTGraficoCliente.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoCliente.btnNextClick(Sender: TObject);
begin
  DBChart1.NextPage;
  btnPreview.Enabled := True;
end;

procedure TTGraficoCliente.btnPreviewClick(Sender: TObject);
begin
  DBChart1.PreviousPage;
  btnNext.Enabled := True;
end;

procedure TTGraficoCliente.ChamaTela(Ini,Fim:TDateTime);
begin
  TGraficoCliente := TTGraficoCliente.Create(Application);
  with TGraficoCliente do
  begin
    RIni := Ini;
    RFim := Fim;
    Grafico;
    if qCliente.IsEmpty then
    begin
      enviaMensagem('Sem registros!','Informação...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      ShowModal;
    FreeAndNil(TGraficoCliente);
  end;
end;

procedure TTGraficoCliente.DBChart1PageChange(Sender: TObject);
begin
  LabPage.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
  if DBChart1.Page <= 1 then
  begin
    btnPreview.Enabled := False;
  end;
  if DBChart1.Page = DBChart1.NumPages then
  begin
    btnNext.Enabled := False;
  end;
end;

procedure TTGraficoCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      Close;
  end;
end;

procedure TTGraficoCliente.Grafico;
begin
  with qCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP(10) C.COD_CLI,C.NOME_CLI,SUM(CP.VALORTOTAL_COMPRA)AS '+QuotedStr('VALOR TOTAL')+'');
    SQL.Add('FROM CLIENTE C');
    SQL.Add('INNER JOIN COMPRA CP ON CP.COD_CLI = C.COD_CLI');
    SQL.Add('WHERE CP.DATA_COMPRA BETWEEN '+dateTextSql(RIni)+' AND '+dateTextSql(RFim)+'');
    SQL.Add('GROUP BY C.COD_CLI,C.NOME_CLI');
    SQL.Add('ORDER BY [Valor Total] ASC');
    Open;
    LabPage.Caption := IntToStr(DBChart1.Page) + '/' + IntToStr(DBChart1.NumPages);
    if DBChart1.Page = 1 then
    begin
      btnPreview.Enabled := False;
    end;
    if DBChart1.Page = DBChart1.NumPages then
    begin
      btnNext.Enabled := False;
    end;
  end;
end;

end.
