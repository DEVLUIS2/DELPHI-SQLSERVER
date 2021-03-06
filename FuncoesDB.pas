unit FuncoesDB;

interface

uses SysUtils, ADODB, DB, Forms, Dialogs, Variants;

function dateTextSql(xData:TDateTime; xTipoHora:char = 'N'):String ;

function dataSQLT(Data: TDateTime): String;

function dataSQL(Data: TDateTime): String;

function ValidaRegistros(Tabela,Campo,Dado:string):Boolean;

function temReferencia(Tabela, Valor_PK, xBanco: String; TabsIgnorar: String = ''): String;

function executaSQL(LinhaSQL: String): Boolean;

Function stringTextSql(xTexto: Variant): String;

function emptyTable(LinhaSQL: String): Boolean;

function DataBetweenSQL(DataIni, DataFin: TDateTime): String;

function DataBetweenSQL_T(DataIni, DataFin: TDateTime): String;

function GetCodigoIdentity(NomeTabela :string):integer;

function GetCodigoIdentity2(const Banco: String; TabelaNome:String = '' ): Integer;

Function IntegerTextSql( xValor:Variant ):String ;


implementation

uses DMPrincipal, funcoes,  Principal;

function dateTextSql(xData: TDateTime; xTipoHora:Char = 'N'):String;
begin
  if xData = 0 then
    result:= 'NULL'
  else
  if xTipoHora = 'T' then
    result:= DataSQLT(xData)
  else
    result:= DataSQL(xData);
end;

function dataSQLT(Data:TDateTime): String;
begin
  Result:= QuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss', Data));
end;

function DataSQL(Data: TDateTime): String;
begin
  Result := QuotedStr(FormatDateTime('yyyy-mm-dd', Data) + ' 00:00:00');
end;

function DataBetweenSQL(DataIni, DataFin: TDateTime): String;
begin
  Result := ' BETWEEN ' + DataSQL(DataIni) + ' AND ' + DataSQL(DataFin);
end;

function DataBetweenSQL_T(DataIni, DataFin: TDateTime): String;
begin
  Result := ' BETWEEN ' + DataSQLT(DataIni) + ' AND ' + DataSQLT(DataFin);
end;

function ValidaRegistros(Tabela,Campo,Dado:string):Boolean;
  var
    AdoQueryAux: TADOQuery;
begin
  AdoQueryAux := TADOQuery.Create(Application);
  try
    with AdoQueryAux do
    begin
      CommandTimeout := 0;
      Connection := TDMPrincipal.Connection;
      Close;
      SQL.Clear;
      SQL.Add('SELECT '+Campo+' FROM '+Tabela+'');
      Open;
      if not IsEmpty then
      begin
        if Locate(''+Campo+'',Dado,[]) then
          Result := True
        else
          Result := False;
      end;
    end;
  finally
  end;
end;

function GetCodigoIdentity(NomeTabela :string):integer;
  var
    AdoQueryAux:TADOQuery;
begin
    AdoQueryAux := TADOQuery.Create(Application);
    try
      with AdoQueryAux do
      begin
        CommandTimeout := 0;
        Connection := TDMPrincipal.Connection;
        Close;
        SQL.Clear;
        SQL.Add('SELECT IDENT_CURRENT('+QuotedStr(NomeTabela)+')');
        Open;
        if IsEmpty then
          Result := 0
        else
          Result := Fields[0].AsInteger;
      end;
    finally
    end;
end;

function TemReferencia(Tabela, Valor_PK, xBanco: String; TabsIgnorar: String = ''): String;
var ADOQueryAux :  TAdoQuery;
    Reconectou, OcorreuErro: Boolean;
    Aux, ClassErro, MsgErro: String;
    Label InicioPesquisa;
begin
  ADOQueryAux := TADOQuery.Create(Application);
  try
  try
    with ADOQueryAux do
    begin
      CommandTimeout := 0;
      Connection := TDMPrincipal.CONNECTION;
      ExecutaSQL('USE ' + xBanco);
      InicioPesquisa:
      Reconectou := False;
      OcorreuErro := False;
      ClassErro := '';
      MsgErro := '';
      try
      try
        Close;
        SQL.Clear;
        SQL.Add('SELECT COLUNA.NAME AS COLUNA, OBJECT_NAME(FK.PARENT_OBJECT_ID) AS TABELA ');
        SQL.Add('FROM SYS.FOREIGN_KEYS AS FK INNER JOIN SYS.FOREIGN_KEY_COLUMNS AS COLUNAFK ');
        SQL.Add('ON COLUNAFK.CONSTRAINT_OBJECT_ID = FK.OBJECT_ID ');
        SQL.Add('INNER JOIN SYS.COLUMNS AS COLUNA ON COLUNAFK.PARENT_COLUMN_ID = COLUNA.COLUMN_ID ');
        SQL.Add('AND COLUNAFK.PARENT_OBJECT_ID = COLUNA.OBJECT_ID ');
        SQL.Add('WHERE OBJECT_NAME(FK.REFERENCED_OBJECT_ID) = ' + StringTextSql(Tabela));
        if not Empty(TabsIgnorar) then
          SQL.Add('AND OBJECT_NAME(FK.PARENT_OBJECT_ID) NOT IN ' + TabsIgnorar);
        SQL.Add('ORDER BY TABELA ');
        Open;
      except
         on E: Exception do
        begin
          OcorreuErro := True;
          ClassErro := E.ClassName;
          MsgErro := E.Message;
        end;
      End;
      finally
        if OcorreuErro then
        begin
          if (MsgErro = 'Falha de conex?o') or
               (MsgErro = '[DBNETLIB][ConnectionWrite (send()).]Erro geral de rede. Verifique a documenta??o da rede')
               or (MsgErro = '[DBNETLIB][ConnectionWrite (WrapperWrite()).]Erro geral de rede. Verifique a documenta??o da rede')
               or (MsgErro = 'Database 8 cannot be autostarted during server shutdown or startup') then
          begin
