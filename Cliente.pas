unit Cliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, DB, ADODB, DBCtrls, Mask,
  ComCtrls,IniFiles;

type
  TTCliente = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    btnLimpar: TBitBtn;
    btnConsultar: TBitBtn;
    btnExcluir: TBitBtn;
    btnEditar: TBitBtn;
    btnInserir: TBitBtn;
    btnSair: TBitBtn;
    Label1: TLabel;
    qCliente: TADOQuery;
    dsCliente: TDataSource;
    dbnCliente: TDBNavigator;
    rgFiltrarPor: TRadioGroup;
    dbGrid1: TDBGrid;
    edCliente: TMaskEdit;
    btnTransferir: TBitBtn;
    lbRegistros: TLabel;
    lbTotal: TLabel;
    procedure btnSairClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnEditarClick(Sender: TObject);
    procedure dbgClienteTitleClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure edClienteKeyPress(Sender: TObject; var Key: Char);
    procedure rgFiltrarPorClick(Sender: TObject);
    procedure QCLIENTEATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure btnInserirClick(Sender: TObject);
    procedure btnTransferirClick(Sender: TObject);
    procedure qClienteAfterOpen(DataSet: TDataSet);
    procedure dbGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    ColunaPesquisa, infocliente: string;
    cpf,DataNascimento,Ativo: Boolean;
    ArquivoIni: TIniFile;
  public
    { Public declarations }
    procedure chamaTela ;
    function transferecliente:String;
  end;
var
  TCliente: TTCliente;

implementation

uses DMPRINCIPAL, Funcoes, Funcoesdb, CLIENTEC, Ini;

{$R *.dfm}

procedure TTCliente.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TTCliente.btnTransferirClick(Sender: TObject);
begin
  if qCliente.IsEmpty then
  begin
    enviaMensagem('Selecione um registro para transferir','Informação...',mtConfirmation,[mbOK]);
    Exit;
  end
  else
  begin
    infocliente := qCliente.FieldByName('COD_CLI').AsString;
    Close;
  end;
end;

procedure TTCliente.btnConsultarClick(Sender: TObject);
begin
  if not qCliente.IsEmpty then
  begin
    TClienteC.chamaTela(qCliente.FieldByName('COD_CLI').AsString,2);
  end
  else
  begin
    enviaMensagem('Selecione um registro para consultar','Informação...',mtConfirmation,[mbOK]);
    if edCliente.CanFocus then
      edCliente.SetFocus;
    Exit;
  end;
end;

procedure TTCliente.btnEditarClick(Sender: TObject);
 var na: integer;
begin
  if not qCliente.IsEmpty then
  begin
    na := StrToInt(qCliente.FieldByName('COD_CLI').AsString);
    TClienteC.chamaTela(qCliente.FieldByName('COD_CLI').AsString,1);
    qCliente.Requery();
    qCliente.Locate('COD_CLI',na,[]);
  end
  else
  begin
    enviaMensagem('Selecione um registro para Editar','Informação...',mtConfirmation,[mbOK]);
    if edCliente.CanFocus then
      edCliente.SetFocus;
    Exit;
  end;
end;

procedure TTCliente.btnExcluirClick(Sender: TObject);
  var
    ExcluirCliente: integer;
begin
  if qCliente.IsEmpty then
  begin
    enviaMensagem('Selecione um registro para editar','Informação...',mtConfirmation,[mbOK]);
    if edCliente.CanFocus then
      edCliente.SetFocus;
    Exit;
  end
  else
  begin
    //Botão excluir
    ExcluirCliente := enviaMensagem('Deseja excluir este cliente?','Informação...', mtConfirmation, [mbYes, mbNo]);
    if ExcluirCliente <> mrYes then
    begin
      CloseModal;
    end
    else
    //TemReferencia função verifica se o campo, tem referencia com a tabela
    if empty(TemReferencia('CLIENTE', qcliente.FieldByName('COD_CLI').AsString,'ESTAGIARIO_LUIS'))then
    begin
      with TDMPrincipal.qGeneric do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM CLIENTE');
        SQL.Add('WHERE COD_CLI = ' + qCliente.FieldByName('COD_CLI').AsString);
        ExecSQL;
        qCliente.Requery();
        lbTotal.Caption := IntToStr(qCliente.RecordCount);
      end;
    end
    else
    //Se caso o cliente possuir ligação com outra tabela, ele vai mudar para inativo, invez de excluir.
    begin
      enviaMensagem('Impossível deletar este Cliente. Pois ele possui uma compra no Banco','Informação...',mtConfirmation,[mbOK]);
      ExcluirCliente := enviaMensagem('Deseja marca-lo como "INATIVO" ?','Informação...', mtConfirmation, [mbYes, mbNo]);
      //Atualiza cliente para Inativo.
      if ExcluirCliente = mrYes then
      begin
        with TDMPrincipal.QGENERIC do
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE CLIENTE');
          SQL.Add('SET ATIVO = 0');
          SQL.Add('WHERE COD_CLI = ' + qcliente.FieldByName('COD_CLI').AsString);
          ExecSQL;
          qCliente.Requery();
        end;
      end
      else
        Exit;
    end;
  end;
