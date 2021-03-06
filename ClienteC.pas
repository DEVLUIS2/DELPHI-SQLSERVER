unit ClienteC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, FuncoesDB, rxToolEdit, DateUtils,
  IniFiles;

type
  TTClienteC = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    edClienteC: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cbClienteC: TCheckBox;
    edRgC: TMaskEdit;
    Label3: TLabel;
    Label4: TLabel;
    edCpf: TMaskEdit;
    Panel3: TPanel;
    edDatanascimento: TDateEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure edClienteCKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure edDatanascimentoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edDatanascimentoExit(Sender: TObject);
  private
    { Private declarations }
    ID: string;
    cpf, DataNascimento: Boolean;
    ArquivoIni: TIniFile;
    RecebeAcao,AtualizaGrid: integer;
    procedure BloquearDados;
  public
    { Public declarations }
    function chamaTela(pid: string; acao: integer): string;
    procedure cargaDados;
  end;

var
  TClienteC: TTClienteC;

implementation

uses
  DMPRINCIPAL, Funcoes, CLIENTE;

{$R *.dfm}

procedure TTClienteC.BloquearDados;
begin
  btnSalvar.Visible := False;
  edClienteC.ReadOnly := True;
  edRgC.ReadOnly := True;
  cbClienteC.Enabled := false;
  edRgC.Font.Color := clBlue;
  edClienteC.font.Color := clBlue;
  edClienteC.Font.Style := edClienteC.Font.Style + [fsbold];
  edRgC.Font.Style := edRgC.Font.Style + [fsBold];
  if cpf = True then
  begin
    edCpf.ReadOnly := True;
    edCpf.Font.Color := clBlue;
    edCpf.Font.Style := edCpf.Font.Style + [fsBold];
  end;
  if DataNascimento = True then
  begin
    edDatanascimento.ReadOnly := True;
    edDatanascimento.Font.Color := clBlue;
    edDatanascimento.Font.Style := edDatanascimento.Font.Style + [fsBold];
  end;
end;

procedure TTClienteC.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTClienteC.btnSalvarClick(Sender: TObject);
  var idade: Integer;
begin
  idade := YearsBetween(Date,edDatanascimento.Date);
  if Alltrim(edClienteC.Text) = '' then
  begin
    enviaMensagem('Nome do cliente imcompleto!', 'Informa??o...', mtConfirmation, [mbOK]);
    if edClienteC.CanFocus then
      edClienteC.SetFocus;
    Exit;
  end
  else
  if edClienteC.Text = '' then
  begin
    enviaMensagem('Inserir o nome do cliente!', 'Informa??o...', mtConfirmation, [mbOK]);
    if edClienteC.CanFocus then
      edClienteC.SetFocus;
    Exit;
  end
  else
  if Length(Alltrim(edRgC.Text)) <= 11 then
  begin
    enviaMensagem('RG incompleto!', 'Information...', mtInformation, [mbOK]);
    edRgC.Clear;
    if edRgC.CanFocus then
      edRgC.SetFocus;
    Exit;
  end
  else
  if (Length(Alltrim(edCpf.Text)) <= 13) and (edCpf.Visible = True) then
  begin
    enviaMensagem('CPF incompleto!', 'Information...', mtInformation, [mbOK]);
    edCpf.Clear;
    if edCpf.CanFocus then
      edCpf.SetFocus;
    Exit;
  end;
  if Length(Alltrim(edCpf.Text)) = 14 then
  begin
    if ValidaRegistros('CLIENTE','CPF_CLI',edCpf.Text) = True then
    begin
      enviaMensagem('CPF j? Inserido','Informa??o...',mtConfirmation,[mbOK]);
      if edCpf.CanFocus then
        edCpf.SetFocus;
      Exit;
    end;
  end;
  if Length(Alltrim(edRgC.Text)) = 12 then
  begin
    if ValidaRegistros('CLIENTE','RG_CLI',edRgC.Text)= true then
    begin
      enviaMensagem('RG j? Inserido','Informa??o...',mtConfirmation,[mbOK]);
      if edRgC.CanFocus then
        edRgC.SetFocus;
      Exit;
    end;
  end
  else
  if (not (edDatanascimento.Date < Date)) then
  begin
    enviaMensagem('A data de nascimento, deve ser menor que a data atual!','Informa??o...',mtConfirmation,[mbOK]);
    if edDatanascimento.CanFocus then
      edDatanascimento.SetFocus;
    Exit;
  end
  else
  if not (validarData(edDatanascimento.Text)) and (edDatanascimento.Visible = True) then
  begin
    enviaMensagem('Data inv?lida!', 'Informa??o...', mtConfirmation, [mbOK]);
    if edDatanascimento.CanFocus then
      edDatanascimento.SetFocus;
    Exit;
  end;
  if (idade < 18) and (edDatanascimento.Visible = True) then
  begin
    enviaMensagem('Cliente ainda n?o possui 18 anos de idade!','Informa??o...',mtConfirmation,[mbOK]);
    if edDatanascimento.CanFocus then
      edDatanascimento.SetFocus;
    Exit;
  end;
  with TDMPrincipal.qgeneric do
  begin
    case RecebeAcao of
      0:
        //inserir
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO CLIENTE');
           SQL.Add('(NOME_CLI,');
          SQL.Add('RG_CLI,');
          SQL.Add('ATIVO,');
          SQL.Add('CPF_CLI,');
          SQL.Add('DT_NASC_CLI)');
          SQL.Add('VALUES(' + QuotedStr(UpperCase(edClienteC.Text)));
          SQL.Add(', ' + QuotedStr(edRgC.Text));
          SQL.Add(', ' + BoolToStr(cbClienteC.Checked));
          if edCpf.Visible = True then
            SQL.Add(', ' + QuotedStr(edCpf.Text))
          else
            SQL.Add(', ' + QuotedStr(''));
          if edDatanascimento.Visible = True then
            SQL.Add(', ' + dateTextSql(edDatanascimento.Date))
          else
            SQL.Add(', ' + dateTextSql(Date));
          SQL.Add(')');
          ExecSQL;
          AtualizaGrid := GetCodigoIdentity('CLIENTE');
        end;
      1:
        //Editar
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE CLIENTE');
          SQL.Add('SET NOME_CLI =' + QuotedStr(UpperCase(edClienteC.Text)));
          SQL.Add(', RG_CLI = ' + quotedStr(edrgc.Text));
          SQL.Add(', ATIVO = ' + BoolToStr(cbClienteC.Checked));
          if cpf = True then
            SQL.Add(', CPF_CLI = '+ QuotedStr(edCpf.Text));
          if DataNascimento = True then
            SQL.Add(', DT_NASC_CLI = '+ dateTextSql(edDatanascimento.Date));
          SQL.Add('WHERE COD_CLI = ' + id);
          ExecSQL;
        end;
    end;
  end;
  Close;
