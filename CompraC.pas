unit CompraC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, rxToolEdit, Grids, DBGrids, DB,
  ADODB, DBClient, rxCurrEdit, Menus, TFlatEditUnit;

type
  TTCompraC = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    dtCompra: TDateEdit;
    Panel4: TPanel;
    btnRemover: TBitBtn;
    Panel2: TPanel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    DBGrid1: TDBGrid;
    btnAdicionar: TBitBtn;
    dsCompraItems: TDataSource;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    btnPesquisaCliente: TBitBtn;
    btnLimpaCliente: TBitBtn;
    edCodCliente: TEdit;
    edNomeCliente: TEdit;
    CDSItens: TClientDataSet;
    CDSItensCOD_PRODUTO: TIntegerField;
    CDSItensDESCRICAO: TStringField;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    btnPesquisaProduto: TBitBtn;
    btnLimpaProduto: TBitBtn;
    edCodProduto: TEdit;
    edDescricaoProduto: TEdit;
    edValorProduto: TCurrencyEdit;
    CDSItensQUANTIDADE: TIntegerField;
    CDSItensPRECO: TFloatField;
    PainelCDSItens: TPanel;
    edPrecoTotal: TCurrencyEdit;
    Label8: TLabel;
    Label9: TLabel;
    CDSItensVALOR_TOTAL: TFloatField;
    edQuantidadeTotal: TCurrencyEdit;
    CDSItensACAO: TStringField;
    edQuantidade: TEdit;
    edEstoque: TEdit;
    Label10: TLabel;
    CDSItensCOD_COMPRA_ITENS: TIntegerField;
    CDSEstoque: TClientDataSet;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtCompraChange(Sender: TObject);
    procedure btnLimpaClienteClick(Sender: TObject);
    procedure btnLimpaProdutoClick(Sender: TObject);
    procedure btnPesquisaClienteClick(Sender: TObject);
    procedure btnPesquisaProdutoClick(Sender: TObject);
    procedure edNomeClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edDescricaoProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edCodClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edCodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnRemoverClick(Sender: TObject);
    procedure CDSItensVALOR_TOTALGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure CDSItensPRECOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure edCodClienteExit(Sender: TObject);
    procedure edCodProdutoExit(Sender: TObject);
    procedure CDSItensCalcFields(DataSet: TDataSet);
    procedure edQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edQuantidadeExit(Sender: TObject);
    procedure dtCompraKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtCompraExit(Sender: TObject);
    procedure edQuantidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    cod: string;
    Recebe, AtualizaGrid: Integer;
    VetProdutosExcluidos: TStringList;
    procedure TransfereDados;
    procedure SomenteLeitura;
    function VerificaEstoque(CodProduto: string): Boolean;
  public
    { Public declarations }
    function chamaTela(pid: string; acao: integer):string;
  end;

var
  TCompraC: TTCompraC;

implementation

uses DMPRINCIPAL, Funcoes, FuncoesDB, CLIENTE, PRODUTO;

{$R *.dfm}

procedure TTCompraC.btnAdicionarClick(Sender: TObject);
  procedure InsereEditaProduto(Acao : string);
  begin
    with CDSItens do
    begin
      if VerificaEstoque(edCodProduto.Text) = False then
        Exit;
      if Acao = 'I' then
        Append
      else
        Edit;
      FieldByName('COD_PRODUTO').AsInteger := StrToInt(edCodProduto.Text);
      FieldByName('DESCRICAO').AsString := edDescricaoProduto.Text;
      FieldByName('PRECO').Value := edValorProduto.Value;
      FieldByName('QUANTIDADE').AsInteger := StrToInt(edQuantidade.Text) + FieldByName('QUANTIDADE').AsInteger;
      if FieldByName('COD_COMPRA_ITENS').IsNull then
        FieldByName('ACAO').AsString := 'I'
      else
        FieldByName('ACAO').AsString := 'E';
      Post;

      CDSItens.FieldByName('PRECO').OnGetText := CDSItensPRECOGetText;
      CDSItens.FieldByName('VALOR_TOTAL').OnGetText := CDSItensVALOR_TOTALGetText;

      edPrecoTotal.Value := edPrecoTotal.Value + (edValorProduto.Value * StrToInt(edQuantidade.Text));
      edQuantidadeTotal.Value := edQuantidadeTotal.Value + StrToInt(edQuantidade.Text);
      btnLimpaProduto.Click;
    end;
  end;
