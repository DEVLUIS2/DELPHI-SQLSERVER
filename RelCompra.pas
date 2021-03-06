unit RelCompra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, jpeg, DB, ADODB, DateUtils, ExtCtrls;

type
  TTRelCompra = class(TForm)
    RLReport1: TRLReport;
    qCompra: TADOQuery;
    dsCompra: TDataSource;
    RLBand2: TRLBand;
    RLBand4: TRLBand;
    RLPanel11: TRLPanel;
    RLLabel8: TRLLabel;
    RLGroup1: TRLGroup;
    RLBand3: TRLBand;
    RLBand6: TRLBand;
    RLPanel16: TRLPanel;
    RLPanel18: TRLPanel;
    RLPanel19: TRLPanel;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText7: TRLDBText;
    RLPanel20: TRLPanel;
    RLPanel5: TRLPanel;
    RLLabel6: TRLLabel;
    RLPanel6: TRLPanel;
    RLLabel7: TRLLabel;
    RLPanel7: TRLPanel;
    RLLabel5: TRLLabel;
    RLPanel21: TRLPanel;
    RLPanel10: TRLPanel;
    RLDBText3: TRLDBText;
    RLPanel8: TRLPanel;
    RLDBText2: TRLDBText;
    RLPanel9: TRLPanel;
    RLPanel22: TRLPanel;
    RLPanel12: TRLPanel;
    RLLabel9: TRLLabel;
    RLPanel14: TRLPanel;
    RLLabel12: TRLLabel;
    RLPanel15: TRLPanel;
    RLLabel10: TRLLabel;
    RLDBText1: TRLDBText;
    RLBand1: TRLBand;
    RLPanel25: TRLPanel;
    RLLabel14: TRLLabel;
    RLPanel26: TRLPanel;
    RLDBResult2: TRLDBResult;
    RLBand5: TRLBand;
    RLPanel23: TRLPanel;
    RLLabel13: TRLLabel;
    RLPanel24: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLReport2: TRLReport;
    RLBand8: TRLBand;
    RLBand9: TRLBand;
    RLPanel46: TRLPanel;
    RLLabel25: TRLLabel;
    RLBand14: TRLBand;
    RLPanel64: TRLPanel;
    RLLabel33: TRLLabel;
    RLPanel65: TRLPanel;
    RLDBResult4: TRLDBResult;
    RLGroup4: TRLGroup;
    RLBand15: TRLBand;
    RLPanel66: TRLPanel;
    RLPanel67: TRLPanel;
    RLLabel34: TRLLabel;
    RLPanel68: TRLPanel;
    RLLabel35: TRLLabel;
    RLPanel69: TRLPanel;
    RLLabel36: TRLLabel;
    RLPanel70: TRLPanel;
    RLPanel71: TRLPanel;
    RLDBText20: TRLDBText;
    RLPanel72: TRLPanel;
    RLPanel73: TRLPanel;
    RLDBText22: TRLDBText;
    RLPanel74: TRLPanel;
    RLPanel75: TRLPanel;
    RLLabel37: TRLLabel;
    RLPanel76: TRLPanel;
    RLLabel38: TRLLabel;
    RLPanel77: TRLPanel;
    RLLabel39: TRLLabel;
    RLPanel78: TRLPanel;
    RLLabel40: TRLLabel;
    RLBand16: TRLBand;
    RLPanel79: TRLPanel;
    RLDBText23: TRLDBText;
    RLPanel80: TRLPanel;
    RLPanel81: TRLPanel;
    RLDBText25: TRLDBText;
    RLPanel82: TRLPanel;
    RLDBText26: TRLDBText;
    RLBand7: TRLBand;
    RLPanel13: TRLPanel;
    RLLabel11: TRLLabel;
    RLPanel17: TRLPanel;
    RLDBResult3: TRLDBResult;
    RLPanel27: TRLPanel;
    RLPanel43: TRLPanel;
    RLLabel22: TRLLabel;
    RLPanel41: TRLPanel;
    RLLabel21: TRLLabel;
    RLPanel44: TRLPanel;
    RLLabel23: TRLLabel;
    RLPanel45: TRLPanel;
    RLLabel24: TRLLabel;
    RLPanel28: TRLPanel;
    Image1: TImage;
    RLPanel29: TRLPanel;
    RLPanel3: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel1: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel4: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel30: TRLPanel;
    Image2: TImage;
    RLDBMemo1: TRLDBMemo;
    RLDBMemo2: TRLDBMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure qCompraVALORTOTAL_COMPRAGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    OrdenaCampo,CodCliente,CodProduto: Integer;
    OrdenaLista,OrdenaCliente,OrdenaProduto: TStringList;
    DataInicial,DataFim: TDateTime;
    procedure DadosRelatorio;
    procedure RelatorioModulo2;
  public
    procedure ChamaTela(Cliente,Produto:TStringList ;Ordenar:Integer; Inicial,Fim:TDateTime);
    procedure ChamaModulo2(Lista,ListaCliente: TStringList;Ordenar:Integer; Inicial,Fim:TDateTime);
    { Public declarations }

  end;

