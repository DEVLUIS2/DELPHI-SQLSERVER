unit FiltroCompraPeriodo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, rxToolEdit, DateUtils;

type
  TTFiltroCompraPeriodo = class(TForm)
    pnl1: TPanel;
    btnCancelar: TBitBtn;
    btnRelatorio: TBitBtn;
    Panel2: TPanel;
    Panel1: TPanel;
    gbPeriodo: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    dtIni: TDateEdit;
    dtFim: TDateEdit;
    rgTipoRelatorio: TRadioGroup;
    Panel3: TPanel;
    rgOrdenar: TRadioGroup;
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    procedure dtIniKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dtFimKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure rgTipoRelatorioClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TFiltroCompraPeriodo: TTFiltroCompraPeriodo;

implementation

uses
  RelatorioCompraPeriodo, GraficoCompraPeriodo, Funcoes, GraficoCompraPeriodoSintetico;

{$R *.dfm}

procedure TTFiltroCompraPeriodo.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroCompraPeriodo.btnRelatorioClick(Sender: TObject);
begin
  if (dtIni.Enabled = True) and not(validarData(dtIni.Text)) then
  begin
    enviaMensagem('Data Inicial Inv?lida','Informa??o...',mtConfirmation,[mbOK]);
    if dtIni.CanFocus then
      dtIni.SetFocus;
    Exit;
  end;
  if (dtFim.Enabled = True) and not(validarData(dtFim.Text)) then
  begin
    enviaMensagem('Data final inv?lida','Informa??o...',mtConfirmation,[mbOK]);
    if dtFim.CanFocus then
      dtFim.SetFocus;
    Exit;
  end;
  if (GroupBox1.Visible = True) and (ComboBox1.ItemIndex = 0) then
  begin
    enviaMensagem('Selecione um tipo de gr?fico para visualizar','Informa??o...',mtConfirmation,[mbOK]);
    if ComboBox1.CanFocus then
      ComboBox1.SetFocus;
    Exit;
  end;
  if rgTipoRelatorio.ItemIndex = 2 then
  begin
    case ComboBox1.ItemIndex of
      1:
      begin
        TGraficoCompraPeriodo.ChamaTela
      end;
      2:
      begin
        TGraficoCompraPeriodoSintetico.ChamaTela(dtIni.Date,dtFim.Date);
      end;
    end;
    Exit;
  end
  else
    TRelatorioCompraPeriodo.ChamaTela(dtIni.Date,dtFim.Date,rgTipoRelatorio.ItemIndex,rgOrdenar.ItemIndex);
end;

procedure TTFiltroCompraPeriodo.ChamaTela;
begin
  TFiltroCompraPeriodo := TTFiltroCompraPeriodo.Create(Application);
  with TFiltroCompraPeriodo do
  begin
    ShowModal;
    FreeAndNil(TFiltroCompraPeriodo);
  end;
end;

procedure TTFiltroCompraPeriodo.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex = 2 then
  begin
    dtIni.Enabled := True;
    dtFim.Enabled := True;
  end
  else
  begin
    dtIni.Enabled := False;
    dtFim.Enabled := False;
  end;
end;

procedure TTFiltroCompraPeriodo.dtFimKeyDown(Sender: TObject; var Key: Word;
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

procedure TTFiltroCompraPeriodo.dtIniKeyDown(Sender: TObject; var Key: Word;
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

procedure TTFiltroCompraPeriodo.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TTFiltroCompraPeriodo.FormShow(Sender: TObject);
begin
  dtIni.Date := StartOfTheMonth(Date);
  dtFim.Date := EndOfTheMonth(Date);
end;

procedure TTFiltroCompraPeriodo.rgTipoRelatorioClick(Sender: TObject);
begin
  case rgTipoRelatorio.ItemIndex of
    0:
    begin
      dtIni.Enabled := True;
      dtFim.Enabled := True;
      rgOrdenar.Enabled := True;
      GroupBox1.Visible := False;
    end;
    1:
    begin
      dtIni.Enabled := True;
      dtFim.Enabled := True;
      rgOrdenar.Enabled := False;
      GroupBox1.Visible := False;
    end;
    2:
    begin
      dtIni.Enabled := False;
      dtFim.Enabled := False;
      GroupBox1.Visible := True;
      rgOrdenar.Enabled := False;
    end;
  end;
end;

end.
