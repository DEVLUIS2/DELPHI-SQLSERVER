unit FiltroCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, rxToolEdit, ComCtrls, DateUtils;

type
  TTFiltroCliente = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    btnCancelar: TBitBtn;
    btnRelatorio: TBitBtn;
    Panel1: TPanel;
    rg2: TRadioGroup;
    RadioGroup1: TRadioGroup;
    Panel2: TPanel;
    rg1: TRadioGroup;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label1: TLabel;
    btnPesquisaCliente: TBitBtn;
    btnLimpaCliente: TBitBtn;
    edCodCliente: TEdit;
    edNomeCliente: TEdit;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRelatorioClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure edCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edCodClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnLimpaClienteClick(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure chamaTela;
  end;

var
  TFiltroCliente: TTFiltroCliente;

implementation

uses
  RELCLIENTE, Funcoes, DMPRINCIPAL, CLIENTE, GraficoCliente, GraficoClienteSintetico;

{$R *.dfm}

{ TForm1 }

procedure TTFiltroCliente.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroCliente.btnLimpaClienteClick(Sender: TObject);
begin
  edCodCliente.ReadOnly := False;
  edCodCliente.Clear;
  edNomeCliente.Clear;
  btnPesquisaCliente.Enabled := True;
  btnLimpaCliente.Enabled := False;
  if edCodCliente.CanFocus then
    edCodCliente.SetFocus;
end;

procedure TTFiltroCliente.btnPesquisaClienteClick(Sender: TObject);
  var CodigoCliente:Integer;
begin
  CodigoCliente := StrToInt(TCliente.transferecliente);
  if CodigoCliente > 0 then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLI,NOME_CLI');
      SQL.Add('FROM CLIENTE');
      SQL.Add('WHERE COD_CLI = '+IntToStr(CodigoCliente));
      Open;
      if not IsEmpty then
      begin
        edCodCliente.Text := FieldByName('COD_CLI').AsString;
        edNomeCliente.Text := FieldByName('NOME_CLI').AsString;
        btnPesquisaCliente.Enabled := False;
        edCodCliente.ReadOnly := True;
        btnLimpaCliente.Enabled := True;
        if btnRelatorio.CanFocus then
          btnRelatorio.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroCliente.btnRelatorioClick(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 2 then
  begin
    TGraficoClienteSintetico.ChamaTela;
    Exit;
  end
  else
  if Empty(edNomeCliente.Text) then
    TRelCliente.ChamaTela(rg2.ItemIndex,rg1.ItemIndex,RadioGroup1.ItemIndex,0)
  else
    TRelCliente.ChamaTela(rg2.ItemIndex,rg1.ItemIndex,RadioGroup1.ItemIndex,StrToInt(edCodCliente.Text));
end;
procedure TTFiltroCliente.chamaTela;
begin
  TFiltroCliente:=TTFiltroCliente.Create(application);
  with TFiltroCliente do
  begin
    ShowModal;
    FreeAndNil(TFiltroCliente);
  end;
end;
procedure TTFiltroCliente.edCodClienteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F3:
      if (btnPesquisaCliente.Visible) and (btnPesquisaCliente.Enabled) then
        btnPesquisaCliente.Click;
    VK_F6:
      if (btnLimpaCliente.Visible) and (btnLimpaCliente.Enabled) then
        btnLimpaCliente.Click;
  end;
end;

procedure TTFiltroCliente.edCodClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in[#13,#48..#57,#8]) then
    key := #0;
  if (key = #13) and not (Empty(edCodCliente.Text)) then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLI,NOME_CLI');
      SQL.Add('FROM CLIENTE');
      SQL.Add('WHERE COD_CLI = ' +edCodCliente.Text);
      OPen;
      if not IsEmpty then
      begin
        edCodCliente.Text := FieldByName('COD_CLI').AsString;
        edNomeCliente.Text := FieldByName('NOME_CLI').AsString;
        edCodCliente.ReadOnly := True;
        btnLimpaCliente.Enabled := True;
        btnPesquisaCliente.Enabled := False;
        if btnRelatorio.CanFocus then
          btnRelatorio.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroCliente.FormKeyDown(Sender: TObject; var Key: Word;
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
procedure TTFiltroCliente.RadioGroup1Click(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    0:
    begin
      rg1.Enabled := True;
      btnPesquisaCliente.Enabled := True;
      btnLimpaCliente.Enabled := True;
      edCodCliente.Enabled := True;
      edNomeCliente.Enabled := True;

      rg2.Enabled := True;
    end;
    1:
    begin
      rg1.Enabled := False;
      btnPesquisaCliente.Enabled := False;
      btnLimpaCliente.Enabled := False;
      edCodCliente.Enabled := False;
      edNomeCliente.Enabled := False;

      rg2.Enabled := False;
    end;
    2:
    begin
      rg1.Enabled := False;
      btnPesquisaCliente.Enabled := False;
      btnLimpaCliente.Enabled := False;
      edCodCliente.Enabled := False;
      edNomeCliente.Enabled := False;

      rg2.Enabled := False;
    end;
  end;
end;

end.