var
  TRelCompra: TTRelCompra;

implementation

uses
  DMPRINCIPAL, FuncoesDB, Funcoes;

{$R *.dfm}

{ TTRCompra }

procedure TTRelCompra.ChamaModulo2(Lista,ListaCliente: TStringList;Ordenar: Integer; Inicial, Fim: TDateTime);
begin
  TRelCompra := TTRelCompra.Create(Application);
  with TRelCompra do
  begin
    OrdenaCampo := Ordenar;
    DataInicial := Inicial;
    DataFim := Fim;
    OrdenaCliente := ListaCliente;
    OrdenaLista := Lista;
    RelatorioModulo2;
    if qCompra.IsEmpty then
    begin
      enviaMensagem('N?o existem registros','Informa??o',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      RLReport2.PreviewModal;
    FreeAndNil(TRelCompra);
  end;
end;

procedure TTRelCompra.ChamaTela(Cliente,Produto: TStringList ;Ordenar:Integer; Inicial,Fim:TDateTime);
begin
  TRelCompra := TTRelCompra.Create(Application);
   with TRelCompra do
  begin
    OrdenaCampo := Ordenar;
    DataInicial := Inicial;
    DataFim := Fim;
    OrdenaCliente := Cliente;
    OrdenaProduto := Produto;
    DadosRelatorio;
    if qCompra.IsEmpty then
    begin
      enviaMensagem('N?o existe informa??o referente a pesquisa efetuada!','Informa??o...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      RLReport1.PreviewModal;
    FreeAndNil(TRelCompra);
  end;
end;

procedure TTRelCompra.DadosRelatorio;
  function RepeteSQL:string;
  begin
    if RLReport1.Tag = 0 then
    begin
      RLReport1.Tag := 1;
      Result := ' WHERE ';
    end
    else
      Result := ' AND ';
  end;
begin
  with qCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT CL.COD_CLI,CL.NOME_CLI');
    SQL.Add(',CONVERT(VARCHAR(10),C.DATA_COMPRA,103)AS DATA_COMPRA');
    SQL.Add(',C.QUANTIDADE_COMPRA,CI.QUANTIDADE_ITENS,P.COD_PROD,C.COD_COMPRA,P.DESCRICAO_PROD,P.PRECO_PROD,C.VALORTOTAL_COMPRA');
    SQL.Add('FROM CLIENTE CL');
    SQL.Add('INNER JOIN COMPRA C ON C.COD_CLI = CL.COD_CLI');
    SQL.Add('INNER JOIN COMPRA_ITENS CI ON CI.COD_COMPRA = C.COD_COMPRA');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_PROD = CI.COD_PROD');
    if OrdenaCliente.Count > 0 then
    begin
      if OrdenaCliente.Count = 1 then
        SQL.Add(RepeteSQL +' CL.COD_CLI = ' +OrdenaCliente.DelimitedText)
      else
        SQL.Add(RepeteSQL +' CL.COD_CLI in ('+OrdenaCliente.DelimitedText+')');
    end;
    if OrdenaProduto.Count > 0 then
    begin
      if OrdenaProduto.Count = 1 then
        SQL.Add(RepeteSQL + 'P.COD_PROD = '+OrdenaProduto.DelimitedText)
      else
        SQL.Add(RepeteSQL + 'P.COD_PROD IN ('+OrdenaProduto.DelimitedText+')');
    end;
    SQL.Add(RepeteSQL +'DATA_COMPRA BETWEEN '+dateTextSql(DataInicial) +' AND '+ dateTextSql(DataFim));
    case OrdenaCampo of
      0:
      begin
        SQL.Add('ORDER BY COD_CLI ASC');
        RLLabel3.Caption := 'Ordenado pelo C?digo do Cliente';
      end;
      1:
      begin
        SQL.Add('ORDER BY NOME_CLI ASC');
        RLLabel3.Caption := 'Ordenado pelo Nome do Cliente';
      end;
      2:
      begin
        SQL.Add('ORDER BY DATA_COMPRA');
        RLLabel3.Caption := 'Ordenado pela Data da Compra';
      end;
    end;
    RLLabel4.Caption := 'Per?odo: De ' + DateToStr(DataInicial) + ' At? ' +DateToStr(DataFim);
    RLLabel8.Caption := '  Focus Desenvolvimento de Sistemas - Gerado em '+ FormatDateTime('dd/mm/yyyy hh:MM:ss',Now) +' .';
    Open;
    qCompra.FieldByName('VALORTOTAL_COMPRA').OnGetText :=  qCompraVALORTOTAL_COMPRAGetText;
  end;
end;

procedure TTRelCompra.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      Close;
  end;
end;
procedure TTRelCompra.qCompraVALORTOTAL_COMPRAGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := 'R$' + FormatFloat('0.00.',qCompra.FieldByName('VALORTOTAL_COMPRA').AsFloat);
end;
procedure TTRelCompra.RelatorioModulo2;
  function RepeteSQL:string;
  begin
    if TRelCompra.Tag = 0 then
    begin
      TRelCompra.Tag := 1;
      Result := ' WHERE ';
    end
    else
      Result := ' AND ';
  end;
begin
  with qCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT CL.COD_CLI,CL.NOME_CLI');
    SQL.Add(',CONVERT(VARCHAR(10),C.DATA_COMPRA,103)AS DATA_COMPRA');
    SQL.Add(',C.QUANTIDADE_COMPRA,CI.QUANTIDADE_ITENS,P.COD_PROD,C.COD_COMPRA,P.DESCRICAO_PROD,P.PRECO_PROD,C.VALORTOTAL_COMPRA');
    SQL.Add(',F.COD_FORNECEDOR, F.NOME_FORNECEDOR,CNPJ_FORNECEDOR,CONVERT(VARCHAR(10),P.DATA_VALIDADE,103)AS DATA_VALIDADE');
    SQL.Add('FROM CLIENTE CL');
    SQL.Add('INNER JOIN COMPRA C ON C.COD_CLI = CL.COD_CLI');
    SQL.Add('INNER JOIN COMPRA_ITENS CI ON CI.COD_COMPRA = C.COD_COMPRA');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_PROD = CI.COD_PROD');
    SQL.Add('INNER JOIN FORNECEDORES F ON F.COD_FORNECEDOR = P.COD_FORNECEDOR');
    if OrdenaCliente.Count > 0 then
    begin
      if OrdenaCliente.Count = 1 then
        SQL.Add(RepeteSQL + 'CL.COD_CLI = '+ OrdenaCliente.DelimitedText);
      if OrdenaCliente.Count >= 2 then
        SQL.Add(RepeteSQL + 'CL.COD_CLI IN ('+OrdenaCliente.DelimitedText+')');
    end;
    if OrdenaLista.Count > 0 then
    begin
      if OrdenaLista.Count = 1 then
      begin
        SQL.Add(RepeteSQL + 'F.COD_FORNECEDOR = '+OrdenaLista.DelimitedText);
      end;
      if OrdenaLista.Count >= 2 then
      begin
        SQL.Add(RepeteSQL + 'F.COD_FORNECEDOR IN('+OrdenaLista.DelimitedText+')');
      end;
    end;
    if CodProduto > 0 then
    begin
      SQL.Add(RepeteSQL + 'CI.COD_PROD = ' +IntToStr(CodProduto));
    end;
    SQL.Add(RepeteSQL + 'DATA_COMPRA BETWEEN '+dateTextSql(DataInicial) +' AND '+ dateTextSql(DataFim));
    case OrdenaCampo of
      0:
      begin
        SQL.Add('ORDER BY COD_CLI ASC');
        RLLabel3.Caption := 'Ordenado pelo C?digo do Cliente';
      end;
      1:
      begin
        SQL.Add('ORDER BY NOME_CLI ASC');
        RLLabel3.Caption := 'Ordenado pelo Nome do Cliente';
      end;
      2:
      begin
        SQL.Add('ORDER BY DATA_COMPRA');
        RLLabel3.Caption := 'Ordenado pela Data da Compra';
      end;
    end;
    InputBox('','',SQL.Text);
    Open;
    RLLabel24.Caption := 'Per?odo: De ' + DateToStr(DataInicial) + ' At? ' +DateToStr(DataFim);
    RLLabel25.Caption := '  Focus Desenvolvimento de Sistemas - Gerado em '+ FormatDateTime('dd/mm/yyyy hh:MM:ss',Now) +' .';
    qCompra.FieldByName('VALORTOTAL_COMPRA').OnGetText :=  qCompraVALORTOTAL_COMPRAGetText;
  end;
end;

end.
