unit FornecedoresC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ExtCtrls, Buttons;

type
  TTFornecedoresC = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    edFornecedor: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    CheckBox1: TCheckBox;
    edCnpj: TMaskEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edFornecedorKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    id:string;
    RecebeAcao, AtualizaGrid: integer;
    procedure BloquearDados;
  public
    { Public declarations }
    function chamaTela(pid:string; acao:integer):string;
    procedure cargaDados;

  end;

var
  TFornecedoresC: TTFornecedoresC;

implementation

uses DMPRINCIPAL, FuncoesDB, Funcoes;

{$R *.dfm}

{ TTFornecedoresC }





procedure TTFornecedoresC.BloquearDados;
begin
  edCnpj.ReadOnly := True;
  edCnpj.Font.Color := clBlue;
  edCnpj.Font.Style := edCnpj.Font.Style + [fsBold];
  edFornecedor.ReadOnly := True;
  edFornecedor.Font.Color := clBlue;
  edFornecedor.Font.Style := edFornecedor.Font.Style + [fsBold];
  btnSalvar.Visible := False;
  CheckBox1.Enabled := False;
end;

procedure TTFornecedoresC.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFornecedoresC.btnSalvarClick(Sender: TObject);
begin
  if Alltrim(edFornecedor.Text) = '' then
  begin
    enviaMensagem('Nome do cliente imcompleto!','Informação...',mtConfirmation,[mbOK]);
    if edFornecedor.CanFocus then
      edFornecedor.SetFocus;
    Exit;
  end;
  if edFornecedor.Text = '' then
  begin
    enviaMensagem('Inserir fornecedor','Informação...',mtConfirmation,[mbOK]);
    if edFornecedor.CanFocus then
      edFornecedor.SetFocus;
    Exit;
  end;
  if edCnpj.Text = '' then
  begin
    enviaMensagem('Inserir CNPJ','Informação...',mtConfirmation,[mbOK]);
    if edCnpj.CanFocus then
      edCnpj.SetFocus;
    Exit;
  end
  else
  if Length(Alltrim(edCnpj.Text)) <= 17 then
  begin
    enviaMensagem('CNPJ Incompleto!','Informação...',mtConfirmation,[mbOK]);
    if edCnpj.CanFocus then
      edCnpj.SetFocus;
    Exit;
  end
  else
  if Length(Alltrim(edCnpj.Text)) = 18 then
  begin
    if ValidaRegistros('FORNECEDORES','CNPJ_FORNECEDOR',edCnpj.Text)= True then
    begin
      enviaMensagem('CNPJ já Inserido','Informação...',mtConfirmation,[mbOK]);
      if edCnpj.CanFocus then
        edCnpj.SetFocus;
      Exit;
    end;
  end;
  with TDMPrincipal.qgeneric do
  begin
    case RecebeAcao of
      0:
      begin //inserir
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO FORNECEDORES');
        SQL.Add('(NOME_FORNECEDOR,');
        SQL.Add('CNPJ_FORNECEDOR,');
        SQL.Add('ATIVO)');
        sql.Add('VALUES('+ QuotedStr(UpperCase(edFornecedor.Text)));
        sql.Add(', ' + QuotedStr(edCnpj.Text));
        sql.Add(', ' + BoolToStr(CheckBox1.Checked));
        sql.Add(')');
        ExecSQL;
        AtualizaGrid := GetCodigoIdentity2('ESTAGIARIO_LUIS','FORNECEDORES');
      end;
      1: //Editar
      begin
        close;
        sql.Clear;
        sql.Add('UPDATE FORNECEDORES');
        sql.Add('SET NOME_FORNECEDOR =' + QuotedStr(UpperCase(edFornecedor.Text)));
        sql.Add(', CNPJ_FORNECEDOR = ' + quotedStr(edCnpj.Text));
        sql.Add(', ATIVO = ' + BoolToStr(CheckBox1.Checked));
        sql.Add('WHERE COD_FORNECEDOR = ' + id);
        ExecSQL;
      end;
    end;
  end;
  Close;
end;

procedure TTFornecedoresC.cargaDados;
begin
  with TDMPrincipal.QGENERIC do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * ');
    SQL.Add('FROM FORNECEDORES');
    SQL.Add('WHERE COD_FORNECEDOR = '+ QuotedStr(ID));
    Open;
    edFornecedor.Text := TDMPrincipal.qGeneric.FieldByName('NOME_FORNECEDOR').AsString;
    edCnpj.Text := TDMPrincipal.qGeneric.FieldByName('CNPJ_FORNECEDOR').AsString;
    if TDMPrincipal.qGeneric.FieldByName('ATIVO').AsBoolean then
      CheckBox1.Checked:=TRUE
    else
      CheckBox1.Checked:=False;
      CheckBox1.Enabled:=true;
    if RecebeAcao = 2 then
       BloquearDados;
    SQL.Add('OREDER BY NOME_FORNECEDOR ASC')
  end;
end;

function TTFornecedoresC.chamaTela(pid: string; acao: integer): string;
begin
  TFornecedoresC:=TTFornecedoresC.Create(application);
  with TFornecedoresC do
  begin
    id:=pid;
    RecebeAcao := Acao;
    if (acao = 1) or (acao = 2) then
    begin
      if (Acao = 1) then
        TFornecedoresC.caption := ('Editar Fornecedor')
      else
      if (Acao = 2) then
        TFornecedoresC.Caption := ('Consultar Fornecedor');
      cargaDados;
    end;
    ShowModal;
    Result := IntToStr(AtualizaGrid);
    FreeAndNil(TFornecedoresC);
  end;
end;

procedure TTFornecedoresC.edFornecedorKeyPress(Sender: TObject; var Key: Char);
  var s1,s2,s3: string;
    Itam: Integer;
begin
  if (not(key in [#13,#8,'A'..'Z','a'..'z',#32,#48..#57])) or (key = '.') then
    Key := #0;
  Itam := Length(edFornecedor.Text);
  if Itam >= 2 then
  begin
    s1 := UpperCase(Key);
    s2 := edFornecedor.Text[Itam];
    s3 := edFornecedor.Text[Itam -1];
    if (s1 = s2) and (s2 = s3) then
    begin
      edFornecedor.Text := '';
      enviaMensagem('Não é permitido reincidir o caractere mais de duas vezes.','Informação...',mtConfirmation,[mbOK]);
    end;
  end;
end;

procedure TTFornecedoresC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) then
        btnCancelar.Click;
    VK_F5:
      if (btnSalvar.Visible) and (btnsalvar.Enabled) then
        btnSalvar.Click;
  end;
end;
end.
