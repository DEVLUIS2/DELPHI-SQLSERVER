unit FiltroTop10Fornecedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, rxToolEdit, DateUtils;

type
  TTFiltroTop10Fornecedores = class(TForm)
    Panel1: TPanel;
    pnl1: TPanel;
    btnCancelar: TBitBtn;
    btnRelatorio: TBitBtn;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtIni: TDateEdit;
    dtFim: TDateEdit;
    RadioGroup1: TRadioGroup;
    procedure dtIniKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dtFimKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRelatorioClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TFiltroTop10Fornecedores: TTFiltroTop10Fornecedores;

implementation

uses
  Funcoes, RelatorioTop10Fornecedores, GraficoTop10Fornecedores;

{$R *.dfm}

procedure TTFiltroTop10Fornecedores.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroTop10Fornecedores.btnRelatorioClick(Sender: TObject);
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
    0:
      TRelatorioTop10Fornecedores.ChamaTela(dtIni.Date,dtFim.Date);
    1:
      TGraficoTop10Fornecedores.ChamaTela;
  end;
end;

procedure TTFiltroTop10Fornecedores.ChamaTela;
begin
  TFiltroTop10Fornecedores := TTFiltroTop10Fornecedores.Create(Application);
  with TFiltroTop10Fornecedores do
  begin
    ShowModal;
    FreeAndNil(TFiltroTop10Fornecedores);
  end;
end;

procedure TTFiltroTop10Fornecedores.dtFimKeyDown(Sender: TObject; var Key: Word;
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

procedure TTFiltroTop10Fornecedores.dtIniKeyDown(Sender: TObject; var Key: Word;
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

procedure TTFiltroTop10Fornecedores.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) then
        btnCancelar.Click;
    VK_F5:
      if (btnRelatorio.Visible) and (btnRelatorio.Enabled) then
        btnRelatorio.Click;
  end;
end;

procedure TTFiltroTop10Fornecedores.FormShow(Sender: TObject);
begin
  dtIni.Date := StartOfTheMonth(Date);
  dtFim.Date := EndOfTheMonth(Date);
end;

procedure TTFiltroTop10Fornecedores.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 1 then
  begin
    dtIni.Enabled := False;
    dtFim.Enabled := False;
  end
  else
  begin
    dtIni.Enabled := True;
    dtFim.Enabled := True;
  end;
end;

end.
