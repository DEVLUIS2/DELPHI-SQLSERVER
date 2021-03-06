unit Compra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, DB, ADODB, DBCtrls, Mask;

type
  TTCompra = class(TForm)
    Panel3: TPanel;
    Panel2: TPanel;
    dsCompra: TDataSource;
    qCompra: TADOQuery;
    dbGrid1: TDBGrid;
    Label1: TLabel;
    DBNavigator1: TDBNavigator;
    edCompra: TMaskEdit;
    btnLimpar: TBitBtn;
    Panel1: TPanel;
    btnConsultar: TBitBtn;
    btnSair: TBitBtn;
    btnEditar: TBitBtn;
    btnInserir: TBitBtn;
    btnExcluir: TBitBtn;
    dbGrid2: TDBGrid;
    dsProdutoCompra: TDataSource;
    qProdutoCompra: TADOQuery;
    qProdutoCompraCOD_PROD: TAutoIncField;
    qProdutoCompraDESCRICAO_PROD: TStringField;
    qProdutoCompraPRECO_PROD: TBCDField;
    qProdutoCompraQUANTIDADE_ITENS: TIntegerField;
    qProdutoCompraVALOR_TOTAL: TFMTBCDField;
    procedure BTNSAIRClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BTNLIMPARClick(Sender: TObject);
    procedure BTNEXCLUIRClick(Sender: TObject);
    procedure BTNINSERIRClick(Sender: TObject);
    procedure dbGrid1TitleClick(Column: TColumn);
    procedure FormCreate(Sender: TObject);
    procedure edCompraKeyPress(Sender: TObject; var Key: Char);
    procedure qCompraAfterScroll(DataSet: TDataSet);
    procedure qProdutoCompraPRECO_PRODGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qProdutoCompraVALORTOTAL_COMPRAGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure btnEditarClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure qProdutoCompraVALOR_TOTALGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    Colunapesquisa:string;
  public
    { Public declarations }
    procedure chamaTela;
  end;

var
  TCompra: TTCompra;

implementation

uses DMPRINCIPAL, Funcoes, FuncoesDB, COMPRAC;

{$R *.dfm}

procedure TTCompra.btnConsultarClick(Sender: TObject);
begin
  if qCompra.IsEmpty then
  begin
    enviaMensagem('Seleciona uma registro para consultar!','Informação',mtConfirmation,[mbOK]);
    if edCompra.CanFocus then
      edCompra.SetFocus;
    Exit;
  end
  else
    TCompraC.chamaTela(qCompra.FieldByName('COD_COMPRA').AsString,2)
end;

procedure TTCompra.btnEditarClick(Sender: TObject);
 var na:Integer;
begin
  if qCompra.IsEmpty then
  begin
    enviaMensagem('Nenhuma Compra foi selecionada!','Informação...',mtConfirmation,[mbOK]);
    if edCompra.CanFocus then
      edCompra.SetFocus;
    Exit;
  end
  else
    TCompraC.chamaTela(qCompra.FieldByName('COD_COMPRA').AsString,1);
  na := StrToInt(qCompra.FieldByName('COD_COMPRA').AsString);
  qCompra.Requery();
  qCompra.Locate('COD_COMPRA',na,[]);
  qProdutoCompra.Requery();
end;

procedure TTCompra.BTNEXCLUIRClick(Sender: TObject);
  var ExcluirCompra,Quant,estoq: integer;
begin
  if qCompra.IsEmpty then
  begin
    enviaMensagem('Selecione um registro para excluir.','Informação...',mtConfirmation,[mbOK]);
    Exit;
  end
  else
    ExcluirCompra := enviaMensagem('Deseja excluir está compra?','Informação',mtConfirmation,[mbYes,mbNo]);
  if ExcluirCompra <> mrYes then
  begin
    CloseModal;
  end
  else
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ESTOQUE_PROD');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PROD = '+qProdutoCompra.FieldByName('COD_PROD').AsString);
      Open;
      if not IsEmpty then
      begin
        estoq := StrToInt(FieldByName('ESTOQUE_PROD').AsString);
        Quant := StrToInt(qProdutoCompra.FieldByName('QUANTIDADE_ITENS').AsString);
        Close;
        SQL.Clear;
        SQL.Add('UPDATE PRODUTO');
        SQL.Add('SET ESTOQUE_PROD = '+ IntToStr(estoq + Quant));
        SQL.Add('WHERE COD_PROD = '+qProdutoCompra.FieldByName('COD_PROD').AsString);
        ExecSQL;
      end;
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM COMPRA_ITENS');
      SQL.Add('WHERE COD_COMPRA = ' + qCompra.FieldByName('COD_COMPRA').AsString);
      SQL.Add('DELETE FROM COMPRA');
      SQL.Add('WHERE COD_COMPRA=' + qCompra.FieldByName('COD_COMPRA').AsString);
      ExecSQL;
      qCompra.Requery();
      qProdutoCompra.Requery();
    end;
  end;
