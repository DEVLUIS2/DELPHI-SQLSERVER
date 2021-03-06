unit Produto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, Buttons, DB, ADODB, DBCtrls,
  Mask, DateUtils, StrUtils, IniFiles;

type
  TTProduto = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    qProduto: TADOQuery;
    dsProduto: TDataSource;
    btnLimpar: TBitBtn;
    btnExcluir: TBitBtn;
    btnInserir: TBitBtn;
    btnEditar: TBitBtn;
    btnFechar: TBitBtn;
    Label1: TLabel;
    dbGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    edProduto: TMaskEdit;
    btnConsultar: TBitBtn;
    rgProduto: TRadioGroup;
    btnTransferir: TBitBtn;
    lbRegistros: TLabel;
    lbTotal: TLabel;
    procedure btnFecharClick(Sender: TObject);
    procedure BTNCONCLUIRClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnLimparClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dbGrid1TitleClick(Column: TColumn);
    procedure edProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure rgProdutoClick(Sender: TObject);
    procedure QPRODUTOATIVOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure btnConsultarClick(Sender: TObject);
    procedure btnTransferirClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure qProdutoPRECO_PRODGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure qProdutoAfterOpen(DataSet: TDataSet);
    procedure dbGrid1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    ColunaPesquisa, InfoProduto: string;
    ArquivoIni:TIniFile;
    estoque:Boolean;
  public
    { Public declarations }
    procedure chamaTela;
    function TransfereProduto: string;
  end;

var
  TProduto: TTProduto;

implementation

uses
  DMPRINCIPAL, Funcoes, FuncoesDB, PRODUTOC, COMPRAC;

{$R *.dfm}

procedure TTProduto.BTNCONCLUIRClick(Sender: TObject);
begin
  Close;
end;

procedure TTProduto.btnConsultarClick(Sender: TObject);
begin
  if not qProduto.IsEmpty then
  begin
    TProdutoC.chamaTela(qProduto.FieldByName('COD_PROD').AsString, 2);
  end
  else
  begin
    enviaMensagem('Selecione um registro para Consultar.','Informação...',mtConfirmation,[mbOK]);
    if edProduto.CanFocus then
      edProduto.SetFocus;
    Exit;
  end;
end;

procedure TTProduto.btnEditarClick(Sender: TObject);
  var na: integer;
begin
  if not qProduto.IsEmpty then
  begin
    na := StrToInt(qProduto.FieldByName('COD_PROD').AsString);
    TProdutoC.chamaTela(qProduto.FieldByName('COD_PROD').AsString, 1);
    qProduto.Requery();
    qProduto.Locate('COD_PROD',na,[]);
  end
  else
  begin
    enviaMensagem('Selecione um registro para editar.','Informação...',mtConfirmation,[mbOK]);
    if edProduto.CanFocus then
      edProduto.SetFocus;
    Exit;
  end;
end;

procedure TTProduto.btnExcluirClick(Sender: TObject);
var
  ExcluirProduto: integer;
begin
  if qProduto.IsEmpty then
  begin
    enviaMensagem('Selecione um registro para excluir.','Informação...',mtConfirmation,[mbOK]);
    if edProduto.CanFocus then
      edProduto.SetFocus;
    Exit;
  end
  else
    ExcluirProduto := enviaMensagem('Deseja excluir este produto?','Informação...',mtConfirmation, [mbYes, mbNo]);
  if ExcluirProduto <> mrYes then
  begin
    CloseModal;
  end
  else
  begin
    if empty(TemReferencia('PRODUTO', qProduto.FieldByName('COD_PROD').AsString, 'ESTAGIARIO_LUIS')) then
    begin
      with TDMPrincipal.qGeneric do
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT ESTOQUE_PROD');
        SQL.Add('FROM PRODUTO');
        SQL.Add('WHERE COD_PROD = '+qProduto.FieldByName('COD_PROD').AsString);
        Open;
        if not IsEmpty then
        begin
          if FieldByName('ESTOQUE_PROD').AsString = '0' then
          begin
            SQL.Add('DELETE FROM PRODUTO');
            SQL.Add('WHERE COD_PROD = ' + qProduto.FieldByName('COD_PROD').AsString);
            ExecSQL;
          end
          else
          begin
            enviaMensagem('Contém produtos no estoque. Não pode ser excluido!','Informação...',mtConfirmation,[mbOK]);
          end;
        end
        else
          enviaMensagem('Vazio!','Informação...',mtConfirmation,[mbOK]);
        qProduto.Requery();
        lbTotal.Caption := IntToStr(qProduto.RecordCount);
      end;
    end
    else
    begin
      enviaMensagem('Este produto tem relação com compras, não pode ser excluido!','Informação...',mtConfirmation,[mbOK]);
      ExcluirProduto := enviaMensagem('Deseja inativar este produto','Informação...',mtConfirmation, [mbYes, mbNo]);
      if ExcluirProduto = mrYes then
      begin
        with TDMPrincipal.qGeneric do
        begin
          Close;
          SQL.Clear;
          SQL.Add('UPDATE PRODUTO');
          SQL.Add('SET ATIVO = 0');
          SQL.Add('WHERE COD_PROD = ' + qProduto.FieldByName('COD_PROD').AsString);
          ExecSQL;
          qProduto.Requery();
        end;
      end
      else
        Exit;
    end;
  end;
