unit FiltroCompraModelo2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Mask, rxToolEdit, DateUtils, CheckLst,
  Grids, DBGrids, DB, DBClient, Menus;

type
  TTFiltroCompraModelo2 = class(TForm)
    Panel2: TPanel;
    grp2: TGroupBox;
    lbl3: TLabel;
    lbl4: TLabel;
    btnPesquisaCliente: TBitBtn;
    btnLimpaCliente: TBitBtn;
    edtCodCliente: TEdit;
    edtNomeCliente: TEdit;
    Panel1: TPanel;
    btnCancelar: TBitBtn;
    btnRelatorio: TBitBtn;
    Panel4: TPanel;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edtDataIni: TDateEdit;
    edtDataFim: TDateEdit;
    rg1: TRadioGroup;
    GroupBox2: TGroupBox;
    cbListaFornecedores: TCheckListBox;
    CDSCliente: TClientDataSet;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    dsCliente: TDataSource;
    CDSClienteCOD_CLIENTE: TIntegerField;
    CDSClienteNOME_CLIENTE: TStringField;
    btnAdicionar: TBitBtn;
    btnRemover: TBitBtn;
    PopupMenu1: TPopupMenu;
    Marcartodos1: TMenuItem;
    Desmarcartodos1: TMenuItem;
    procedure btnRelatorioClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtDataIniKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDataFimKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edtCodClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure btnLimpaClienteClick(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure Marcartodos1Click(Sender: TObject);
    procedure Desmarcartodos1Click(Sender: TObject);
  private
      Lista: TStringList;
      Cliente:TStringList;
    { Private declarations }
  public
    procedure ChamaTela;
    { Public declarations }
  end;

var
  TFiltroCompraModelo2: TTFiltroCompraModelo2;

implementation

uses
  DMPRINCIPAL, Funcoes, RELCOMPRA, CLIENTE, PRODUTO, Fornecedores;

{$R *.dfm}

procedure TTFiltroCompraModelo2.btnAdicionarClick(Sender: TObject);
 VAR V:Integer;
begin
  if not CDSCliente.Locate('COD_CLIENTE',edtCodCliente.Text,[]) then
  begin
    with CDSCliente do
    begin
      Append;
      FieldByName('COD_CLIENTE').AsInteger := StrToInt(edtCodCliente.Text);
      FieldByName('NOME_CLIENTE').AsString := edtNomeCliente.Text;
      Post;
    end;
  end
  else
  begin
    enviaMensagem('Registro já Inserido','Informação',mtConfirmation,[mbOK]);
    Exit;
  end;

  Cliente.Add(CDSCliente.FieldByName('COD_CLIENTE').AsString);

  edtCodCliente.Clear;
  edtNomeCliente.Clear;
  edtCodCliente.ReadOnly := False;
  btnLimpaCliente.Enabled := False;
  btnPesquisaCliente.Enabled := True;
end;

procedure TTFiltroCompraModelo2.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroCompraModelo2.btnLimpaClienteClick(Sender: TObject);
begin
  edtCodCliente.Clear;
  edtCodCliente.ReadOnly := False;
  edtNomeCliente.Clear;
  btnPesquisaCliente.Enabled := True;
  btnLimpaCliente.Enabled := False;
end;


procedure TTFiltroCompraModelo2.btnPesquisaClienteClick(Sender: TObject);
  var InfoCliente:Integer;
begin
  InfoCliente := StrToInt(TCliente.transferecliente);
  if InfoCliente > 0 then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLI,NOME_CLI');
      SQL.Add('FROM CLIENTE');
      SQL.Add('WHERE COD_CLI = '+IntToStr(InfoCliente));
      Open;
      if not IsEmpty then
      begin
        edtCodCliente.Text := FieldByName('COD_CLI').AsString;
        edtNomeCliente.Text := FieldByName('NOME_CLI').AsString;
        edtCodCliente.ReadOnly := True;
        btnPesquisaCliente.Enabled := False;
        btnLimpaCliente.Enabled := True;
        if btnAdicionar.CanFocus then
          btnAdicionar.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroCompraModelo2.btnRelatorioClick(Sender: TObject);
  var i: Integer;
  rec : String;
begin
  for I := 0 to cbListaFornecedores.Items.Count - 1 do
  begin
    if cbListaFornecedores.Checked[i] = True then
    begin
      rec := Copy(cbListaFornecedores.Items[i],0,2);
      Lista.Add(rec);
    end;
  end;
  if not(validarData(edtDataIni.Text)) then
  begin
    enviaMensagem('Data Inválida!','Informação...',mtConfirmation,[mbOK]);
    if edtDataIni.CanFocus then
      edtDataIni.SetFocus;
    Exit;
  end
  else
  if not (validarData(edtDataFim.Text)) then
  begin
    if edtDataFim.CanFocus then
      edtDataFim.SetFocus;
    Exit;
  end
  else
    TRelCompra.ChamaModulo2(Lista,Cliente,rg1.ItemIndex,edtDataIni.Date,edtDataFim.Date);
  Lista.Clear;
  Cliente.Clear;
  CDSCliente.Close;
  CDSCliente.CreateDataSet;
end;

procedure TTFiltroCompraModelo2.btnRemoverClick(Sender: TObject);
begin
  if not CDSCliente.IsEmpty then
  begin
    CDSCliente.Delete;
  end
  else
  begin
    enviaMensagem('Não existe registro para excluir','Informação...',mtConfirmation,[mbOK]);
    Exit;
  end;
end;

procedure TTFiltroCompraModelo2.ChamaTela;
begin
  TFiltroCompraModelo2 := TTFiltroCompraModelo2.Create(Application);
  with TFiltroCompraModelo2 do
  begin
    ShowModal;
    FreeAndNil(TFiltroCompraModelo2);
  end;
end;

procedure TTFiltroCompraModelo2.Desmarcartodos1Click(Sender: TObject);
  var i: Integer;
begin
  with cbListaFornecedores do
  begin
    for I := 0 to cbListaFornecedores.Items.Count - 1 do
    begin
      cbListaFornecedores.Checked[i] := False
    end;
  end;
end;


procedure TTFiltroCompraModelo2.edtCodClienteKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
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

procedure TTFiltroCompraModelo2.edtCodClienteKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (key in[#13,#8,#48..#57]) then
    key := #0;
  edtCodCliente.MaxLength := 8;
  if (key = #13) and not(Empty(edtCodCliente.Text)) then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLI,NOME_CLI');
      SQL.Add('FROM CLIENTE');
      SQL.Add('WHERE COD_CLI = '+edtCodCliente.Text);
      Open;
      if not IsEmpty then
      begin
        edtCodCliente.Text := FieldByName('COD_CLI').AsString;
        edtNomeCliente.Text := FieldByName('NOME_CLI').AsString;
        edtCodCliente.ReadOnly := True;
        btnLimpaCliente.Enabled := True;
        btnPesquisaCliente.Enabled := False;
        if btnAdicionar.CanFocus then
          btnAdicionar.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroCompraModelo2.edtDataFimKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
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

procedure TTFiltroCompraModelo2.edtDataIniKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
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


procedure TTFiltroCompraModelo2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(Lista);
  FreeAndNil(Cliente);
  FreeAndNil(CDSCliente);
end;

procedure TTFiltroCompraModelo2.FormCreate(Sender: TObject);
begin
  lista := TStringList.Create;
  Cliente := TStringList.Create;
  CDSCliente.CreateDataSet;
end;

procedure TTFiltroCompraModelo2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) then
        btnCancelar.Click;
    VK_F2:
      if (btnAdicionar.Visible) and (btnAdicionar.Enabled) then
        btnAdicionar.Click;
    VK_F4:
      if (btnRemover.Visible) and (btnRemover.Enabled) then
        btnRemover.Click;
    VK_F5:
      if (btnRelatorio.Visible) and (btnRelatorio.Enabled) then
        btnRelatorio.Click;
  end;
end;

procedure TTFiltroCompraModelo2.FormShow(Sender: TObject);
  var I: Integer;
begin
  edtDataIni.Date := StartOfTheMonth(Date);
  edtDataFim.Date := EndOfTheMonth(Date);

  with TDMPrincipal.qGeneric do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_FORNECEDOR,NOME_FORNECEDOR');
    SQL.Add('FROM FORNECEDORES');
    Open;
    if not IsEmpty then
    begin
      First;
      while not TDMPrincipal.qGeneric.Eof do
      begin
        cbListaFornecedores.Items.Add(TDMPrincipal.qGeneric.FieldByName('COD_FORNECEDOR').AsString + ' - ' + TDMPrincipal.qGeneric.FieldByName('NOME_FORNECEDOR').AsString);
        Next;
      end;
    end;
  end;
end;
procedure TTFiltroCompraModelo2.Marcartodos1Click(Sender: TObject);
  var i: Integer;
begin
  with cbListaFornecedores do
  begin
    for I := 0 to cbListaFornecedores.Items.Count - 1 do
    begin
      cbListaFornecedores.Checked[i] := True
    end;
  end;
end;

end.