begin
  if Empty(edCodProduto.Text) then
  begin
    enviaMensagem('Inserir c?digo do produto!','Informa??o...',mtConfirmation,[mbOK]);
    if edCodProduto.CanFocus then
      edCodProduto.SetFocus;
    Exit;
  end;

  if empty(edCodCliente.Text) then
  begin
    enviaMensagem('Informar c?digo do cliente!','Informa??o...',mtConfirmation,[mbOK]);
    if edCodCliente.CanFocus then
      edCodCliente.SetFocus;
    Exit;
  end;

  if Empty(edCodProduto.Text) then
  begin
    enviaMensagem('Informe c?digo do Produto!','Informa??o...',mtConfirmation,[mbOK]);
    if edCodProduto.CanFocus then
       edCodProduto.SetFocus;
    Exit;
  end;

  if Empty(edQuantidade.Text) then
  begin
    enviaMensagem('Informe a quantidade!','Informa??o...',mtConfirmation,[mbOK]);
    if edQuantidade.CanFocus then
       edQuantidade.SetFocus;
    Exit;
  end;

  if Empty(edQuantidade.Text) then
  begin
    enviaMensagem('Inserir quantidade!','Informa??o...',mtConfirmation,[mbOK]);
    if edQuantidade.CanFocus then
      edQuantidade.SetFocus;
    Exit;
  end;

  if StrToInt(edQuantidade.Text) <= 0 then
  begin
    enviaMensagem('Informe uma quantidade maior que zero!!','Informa??o...',mtConfirmation,[mbOK]);
    edQuantidade.Clear;
    if edQuantidade.CanFocus then
       edQuantidade.SetFocus;
    Exit;
  end;

  if CDSItens.Locate('COD_PRODUTO', edCodProduto.Text, []) then
  begin
    if EnviaMensagem('Produto j? inserido. Voc? quer acrescentar a quantidade, ? quantidade j? inserida?',  'Aten??o...',mtConfirmation,[mbYes,mbNo]) = mrYes then
    begin
      InsereEditaProduto('E');
    end
    else
    begin
      btnLimpaProduto.Click;
      if edCodProduto.CanFocus then
        edCodProduto.SetFocus;
      Exit;
    end;
  end
  else
  begin
    InsereEditaProduto('I');
  end;
end;

procedure TTCompraC.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTCompraC.btnLimpaClienteClick(Sender: TObject);
begin
  edCodCliente.Text := '';
  edNomeCliente.Text := '';
  btnLimpaCliente.Enabled := False;
  btnPesquisaCliente.Enabled := True;
  edCodCliente.ReadOnly := False;
  //Limpa Produto
  edCodProduto.Clear;
  edCodProduto.ReadOnly := True;
  edDescricaoProduto.Clear;
  edEstoque.Clear;
  edValorProduto.Clear;
  edQuantidade.Clear;
  btnLimpaProduto.Enabled := False;
  btnPesquisaProduto.Enabled := False;
  edQuantidade.ReadOnly := True;
  //Limpa Grid
  CDSItens.Close;
  edPrecoTotal.Clear;
  edQuantidadeTotal.Clear;
  if edCodCliente.CanFocus then
    edCodCliente.SetFocus;
end;

procedure TTCompraC.btnLimpaProdutoClick(Sender: TObject);
begin
  edCodProduto.Clear;
  edDescricaoProduto.Clear;
  edValorProduto.Clear;
  edQuantidade.Clear;
  edEstoque.Clear;
  btnLimpaProduto.Enabled := False;
  btnPesquisaProduto.Enabled := True;
  edCodProduto.ReadOnly := False;
  edQuantidade.ReadOnly := True;
  if edCodProduto.CanFocus then
    edCodProduto.SetFocus;
end;

procedure TTCompraC.btnPesquisaClienteClick(Sender: TObject);
  var InfoCliente: Integer;
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
        btnPesquisaCliente.Enabled := False;
        btnLimpaCliente.Enabled := True;
        edCodCliente.ReadOnly := True;
        btnPesquisaProduto.Enabled := True;
        edCodProduto.ReadOnly := False;
        edCodProduto.Enabled := True;
        if edCodProduto.CanFocus then
          edCodProduto.SetFocus;
      end;
    end;
  end;
