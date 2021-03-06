unit Fornecedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, ADODB, Grids, DBGrids, DBCtrls, Buttons, Mask;

type
  TTFornecedores = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    dsFornecedores: TDataSource;
    rgFiltrar: TRadioGroup;
    DBNavigator1: TDBNavigator;
    edFornecedor: TMaskEdit;
    btnLimpar: TBitBtn;
    btnConsultar: TBitBtn;
    btnExcluir: TBitBtn;
    btnEditar: TBitBtn;
    btnInserir: TBitBtn;
    btnFechar: TBitBtn;
    btnTransferir: TBitBtn;
    dbGrid1: TDBGrid;
    qFornecedores: TADOQuery;
    Label1: TLabel;
    lbRegistros: TLabel;
    lbTotal: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnLimparClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure edFornecedorKeyPress(Sender: TObject; var Key: Char);
    procedure dbGrid1TitleClick(Column: TColumn);
    procedure btnInserirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgFiltrarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure qFornecedoresATIVOGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qFornecedoresAfterOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure btnTransferirClick(Sender: TObject);
    procedure dbGrid1DblClick(Sender: TObject);
    procedure dbGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
     ColunaPesquisa: string;
     InfoProduto:string;
  public
    { Public declarations }
     procedure chamaTela;
     function TransfereFornecedor(Codigo:Integer):string;
  end;

var
  TFornecedores: TTFornecedores;

implementation

uses FornecedoresC, DMPRINCIPAL, Funcoes, FuncoesDB;

{$R *.dfm}

{ TTFornecedores }

procedure TTFornecedores.btnConsultarClick(Sender: TObject);
begin
  if not qFornecedores.IsEmpty then
  begin
    TFornecedoresC.chamaTela(qFornecedores.FieldByName('COD_FORNECEDOR').AsString,2);
  end
  else
  begin
    enviaMensagem('Selecione um registro para consultar.','Informa??o...',mtConfirmation,[mbOK]);
    if edFornecedor.CanFocus then
      edFornecedor.SetFocus;
    Exit;
  end;
end;

procedure TTFornecedores.btnEditarClick(Sender: TObject);
  var na: Integer;
begin
  if not qFornecedores.IsEmpty then
  begin
    na := StrToInt(qFornecedores.FieldByName('COD_FORNECEDOR').AsString);
    TFornecedoresC.chamaTela(qFornecedores.FieldByName('COD_FORNECEDOR').AsString,1);
    qFornecedores.Requery();
    qFornecedores.Locate('COD_FORNECEDOR',na,[]);
  end
  else
  begin
    enviaMensagem('Selecione um registro para editar.','Informa??o...',mtConfirmation,[mbOK]);
    if edFornecedor.CanFocus then
      edFornecedor.SetFocus;
    Exit;
  end;
end;

procedure TTFornecedores.btnExcluirClick(Sender: TObject);
  var ExcluirFornecedor: integer;
begin
  //Se tentar excluir sem ter selecionado nada.
  if qFornecedores.IsEmpty then
  begin
    enviaMensagem('Selecione um registro para excluir.','Informa??o...',mtConfirmation,[mbOK]);
    if edFornecedor.CanFocus then
      edFornecedor.SetFocus;
    Exit;
  end
  else
  begin
    //Bot?o excluir
    ExcluirFornecedor := enviaMensagem('Deseja excluir este fornecedor?','Informa??o...', mtConfirmation, [mbYes, mbNo]);
    if ExcluirFornecedor <> mrYes then
    begin
      CloseModal;
    end
    else
    //TemReferencia fun??o verifica se o campo, tem referencia com a tabela
    if empty(TemReferencia('FORNECEDORES', qFornecedores.FieldByName('COD_FORNECEDOR').AsString,'ESTAGIARIO_LUIS'))then
    begin
      with TDMPrincipal.qGeneric do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM FORNECEDORES');
        SQL.Add('WHERE COD_FORNECEDOR = ' + qFornecedores.FieldByName('COD_FORNECEDOR').AsString);
        ExecSQL;
        qFornecedores.Requery();
        lbTotal.Caption := IntToStr(qFornecedores.RecordCount);
      end;
    end
    else
    begin
      enviaMensagem('Imposs?vel deletar este fornecedor. Pois ele possui uma Liga??o no Banco','Informa??o...',mtConfirmation,[mbOK]);
      ExcluirFornecedor := enviaMensagem('Deseja marca-lo como "INATIVO"?','Informa??o...',mtConfirmation, [mbYes, mbNo]);
      if ExcluirFornecedor = mrYes then
      begin
        with TDMPrincipal.QGENERIC do
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE FORNECEDORES');
          SQL.Add('SET ATIVO = 0');
          SQL.Add('WHERE COD_FORNECEDOR = ' + qFornecedores.FieldByName('COD_FORNECEDOR').AsString);
          ExecSQL;
          qFornecedores.Requery();
        end;
      end
      else
        Exit;
    end;
  end;