end;

procedure TTCliente.btnInserirClick(Sender: TObject);
  var RecebeChamada: String;
begin
  RecebeChamada := TClienteC.chamaTela('',0);
  if RecebeChamada > '0' then
  with qCliente do
  begin
    if Active then
      Requery()
    else
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_CLI,NOME_CLI,RG_CLI,ATIVO,CPF_CLI,DT_NASC_CLI');
      SQL.Add('FROM CLIENTE');
      SQL.Add('WHERE COD_CLI = ' + (RecebeChamada));
      Open;
      qCliente.FieldByName('ATIVO').OnGetText := QCLIENTEATIVOGetText;
    end;
    Locate('COD_CLI', RecebeChamada,[]);
  end;
end;

procedure TTCliente.btnLimparClick(Sender: TObject);
begin
  edCliente.Clear;
  qCliente.Close;
  edCliente.EditMask := '';
  lbTotal.Caption := '0';
  if edCliente.CanFocus then
    edCliente.SetFocus;
end;

procedure TTCliente.chamaTela;
begin
  //Para chamar a tela no TPRINCIPAL
  TCliente := TTCliente.Create(Application);
  with TCliente do
  begin
    ShowModal;
    FreeAndNil(TCliente);
  end;
end;

procedure TTCliente.dbgClienteTitleClick(Column: TColumn);
  var i: Integer;
begin
  ColunaPesquisa := Column.FieldName;
  if ColunaPesquisa = 'ATIVO' then
  begin
    btnLimpar.Click;
    ColunaPesquisa := 'NOME_CLI';
    dbGrid1.Columns[1].Title.Font.Color := clRed;
    dbGrid1.Columns[0].Title.Font.Color := clBlack;
    dbGrid1.Columns[2].Title.Font.Color := clBlack;
    if cpf = True then
      dbGrid1.Columns[3].Title.Font.Color := clBlack;
    if DataNascimento = True then
      dbGrid1.Columns[4].Title.Font.Color := clBlack;
    enviaMensagem('A consulta não pode ser feita por ativo','Atenção',mtWarning,[mbOK]);
    if edCliente.CanFocus then
      edCliente.SetFocus;
    Exit;
  end
  else
  begin
    Label1.Caption := 'Digite o ' +  Column.Title.Caption + ' ou * para todos e tecle ENTER';
    btnLimpar.Click;
    edCliente.EditMask := '';
    for i := 0 to dbGrid1.Columns.Count -1 do
    begin
      if dbGrid1.Columns[I].FieldName = Column.FieldName then
        dbGrid1.Columns[I].Title.Font.Color := clRed
      else
        dbGrid1.Columns[I].Title.Font.Color := clBlack;
    end;
  end;

end;
procedure TTCliente.dbGrid1DblClick(Sender: TObject);
begin
  if btnTransferir.Visible = True then
    btnTransferir.Click;
end;

procedure TTCliente.dbGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN:
      if (btnTransferir.Visible) and (btnTransferir.Enabled) then
        btnTransferir.Click;
  end;
end;

procedure TTCliente.FormCreate(Sender: TObject);
begin
  ColunaPesquisa := 'NOME_CLI';
end;