end;

procedure TTCompra.BTNINSERIRClick(Sender: TObject);
  var
    RecebeChamada: Integer;
begin
  RecebeChamada := StrToInt(TCompraC.chamaTela('',0));
  if RecebeChamada <> 0 then
  with qCompra do
  begin
    if Active then
      Requery()
    else
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT C.COD_COMPRA,NOME_CLI');
      SQL.Add(',CONVERT(VARCHAR(10),DATA_COMPRA,103)AS DATA_COMPRA');
      SQL.Add('FROM COMPRA C');
      SQL.Add('INNER JOIN CLIENTE CL ON CL.COD_CLI = C.COD_CLI');
      SQL.Add('WHERE COD_COMPRA = '+ IntegerTextSql(RecebeChamada));
      Open;
    end;
    Locate('COD_COMPRA',RecebeChamada,[]);
  end;
end;

procedure TTCompra.BTNLIMPARClick(Sender: TObject);
begin
  edCompra.Clear;
  qCompra.Close;
  edCompra.EditMask := '';
  qProdutoCompra.Close;
  if edCompra.CanFocus then
    edCompra.SetFocus;
end;

procedure TTCompra.BTNSAIRClick(Sender: TObject);
begin
  Close;
end;

procedure TTCompra.chamaTela;
begin
  TCompra:=TTCompra.Create(application);
  with TCompra do
  begin
    ShowModal;
    FreeAndNil(TCompra);
  end;
end;

procedure TTCompra.dbGrid1TitleClick(Column: TColumn);
  var i: integer;
begin
  colunapesquisa := column.FieldName;
  Label1.Caption := 'Digite o ' + Column.Title.Caption + ' ou * para todos e tecle ENTER';
  btnLimpar.Click;
  if Colunapesquisa = 'DATA_COMPRA'  then
  else
    edCompra.EditMask := '';
  //Comandos para mudar o Caption da Label, quando mudar de Coluna.
  for i := 0 to dbGrid1.Columns.Count - 1 do
  begin
    if dbGrid1.Columns[i].FieldName = Column.FieldName then
      dbGrid1.Columns[i].Title.Font.Color := clred
    else
      dbGrid1.Columns[i].Title.Font.Color := clblack;
  end;
end;

procedure TTCompra.FormCreate(Sender: TObject);
begin
  Colunapesquisa := 'NOME_CLI';
end;
procedure TTCompra.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Teclas de Atalho.
  case key of
    VK_ESCAPE:
      if(btnSair.Visible) and (btnSair.Enabled)then
        btnSair.Click;
    vk_f2:
      if(btnInserir.visible) and (btnInserir.Enabled) then
        btnInserir.Click;
    vk_f3:
      if(btnConsultar.Visible) and (btnConsultar.Enabled) then
        btnConsultar.Click;
    vk_f4:
      if (btnEditar.Visible) and (btnEditar.Enabled) then
        btnEditar.Click;
    vk_f7:
      if(btnLimpar.Visible) and (btnLimpar.Enabled) then
        btnLimpar.Click;
    vk_f8:
      if (btnExcluir.Visible) and (btnExcluir.Enabled)  then
        btnExcluir.Click;
  end;
end;

procedure TTCompra.qCompraAfterScroll(DataSet: TDataSet);
begin
  if not qCompra.IsEmpty then
  begin
    with qProdutoCompra do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT P.COD_PROD,P.DESCRICAO_PROD,P.PRECO_PROD,CI.QUANTIDADE_ITENS,CI.QUANTIDADE_ITENS * P.PRECO_PROD AS VALOR_TOTAL');
      SQL.Add('FROM PRODUTO P');
      SQL.Add('INNER JOIN COMPRA_ITENS CI ON CI.COD_PROD = P.COD_PROD');
      SQL.Add('INNER JOIN COMPRA C ON C.COD_COMPRA = CI.COD_COMPRA');
      SQL.Add('WHERE CI.COD_COMPRA = ' + qCompra.FieldByName('COD_COMPRA').AsString);
      Open;
    end;
  end
  else
    qCompra.Close;
end;

procedure TTCompra.qProdutoCompraPRECO_PRODGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not qCompra.IsEmpty then
    Text := 'R$' + FormatFloat('0.00',qProdutoCompra.FieldByName('PRECO_PROD').AsFloat)
  else
    Text := '';