end;

procedure TTFornecedores.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTFornecedores.btnInserirClick(Sender: TObject);
  var
    RecebeChamada: string;
begin
  RecebeChamada := TFornecedoresC.chamaTela('',0);
  if RecebeChamada > '0' then
  begin
    with qFornecedores do
    begin
      if Active then
        Requery()
      else
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_FORNECEDOR,NOME_FORNECEDOR,CNPJ_FORNECEDOR,ATIVO');
        SQL.Add('FROM FORNECEDORES');
        SQL.Add('WHERE COD_FORNECEDOR = ' +RecebeChamada);
        Open;
        qFornecedores.FieldByName('ATIVO').OnGetText := qFornecedoresATIVOGetText;
      end;
      Locate('COD_FORNECEDOR',RecebeChamada,[]);
    end;
  end;
end;

procedure TTFornecedores.btnLimparClick(Sender: TObject);
begin
  edFornecedor.EditMask := '';
  edFornecedor.Clear;
  lbTotal.Caption := '0';
  qFornecedores.Close;
  if edFornecedor.CanFocus then
    edfornecedor.SetFocus;
end;

procedure TTFornecedores.btnTransferirClick(Sender: TObject);
begin
  if qFornecedores.IsEmpty then
    enviaMensagem('Selecione um registro para Transferir','string',mtConfirmation,[mbOK])
  else
  begin
    InfoProduto := qFornecedores.FieldByName('COD_FORNECEDOR').AsString;
    Close;
  end;
end;

procedure TTFornecedores.chamaTela;
begin
  TFornecedores := TTFornecedores.Create(Application);
  with TFornecedores do
  begin
    ShowModal;
    FreeAndNil(TFornecedores);
  end;
end;

procedure TTFornecedores.dbGrid1DblClick(Sender: TObject);
begin
  if (btnTransferir.Visible = True) or (btnTransferir.Enabled = False) then
    btnTransferir.Click;
end;

procedure TTFornecedores.dbGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN:
      if (btnTransferir.Visible) and (btnTransferir.Enabled) then
        btnTransferir.Click;
  end
end;

procedure TTFornecedores.dbGrid1TitleClick(Column: TColumn);
  var i: Integer;
begin
  ColunaPesquisa := Column.FieldName;
  if ColunaPesquisa = 'ATIVO' then
  begin
    btnLimpar.Click;
    ColunaPesquisa := 'NOME_FORNECEDOR';
    dbGrid1.Columns[1].Title.Font.Color := clRed;
    dbGrid1.Columns[0].Title.Font.Color := clBlack;
    dbGrid1.Columns[2].Title.Font.Color := clBlack;
    enviaMensagem('A consulta n?o pode ser feita por ativo','Aten??o',mtWarning,[mbOK]);
    if edFornecedor.CanFocus then
      edFornecedor.SetFocus;
    Exit;
  end
  else
  begin
    Label1.Caption := 'Digite o ' + Column.Title.Caption + ' ou * para todos e tecle Enter';
    btnLimpar.Click;
    if ColunaPesquisa = 'CNPJ_FORNECEDOR' then
    else
      edFornecedor.EditMask := '';
    for i := 0 to dbGrid1.Columns.Count -2 do
    begin
      if dbGrid1.Columns[I].FieldName = column.FieldName then
        dbGrid1.Columns[I].Title.Font.Color := clRed
      else
        dbGrid1.Columns[I].Title.Font.Color := clBlack;
    end;
  end;
end;

procedure TTFornecedores.FormCreate(Sender: TObject);
begin
  ColunaPesquisa := 'NOME_FORNECEDOR';
end;

procedure TTFornecedores.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnFechar.Click;
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
procedure TTFornecedores.FormShow(Sender: TObject);
begin
  if edFornecedor.CanFocus then
    edFornecedor.SetFocus
end;

