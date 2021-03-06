unit FiltroTop10Clientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Mask, rxToolEdit, DateUtils;

type
  TTFiltroTop10Clientes = class(TForm)
    Panel2: TPanel;
    btnImprimir: TBitBtn;
    btnCancelar: TBitBtn;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtIni: TDateEdit;
    dtFim: TDateEdit;
    RadioGroup1: TRadioGroup;
    procedure btnImprimirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure dtIniKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TFiltroTop10Clientes: TTFiltroTop10Clientes;

implementation

uses
   Funcoes, RelatorioTop10Cliente, GraficoCliente;

{$R *.dfm}

procedure TTFiltroTop10Clientes.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroTop10Clientes.btnImprimirClick(Sender: TObject);
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
  if RadioGroup1.ItemIndex = 1 then
    TGraficoCliente.ChamaTela(dtIni.Date,dtFim.Date)
  else
    TRelatorioTop10Cliente.ChamaTela(dtIni.Date,dtFim.Date,RadioGroup1.ItemIndex);
end;

procedure TTFiltroTop10Clientes.ChamaTela;
begin
  TFiltroTop10Clientes := TTFiltroTop10Clientes.Create(Application);
  with TFiltroTop10Clientes do
  begin
    ShowModal;
    FreeAndNil(TFiltroTop10Clientes);
  end;
end;

procedure TTFiltroTop10Clientes.dtIniKeyDown(Sender: TObject; var Key: Word;
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

procedure TTFiltroTop10Clientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) then
        btnCancelar.Click;
    VK_F5:
      if (btnImprimir.Visible) and (btnImprimir.Enabled) then
        btnImprimir.Click;
  end;
end;

procedure TTFiltroTop10Clientes.FormShow(Sender: TObject);
begin
  dtIni.Date := StartOfTheMonth(Date);
  dtFim.Date := EndOfTheMonth(Date);
end;

end.