end;

procedure TTProduto.btnLimparClick(Sender: TObject);
begin
  edProduto.EditMask := '';
  edProduto.Clear;
  lbTotal.Caption := '0';
  qProduto.Close;
  if edProduto.CanFocus then
    edProduto.SetFocus;
end;

procedure TTProduto.btnTransferirClick(Sender: TObject);
begin
  if qProduto.IsEmpty then
  begin
    enviaMensagem('Selecione um registro para transferir','Informação...',mtConfirmation,[mbOK])
  end
  else
  begin
    InfoProduto := qProduto.FieldByName('COD_PROD').AsString;
    Close;
  end;
end;

procedure TTProduto.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TTProduto.btnInserirClick(Sender: TObject);
var
  RecebeChamada: string;
begin
  RecebeChamada := TProdutoC.chamaTela('', 0);
  if RecebeChamada > '0' then
  begin
    with qProduto do
    begin
      if Active then
        Requery()
      else
      begin
        Close;
        SQL.Clear;
        SQL.Add('SELECT COD_PROD,DESCRICAO_PROD,PRECO_PROD');
        SQL.Add(',CONVERT(VARCHAR(10),DATA_VALIDADE,103)AS DATA_VALIDADE');
        SQL.Add(',ESTOQUE_PROD,ATIVO');
        SQL.Add('FROM PRODUTO');
        SQL.Add('WHERE COD_PROD = ' + RecebeChamada);
        Open;
        qProduto.FieldByName('ATIVO').OnGetText := QPRODUTOATIVOGetText;
        qProduto.FieldByName('PRECO_PROD').OnGetText := qProdutoPRECO_PRODGetText;
        if not IsEmpty then
        begin
          if (qProduto.FieldByName('ATIVO').AsBoolean = True) and (StrToInt(qProduto.FieldByName('ESTOQUE_PROD').AsString) = 0) then
          begin
            Close;
            SQL.Clear;
            SQL.Add('UPDATE PRODUTO');
            SQL.Add('SET ATIVO = 0');
            SQL.Add('WHERE COD_PROD = '+ RecebeChamada);
            ExecSQL;
          end
          else
          Locate('COD_PROD', RecebeChamada, []);
        end;
      end;
    end;
  end;
end;

procedure TTProduto.chamaTela;
begin
  //Chama tela
  TProduto := TTProduto.Create(application);
  with TProduto do
  begin
    ShowModal;
    FreeAndNil(TProduto);
  end;
end;

procedure TTProduto.dbGrid1DblClick(Sender: TObject);
begin
  if btnTransferir.Visible = True then
    btnTransferir.Click;
end;

procedure TTProduto.dbGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN:
      if (btnTransferir.Visible) and (btnTransferir.Enabled) then
        btnTransferir.Click;
  end
end;

procedure TTProduto.dbGrid1TitleClick(Column: TColumn);
var
  i: Integer;
begin
  ColunaPesquisa := Column.FieldName;
  if ColunaPesquisa = 'ATIVO' then
  begin
    btnLimpar.Click;
    ColunaPesquisa := 'DESCRICAO_PROD';
    dbGrid1.Columns[1].Title.Font.Color := clRed;
    dbGrid1.Columns[0].Title.Font.Color := clBlack;
    dbGrid1.Columns[2].Title.Font.Color := clBlack;
    if estoque = True then
      dbGrid1.Columns[3].Title.Font.Color := clBlack;
    dbGrid1.Columns[4].Title.Font.Color := clBlack;
    enviaMensagem('A consulta não pode ser feita por ativo','Atenção',mtWarning,[mbOK]);
    if edProduto.CanFocus then
      edProduto.SetFocus;
    Exit;
  end
  else
  begin
    Label1.Caption := 'Digite o ' + Column.Title.Caption + ' ou * para todos e tecle ENTER';
    btnLimpar.Click;
    if ColunaPesquisa = 'DATA_VALIDADE' then
    else
      edProduto.EditMask := '';
    //Estrutura de retição de clique, para quando selecionar o título na dbgrid
    for i := 0 to dbGrid1.Columns.Count - 1 do
    begin
      if dbGrid1.Columns[i].FieldName = Column.FieldName then
        dbGrid1.Columns[i].Title.Font.Color := clRed
      else
        dbGrid1.Columns[i].Title.Font.Color := clBlack
    end;
  end;