end;

procedure TTClienteC.cargaDados;
begin
  with TDMPrincipal.qGeneric do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT');
    sql.Add('*');
    SQL.Add('FROM CLIENTE');
    SQL.Add('WHERE COD_CLI = ' + QuotedStr(ID));
    Open;
    edClienteC.Text := TDMPrincipal.qGeneric.FieldByName('NOME_CLI').AsString;
    edRgC.Text := TDMPrincipal.qGeneric.FieldByName('RG_CLI').AsString;
    if cpf = True then
    begin
      edCpf.Text := TDMPrincipal.qGeneric.FieldByName('CPF_CLI').AsString;
    end;
    if DataNascimento = True then
    begin
      edDatanascimento.Date := TDMPrincipal.qGeneric.FieldByName('DT_NASC_CLI').AsDateTime;
    end
    else
    if TDMPrincipal.qGeneric.FieldByName('ATIVO').AsBoolean then
      cbClienteC.Checked := TRUE
    else
      cbClienteC.Checked := False;
    cbClienteC.Enabled := true;
    if RecebeAcao = 2 then
      BloquearDados;
    SQL.Add('ORDER BY NOME_CLI ASC')
  end;
end;

function TTClienteC.chamaTela(pid: string; acao: integer): string;
begin
  TClienteC := TTClienteC.Create(application);
  with TClienteC do
  begin
    id := pid;
    RecebeAcao := acao;
    if (acao = 1) or (acao = 2) then
    begin
      if (acao = 1) then
        TClienteC.caption := ('Editar Cliente')
      else if (acao = 2) then
        TClienteC.Caption := ('Consultar Cliente');
      cargaDados;
    end;
    ShowModal;
    Result := IntToStr(AtualizaGrid);
    FreeAndNil(TClienteC);
  end;
end;

procedure TTClienteC.edClienteCKeyPress(Sender: TObject; var Key: Char);
var
  s1, s2, s3: string;
  iTam: integer;
begin
  if not (Key in [#13, #8, #32, 'a'..'z', 'A'..'Z']) then
    Key := #0;
  iTam := Length(edClienteC.Text);
  if iTam >= 2 then
  begin
    s1 := UpperCase(Key);
    s2 := edClienteC.Text[iTam];
    s3 := edClienteC.Text[iTam - 1];
    if (s1 = s2) and (s2 = s3) then
    begin
      edClienteC.Text := '';
      enviaMensagem('N?o ? permitido reincidir o caractere mais de duas vezes', 'Informa??o...', mtConfirmation, [mbOK]);
      Exit;
    end;
  end;
end;

procedure TTClienteC.edDatanascimentoExit(Sender: TObject);
begin
  if not(validarData(edDatanascimento.Text)) then
  begin
    if btnCancelar.Focused then
      btnCancelar.Click
    else
    begin
      enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
      if edDatanascimento.CanFocus then
        edDatanascimento.SetFocus;
      Exit;
    end;
  end;
end;

procedure TTClienteC.edDatanascimentoKeyDown(Sender: TObject; var Key: Word;
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

procedure TTClienteC.FormCreate(Sender: TObject);
begin
  ArquivoIni := TIniFile.Create('D:\FOCUS\Ini\config.ini');
  cpf := StrToBool(ArquivoIni.ReadString('CLIENTE','CPF',''));
  DataNascimento := StrToBool(ArquivoIni.ReadString('CLIENTE','DATA_NASC',''));
  ArquivoIni.Free;
  if (cpf = True) and (DataNascimento = False) then
  begin
    Label3.Visible := False;
    edDatanascimento.Visible := False;
    Panel3.Visible := False;
    Height := 220;
  end
  else
  if (DataNascimento = True) and (cpf = False) then
  begin
    Label4.Visible := False;
    edCpf.Visible := False;
    Height := 220;
  end;
  if (DataNascimento = False) and (cpf = False) then
  begin
    Height := 170;
    Label4.Visible := False;
    edCpf.Visible := False;
    Label3.Visible := False;
    edDatanascimento.Visible := False;
    Panel3.Visible := False;
  end;
end;

procedure TTClienteC.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) and (btnCancelar.CanFocus) then
        btnCancelar.Click;
    VK_F5:
      if (btnSalvar.Visible) and (btnSalvar.Enabled) then
        btnSalvar.Click;
  end;
end;

end.