//             if TestaConexaoSistema(TDMPrincipal.ADOConexao) then
//                Reconectou := True;
          end
          else
          begin
            EnviaMensagem('Ocorreu um erro ao Verificar as Referencias do Banco!' + #13 +
                          'Classe do erro: ' + ClassErro + ';' + #13 +
                          'Mensagem do erro: ' + MsgErro + '.', 'Aviso...', mtWarning, [mbOK]);
          end;
        end;
      end;
      if Reconectou then
         goto InicioPesquisa;
      Aux := '';
      if not IsEmpty then
      begin
        First;
        while not Eof do
        begin
          if not EmptyTable('SELECT ' + FieldByName('COLUNA').AsString + ' FROM ' + FieldByName('TABELA').AsString +
                 ' WHERE ' + FieldByName('COLUNA').AsString + ' = ' + StringTextSql(Valor_PK)) then
          begin
            Aux := FieldByName('TABELA').AsString;
            Break;
          end;
          Next;
        end;
      end;
      Close;
    end;
  except
    Aux := '';
  end;
  finally
    FreeAndNil(ADOQueryAux);
    ExecutaSQL('USE ESTAGIARIO_LUIS');
  end;
  Result := Aux;
end;

function executaSQL(LinhaSQL: String): Boolean;
var
  ADOQueryAux: TADOQuery;
begin
  ADOQueryAux:= TADOQuery.Create(Application);
  ADOQueryAux.CommandTimeout:= 0;
  ADOQueryAux.Connection:= TDMPrincipal.Connection;

  with ADOQueryAux do
  begin
    ADOQueryAux.Tag:= 0;
    Close;
    SQL.Clear;
    SQL.Add(LinhaSQL);
    try
      ExecSQL;
    except
      ADOQueryAux.Tag:= 1;
    end;
    result:= (ADOQueryAux.Tag = 0);
    free;
  end;
end;

function stringTextSql(xTexto: Variant): String;
begin
  if (xTexto = '') or (xTexto = null) then
    result:= 'NULL'
  else
    result:= QuotedStr(xTexto);
end;

function emptyTable(LinhaSQL: String): boolean;
var
  ADOQueryAux: TADOQuery;
  Reconectou, OcorreuErro: Boolean;
  ClassErro, MsgErro: string;
  label InicioPesquisa;

begin
  ADOQueryAux:= TADOQuery.Create(Application);
  ADOQueryAux.CommandTimeout:= 0;
  ADOQueryAux.Connection:= TDMPrincipal.CONNECTION;

  with ADOQueryAux do
  begin
    InicioPesquisa:
    Reconectou:= False;
    OcorreuErro:= False;
    ClassErro:= '';
    MsgErro:= '';
    try
    try
      Close;
      SQL.Clear;
      SQL.Add(LinhaSQL);
      Open;
    except
      on E: Exception do
      begin
       OcorreuErro:= True;
       ClassErro:= E.ClassName;
       MsgErro:= E.Message;
      end;
    end;
    finally
      if  OcorreuErro then
      begin
        if (MsgErro = 'Falha na conex?o') or
           (MsgErro = 'DBNETLIB][ConnectionWrite (send()).]Erro geral de Rede. Verifique a documenta??o da Rede')
           or (MsgErro = '[DBNETLIB][ConnectionWrite (WrapperWrite()).]Erro geral de rede. Verifique a documenta??o da Rede')
           or (MsgErro = 'Database 8 cannot be autostarted during server shutdown or startup') then
           begin
            /// if TestaConexaoSistema(TDMPrincipal.ADOConexao) then
            /// Reconectou := True;

           end
        else
        begin
          enviaMensagem('Ocorreu um erro ao carrear informa??oes do banco' + #13 +
                        'Classe do erro' + ClassErro + ';' + #13 +
                        ' Mensagem do erro: ' + MsgErro + '.', 'Abiso...', mtWarning, [mbOK])
        end;
      end;
    end;
    if Reconectou then
      goto InicioPesquisa;

      Result:= IsEmpty;
      Close;
      FreeAndNil(ADOQueryAux);
  end;
end;
function GetCodigoIdentity2(const Banco: String ; TabelaNome:String ): Integer;
var
  ADOQueryAux : TADOQuery;
  BancoDefault: String;
begin
 ADOQueryAux := TADOQuery.Create(Application);
  ADOQueryAux.Connection := TDMPrincipal.Connection;
  BancoDefault := TDMPrincipal.Connection.DefaultDatabase;
  with ADOQueryAux do
  begin
    SQL.Add('SELECT @@Identity as CODIGO');
    //
    Open;
    //
    if (ADOQueryAux.FieldByName('CODIGO').AsVariant <> null) then
      Result := ADOQueryAux.FieldByName('CODIGO').AsInteger
    else
      Result := 0;
    //
    Close;
  end;
  FreeAndNil(ADOQueryAux);
end;
Function IntegerTextSql( xValor:Variant ):String ;
Begin
  if ( xValor = null ) then
     Result := 'NULL'
  Else
  Begin
    Result := StringTextSql( IntToStr(xValor)  ) ;
  End;
End;

end.
