unit FiltroCompra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Mask, rxToolEdit, DateUtils, Grids,
  DBGrids, DB, DBClient, ADODB;

type
  TTFiltroCompra = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancelar: TBitBtn;
    btnRelatorio: TBitBtn;
    grp2: TGroupBox;
    lbl3: TLabel;
    lbl4: TLabel;
    btnPesquisaCliente: TBitBtn;
    btnLimpaCliente: TBitBtn;
    edtCodCliente: TEdit;
    edtNomeCliente: TEdit;
    grp3: TGroupBox;
    Panel4: TPanel;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edtDataIni: TDateEdit;
    edtDataFim: TDateEdit;
    rg1: TRadioGroup;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    CDSCliente: TClientDataSet;
    dsCliente: TDataSource;
    CDSClienteCOD_CLIENTE: TIntegerField;
    CDSClienteNOME_CLIENTE: TStringField;
    Panel6: TPanel;
    Panel7: TPanel;
    btnTransfere: TBitBtn;
    btnTransfereTodos: TBitBtn;
    btnEstornaTodos: TBitBtn;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    qProduto: TADOQuery;
    dsProduto: TDataSource;
    dsRecebeProduto: TDataSource;
    CDSRecebeProduto: TClientDataSet;
    CDSRecebeProdutoCOD_PROD: TIntegerField;
    CDSRecebeProdutoDESCRICAO_PROD: TStringField;
    CDSProduto: TClientDataSet;
    CDSProdutoCOD_PROD: TIntegerField;
    CDSProdutoDESCRICAO_PROD: TStringField;
    btnEstorna: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    btnAdicionar: TBitBtn;
    btnRemover: TBitBtn;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnLimpaClienteClick(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edtDataIniKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDataFimKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDataIniExit(Sender: TObject);
    procedure edtDataFimExit(Sender: TObject);
    procedure btnRelatorioClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAdicionarClick(Sender: TObject);
    procedure w(Sender: TObject);
    procedure btnEstornaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTransfereClick(Sender: TObject);
    procedure btnEstornaTodosClick(Sender: TObject);
    procedure btnTransfereTodosClick(Sender: TObject);
    procedure edtCodClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    RecebeModulo:Integer;
    Cliente,Produto: TStringList;
    { Private declarations }
  public
    { Public declarations }
    procedure chamaTela;
 end;
var
  TFiltroCompra: TTFiltroCompra;

implementation

uses
  RELCOMPRA, CLIENTE, PRODUTO, Funcoes, DMPRINCIPAL;

{$R *.dfm}

{ TTFRCOMPRA }

procedure TTFiltroCompra.btnAdicionarClick(Sender: TObject);
  var i: Integer;
begin
  if Empty(edtCodCliente.Text) then
  begin
    enviaMensagem('N?o existe informa??o para inclus?o','Informa??o...',mtConfirmation,[mbOK]);
    if edtCodCliente.CanFocus then
      edtCodCliente.SetFocus;
    Exit;
  end;
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
    enviaMensagem('Registro j? Inserido','Informa??o',mtConfirmation,[mbOK]);
    Exit;
  end;
  edtCodCliente.Clear;
  edtNomeCliente.Clear;
  btnLimpaCliente.Enabled := False;
  btnPesquisaCliente.Enabled := True;
  edtCodCliente.ReadOnly := False;
  if btnRelatorio.CanFocus then
    btnRelatorio.SetFocus;
end;

procedure TTFiltroCompra.btnTransfereClick(Sender: TObject);
begin
  if not CDSProduto.IsEmpty then
  begin
    with CDSProduto do
    begin
      CDSRecebeProduto.Append;
      CDSRecebeProduto.FieldByName('COD_PROD').AsInteger := FieldByName('COD_PROD').AsInteger;
      CDSRecebeProduto.FieldByName('DESCRICAO_PROD').AsString := FieldByName('DESCRICAO_PROD').AsString;
      CDSRecebeProduto.Post;
      CDSProduto.Delete;
    end;
  end
  else
  begin
    enviaMensagem('Sem registro!','Informa??o...',mtInformation,[mbOK]);
    if btnEstornaTodos.CanFocus then
      btnEstornaTodos.SetFocus;
    Exit;
  end;
end;

procedure TTFiltroCompra.btnEstornaClick(Sender: TObject);
begin
  if not CDSRecebeProduto.IsEmpty then
  begin
    with CDSRecebeProduto do
    begin
      CDSProduto.Append;
      CDSProduto.FieldByName('COD_PROD').AsInteger := FieldByName('COD_PROD').AsInteger;
      CDSProduto.FieldByName('DESCRICAO_PROD').AsString := FieldByName('DESCRICAO_PROD').AsString;
      CDSProduto.Post;
      CDSRecebeProduto.Delete;
    end;
  end
  else
  begin
    enviaMensagem('Sem Registro!','Informa??o...',mtInformation,[mbOK]);
    if btnTransfere.CanFocus then
      btnTransfere.SetFocus;
    Exit;
  end;
end;

procedure TTFiltroCompra.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroCompra.btnTransfereTodosClick(Sender: TObject);
 var i: Integer;
begin
  if not CDSProduto.IsEmpty then
  begin
    with CDSProduto do
    begin
      for I := 0 to CDSProduto.RecordCount - 1 do
      begin
        CDSRecebeProduto.Append;
        CDSRecebeProduto.FieldByName('COD_PROD').AsInteger := FieldByName('COD_PROD').AsInteger;
        CDSRecebeProduto.FieldByName('DESCRICAO_PROD').AsString := FieldByName('DESCRICAO_PROD').AsString;
        CDSRecebeProduto.Post;
        CDSProduto.Delete;
      end;
    end;
  end
  else
  begin
    enviaMensagem('Sem registro!','Informa??o',mtInformation,[mbOK]);
    if btnEstorna.CanFocus then
      btnEstorna.SetFocus;
    Exit;
  end;
end;

procedure TTFiltroCompra.btnEstornaTodosClick(Sender: TObject);
  var i: Integer;
begin
  if not CDSRecebeProduto.IsEmpty then
  begin
    with CDSRecebeProduto do
    begin
      for I := 0 to CDSRecebeProduto.RecordCount - 1 do
      begin
        CDSProduto.Append;
        CDSProduto.FieldByName('COD_PROD').AsInteger := FieldByName('COD_PROD').AsInteger;
        CDSProduto.FieldByName('DESCRICAO_PROD').AsString := FieldByName('DESCRICAO_PROD').AsString;
        CDSProduto.Post;
        CDSRecebeProduto.Delete;
      end;
    end;
  end
  else
  begin
    enviaMensagem('Sem registros!','Informa??o...',mtInformation,[mbOK]);
    if btnTransfereTodos.CanFocus then
      btnTransfereTodos.SetFocus;
    Exit;
  end;
end;

procedure TTFiltroCompra.btnLimpaClienteClick(Sender: TObject);
begin
  edtCodCliente.Clear;
  edtNomeCliente.Clear;
  btnLimpaCliente.Enabled := False;
  btnPesquisaCliente.Enabled := True;
  edtCodCliente.ReadOnly := False;
  if edtCodCliente.CanFocus then
    edtCodCliente.SetFocus;
end;

procedure TTFiltroCompra.btnPesquisaClienteClick(Sender: TObject);
  var InfoCliente: Integer;
begin
  InfoCliente := StrToInt(TCliente.transferecliente);
  if InfoCliente > 0 then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLI, NOME_CLI');
      SQL.Add('FROM CLIENTE');
      SQL.Add('WHERE COD_CLI = '+ IntToStr(InfoCliente));
      Open;
      if not IsEmpty then
      begin
        edtCodCliente.Text := FieldByName('COD_CLI').AsString;
        edtNomeCliente.Text := FieldByName('NOME_CLI').AsString;
        btnPesquisaCliente.Enabled := False;
        btnLimpaCliente.Enabled := True;
        edtCodCliente.ReadOnly := True;
        if btnAdicionar.CanFocus then
          btnAdicionar.SetFocus;
      end;
    end;
  end;
end;


procedure TTFiltroCompra.btnRelatorioClick(Sender: TObject);
begin
  if not CDSCliente.IsEmpty then
  begin
    with CDSCliente do
    begin
      First;
      while not CDSCliente.Eof do
      begin
        if Cliente.IndexOf(CDSCliente.FieldByName('COD_CLIENTE').AsString) = -1 then
        begin
          Cliente.Add(CDSCliente.FieldByName('COD_CLIENTE').AsString);
        end;
        Next;
      end;
    end;
  end;

  if not CDSRecebeProduto.IsEmpty then
  begin
    with CDSRecebeProduto do
    begin
      First;
      while not CDSRecebeProduto.Eof do
      begin
        if Produto.IndexOf(CDSRecebeProduto.FieldByName('COD_PROD').AsString) = -1 then
        begin
          Produto.Add(CDSRecebeProduto.FieldByName('COD_PROD').AsString);
        end;
        Next;
      end;
    end;
  end;

  if not(validarData(edtDataIni.Text)) then
  begin
    enviaMensagem('Data Inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
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
    TRelCompra.ChamaTela(Cliente,Produto,rg1.ItemIndex,edtDataIni.Date,edtDataFim.Date);
  Cliente.Clear;
  Produto.Clear;
end;

procedure TTFiltroCompra.w(Sender: TObject);
begin
  if not CDSCliente.IsEmpty then
  begin
    CDSCliente.Delete;
  end
  else
  begin
    enviaMensagem('Sem registros para excluir','Informa??o...',mtConfirmation,[mbOK]);
    Exit;
  end;
end;

procedure TTFiltroCompra.chamaTela;
begin
  TFiltroCompra:=TTFiltroCompra.Create(application);
  with TFiltroCompra do
  begin
    ShowModal;
    FreeAndNil(TFiltroCompra);
  end;
end;

procedure TTFiltroCompra.edtCodClienteExit(Sender: TObject);
begin
  if Empty(edtNomeCliente.Text) then
    edtCodCliente.Clear;
end;

procedure TTFiltroCompra.edtCodClienteKeyDown(Sender: TObject; var Key: Word;
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

procedure TTFiltroCompra.edtCodClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if (not(key in [#8, #13, #86, #46, #48..#57])) or (key = '.') then
    Key := #0;
  edtCodCliente.MaxLength := 8;
  if key = #13 then
  begin
    if (not Empty(edtCodCliente.Text)) and (edtCodCliente.ReadOnly = False) then
    begin
      with TDMPrincipal.qGeneric do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_CLI,NOME_CLI');
        SQL.Add('FROM CLIENTE');
        SQL.Add('WHERE COD_CLI = ' +edtCodCliente.Text);
        Open;
        if not IsEmpty then
        begin
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
end;

procedure TTFiltroCompra.edtDataFimExit(Sender: TObject);
begin
  if not(validarData(edtDataFim.Text)) then
  begin
    if btnCancelar.Focused then
      btnCancelar.Click
    else
    begin
      enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
      if edtDataFim.CanFocus then
        edtDataFim.SetFocus;
      Exit;
    end;
  end;
end;

procedure TTFiltroCompra.edtDataFimKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.CanFocus) then
      begin
        btnCancelar.SetFocus;
        Close;
      end;
  end;
end;

procedure TTFiltroCompra.edtDataIniExit(Sender: TObject);
begin
  if not(validarData(edtDataIni.Text)) then
  begin
    if btnCancelar.Focused then
      btnCancelar.Click
    else
    begin
      enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
      if edtDataIni.CanFocus then
        edtDataIni.SetFocus;
      Exit;
    end;
  end;
end;

procedure TTFiltroCompra.edtDataIniKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.CanFocus) then
      begin
        btnCancelar.SetFocus;
        Close;
      end;
  end;
end;

procedure TTFiltroCompra.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(CDSRecebeProduto);
  FreeAndNil(CDSCliente);
  FreeAndNil(CDSProduto);
  FreeAndNil(Cliente);
  FreeAndNil(Produto);
end;

procedure TTFiltroCompra.FormCreate(Sender: TObject);
begin
  edtDataIni.Date:= StartOfTheMonth(Date);
  edtDataFim.Date:= EndOfTheMonth(Date);
  CDSCliente.CreateDataSet;
  CDSRecebeProduto.CreateDataSet;
  CDSProduto.CreateDataSet;
  Cliente := TStringList.Create;
  Produto := TStringList.Create;
end;

procedure TTFiltroCompra.FormKeyDown(Sender: TObject; var Key: Word;
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
    VK_F6:
      if (btnLimpaCliente.Enabled) or (btnLimpaCliente.Visible) then
        btnLimpaCliente.Click;
  end;
end;

procedure TTFiltroCompra.FormShow(Sender: TObject);
begin
  with qProduto do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_PROD,DESCRICAO_PROD');
    SQL.Add('FROM PRODUTO');
    Open;
    if not IsEmpty then
    begin
      First;
      while not Eof do
      begin
        CDSProduto.Append;
        CDSProduto.FieldByName('COD_PROD').AsInteger := StrToInt(FieldByName('COD_PROD').AsString);
        CDSProduto.FieldByName('DESCRICAO_PROD').AsString := FieldByName('DESCRICAO_PROD').AsString;
        CDSProduto.Post;
        Next;
      end;
    end;
  end;
end;

end.
