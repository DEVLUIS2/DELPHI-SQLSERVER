unit FiltroFornecedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Mask, rxToolEdit, DateUtils;

type
  TTFiltroFornecedores = class(TForm)
    Panel1: TPanel;
    pnl1: TPanel;
    btnCancelar: TBitBtn;
    btnRelatório: TBitBtn;
    GroupBox1: TGroupBox;
    btnPesquisaProduto: TBitBtn;
    btnLimpaProduto: TBitBtn;
    edCodProduto: TEdit;
    edDescricaoProduto: TEdit;
    Label5: TLabel;
    Label1: TLabel;
    Panel2: TPanel;
    rg1: TRadioGroup;
    rg2: TRadioGroup;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRelatórioClick(Sender: TObject);
    procedure btnPesquisaProdutoClick(Sender: TObject);
    procedure btnLimpaProdutoClick(Sender: TObject);
    procedure edCodProdutoExit(Sender: TObject);
    procedure edCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCodProdutoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure chamaTela;
  end;

var
  TFiltroFornecedores: TTFiltroFornecedores;

implementation

uses
  Funcoes, PRODUTO, DMPRINCIPAL, RelFornecedores;

{$R *.dfm}

{ TTFRelFornecedores }

procedure TTFiltroFornecedores.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroFornecedores.btnLimpaProdutoClick(Sender: TObject);
begin
  edCodProduto.Clear;
  edDescricaoProduto.Clear;
  btnPesquisaProduto.Enabled := True;
  btnLimpaProduto.Enabled := False;
  edCodProduto.ReadOnly := False;
  if edCodProduto.CanFocus then
    edCodProduto.SetFocus;
end;

procedure TTFiltroFornecedores.btnPesquisaProdutoClick(Sender: TObject);
var
  RecebeProduto: string;
begin
  RecebeProduto := TProduto.TransfereProduto;
  if RecebeProduto <> '' then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_PROD,DESCRICAO_PROD');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PROD = '+RecebeProduto);
      Open;
      if not IsEmpty then
      begin
        edCodProduto.Text := FieldByName('COD_PROD').AsString;
        edDescricaoProduto.Text := FieldByName('DESCRICAO_PROD').AsString;
        btnPesquisaProduto.Enabled := False;
        btnLimpaProduto.Enabled := True;
        edCodProduto.ReadOnly := True;
        if btnRelatório.CanFocus then
          btnRelatório.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroFornecedores.btnRelatórioClick(Sender: TObject);
begin
  if Empty(edDescricaoProduto.Text)  then
  begin
    TRelFornecedores.ChamaTela(rg1.ItemIndex , rg2.ItemIndex,0,1,5);
  end
  else
    TRelFornecedores.ChamaTela(rg1.ItemIndex,rg2.ItemIndex,StrToInt(edCodProduto.Text),1,5);
end;

procedure TTFiltroFornecedores.chamaTela;
begin
  TFiltroFornecedores := TTFiltroFornecedores.Create(Application);
  with TFiltroFornecedores do
  begin
    ShowModal;
    FreeAndNil(TFiltroFornecedores);
  end;
end;

procedure TTFiltroFornecedores.edCodProdutoExit(Sender: TObject);
begin
  if Empty(edDescricaoProduto.Text) then
    edCodProduto.Clear;
end;

procedure TTFiltroFornecedores.edCodProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_F3:
    if (btnPesquisaProduto.Enabled) or (btnPesquisaProduto.Enabled) then
      btnPesquisaProduto.Click;
  end;
end;

procedure TTFiltroFornecedores.edCodProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Key in[#13,#8,#48..#57])) then
    Key := #0;
  if Key = #13 then
  begin
    if not Empty(edCodProduto.Text) then
    begin
      with TDMPrincipal.qGeneric do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_PROD,DESCRICAO_PROD');
        SQL.Add('FROM PRODUTO');
        SQL.Add('WHERE COD_PROD = ' +edCodProduto.Text);
        Open;
        if not IsEmpty then
        begin
          edCodProduto.Text := FieldByName('COD_PROD').AsString;
          edDescricaoProduto.Text := FieldByName('DESCRICAO_PROD').AsString;
          btnPesquisaProduto.Enabled := False;
          btnLimpaProduto.Enabled := True;
          edCodProduto.ReadOnly := True;
          if btnRelatório.CanFocus then
            btnRelatório.SetFocus;
        end;
      end;
    end;
  end;
end;

procedure TTFiltroFornecedores.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) or (btnCancelar.Enabled) then
        btnCancelar.Click;
    vk_f5:
      if (btnRelatório.Visible) or (btnRelatório.Enabled) then
        btnRelatório.Click;
    vk_F7:
      if (btnLimpaProduto.Visible) or (btnLimpaProduto.Enabled) then
        btnLimpaProduto.Click;
  end;
end;

end.