procedure TTCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Teclas de atalho.
  case key of
    VK_ESCAPE:
      if (btnSair.Visible) and (btnSair.Enabled) then
        btnSair.Click;
    vk_f2:
      if (btnInserir.Visible) and (btnInserir.Enabled) then
        btnInserir.Click;
    VK_f3:
      if (btnConsultar.Visible) and (btnConsultar.Enabled) then
        btnConsultar.Click;
    vk_f4:
      if (btnEditar.Visible) and (btnEditar.Enabled) then
        btnEditar.Click;
    vk_f8:
      if (btnExcluir.Visible) and (btnExcluir.Enabled) then
        btnExcluir.Click;
    vk_f7:
      if (btnLimpar.Visible) and (btnLimpar.Enabled) then
        btnLimpar.Click;
    vk_f12:
      if (btnTransferir.Visible) and (btnTransferir.Enabled) then
        btnTransferir.Click;
  end;
end;

procedure TTCliente.FormShow(Sender: TObject);
begin
  ArquivoIni := TIniFile.Create('D:\FOCUS\Ini\config.ini');
  cpf := StrToBool(ArquivoIni.ReadString('CLIENTE','CPF',''));
  DataNascimento := StrToBool(ArquivoIni.ReadString('CLIENTE','DATA_NASC',''));

  ArquivoIni.Free;
  if (cpf = True) and (DataNascimento = False) then
  begin
    with dbGrid1 do
    begin
      Columns.Add;
      Columns[4].Title.Caption := 'CPF';
      Columns[4].FieldName := 'CPF_CLI';
      Columns[4].Index := 3;
      Columns[3].Width := 127;
      Columns[1].Width := 300;
    end;
  end
  else
  if (DataNascimento = true) and (cpf = False) then
  begin
    with dbGrid1 do
    begin
      Columns.Add;
      Columns[4].Title.Caption := 'Data Nascimento';
      Columns[4].FieldName := 'DT_NASC_CLI';
      Columns[4].Index := 3;
      Columns[3].Title.Font.Size := 8;
      Columns[3].Width := 127;
      Columns[1].Width := 300;
    end;
  end
  else
  if (cpf = True) and (DataNascimento = True) then
  begin
    with dbGrid1 do
    begin
      Columns[1].Width := 240;
      Columns.Add;
      Columns[4].Title.Caption := 'CPF';
      Columns[4].FieldName := 'CPF_CLI';
      Columns[4].Title.Font.Size := 8;
      Columns[4].Width := 90;
      Columns[4].Index := 3;
      Columns.Add;
      Columns[5].Title.Caption := 'Data Nascimento';
      Columns[5].FieldName := 'DT_NASC_CLI';
      Columns[5].Title.Font.Size := 8;
      Columns[5].Width := 105;
      Columns[5].Index := 4;
      Columns[5].Width := 80;
    end;
  end;
  if edCliente.CanFocus then
    edCliente.SetFocus;
end;


procedure TTCliente.qClienteAfterOpen(DataSet: TDataSet);
begin
  lbTotal.Caption := IntToStr(qCliente.RecordCount);
  if edCliente.CanFocus then
    edCliente.SetFocus;
end;

procedure TTCliente.edClienteKeyPress(Sender: TObject; var Key: Char);
  //função para repetir o 'where' usando a propriedade:'tag'
  function GetCondicao: string;
  begin
    if edCliente.tag = 0 then
    begin
      edCliente.Tag := 1;
      Result := ' WHERE ';
    end
    else
      Result := ' AND '
  end;