end;

procedure TTCompraC.btnPesquisaProdutoClick(Sender: TObject);
  var InfoProduto: string;
begin
  if Empty(edCodCliente.Text) and Empty(edNomeCliente.Text) then
  begin
    enviaMensagem('Dados do cliente incompletos!','Informa??o...',mtConfirmation,[mbOK]);
    if edCodCliente.CanFocus then
      edCodCliente.SetFocus;
    Exit;
  end;
  InfoProduto := TProduto.TransfereProduto;
  if InfoProduto <> '' then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_PROD,DESCRICAO_PROD,PRECO_PROD,ESTOQUE_PROD,ATIVO');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PROD = '+InfoProduto);
      Open;
      if not IsEmpty then
      begin
        edCodProduto.Text := FieldByName('COD_PROD').AsString;
        edDescricaoProduto.Text := FieldByName('DESCRICAO_PROD').AsString;
        edValorProduto.Value := FieldByName('PRECO_PROD').AsFloat;
        edEstoque.Text := FieldByName('ESTOQUE_PROD').AsString;
        btnPesquisaProduto.Enabled := False;
        btnLimpaProduto.Enabled :=True;
        edCodProduto.ReadOnly := True;
        edQuantidade.ReadOnly := False;
        if edQuantidade.CanFocus then
        edQuantidade.SetFocus;
      end;
    end;
  end;
end;

procedure TTCompraC.btnRemoverClick(Sender: TObject);
begin
  if not CDSItens.IsEmpty then
  begin
    if not CDSItens.FieldByName('COD_COMPRA_ITENS').IsNull then
    begin
      if VetProdutosExcluidos.IndexOf(CDSItens.FieldByName('COD_COMPRA_ITENS').AsString) = -1 then
      begin
        VetProdutosExcluidos.Add(CDSItens.FieldByName('COD_COMPRA_ITENS').AsString)
      end;
    end;
    edPrecoTotal.Value := (edPrecoTotal.Value - (CDSItens.FieldByName('PRECO').AsFloat * CDSItens.FieldByName('QUANTIDADE').AsInteger));
    edQuantidadeTotal.Value := edQuantidadeTotal.Value - CDSItensQUANTIDADE.AsInteger;
    CDSItens.Delete;
    btnLimpaProduto.Click;
    if edCodProduto.CanFocus then
      edCodProduto.SetFocus;
  end
  else
    enviaMensagem('Nenhum registro identificado para ser removido!','Informa??o...',mtConfirmation,[mbOK]);
end;

procedure TTCompraC.btnSalvarClick(Sender: TObject);
  var codigoCompra,VEstoque,VQuantidade,
      CProduto, I ,proceest,procquant,proccod,Contador : Integer;
  procedure RetornaProduto(Estoque:Integer);
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT P.ESTOQUE_PROD,CI.QUANTIDADE_ITENS,P.COD_PROD');
      SQL.Add('FROM COMPRA_ITENS CI');
      SQL.Add('INNER JOIN PRODUTO P ON CI.COD_PROD = P.COD_PROD');
      SQL.Add('WHERE CI.COD_COMPRA_ITENS = '+IntToStr(Estoque));
      Open;
      if not IsEmpty then
      begin
        proceest := StrToInt(FieldByName('ESTOQUE_PROD').AsString);
        procquant := StrToInt(FieldByName('QUANTIDADE_ITENS').AsString);
        proccod := StrToInt(FieldByName('COD_PROD').AsString);
        Close;
        SQL.Clear;
        SQL.Add('UPDATE PRODUTO');
        SQL.Add('SET ESTOQUE_PROD = '+ IntToStr(proceest + procquant));
        SQL.Add('WHERE COD_PROD = '+ IntToStr(proccod));
        ExecSQL;
      end;
    end;
  end;
