unit FiltroTop10Produtos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, rxToolEdit, Buttons, ExtCtrls, DateUtils;

type
  TTFiltroTop10Produtos = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnImprimir: TBitBtn;
    btnCancelar: TBitBtn;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtIni: TDateEdit;
    dtFim: TDateEdit;
    RadioGroup1: TRadioGroup;
    procedure dtIniKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dtFimKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TFiltroTop10Produtos: TTFiltroTop10Produtos;

implementation

uses
  Funcoes, RelatorioTop10Produto, GraficoTop10Produto;

{$R *.dfm}

procedure TTFiltroTop10Produtos.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroTop10Produtos.btnImprimirClick(Sender: TObject);
begin
  if not(validarData(dtIni.Text)) then
  begin
    enviaMensagem('Data Inicial Inv?lida','Informa??o',mtConfirmation,[mbOK]);
    if dtIni.CanFocus then
      dtIni.SetFocus;
    Exit;
  end;
  if not(validarData(dtFim.Text)) then
  begin
    enviaMensagem('Data final inv?lida','Informa??o',mtConfirmation,[mbOK]);
    if dtFim.CanFocus then
      dtFim.SetFocus;
    Exit
  end;
  case RadioGroup1.ItemIndex of
    0:  TRelatorioTop10Produto.ChamaTela(dtIni.Date,dtFim.Date);
    1:  TGraficoTop10Produto.ChamaTela(dtIni.Date,dtFim.Date);
  end;
end;

procedure TTFiltroTop10Produtos.ChamaTela;
begin
  TFiltroTop10Produtos := TTFiltroTop10Produtos.Create(Application);
  with TFiltroTop10Produtos do
  begin
    ShowModal;
    FreeAndNil(TFiltroTop10Produtos);
  end;
end;

procedure TTFiltroTop10Produtos.dtFimKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if btnCancelar.CanFocus then
      begin
         btnCancelar.SetFocus;
         Close;
      end;
  end;
end;

procedure TTFiltroTop10Produtos.dtIniKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if btnCancelar.CanFocus then
      begin
         btnCancelar.SetFocus;
         Close;
      end;
  end;
end;

procedure TTFiltroTop10Produtos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) then
        btnCancelar.Click;
  end;
end;

procedure TTFiltroTop10Produtos.FormShow(Sender: TObject);
begin
  dtIni.Date := StartOfTheMonth(Date);
  dtFim.Date := EndOfTheMonth(Date);
end;

end.