begin
  edCliente.Tag := 0;
  Key := somenteLetraeNumero(Key);
  if Length(LimpaCaracter(edCliente.Text)) = 0 then
    edCliente.EditMask := '';
  if ColunaPesquisa = 'COD_CLI'then
  begin
    if (not(key in [#13,#42,#8,#48..#57])) then
      Key := #0;
    if edCliente.Text <> '' then
    begin
      if (not (Key in[#32,#13,#8,#48..#57])) then
        Key := #0;
    end;
    edCliente.MaxLength := 9;
    Key := somenteNumero(Key);
  end
  else
  if ColunaPesquisa = 'NOME_CLI' then
  begin
    Key := somenteLetra(key);
    edCliente.MaxLength := 100;
    if edCliente.Text <> '' then
    begin
      if (not (Key in[#32,#13,#16,#8,'A'..'Z','a'..'z'])) then
        Key := #0;
    end;
  end
  else
  if ColunaPesquisa = 'RG_CLI' then
  begin
    if (not(Key in[#13,#42,#8])) then
      if (edCliente.Text = '*') and (edCliente.Text <> '') then
        key:=#0
      else
      if Key in[#48..#57]then
        edCliente.EditMask := '!99.999.999-9;1;_'
      else
        key:= #0;
  end
  else
  if ColunaPesquisa = 'CPF_CLI' then
  begin
    if (not(Key in[#13,#42,#8])) then
      if (edCliente.Text = '*') and (edCliente.Text <> '') then
        key:=#0
      else
      if Key in[#48..#57]then
        edCliente.EditMask := '!999.999.999-99;1;_'
      else
        key:= #0;
  end
  else
  if Colunapesquisa = 'DT_NASC_CLI' then
  begin
    if (not(Key in[#13,#42,#8])) then
      if (edCliente.Text = '*') and (edCliente.Text <> '') then
        key:=#0
      else
      if Key in[#48..#57]then
        edCliente.EditMask := '!99/99/9999;1;_'
      else
        key:= #0;;
  end;
  if edCliente.Text = '*' then
  begin
    if (not(key in [#13,#16,#8])) then
      Key := #0;
  end;
  if (Key = #13) and not(Empty(edCliente.Text)) then
  begin
    if (ColunaPesquisa = 'DT_NASC_CLI') and (edCliente.Text <> '*') then
    begin
      if not validarData(edCliente.Text) then
      begin
        enviaMensagem('Data Inválida','Informação...',mtConfirmation,[mbOK]);
        if edCliente.CanFocus then
          edCliente.SetFocus;
        Exit;
      end;
    end;
    with qCliente do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('COD_CLI,');
      SQL.Add('NOME_CLI,RG_CLI,ATIVO,CPF_CLI,DT_NASC_CLI');
      SQL.Add('FROM CLIENTE');
      if edCliente.Text <> '*' then
      begin
        if UpperCase(ColunaPesquisa) = 'COD_CLI' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' +edCliente.Text)
        else
        if UpperCase(ColunaPesquisa) = 'NOME_CLI' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' LIKE ' +QuotedStr('%'+edCliente.Text+'%'))
        else
        if UpperCase(ColunaPesquisa) = 'RG_CLI' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + QuotedStr(edCliente.Text))
        else
        if UpperCase(ColunaPesquisa) = 'CPF_CLI' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + QuotedStr(edCliente.Text))
        else
        if UpperCase(ColunaPesquisa) = 'DT_NASC_CLI' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + QuotedStr(edCliente.Text))
      end;
      case rgFiltrarPor.ItemIndex of
        0:
          SQL.Add(GetCondicao + ' ATIVO = 1 ');
        1:
          SQL.Add(GetCondicao + ' ATIVO = 0 ');
      end;
      SQL.Add('ORDER BY ' + colunaPesquisa);
      Open;
      qCliente.FieldByName('ATIVO').OnGetText := QCLIENTEATIVOGetText;
      if dbGrid1.CanFocus then
        dbGrid1.SetFocus;
      if IsEmpty then
      begin
        enviaMensagem('Nenhum registro encontrado','Informação...',mtConfirmation,[mbOK]);
        if edCliente.CanFocus then
          edCliente.SetFocus;
        Exit;
      end;
    end;
  end;
end;

procedure TTCliente.QCLIENTEATIVOGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if not qCliente.IsEmpty then
  begin
    if qCliente.FieldByName('ATIVO').AsBoolean then
      Text := 'ATIVO'
    else
      Text := 'INATIVO';
  end
  else
    Text := '';
end;

procedure TTCliente.rgFiltrarPorClick(Sender: TObject);
begin
  case rgFiltrarPor.ItemIndex of
    0:
      btnLimpar.Click;
    1:
      btnLimpar.Click;
    2:
      btnLimpar.Click;
  end;
end;
function TTCliente.transferecliente: String;
begin
  TCliente := TTCliente.Create(Application);
  with TCliente do
  begin
    btnTransferir.visible := True;
    btnEditar.Visible := False;
    btnInserir.Visible := False;
    btnExcluir.Visible := False;
    rgFiltrarPor.Visible := False;
    ShowModal;
    if infocliente <> '' then
      Result := infocliente
    else
      Result := '0';
    FreeAndNil(tcliente);
  end;
end;
end.
