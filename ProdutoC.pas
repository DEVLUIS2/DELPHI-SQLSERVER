unit ProdutoC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, rxToolEdit, rxCurrEdit, DateUtils, StrUtils;

type
  TTProdutoC = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    btnCancelar: TBitBtn;
    btnSalvar: TBitBtn;
    CheckBox1: TCheckBox;
    Panel3: TPanel;
    ceValor: TCurrencyEdit;
    Label1: TLabel;
    lbEstoque: TLabel;
    edEstoque: TEdit;
    edDescricao: TEdit;
    Label2: TLabel;
    dtProduto: TDateEdit;
    lbData: TLabel;
    GroupBox1: TGroupBox;
    btnPesquisaFornecedor: TBitBtn;
    btnLimpaFornecedor: TBitBtn;
    edCodFornecedor: TEdit;
    edFornecedor: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure edEstoqueKeyPress(Sender: TObject; var Key: Char);
    procedure btnPesquisaFornecedorClick(Sender: TObject);
    procedure btnLimpaFornecedorClick(Sender: TObject);
    procedure edCodFornecedorExit(Sender: TObject);
    procedure edCodFornecedorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCodFornecedorKeyPress(Sender: TObject; var Key: Char);
    procedure dtProdutoAcceptDate(Sender: TObject; var ADate: TDateTime;
      var Action: Boolean);
    procedure dtProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtProdutoExit(Sender: TObject);
  private
    { Private declarations }
    cod:string;
    RecebeAcao,AtualizaGrid: integer;
    procedure BloquearDados;
    procedure cargaDados;

  public
    { Public declarations }
    function chamaTela(pid:string; acao:integer):string;
  end;

var
  TProdutoC: TTProdutoC;

implementation

uses DMPRINCIPAL, FuncoesDB, Funcoes, Fornecedores;

{$R *.dfm}


procedure TTProdutoC.btnPesquisaFornecedorClick(Sender: TObject);
 var
    InfoProduto: string;
begin
  InfoProduto := TFornecedores.TransfereFornecedor(0);
  if InfoProduto <> '' then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_FORNECEDOR,NOME_FORNECEDOR');
      SQL.Add('FROM FORNECEDORES');
      SQL.Add('WHERE COD_FORNECEDOR =' +InfoProduto);
      Open;
      edCodFornecedor.Text := TDMPrincipal.qGeneric.FieldByName('COD_FORNECEDOR').AsString;
      edFornecedor.Text := TDMPrincipal.qGeneric.FieldByName('NOME_FORNECEDOR').AsString;
      edCodFornecedor.ReadOnly := True;
      btnPesquisaFornecedor.Enabled := False;
      btnLimpaFornecedor.Enabled := True;
      if btnSalvar.CanFocus then
        btnSalvar.SetFocus;
    end;
  end;
end;

procedure TTProdutoC.BloquearDados;
begin
  CheckBox1.Enabled := False;
  btnSalvar.Visible := False;
  edDescricao.ReadOnly := True;
  edDescricao.Font.Color := clBlue;
  edDescricao.Font.Style := edDescricao.Font.Style + [fsBold];
  dtProduto.ReadOnly := True;
  dtProduto.Font.Color := clBlue;
  dtProduto.Font.Style := dtProduto.Font.Style + [fsBold];
  ceValor.ReadOnly := True;
  ceValor.Font.Color := clBlue;
  ceValor.Font.Style := ceValor.Font.Style + [fsBold];
  edEstoque.ReadOnly := True;
  edEstoque.Font.Color := clBlue;
  edEstoque.Font.Style := edEstoque.Font.Style + [fsBold];
  btnPesquisaFornecedor.Enabled := False;
  btnLimpaFornecedor.Enabled := False;
  edCodFornecedor.ReadOnly := True;
  edCodFornecedor.Font.Color := clBlue;
  edCodFornecedor.Font.Style := edCodFornecedor.Font.Style + [fsBold];
  edFornecedor.Font.Color := clBlue;
  edFornecedor.Font.Style := edFornecedor.Font.Style + [fsBold];
end;