end;

procedure TTProduto.FormCreate(Sender: TObject);
begin
  ColunaPesquisa := 'DESCRICAO_PROD';
end;

procedure TTProduto.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //ATALHOS DO TECLADO
  case Key of
    VK_ESCAPE:
      if (btnFechar.Visible) and (btnFechar.Enabled) then
        btnFechar.Click;
    vk_f2:
      if (btnInserir.Visible) and (btnInserir.Enabled) then
        btnInserir.Click;
    vk_f3:
      if (btnConsultar.Visible) and (btnConsultar.Enabled) then
        btnConsultar.Click;
    vk_f4:
      if (btnEditar.Visible) and (btnEditar.Enabled) then
        btnEditar.Click;
    vk_f7:
      if (btnLimpar.Visible) and (btnLimpar.Enabled) then
        btnLimpar.Click;
    vk_f8:
      if (btnExcluir.Visible) and (btnExcluir.Enabled) then
        btnExcluir.Click;
    vk_f12:
      if (btnTransferir.Visible) and (btnTransferir.Enabled) then
        btnTransferir.Click;
  end;
end;

procedure TTProduto.FormShow(Sender: TObject);
begin
  ArquivoIni := TIniFile.Create('D:\FOCUS\Ini\config.ini');
  estoque := StrToBool(ArquivoIni.ReadString('PRODUTO','ESTOQUE',''));
  ArquivoIni.Free;
  if estoque = False then
  begin
    with dbGrid1 do
    begin
      Columns[3].Visible := False;
      Columns[1].Width := 328;
    end;
  end;
  if edProduto.CanFocus then
    edProduto.SetFocus;
end;

procedure TTProduto.qProdutoAfterOpen(DataSet: TDataSet);
begin
  lbTotal.Caption := IntToStr(qProduto.RecordCount);
  if dbGrid1.CanFocus then
    dbGrid1.SetFocus;
end;

procedure TTProduto.edProdutoKeyPress(Sender: TObject; var Key: Char);
  var s1: string;
      itam: integer;
  function GetCondicao: string;
  begin
    if edProduto.Tag = 0 then
    begin
      edProduto.Tag := 1;
      Result := ' WHERE '
    end
    else
      Result := ' AND '
  end;