begin
  if dtCompra.Date > Date then
  begin
    enviaMensagem('Data da compra, n?o pode ser superior ao dia atual!','Informa??o...',mtConfirmation,[mbOK]);
    if dtCompra.CanFocus then
      dtCompra.SetFocus;
    Exit;
  end;
  if not (validarData(dtCompra.Text)) then
  begin
    enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
    Exit;
  end;
  if Empty(edCodCliente.Text) then
  begin
    enviaMensagem('Inserir o c?digo do cliente','Informa??o...',mtConfirmation,[mbOK]);
    if edCodCliente.CanFocus then
      edCodCliente.SetFocus;
    Exit;
  end;
  if Empty(edNomeCliente.Text) then
  begin
    enviaMensagem('Nome vazio, por favor inserir o c?digo.','Informa??o...',mtConfirmation,[mbOK]);
    if edCodCliente.CanFocus then
      edCodCliente.SetFocus;
    Exit;
  end;
  with TDMPrincipal.qGeneric do
  begin
    case Recebe of
      0:
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO COMPRA(COD_CLI,DATA_COMPRA,VALORTOTAL_COMPRA,QUANTIDADE_COMPRA)');
        SQL.Add('VALUES(' +edCodCliente.Text);
        SQL.Add(', ' + dateTextSql(dtCompra.Date));
        SQL.Add(', ' + virgulaPorPonto(FloatToStr(edPrecoTotal.Value)));
        SQL.Add(', ' + edQuantidadeTotal.Text);
        SQL.Add(')');
        ExecSQL;
        codigoCompra :=  GetCodigoIdentity('COMPRA');
        CDSItens.First;
        while not CDSItens.Eof do //eof - n?o for o fim
        begin
          CProduto := CDSItens.FieldByName('COD_PRODUTO').AsInteger;
          VQuantidade := CDSItens.FieldByName('QUANTIDADE').AsInteger;
          Close;
          SQL.Clear;
          SQL.Add('SELECT ESTOQUE_PROD');
          SQL.Add('FROM PRODUTO');
          SQL.Add('WHERE COD_PROD = '+IntToStr(CProduto));
          Open;
          if not IsEmpty then
          begin
            VEstoque := strtoint(FieldByName('ESTOQUE_PROD').AsString);
            if VEstoque > VQuantidade then
            begin
              Close;
              SQL.Clear;
              SQL.Add('UPDATE PRODUTO');
              SQL.Add('SET ESTOQUE_PROD = '+ IntToStr(VEstoque - VQuantidade));
              SQL.Add('WHERE COD_PROD = '+IntToStr(CProduto));
              ExecSQL;
            end
            else
            if VEstoque = VQuantidade then
            begin
              Close;
              SQL.Add('UPDATE PRODUTO');
              SQL.Add('SET ESTOQUE_PROD = '+ IntToStr(VEstoque - VQuantidade));
              SQL.Add('WHERE COD_PROD = '+IntToStr(CProduto));
              SQL.Add('UPDATE PRODUTO');
              SQL.Add('SET ATIVO = 0');
              SQL.Add('WHERE COD_PROD = '+IntToStr(CProduto));
              ExecSQL;
            end;
          end;
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO COMPRA_ITENS(COD_COMPRA, COD_PROD,QUANTIDADE_ITENS)');
          SQL.Add('VALUES (');
          SQL.Add(IntToStr(codigoCompra));
          SQL.Add(',' +IntToStr(CDSItens.FieldByName('COD_PRODUTO').AsInteger));
          SQL.Add(',' +IntToStr(CDSItens.FieldByName('QUANTIDADE').AsInteger));
          SQL.Add(')');
          ExecSQL;
          CDSItens.Next;
        end;
        AtualizaGrid := codigoCompra;
      end;
      1:
      if CDSItens.IsEmpty then
      begin
        enviaMensagem('Por Favor, inserir produtos','Aten??o',mtWarning,[mbOK]);
        Exit;
      end
      else
      begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE COMPRA');
        SQL.Add('SET COD_CLI = '+edCodCliente.Text);
        SQL.Add(',DATA_COMPRA = ' +dateTextSql(dtCompra.Date));
        SQL.Add(',VALORTOTAL_COMPRA = '+virgulaporponto(edPrecoTotal.Text));
        SQL.Add(',QUANTIDADE_COMPRA = '+edQuantidadeTotal.Text);
        SQL.Add('WHERE COD_COMPRA = '+cod);
        ExecSQL;

        if VetProdutosExcluidos.Count > 0 then
        begin
          for I := 0 to VetProdutosExcluidos.Count - 1 do
          begin
            Contador := StrToInt(VetProdutosExcluidos.DelimitedText);
            RetornaProduto(Contador);
          end;
          Close;
          SQL.Clear;
          SQL.Add('DELETE FROM COMPRA_ITENS');
          if VetProdutosExcluidos.Count  =1 then
            SQL.Add('WHERE COD_COMPRA_ITENS = ' + VetProdutosExcluidos.DelimitedText)
          else
            SQL.Add('WHERE COD_COMPRA_ITENS IN ('+ VetProdutosExcluidos.DelimitedText +')');
          ExecSQL;
        end;

        CDSItens.First;
        while not CDSItens.Eof do //eof - n?o for o fim
        begin
          if CDSItens.FieldByName('ACAO').AsString = 'I' then
          begin
            CProduto := CDSItens.FieldByName('COD_PRODUTO').AsInteger;
            VQuantidade := CDSItens.FieldByName('QUANTIDADE').AsInteger;

            Close;
            SQL.Clear;
            SQL.Add('SELECT ESTOQUE_PROD');
            SQL.Add('FROM PRODUTO');
            SQL.Add('WHERE COD_PROD = '+IntToStr(CProduto));
            Open;
            if not IsEmpty then
            begin
              VEstoque := strtoint(FieldByName('ESTOQUE_PROD').AsString);
              if VEstoque > VQuantidade then
              begin
                Close;
                SQL.Clear;
                SQL.Add('UPDATE PRODUTO');
                SQL.Add('SET ESTOQUE_PROD = '+ IntToStr(VEstoque - VQuantidade));
                SQL.Add('WHERE COD_PROD = '+IntToStr(CProduto));
                ExecSQL;
              end
              else
              if VEstoque = VQuantidade then
              begin
                Close;
                SQL.Add('UPDATE PRODUTO');
                SQL.Add('SET ESTOQUE_PROD = '+ IntToStr(VEstoque - VQuantidade));
                SQL.Add('WHERE COD_PROD = '+IntToStr(CProduto));
                SQL.Add('UPDATE PRODUTO');
                SQL.Add('SET ATIVO = 0');
                SQL.Add('WHERE COD_PROD = '+IntToStr(CProduto));
                ExecSQL;
              end;
            end;
            Close;
            SQL.Clear;
            SQL.Add('INSERT INTO COMPRA_ITENS(COD_COMPRA, COD_PROD,QUANTIDADE_ITENS)');
            SQL.Add('VALUES (');
            SQL.Add(cod);
            SQL.Add(',' +IntToStr(CDSItens.FieldByName('COD_PRODUTO').AsInteger));
            SQL.Add(',' +IntToStr(CDSItens.FieldByName('QUANTIDADE').AsInteger));
            SQL.Add(')');
            ExecSQL;
          end;
          CDSItens.Next;
        end;
      end;
    end;
  end;
  btnLimpaProduto.Click;
  btnLimpaCliente.Click;
  Close;