end;

procedure TTCompra.qProdutoCompraVALORTOTAL_COMPRAGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not qCompra.IsEmpty then
  begin
    if qProdutoCompra.IsEmpty then
      Text := ''
    else
      Text := 'R$' + FormatFloat('0.00',qProdutoCompra.FieldByName('VALORTOTAL_COMPRA').AsFloat)
  end
  else
    Text := '';
end;

procedure TTCompra.qProdutoCompraVALOR_TOTALGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  if not qCompra.IsEmpty then
    Text := 'R$' + FormatFloat('0.00',qProdutoCompra.FieldByName('VALOR_TOTAL').AsFloat)
  else
    Text := '';
end;

procedure TTCompra.edCompraKeyPress(Sender: TObject; var Key: Char);
  //função feita com a tag do tedit para repetir o 'where'.
  function GetCondicao: string;
  begin
    if edCompra.Tag = 0 then
    begin
      edCompra.Tag := 1;
      Result := ' WHERE '
    end
    else
      Result := ' AND '
  end;
begin
  edCompra.Tag := 0;
  Key := somenteLetraeNumero(Key);
  if Length(LimpaCaracter(edCompra.Text)) = 0 then
    edCompra.EditMask := '';
  if Colunapesquisa = 'DATA_COMPRA' then
  begin
    if (not(Key in[#13,#42,#8])) then
      if (edCompra.Text = '*') and (edCompra.Text <> '') then
        key:=#0
      else
      if Key in[#48..#57]then
        edCompra.EditMask := '!99/99/9999;1;_'
      else
        key:= #0;
  end;
  if Colunapesquisa = 'COD_COMPRA' then
  begin
    if (not (Key in [#13,#8,#42,#47..#57])) or (key = '.') then
      Key := #0;
      Key := somenteNumero(Key);
    edCompra.MaxLength := 9;
  end;
  if Colunapesquisa = 'NOME_CLI' then
  begin
    if (not (Key in [#13,#42,#8,'A'..'Z','a'..'z'])) or (key = '.') then
      Key := #0;
      Key := somenteLetra(Key);
    edCompra.MaxLength := 100;
  end;
  if edCompra.Text = '*' then
  begin
    if (not(key in [#13,#16,#8])) or (key = '.') then
      Key := #0;
  end;
  if edCompra.Text <> '' then
    if (not(key in ['a'..'z','A'..'Z',#48..#57,#13,#16,#8])) or (key = '.') then
      Key := #0;
  if (key = #13) and not (Empty(edCompra.Text)) then
  begin
    if Colunapesquisa = 'DATA_COMPRA' then
    begin
      if not validarData(edCompra.Text) and (edCompra.Text <> '*') then
      begin
        enviaMensagem('Data inválida!','Informação',mtConfirmation,[mbOK]);
        Exit;
      end;
    end;
    with qCompra do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SET DATEFORMAT DMY');
      SQL.Add('SELECT C.COD_COMPRA,');
      SQL.Add('CL.NOME_CLI,');
      SQL.Add('CONVERT(VARCHAR(10),C.DATA_COMPRA, 103)AS DATA_COMPRA');
      SQL.Add('FROM COMPRA C');
      SQL.Add('INNER JOIN CLIENTE CL ON C.COD_CLI = CL.COD_CLI');
      if edCompra.Text <> '*' then
      begin
        if UpperCase(Colunapesquisa) = 'NOME_CLI' then
          SQL.Add(GetCondicao + Colunapesquisa + ' LIKE ' + QuotedStr('%'+edCompra.Text+'%'))
        else
        if UpperCase(Colunapesquisa) = 'COD_COMPRA' then
          SQL.Add(GetCondicao + Colunapesquisa + ' = ' +edCompra.Text)
        else
        if UpperCase(Colunapesquisa) = 'DATA_COMPRA' then
          SQL.Add(GetCondicao + Colunapesquisa + ' = ' +QuotedStr(edCompra.Text))
      end;
      SQL.Add('ORDER BY ' + colunaPesquisa);
      Open;
      qProdutoCompra.FieldByName('PRECO_PROD').OnGetText := qProdutoCompraPRECO_PRODGetText;
      qProdutoCompra.FieldByName('VALOR_TOTAL').OnGetText := qProdutoCompraVALOR_TOTALGetText;
      if dbGrid1.CanFocus then
        dbGrid1.SetFocus;
      if IsEmpty then
      begin
        enviaMensagem('Nenhum registro encontrado','Informação...',mtConfirmation,[mbOK]);
        if edCompra.CanFocus then
          edCompra.SetFocus;
        Exit;
      end;
    end;
  end;
end;
end.