procedure TTFornecedores.edFornecedorKeyPress(Sender: TObject; var Key: Char);
  function GetCondicao:string;
  begin
    if edFornecedor.Tag = 0 then
    begin
      edFornecedor.Tag := 1;
      Result := ' WHERE '
    end
    else
      Result := ' AND '
  end;
begin
  edFornecedor.Tag := 0;
  Key := somenteLetraeNumero(Key);
  if Length(LimpaCaracter(edFornecedor.Text)) = 0 then
    edFornecedor.EditMask := '';
  if edFornecedor.Text = '*' then
  begin
    if (not(Key in[#13,#8,#16])) then
      Key := #0;
  end
  else
  if edFornecedor.Text <> '' then
  begin
    if (not(Key in[#13,#8,'A'..'Z','a'..'z',#48..#57])) then
      Key := #0;
  end;
  if ColunaPesquisa = 'COD_FORNECEDOR' then
  begin
    if (not(key in [#13,#42,#8,#48..#57])) or (key = '.') then
      Key := #0;
    edFornecedor.MaxLength := 9;
  end
  else if ColunaPesquisa = 'NOME_FORNECEDOR' then
  begin
    edFornecedor.MaxLength := 100;
    Key := somenteLetra(Key);
  end
  else if ColunaPesquisa = 'CNPJ_FORNECEDOR' then
  begin
    if (not(key in [#13,#42,#8])) or (key = '.') then
      edFornecedor.EditMask := '!99.999.999/9999-99;1;_';
    Key := somenteNumero(Key);
  end
  else
  if edFornecedor.Text <> '' then
  begin
    if (not (Key in[#32,#13,#16,#8,'A'..'Z','a'..'z'])) then
      Key := #0;
  end;
  if (key = #13) and not(empty(edFornecedor.Text)) then
  begin
    with qFornecedores do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_FORNECEDOR,NOME_FORNECEDOR,');
      SQL.Add('CNPJ_FORNECEDOR,ATIVO');
      SQL.Add('FROM FORNECEDORES');
      if edFornecedor.Text <> '*' then
      begin
        if UpperCase(ColunaPesquisa) = 'COD_FORNECEDOR' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' +edFornecedor.Text)
        else
        if UpperCase(ColunaPesquisa) = 'NOME_FORNECEDOR' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' LIKE ' +QuotedStr('%'+edFornecedor.Text+'%'))
        else
        if UpperCase(ColunaPesquisa) = 'CNPJ_FORNECEDOR' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' +QuotedStr(edFornecedor.Text))
      end;
      case rgFiltrar.ItemIndex of
        0:
          SQL.Add(GetCondicao + ' ATIVO = 1 ');
        1:
          SQL.Add(GetCondicao + ' ATIVO = 0 ');
      end;
      SQL.Add('ORDER BY ' + colunaPesquisa);
      Open;
      qFornecedores.FieldByName('ATIVO').OnGetText := qFornecedoresATIVOGetText;
      if dbGrid1.CanFocus then
        dbGrid1.SetFocus;
      if IsEmpty then
      begin
        enviaMensagem('Nenhum registro encontrado','Informa??o...',mtConfirmation,[mbOK]);
        if edFornecedor.CanFocus then
          edFornecedor.SetFocus;
        Exit;
      end;
    end;
  end;
end;
procedure TTFornecedores.qFornecedoresAfterOpen(DataSet: TDataSet);
begin
  lbTotal.Caption := IntToStr(qFornecedores.RecordCount);
  if dbGrid1.CanFocus then
    dbGrid1.SetFocus;
end;

procedure TTFornecedores.qFornecedoresATIVOGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not qFornecedores.IsEmpty then
  begin
    if qFornecedores.FieldByName('ATIVO').AsBoolean then
      Text := ' ATIVO '
    else
      Text := ' INATIVO '
  end
  else
    Text := '';
end;

procedure TTFornecedores.rgFiltrarClick(Sender: TObject);
begin
  case rgFiltrar.ItemIndex of
    0:
      btnLimpar.Click;
    1:
      btnLimpar.Click;
    2:
      btnLimpar.Click;
  end;
end;

function TTFornecedores.TransfereFornecedor(Codigo: Integer): string;
begin
  TFornecedores := TTFornecedores.Create(Application);
  with TFornecedores do
  begin
    btnTransferir.Visible := True;
    btnInserir.Visible := False;
    btnExcluir.Visible := False;
    btnEditar.Visible := False;
    ShowModal;
    if InfoProduto <> '' then
      Result := InfoProduto
    else
      Result := '0';
    FreeAndNil(TFornecedores);
  end;
end;
end.