end;

procedure TTCompraC.TransfereDados;
var
  KeyEnter: Char;
begin
  with TDMPrincipal.qGeneric do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT CP.COD_COMPRA,');
    SQL.Add('CONVERT(VARCHAR(10), CP.DATA_COMPRA, 103) AS DATA_COMPRA,');
    SQL.Add('CP.COD_CLI,CP.VALORTOTAL_COMPRA,CP.QUANTIDADE_COMPRA,C.NOME_CLI');
    SQL.Add('FROM COMPRA CP');
    SQL.Add('INNER JOIN CLIENTE C ON CP.COD_CLI = C.COD_CLI ');
    SQL.Add('WHERE CP.COD_COMPRA=' +QuotedStr(cod));
    Open;
    if not IsEmpty then
    begin
      dtCompra.Date := FieldByName('DATA_COMPRA').AsDateTime;
      edCodCliente.Text := FieldByName('COD_CLI').AsString;
      edNomeCliente.Text := FieldByName('NOME_CLI').AsString;
      edPrecoTotal.Value := FieldByName('VALORTOTAL_COMPRA').AsFloat;
      edQuantidadeTotal.Value := FieldByName('QUANTIDADE_COMPRA').AsInteger;
      Close;
      SQL.Clear;
      SQL.Add('SELECT CI.COD_COMPRA_ITENS,CI.COD_PROD,CI.QUANTIDADE_ITENS,P.DESCRICAO_PROD,P.PRECO_PROD');
      SQL.Add('FROM COMPRA_ITENS CI');
      SQL.Add('INNER JOIN PRODUTO P ON P.COD_PROD = CI.COD_PROD');
      SQL.Add('WHERE COD_COMPRA = ' +QuotedStr(cod));
      Open;
      if not IsEmpty then
      begin
        First;
        while not Eof do
        begin
          CDSItens.Append;
          CDSItens.FieldByName('COD_COMPRA_ITENS').AsInteger := FieldByName('COD_COMPRA_ITENS').AsInteger;
          CDSItens.FieldByName('COD_PRODUTO').AsInteger := FieldByName('COD_PROD').AsInteger;
          CDSItens.FieldByName('DESCRICAO').AsString := FieldByName('DESCRICAO_PROD').AsString;
          CDSItens.FieldByName('QUANTIDADE').AsInteger := FieldByName('QUANTIDADE_ITENS').AsInteger;
          CDSItens.FieldByName('PRECO').AsFloat := FieldByName('PRECO_PROD').AsFloat;
          CDSItens.FieldByName('VALOR_TOTAL').AsFloat := FieldByName('QUANTIDADE_ITENS').Value * FieldByName('PRECO_PROD').Value;
          CDSItens.FieldByName('ACAO').AsString := 'N';
          CDSItens.Post;
          Next;
        end;
        if Recebe = 2 then
          SomenteLeitura;
      end;
    end;
  end;
