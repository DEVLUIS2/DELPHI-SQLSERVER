unit Funcoes;

interface

uses SysUtils, Dialogs, StdCtrls, Controls, Forms;

function Alltrim(pvalue:string):string;

function Empty( Dados: string): boolean;

function enviaMensagem(Mensagem, tipo: string; DlgType:TMsgDlgType; DlgButtonsType: TMsgDlgButtons): TModalResult;

function desagrupaString(Texto: string; Posicao: integer; Separador: Char): String;

function somenteNumero(Key: char): char;

function LimpaCaracter(Dados: String): String;

function somenteNumero2(Key: char): char;

function somenteLetra(Key: char): char;

function somenteLetraeNumero(Key: char): char;

function retiraAcentoChar(Dados: char): Char;

function transformaMaiuscula(key:char): char;

function mascaraReal(conteudo: Extended): string;

function virgulaPorPonto(Dados: string): string;

function diaDoMes(AYear, AMonth: Integer): Integer;

function bissexto(AYear: integer): boolean;

function validarData(Data: String): Boolean;

implementation

function Empty(Dados: string): boolean;
begin
  if Length(Trim( Dados ) ) = 0 then
    Empty := True
  else
    Empty := False;
end;

function enviaMensagem(Mensagem, tipo: string; DlgType:TMsgDlgType; DlgButtonsType: TMsgDlgButtons): TModalResult;
  var
    i: Integer;
begin
  with CreateMessageDialog(Mensagem, DlgType, DlgButtonsType) do
    try
      for I := 0 to ComponentCount - 1 do
        if Components[i] is TButton then
      begin
        with TButton(Components[i]) do
        case ModalResult of
          mrOk: Caption:= 'Ok';
          mrCancel: Caption:= 'Cancelar';
          mrAbort: Caption  :=  'Abortar';
          mrRetry:  Caption := 'Repetir';
          mrIgnore: Caption := 'Ignorar';
          mrYes:  Caption := 'Sim';
          mrNo: Caption := 'N?o';
        end;
      end;
      Caption:= tipo;
      Result:= ShowModal;
    finally
      Free;
    end;
end;

function desagrupaString(Texto: string; Posicao: integer; Separador: Char): String;
  var i, x: Integer;
      AuxR: string;
begin
  x := 0 ;
  AuxR := '';

  if (Texto <> '') and (Posicao > -1) then
  begin
   for I := 1 to Length(Texto) do
   begin
    Application.ProcessMessages;
    if Texto[i] = Separador then
      Inc(x)
    else
      if x = Posicao then
        AuxR := AuxR + Texto[i];
      if (x > Posicao) then
        Break;
   end;
  end;
  Result:= AuxR;
end;

function somenteNumero(key: Char): Char;
begin
 if (not(key in [#8, #13,#42,#48..#57])) or (key = '.') then
  Key := #0;
  result:= Key;

end;

function somenteNumero2(key: Char): Char;
begin
  if(not (key in [#13, #8, #44, #42, #48..#57]))or (Key = '.') then
    key:= #0;
    result:= Key;
end;

function somenteLetra(key: char): char;
begin
  if (not(Key in [#13,#32,#8,#42,'A'..'Z', 'a'..'z'])) or (Key = '.') then
    key:= #0;
    result:= Key;
end;

function somenteLetraeNumero(key: char): char;
begin
  if (not(Key in [#32,#13,#8,#42,#46,#44,'a'..'z','A'..'Z', #48..#57]))  or (Key = '.') then
    key:= #0;
  result:= Key;
end;

function retiraAcentoChar(Dados: char): Char;
const
  ComAcento: String = '????????????????????????????????????????';
  SemAcento: String = 'CEAEIOUaeiouAOaoAEIOUaeiouCcAEIOUaeiouUu';
var
  y: Integer;
begin
  y:= Pos(Dados, ComAcento);
  if y > 0 then
    Dados:= SemAcento[y];
    result:= Dados;
end;

function transformaMaiuscula(key: char): char;
begin
  key:= UpCase(Key);
  result:= key;
end;

function mascaraReal(conteudo: Extended): string;
 var
  TamMascara: Integer;
  Brancos: String;
  Dados: string;
  Mascara: string;
begin
  Mascara:= '###,###,###,##0.00';
  TamMascara:= Length(Mascara);
  Dados:= FormatFloat(Mascara, Conteudo);
  MascaraReal:= Trim(dados);
end;

function virgulaPorPonto(Dados: string): string;
  var aux1, I: Integer;
begin
  aux1:= Length(Dados);
  for I := 0 to (aux1 - 1) do
    if (Dados[I] in ['1','2','3','4','5','6','7','8','9','-',',','.']) then
    begin
      if Dados[I] = ',' then
        Dados[I] := '.';
      if Dados[I] = '-' then
        Dados[I] := '/';
    end;
  Result := Dados;
end;

function validarData(Data: String): Boolean;
var
  I, Y, UltDiaAux, DiaAux, MesAux: Integer;
  Teste: Boolean;
  sDia, sMes, sAno, sMesAno: string;
  begin
   Teste:= True;
   I := Length(Data);

    for Y := 1 to I do
      if not(Data[Y] in ['0','1','2','3','4','5','6','7','8','9','/']) then
        teste:= False;

      if teste = True then
      begin
    if (Length(Data) = 8) then
    begin

      sDia := Copy(Data, 1, 2);
      sMes := Copy(Data, 4, 2);
      sAno := Copy(Data, 7, 2);
      SMesAno := Copy(Data, 4, 5);
    end
    else
    begin
      if (Length(Data) = 10) then
      begin
        sDia := Copy(Data, 1, 2);
        sMes := Copy(Data, 4, 2);
        sAno := Copy(Data, 7, 4);
        SMesAno := Copy(Data,4, 7);
      end
      else
        Teste := False;
    end;
  end;

  if Teste = true then
  begin
    MesAux:= StrToInt(sMes);
    if (MesAux<= 12) and (MesAux > 0) then
    begin
      UltDiaAux:= DiaDoMes(StrToInt(sAno), StrToInt(sMes));
      DiaAux:= StrToInt(sDia);
      if (DiaAux > UltDiaAux) or (DiaAux < 1) then
        Teste:= False;
    end
    else
      Teste:= False;
  end;

  validarData:= Teste;
  end;

function diaDoMes(AYear, AMonth: Integer): Integer;
const
  DaysInMonth: array[1..12] of integer=(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  result:= DaysInMonth[AMonth];
  if (AMonth = 2) and bissexto(AYear) then
    Inc(Result);
end;

function bissexto(AYear: Integer): Boolean;
begin
  result:= (AYear mod 4 = 0) and ((AYear mod 100<>0) or (AYear mod 400 = 0));
end;

function alltrim(pvalue:string):string;
var
  i: Integer;
  Frase: string;
begin
  Frase := '';
  pvalue := Trim(pvalue);
  for i:= 1 to Length(pvalue) do
  begin
    if Copy(pvalue , i , 1) <> ' ' then
      Frase := Frase + Copy(pvalue, i ,1);
    Application.ProcessMessages;
  end;
   Result := Frase
end;

function LimpaCaracter(Dados: String): String;
var Linha: String;
    Tam, i : Integer;
begin
  Linha:= '';
  Tam := Length(Dados);
  for i := 1 to Tam do
    if (Dados[I] in ['0','1','2','3','4','5','6','7','8','9'])then
      Linha := Linha + Dados[i];
  Result := Linha;
end;

end.