begin
  edProduto.Tag := 0;
  itam := Length(edProduto.Text);
  if Length(LimpaCaracter(edProduto.Text)) = 0 then
    edProduto.EditMask := '';
  if edProduto.Text = '*' then
  begin
    if (not(Key in[#13,#8,#16])) then
      Key := #0;
  end
  else
  if ColunaPesquisa = 'DATA_VALIDADE' then
  begin
    if Key = '*'  then
     edProduto.MaxLength := 1;
    if (not(Key in[#13,#42,#8])) then
      edProduto.EditMask := '!99/99/9999;1;_';
  end
  else
  if ColunaPesquisa = 'COD_PROD' then
  begin
    edProduto.MaxLength := 9;
    if (not(key in[#13,#42,#8,#48..#57])) then
      key := #0
    else
    if edProduto.Text <> '' then
      if not (key in[#13,#8,#48..#57]) then
        key := #0
  end
  else
  if ColunaPesquisa = 'DESCRICAO_PROD' then
  begin
    edProduto.MaxLength := 100;
    if (not(key in[#13,#42,#8,'a'..'z','A'..'Z'])) then
      key := #0
    else
    if edProduto.Text <> '' then
      if not (key in[#13,#8,'a'..'z','A'..'Z']) then
        key := #0
  end
  else
  if ColunaPesquisa = 'PRECO_PROD' then
  begin
    if edProduto.Text <> '' then
    begin
      edProduto.MaxLength := 8;
      if not (key in[#13,#8,#48..#57,#44]) then
        key := #0;
      if pos(',',edProduto.Text) > 0 then
      begin
        if not (Key in[#13,#8,#48..#57]) then
        begin
          key := #0;
        end;
        if itam >= 2 then
        begin
          s1:= edProduto.Text[itam];
          if (key = #13) and (s1 = #44) then
            edproduto.Clear;
        end;
      end;
    end
    else
    if not (key in[#13,#8,#48..#57,#42]) then
      key := #0;
  end
  else
  if ColunaPesquisa = 'ESTOQUE_PROD' then
  begin
    edProduto.MaxLength := 8;
    if (not(key in[#13,#42,#8,#48..#57])) then
        key := #0
    else
    if edProduto.Text <> '' then
      if not (key in[#13,#8,#48..#57]) then
        key := #0
  end;
  if (Key = #13) and not (Empty(Alltrim(edProduto.Text))) then
  begin
    if (ColunaPesquisa = 'DATA_VALIDADE') and (edProduto.Text <> '*') then
    begin
      if not validarData(edProduto.Text) then
      begin
        enviaMensagem('Data inválida!','Informação...',mtConfirmation,[mbOK]);
        Exit;
      end;
    end;
    with qProduto do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SET DATEFORMAT DMY');
      SQL.Add('SELECT COD_PROD,DESCRICAO_PROD,PRECO_PROD,');
      SQL.Add('CONVERT(varchar(10),DATA_VALIDADE,103)AS DATA_VALIDADE,');
      SQL.Add('ESTOQUE_PROD,');
      SQL.Add('ATIVO');
      SQL.Add('FROM PRODUTO');
      if edProduto.Text <> '*' then
      begin
        if UpperCase(ColunaPesquisa) = 'COD_PROD' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + edProduto.Text)
        else
        if UpperCase(ColunaPesquisa) = 'DESCRICAO_PROD' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' LIKE ' + QuotedStr('%' + edProduto.Text + '%'))
        else
        if UpperCase(ColunaPesquisa) = 'PRECO_PROD' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + QuotedStr(virgulaPorPonto(edProduto.Text)))
        else
        if UpperCase(ColunaPesquisa) = 'DATA_VALIDADE' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + QuotedStr(edProduto.Text))
        else
        if UpperCase(ColunaPesquisa) = 'ESTOQUE_PROD' then
          SQL.Add(GetCondicao + ColunaPesquisa + ' = ' + edProduto.Text)
      end;
      case rgProduto.ItemIndex of
        0:
          SQL.Add(GetCondicao + ' ATIVO = 1 ');
        1:
          SQL.Add(GetCondicao + ' ATIVO = 0 ');
      end;
      SQL.Add('ORDER BY ' + colunaPesquisa);

      SQL.Add('UPDATE PRODUTO');
      SQL.Add('SET ATIVO = 0');
      SQL.Add('WHERE DATA_VALIDADE <= '+ QuotedStr(DateToStr(Today)));


      Open;
      qProduto.FieldByName('ATIVO').OnGetText := QPRODUTOATIVOGetText;
      qProduto.FieldByName('PRECO_PROD').OnGetText := qProdutoPRECO_PRODGetText;
      if dbGrid1.CanFocus then
        dbGrid1.SetFocus;
      if IsEmpty then
      begin
        enviaMensagem('Nenhum registro encontrado','Informação...',mtConfirmation,[mbOK]);
        if edProduto.CanFocus then
          edProduto.SetFocus;
        Exit;
      end;
    end;
  end;
end;

procedure TTProduto.QPRODUTOATIVOGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if not qProduto.IsEmpty then
  begin
    if qProduto.FieldByName('ATIVO').AsBoolean then
      Text := 'ATIVO'
    else
      Text := 'INATIVO';
  end
  else
    Text := '';
end;


procedure TTProduto.qProdutoPRECO_PRODGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if qProduto.IsEmpty then
    Text := ''
  else
    Text := 'R$' + FormatFloat('0.00',qProduto.FieldByName('PRECO_PROD').AsFloat);
end;

procedure TTProduto.rgProdutoClick(Sender: TObject);
begin
  case rgProduto.ItemIndex of
    0:
      btnLimpar.Click;
    1:
      btnLimpar.Click;
    2:
      btnLimpar.Click;
  end;
end;

function TTProduto.TransfereProduto: string;
begin
  TProduto := TTProduto.Create(Application);
  with TProduto do
  begin
    btnTransferir.Visible := True;
    btnInserir.Visible := False;
    btnEditar.Visible := False;
    btnExcluir.Visible := False;
    rgProduto.Visible := False;
    ShowModal;
    if InfoProduto <> '' then
    begin
      Result := InfoProduto;
    end
    else
      Result := '0';
    FreeAndNil(TProduto);
  end;
end;

end.