end;

function TTCompraC.VerificaEstoque(CodProduto: string): Boolean;
var aux : Boolean;
begin
  aux :=  True;
  with TDMPrincipal.qGeneric do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT ESTOQUE_PROD');
    SQL.Add('FROM PRODUTO');
    SQL.Add('WHERE COD_PROD = '+ CodProduto);
    Open;
    if not IsEmpty then
    begin
      if FieldByName('ESTOQUE_PROD').AsInteger > 0 then
      begin
        if CDSItens.Locate('COD_PRODUTO', CodProduto, []) then { J? INSERIDO }
        begin
           if (FieldByName('ESTOQUE_PROD').AsInteger - (CDSItens.FieldByName('QUANTIDADE').AsInteger +StrToInt(edQuantidade.Text))) >= 0 then
           begin { ESTOQUE MAIOR QUE ZERO }
             aux := True;
           end
           else { ESTOQUE  }
             aux := False;
        end
        else
        begin
           if (FieldByName('ESTOQUE_PROD').AsInteger - StrToInt(edQuantidade.Text)) >= 0 then
           begin { OK }
             aux := True;
           end
           else { DEU RUIM }
             aux := False;
        end;
      end;
    end;
  end;
  if aux = False then
  begin
    EnviaMensagem('Quantidade solicitada, Indispon?vel no estoque!', 'Informa??o...', mtConfirmation,[mbOK]);
    edQuantidade.Clear;
    if edQuantidade.CanFocus then
      edQuantidade.SetFocus;
  end;
  Result := aux;
end;

procedure TTCompraC.CDSItensCalcFields(DataSet: TDataSet);
begin
  CDSItensVALOR_TOTAL.AsFloat := CDSItensPRECO.AsFloat * CDSItensQUANTIDADE.AsInteger;
end;

procedure TTCompraC.CDSItensPRECOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not CDSItens.IsEmpty then
    Text := 'R$' + FormatFloat('0.00',CDSItens.FieldByName('PRECO').AsFloat)
  else
    Text := '';
end;

procedure TTCompraC.CDSItensVALOR_TOTALGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not CDSItens.IsEmpty then
    Text := 'R$' + FormatFloat('0.00',CDSItens.FieldByName('VALOR_TOTAL').AsFloat)
  else
    Text := '';
end;

