unit FiltroListagemFornecedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TTFiltroListagemFornecedores = class(TForm)
    Panel1: TPanel;
    pnl1: TPanel;
    btnCancelar: TBitBtn;
    btnRelatorio: TBitBtn;
    Panel2: TPanel;
    Panel3: TPanel;
    grp3: TGroupBox;
    lbl5: TLabel;
    lbl6: TLabel;
    btnPesquisaFornecedor: TBitBtn;
    btnLimpaFornecedor: TBitBtn;
    edNomeFornecedor: TEdit;
    edFornecedor: TEdit;
    RadioGroup1: TRadioGroup;
    rg2: TRadioGroup;
    rg1: TRadioGroup;
    procedure btnRelatorioClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure btnLimpaFornecedorClick(Sender: TObject);
    procedure edFornecedorKeyPress(Sender: TObject; var Key: Char);
    procedure edFornecedorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPesquisaFornecedorClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TFiltroListagemFornecedores: TTFiltroListagemFornecedores;

implementation

uses
  RelFornecedores, Funcoes, DMPRINCIPAL, Fornecedores, GraficoFornecedorSintetico;

{$R *.dfm}

procedure TTFiltroListagemFornecedores.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroListagemFornecedores.btnLimpaFornecedorClick(Sender: TObject);
begin
  edNomeFornecedor.Clear;
  edFornecedor.Clear;
  edFornecedor.ReadOnly := False;
  btnPesquisaFornecedor.Enabled := True;
  btnLimpaFornecedor.Enabled := False;
end;

procedure TTFiltroListagemFornecedores.btnPesquisaFornecedorClick(
  Sender: TObject);
  var infoFornecedor: Integer;
begin
  infoFornecedor := StrToInt(TFornecedores.TransfereFornecedor(0));
  if infoFornecedor > 0 then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_FORNECEDOR,NOME_FORNECEDOR');
      SQL.Add('FROM FORNECEDORES');
      SQL.Add('WHERE COD_FORNECEDOR = '+IntToStr(infoFornecedor));
      Open;
      if not IsEmpty then
      begin
        edFornecedor.Text := FieldByName('COD_FORNECEDOR').AsString;
        edNomeFornecedor.Text := FieldByName('NOME_FORNECEDOR').AsString;
        edFornecedor.ReadOnly := True;
        btnLimpaFornecedor.Enabled := True;
        btnPesquisaFornecedor.Enabled := False;
        if btnRelatorio.CanFocus then
          btnRelatorio.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroListagemFornecedores.btnRelatorioClick(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 2 then
  begin
    TGraficoSinteticoFornecedor.ChamaTela;
    Exit;
  end;
  if Empty(edNomeFornecedor.Text) then
    TRelFornecedores.ChamaTela(rg1.ItemIndex , rg2.ItemIndex,0,2,RadioGroup1.ItemIndex)
  else
    TRelFornecedores.ChamaTela(rg1.ItemIndex , rg2.ItemIndex,StrToInt(edFornecedor.Text),2,RadioGroup1.ItemIndex);
end;

procedure TTFiltroListagemFornecedores.ChamaTela;
begin
  TFiltroListagemFornecedores := TTFiltroListagemFornecedores.Create(Application);
  with TFiltroListagemFornecedores do
  begin
    ShowModal;
    FreeAndNil(TFiltroListagemFornecedores);
  end;
end;

procedure TTFiltroListagemFornecedores.edFornecedorKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_F3:
      if (btnPesquisaFornecedor.Visible) and (btnPesquisaFornecedor.Enabled) then
        btnPesquisaFornecedor.Click;
    VK_F6:
      if (btnLimpaFornecedor.Visible) and (btnLimpaFornecedor.Enabled) then
        btnLimpaFornecedor.Click;
  end;
end;

procedure TTFiltroListagemFornecedores.edFornecedorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = #13) and not(Empty(edFornecedor.Text)) then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Add('SELECT COD_FORNECEDOR,NOME_FORNECEDOR');
      SQL.Add('FROM FORNECEDORES');
      SQL.Add('WHERE COD_FORNECEDOR = '+edFornecedor.Text);
      Open;
      if not IsEmpty then
      begin
        edFornecedor.Text := FieldByName('COD_FORNECEDOR').AsString;
        edNomeFornecedor.Text := FieldByName('NOME_FORNECEDOR').AsString;
        edFornecedor.ReadOnly := True;
        btnPesquisaFornecedor.Enabled := False;
        btnLimpaFornecedor.Enabled := True;
        if btnRelatorio.CanFocus then
          btnRelatorio.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroListagemFornecedores.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
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

procedure TTFiltroListagemFornecedores.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then
  begin
    edNomeFornecedor.Enabled := True;
    edFornecedor.Enabled := True;
    btnLimpaFornecedor.Enabled := True;
    btnPesquisaFornecedor.Enabled := True;
    rg2.Enabled := True;

    rg1.Enabled := True;
  end
  else
  begin
    edNomeFornecedor.Enabled := False;
    edFornecedor.Enabled := False;
    btnLimpaFornecedor.Enabled := False;
    btnPesquisaFornecedor.Enabled := False;
    rg2.Enabled := False;

    rg1.Enabled := False;
  end;
end;

end.
