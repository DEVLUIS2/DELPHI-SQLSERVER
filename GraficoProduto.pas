unit GraficoProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, DBChart, DB, ADODB, Series,
  StdCtrls, Buttons;

type
  TTGraficoProduto = class(TForm)
    qProduto: TADOQuery;
    qProdutoDESCRICAO_PROD: TStringField;
    qProdutoESTOQUE_PROD: TBCDField;
    Panel1: TPanel;
    btnNext: TBitBtn;
    btnPrev: TBitBtn;
    BitBtn3: TBitBtn;
    LabPage: TLabel;
    DBChart1: TDBChart;
    Series1: TBarSeries;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure DBChart1PageChange(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    OAtivo:Integer;
    procedure Grafico;
    { Private declarations }
  public
    procedure ChamaTela(Ativo:Integer);
    { Public declarations }
  end;

var
  TGraficoProduto: TTGraficoProduto;

implementation

uses
  DMPrincipal, Funcoes;

{$R *.dfm}

procedure TTGraficoProduto.btnPreviewClick(Sender: TObject);
begin
  DBChart1.PreviousPage;
end;

procedure TTGraficoProduto.btnNextClick(Sender: TObject);
begin
  DBChart1.NextPage;
end;

procedure TTGraficoProduto.BitBtn1Click(Sender: TObject);
begin
  DBChart1.NextPage;
  btnPrev.Enabled := True;
end;

procedure TTGraficoProduto.btnPrevClick(Sender: TObject);
begin
  DBChart1.PreviousPage;
  btnNext.Enabled := True;
end;

procedure TTGraficoProduto.BitBtn3Click(Sender: TObject);
begin
  Close;
end;

procedure TTGraficoProduto.ChamaTela(Ativo:Integer);
begin
  TGraficoProduto := TTGraficoProduto.Create(Application);
  with TGraficoProduto do
  begin
    OAtivo := Ativo;
    Grafico;
    if qProduto.IsEmpty then
    begin
      enviaMensagem('Sem registro!','Informação...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      ShowModal;
    FreeAndNil(TGraficoProduto);
  end;
end;

procedure TTGraficoProduto.DBChart1PageChange(Sender: TObject);
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

procedure TTGraficoProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      Close;
  end;
end;

procedure TTGraficoProduto.Grafico;
begin
  with qProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT DESCRICAO_PROD,ESTOQUE_PROD');
    SQL.Add('FROM PRODUTO');
    case OAtivo of
      1:
        SQL.Add('WHERE ATIVO = 1');
      2:
        SQL.Add('WHERE ATIVO = 0');
    end;
    SQL.Add('ORDER BY ESTOQUE_PROD');
    Open;
    if qProduto.RecordCount = 1 then
      DBChart1.pages.AutoScale := False;
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
end;

end.