function TTCompraC.chamaTela(pid: string; acao: integer): string;
begin
  TCompraC := TTCompraC.Create(application);
  with TCompraC do
  begin
    Recebe := acao;
    cod := pid;
    if acao = 1 then
    begin
      TCompraC.Caption := 'Editar Compra';
      btnPesquisaCliente.Enabled := False;
      //Libera Produto
      btnPesquisaProduto.Enabled := True;
      edCodProduto.Enabled := True;
      edCodProduto.ReadOnly := False;
      TransfereDados;
    end;
    if (acao = 0) or (acao = 2) then
    begin
      if acao = 2 then
        TCompraC.Caption := 'Consultar Compra';
      TransfereDados;
    end;
    ShowModal;
    Result := IntToStr(AtualizaGrid);
    FreeAndNil(TCompraC);
  end;
end;

procedure TTCompraC.edQuantidadeExit(Sender: TObject);
begin
  if Empty(edCodProduto.Text) then
    edQuantidade.Clear;
end;

procedure TTCompraC.edQuantidadeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN:
      if btnAdicionar.CanFocus then
        btnAdicionar.SetFocus
  end;
end;

procedure TTCompraC.edQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
  if (not(key in [#8, #13, #86, #46, #48..#57])) or (key = '.') then
    Key := #0;
  if (edQuantidade.ReadOnly = True) and (Recebe <> 2) then
  begin
    enviaMensagem('Deve ser Inserido um Cliente, para inserir a quantidade!','',mtConfirmation,[mbOK]);
    if edCodCliente.CanFocus then
      edCodCliente.SetFocus;
    Exit;
  end;
end;

procedure TTCompraC.dtCompraChange(Sender: TObject);
begin
  dtCompra.MaxDate := Date;
end;

procedure TTCompraC.dtCompraExit(Sender: TObject);
begin
  if not(validarData(dtCompra.Text)) then
  begin
    if btnCancelar.Focused then
      btnCancelar.Click
    else
    begin
      enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
      if dtCompra.CanFocus then
        dtCompra.SetFocus;
      Exit;
    end;
  end;
end;

procedure TTCompraC.dtCompraKeyDown(Sender: TObject; var Key: Word;
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

procedure TTCompraC.edCodClienteExit(Sender: TObject);
begin
  if Empty(edNomeCliente.Text) then
    edCodCliente.Clear;
end;

procedure TTCompraC.edCodClienteKeyDown(Sender: TObject; var Key: Word;
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

procedure TTCompraC.edCodClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if (not(key in [#8, #13, #86, #46, #48..#57])) or (key = '.') then
    Key := #0;
  if key = #13 then
  begin
    if (not Empty(edCodCliente.Text)) and (edCodCliente.ReadOnly = False) then
    begin
      with TDMPrincipal.qGeneric do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_CLI,NOME_CLI,ATIVO');
        SQL.Add('FROM CLIENTE');
        SQL.Add('WHERE COD_CLI = ' +edCodCliente.Text);
        Open;
        if not IsEmpty then
        begin
          if FieldByName('ATIVO').AsBoolean then
          begin
            edCodCliente.ReadOnly := True;
            btnPesquisaCliente.Enabled := False;
            btnLimpaCliente.Enabled := True;
            edNomeCliente.Text := FieldByName('NOME_CLI').AsString;
            //Libera Produto
            btnPesquisaProduto.Enabled := True;
            edCodProduto.ReadOnly := False;
            edCodProduto.Enabled := True;
            if edCodProduto.CanFocus then
              edCodProduto.SetFocus;
          end
          else
            enviaMensagem('Cliente inativo, n?o pode ser selecionado!','Informa??o...',mtConfirmation,[mbOK]);
        end;
      end;
    end;
  end;
end;

procedure TTCompraC.edCodProdutoExit(Sender: TObject);
begin
  if Empty(edDescricaoProduto.Text) then
    edCodProduto.Clear;
end;

procedure TTCompraC.edCodProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F3:
      if (btnPesquisaProduto.Enabled) or (btnPesquisaProduto.Visible) then
        btnPesquisaProduto.Click;
    VK_F6:
      if (btnLimpaProduto.Visible) and (btnLimpaProduto.Enabled) then
        btnLimpaProduto.Click;
  end;
end;

procedure TTCompraC.edCodProdutoKeyPress(Sender: TObject; var Key: Char);
  var ValidaStatus: Boolean;
begin
  if (not(key in [#8, #13, #86, #46, #48..#57])) or (key = '.') then
    Key := #0;
  if (edCodProduto.ReadOnly = True) and (Recebe <> 2) then
  begin
    enviaMensagem('Deve ser Inserido um Cliente, para inserir um Produto!','',mtConfirmation,[mbOK]);
    if edCodCliente.CanFocus then
      edCodCliente.SetFocus;
    Exit;
  end;
  if (Key = #13) then
  begin
    if (not Empty(edCodProduto.Text)) and (edCodProduto.ReadOnly = False) then
    begin
      with TDMPrincipal.qGeneric do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_PROD,DESCRICAO_PROD,PRECO_PROD,ESTOQUE_PROD,ATIVO');
        SQL.Add('FROM PRODUTO');
        SQL.Add('WHERE COD_PROD = ' + edCodProduto.Text);
        Open;
        if not IsEmpty then
        begin
          if FieldByName('ATIVO').AsBoolean then
          begin
            edCodProduto.ReadOnly := True;
            btnPesquisaProduto.Enabled := False;
            btnLimpaProduto.Enabled := True;
            edQuantidade.ReadOnly := False;
            edDescricaoProduto.Text := FieldByName('DESCRICAO_PROD').AsString;
            edValorProduto.Text := FieldByName('PRECO_PROD').AsString;
            edEstoque.Text := FieldByName('ESTOQUE_PROD').AsString;
            if edQuantidade.CanFocus then
              edQuantidade.SetFocus;
          end
          else
            enviaMensagem('Produto inativo, n?o pode ser selecionado!','Information...',mtConfirmation,[mbOK]);
        end;
      end;
    end;
  end
end;

procedure TTCompraC.edDescricaoProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  key := somenteLetra(key);
end;

procedure TTCompraC.edNomeClienteKeyPress(Sender: TObject; var Key: Char);
begin
  key := somenteLetra(key);
end;

procedure TTCompraC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(CDSItens);
  FreeAndNil(VetProdutosExcluidos);
end;

procedure TTCompraC.FormCreate(Sender: TObject);
begin
  dtCompra.Date := Date;
  CDSItens.CreateDataSet;
  VetProdutosExcluidos := TStringList.Create;
end;

procedure TTCompraC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) and (not dtCompra.Focused) then
        btnCancelar.Click;
    VK_F2:
      if (btnAdicionar.Visible) and (btnAdicionar.Enabled) then
        btnAdicionar.Click;
    VK_F4:
      if (btnRemover.Visible) and (btnRemover.Enabled) then
        btnRemover.Click;
    vk_F5:
      if (btnSalvar.Visible) and (btnSalvar.Enabled) then
        btnSalvar.Click;
  end;
end;

procedure TTCompraC.SomenteLeitura;
begin
  dtCompra.ReadOnly := True;
  dtcompra.Font.Color := clBlue;
  dtcompra.Font.Style := dtCompra.Font.Style + [fsBold];
  btnLimpaProduto.Enabled := False;
  btnLimpaCliente.Enabled := False;
  btnPesquisaCliente.Enabled := False;
  btnPesquisaProduto.Enabled := False;
  edCodProduto.ReadOnly := True;
  edCodCliente.Font.Color := clBlue;
  edCodCliente.Font.Style := edCodCliente.Font.Style + [fsBold];
  edCodCliente.ReadOnly := True;
  edNomeCliente.Font.Color := clBlue;
  edNomeCliente.Font.Style := edNomeCliente.Font.Style + [fsBold];
  edValorProduto.ReadOnly := True;
  edQuantidade.ReadOnly := True;
  edQuantidadeTotal.Font.Color := clBlue;
  edQuantidadeTotal.Font.Style := edQuantidadeTotal.Font.Style + [fsBold];
  btnRemover.Enabled := False;
  btnAdicionar.Enabled := False;
  btnSalvar.Enabled := False;
  edPrecoTotal.Font.Color := clBlue;
  edPrecoTotal.Font.Style := edPrecoTotal.Font.Style + [fsBold];
  DBGrid1.ReadOnly := True;
  DBGrid1.font.Color := clBlue;
  DBGrid1.font.Style := DBGrid1.font.Style + [fsBold];
end;
end.