procedure TTProdutoC.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTProdutoC.btnLimpaFornecedorClick(Sender: TObject);
begin
  edCodFornecedor.Clear;
  edFornecedor.Clear;
  edCodFornecedor.ReadOnly := False;
  btnPesquisaFornecedor.Enabled := True;
  btnLimpaFornecedor.Enabled := False;
  if edCodFornecedor.CanFocus then
    edCodFornecedor.SetFocus;
end;

procedure TTProdutoC.btnSalvarClick(Sender: TObject);
var PAtivado: Integer;
begin
  if (not validarData(dtProduto.Text)) then
  begin
    enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
    if dtProduto.CanFocus then
      dtProduto.SetFocus;
    Exit;
  end
  else
  if Alltrim(edDescricao.Text) = '' then
  begin
    enviaMensagem('Nome do cliente imcompleto!','Informa??o...',mtConfirmation,[mbOK]);
    if edDescricao.CanFocus then
      edDescricao.SetFocus;
    Exit;
  end
  else
  if edFornecedor.Text = '' then
  begin
    enviaMensagem('Por favor, inserir fornecedor!','Informa??o...',mtConfirmation,[mbOK]);
    if edCodFornecedor.CanFocus then
      edCodFornecedor.SetFocus;
    Exit;
  end
  else
  if edDescricao.Text = '' then
  begin
    enviaMensagem('Insira uma descri??o para o produto.','Informa??o...',mtConfirmation,[mbOK]);
    if edDescricao.CanFocus then
      edDescricao.SetFocus;
    Exit;
  end
  else
  if ceValor.Value = 0 then
  begin
    enviaMensagem('Digite o pre?o do produto.','Informa??o...',mtConfirmation,[mbOK]);
    if ceValor.CanFocus then
      ceValor.SetFocus;
    Exit;
  end
  else
  if StrToInt(edEstoque.Text) < 0 then
  begin
    enviaMensagem('Insira a quantidade do estoque.','Informa??o...',mtConfirmation,[mbOK]);
    if edEstoque.CanFocus then
      edEstoque.SetFocus;
    Exit;
  end;
  with TDMPrincipal.qGeneric do
  begin
    case RecebeAcao of
      0:  //Inserir
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO PRODUTO(DESCRICAO_PROD,PRECO_PROD,');
        SQL.Add('DATA_VALIDADE,ATIVO,ESTOQUE_PROD,COD_FORNECEDOR)');
        SQL.Add('VALUES('+QuotedStr(UpperCase(edDescricao.Text)));
        SQL.Add(', ' + virgulaporponto(FloatToStr(ceValor.Value)));
        SQL.Add(', ' + dateTextSql(dtProduto.Date));
        SQL.Add(', ' + BoolToStr(CheckBox1.Checked));
        SQL.Add(', ' + edEstoque.Text);
        SQL.Add(', ' + edCodFornecedor.Text);
        SQL.Add(')');
        ExecSQL;
        AtualizaGrid := GetCodigoIdentity2('ESTAGIARIO_LUIS','PRODUTO');
      end;
      1:  //Editar
      begin
        if FieldByName('ATIVO').AsBoolean then
        begin
          if StrToInt(edEstoque.Text)<= 0  then
          begin
            enviaMensagem('Estoque zerado. produto n?o pode ser ativado!','Informa??o...',mtConfirmation,[mbOK]);
            if edEstoque.CanFocus then
              edEstoque.SetFocus;
            Exit;
          end;
          if dtProduto.Date <= Tomorrow then
          begin
            enviaMensagem('A data para registrar um produto, n?o pode ser vencida','Informa??o...',mtConfirmation,[mbOK]);
            if dtProduto.CanFocus then
              dtProduto.SetFocus;
            Exit;
          end;
          if Empty(edEstoque.Text) then
          begin
            enviaMensagem('Estoque n?o pode ser vazio','Informa??o...',mtConfirmation,[mbOK]);
            if edEstoque.CanFocus then
              edEstoque.SetFocus;
            Exit;
          end;
          if CheckBox1.Checked = True then
          begin
            CheckBox1.Checked := True;
          end;
        end
        else if FieldByName('ATIVO').AsBoolean = False  then
        begin
          if enviaMensagem('Se deseja somente atualizar o nome do Produto selecione "SIM", ou para Modificar seu status "N?O"','Informa??o...',mtConfirmation,[mbYes,mbNo])= mrNo then
          begin
            if StrToInt(edEstoque.Text)<= 0 then
            begin
              enviaMensagem('Estoque zerado. produto n?o pode ser ativado!','Informa??o...',mtConfirmation,[mbOK]);
              if edEstoque.CanFocus then
                edEstoque.SetFocus;
              Exit;
            end;
            if dtProduto.Date <= Tomorrow then
            begin
              enviaMensagem('A data para registrar um produto, n?o pode ser vencida','Informa??o...',mtConfirmation,[mbOK]);
              if dtProduto.CanFocus then
                dtProduto.SetFocus;
              Exit;
            end;
            if Empty(edEstoque.Text) then
            begin
              enviaMensagem('Estoque n?o pode ser vazio','Informa??o...',mtConfirmation,[mbOK]);
              if edEstoque.CanFocus then
                edEstoque.SetFocus;
              Exit;
            end;
            if CheckBox1.Checked = False then
            begin
              if enviaMensagem('Deseja ativar este produto','Informa??o...',mtConfirmation,[mbYes,mbNo])= mrNo then
                CheckBox1.Checked := False
              else
                CheckBox1.Checked := True;
            end;
          end;
        end;
        Close;
        SQL.Clear;
        SQL.Add('UPDATE PRODUTO');
        SQL.Add('SET DESCRICAO_PROD = ' +QuotedStr(UpperCase(edDescricao.Text)));
        SQL.Add(', PRECO_PROD= ' + virgulaPorPonto(FloatToStr(ceValor.Value)));
        SQL.Add(', DATA_VALIDADE= ' + dateTextSql(dtProduto.Date));
        SQL.Add(', ESTOQUE_PROD= '+edEstoque.Text);
        SQL.Add(', COD_FORNECEDOR=' +edCodFornecedor.Text);
        SQL.Add(', ATIVO =' +BoolToStr(CheckBox1.Checked));
        SQL.Add('WHERE COD_PROD = '+cod);
        ExecSQL;
      end;
    end;
  end;
  Close;
end;
procedure TTProdutoC.cargadados;
begin
  with TDMPrincipal.qGeneric do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT P.COD_PROD,P.DESCRICAO_PROD,');
    SQL.Add('P.PRECO_PROD,F.COD_FORNECEDOR,F.NOME_FORNECEDOR');
    SQL.Add(',CONVERT(DATETIME, P.DATA_VALIDADE, 103) AS DATA_VALIDADE,');
    SQL.Add('P.ATIVO,P.ESTOQUE_PROD');
    SQL.Add('FROM PRODUTO P');
    SQL.Add('INNER JOIN FORNECEDORES F ON F.COD_FORNECEDOR = P.COD_FORNECEDOR');
    SQL.Add('WHERE COD_PROD=' +QuotedStr(cod));
    OPen;
    if not IsEmpty then
    begin
      edCodFornecedor.Text := FieldByName('COD_FORNECEDOR').AsString;
      edCodFornecedor.ReadOnly := True;
      edCodFornecedor.Color := clBtnFace;
      btnPesquisaFornecedor.Enabled := False;
      btnLimpaFornecedor.Enabled := True;
      edFornecedor.Text := FieldByName('NOME_FORNECEDOR').AsString;
      edDescricao.Text := FieldByName('DESCRICAO_PROD').AsString;
      ceValor.value := FieldByName('PRECO_PROD').AsFloat;
      dtProduto.date := FieldByName('DATA_VALIDADE').AsDateTime;
      edEstoque.Text := FieldByName('ESTOQUE_PROD').AsString;
      if TDMPrincipal.qGeneric.FieldByName('ATIVO').AsBoolean  then
        CheckBox1.Checked := True
      else
        CheckBox1.Checked := False;
      CheckBox1.Enabled := True;
      if RecebeAcao = 2 then
        BloquearDados;
    end;
  end;
end;

function TTProdutoC.chamaTela (pid:string;acao:integer):string;
begin
  TProdutoC:=TTProdutoC.Create(application);
  with TProdutoC do
  begin
    dtProduto.Date := Tomorrow;
    RecebeAcao := acao;
    cod:=pid;
    if (acao = 1) or (acao = 2) then
    begin
      if (acao = 1) then
        tprodutoc.Caption := ('Editar Produto')
      else
      if (acao = 2) then
        TProdutoC.Caption := ('Consultar Produto');
      cargaDados;
    end;
    ShowModal;
    Result := IntToStr(AtualizaGrid);
    FreeAndNil(TProdutoC);
  end;
end;

procedure TTProdutoC.dtProdutoAcceptDate(Sender: TObject; var ADate: TDateTime;
  var Action: Boolean);
begin
  dtProduto.MinDate := Tomorrow;
end;

procedure TTProdutoC.dtProdutoExit(Sender: TObject);
begin
  if not(validarData(dtProduto.Text)) then
  begin
    if btnCancelar.Focused then
      btnCancelar.Click
    else
    begin
      enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
      if dtProduto.CanFocus then
        dtProduto.SetFocus;
      Exit;
    end;
  end;
end;

procedure TTProdutoC.dtProdutoKeyDown(Sender: TObject; var Key: Word;
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

procedure TTProdutoC.edCodFornecedorExit(Sender: TObject);
begin
  if Empty(edFornecedor.Text) then
    edCodFornecedor.Clear;
end;

procedure TTProdutoC.edCodFornecedorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F3:
      if (btnPesquisaFornecedor.Visible) and  (btnPesquisaFornecedor.Enabled) then
        btnPesquisaFornecedor.Click;
  end;
end;

procedure TTProdutoC.edCodFornecedorKeyPress(Sender: TObject; var Key: Char);
begin
  if (not(key in [#8, #13, #86, #46, #48..#57])) or (key = '.') then
    Key := #0;
  if Key = #13 then
  begin
    if not (Empty(edCodFornecedor.Text)) then
    begin
      with TDMPrincipal.qGeneric do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_FORNECEDOR,NOME_FORNECEDOR,ATIVO');
        SQL.Add('FROM FORNECEDORES');
        SQL.Add('WHERE COD_FORNECEDOR = '+ edCodFornecedor.Text);
        Open;
        if not IsEmpty then
        begin
          if FieldByName('ATIVO').AsBoolean then
          begin
            edFornecedor.Text := FieldByName('NOME_FORNECEDOR').AsString;
            edCodFornecedor.ReadOnly := True;
            btnLimpaFornecedor.Enabled := True;
            btnPesquisaFornecedor.Enabled := False;
            if btnSalvar.CanFocus then
              btnSalvar.SetFocus;
          end
          else
            enviaMensagem('Fornecedor inativo, n?o pode ser selecionado!','Informa??o...',mtConfirmation,[mbOK]);
        end;
      end;
    end
    else
      enviaMensagem('Sem Registro!','Informa??o...',mtConfirmation,[mbOK]);
  end;
end;

procedure TTProdutoC.edDescricaoKeyPress(Sender: TObject; var Key: Char);
  var
    s1,s2,s3:string;
    iTam: integer;
begin
  if (not(key in [#13,#8,'A'..'Z',#32,'a'..'z'])) or (key = '.') then
    Key := #0;
  iTam := Length(edDescricao.Text);
  if iTam >= 2 then
  begin
    s1 := UpperCase(Key);
    s2 := edDescricao.Text[iTam];
    s3 := edDescricao.Text[iTam -1];
    if (s1 = s2) and (s2 = s3) then
    begin
      edDescricao.Text := '';
      enviaMensagem('N?o ? permitido, reincidir o caracter, mais de duas vezes.','Informa??o...',mtConfirmation,[mbOK]);
      Exit;
    end;
  end;
end;

procedure TTProdutoC.edEstoqueKeyPress(Sender: TObject; var Key: Char);
begin
  if (not(key in [#8, #13, #86, #46, #48..#57])) or (key = '.') then
    Key := #0;
end;

procedure TTProdutoC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) and (not dtProduto.Focused) then
        btnCancelar.Click;
    VK_F5:
      if (btnSalvar.Visible) and (btnSalvar.Enabled) then
        btnSalvar.Click;
    VK_F6:
      if (btnLimpaFornecedor.Visible) and (btnLimpaFornecedor.Enabled) then
        btnLimpaFornecedor.Click;
  end;
end;

end.
