unit RelFornecedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, jpeg, DB, ADODB, DateUtils, ExtCtrls;

type
  TTRelFornecedores = class(TForm)
    RLReport1: TRLReport;
    qFornecedores: TADOQuery;
    dsFornecedores: TDataSource;
    RLBand1: TRLBand;
    RLBand4: TRLBand;
    RLPanel11: TRLPanel;
    RLLabel7: TRLLabel;
    RLBand10: TRLBand;
    RLPanel36: TRLPanel;
    RLPanel37: TRLPanel;
    RLLabel18: TRLLabel;
    RLLabel19: TRLLabel;
    RLBand11: TRLBand;
    RLPanel38: TRLPanel;
    RLPanel39: TRLPanel;
    RLPanel41: TRLPanel;
    RLDBText13: TRLDBText;
    RLDBText11: TRLDBText;
    RLReport2: TRLReport;
    RLBand12: TRLBand;
    RLBand13: TRLBand;
    RLPanel44: TRLPanel;
    RLLabel23: TRLLabel;
    RLBand6: TRLBand;
    RLPanel26: TRLPanel;
    RLPanel27: TRLPanel;
    RLLabel14: TRLLabel;
    RLPanel28: TRLPanel;
    RLLabel15: TRLLabel;
    RLPanel29: TRLPanel;
    RLLabel16: TRLLabel;
    RLGroup1: TRLGroup;
    RLBand8: TRLBand;
    RLPanel21: TRLPanel;
    RLPanel5: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel7: TRLPanel;
    RLLabel6: TRLLabel;
    RLPanel6: TRLPanel;
    RLLabel5: TRLLabel;
    RLPanel22: TRLPanel;
    RLPanel8: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel9: TRLPanel;
    RLPanel10: TRLPanel;
    RLDBText3: TRLDBText;
    RLPanel23: TRLPanel;
    RLPanel14: TRLPanel;
    RLLabel9: TRLLabel;
    RLPanel16: TRLPanel;
    RLLabel10: TRLLabel;
    RLPanel1: TRLPanel;
    RLLabel11: TRLLabel;
    RLPanel15: TRLPanel;
    RLLabel12: TRLLabel;
    RLBand7: TRLBand;
    RLPanel17: TRLPanel;
    RLDBText4: TRLDBText;
    RLPanel18: TRLPanel;
    RLPanel19: TRLPanel;
    RLDBText6: TRLDBText;
    RLPanel20: TRLPanel;
    RLDBText7: TRLDBText;
    RLBand5: TRLBand;
    RLPanel12: TRLPanel;
    RLLabel8: TRLLabel;
    RLPanel13: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLBand9: TRLBand;
    RLPanel30: TRLPanel;
    RLPanel31: TRLPanel;
    RLDBText8: TRLDBText;
    RLPanel32: TRLPanel;
    RLPanel33: TRLPanel;
    RLDBText10: TRLDBText;
    RLBand3: TRLBand;
    RLPanel34: TRLPanel;
    RLLabel17: TRLLabel;
    RLPanel35: TRLPanel;
    RLDBResult3: TRLDBResult;
    RLBand2: TRLBand;
    RLPanel24: TRLPanel;
    RLLabel13: TRLLabel;
    RLPanel25: TRLPanel;
    RLDBResult2: TRLDBResult;
    RLPanel45: TRLPanel;
    RLPanel43: TRLPanel;
    RLLabel22: TRLLabel;
    RLPanel42: TRLPanel;
    RLLabel21: TRLLabel;
    RLPanel40: TRLPanel;
    RLLabel20: TRLLabel;
    RLPanel46: TRLPanel;
    Image1: TImage;
    RLPanel47: TRLPanel;
    RLPanel4: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel48: TRLPanel;
    Image2: TImage;
    RLDBMemo1: TRLDBMemo;
    RLDBMemo2: TRLDBMemo;
    RLDBMemo3: TRLDBMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure qFornecedoresPRECO_PRODGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    { Private declarations }
    OrdenaStatus,OrdenaCampo,OrdenaProduto,RecebeChamada,RecebeRelatorio: Integer;
    procedure DadosRelatorio;
    procedure BlockRelatorio;
    procedure RelatorioAnalitico;
    procedure RelatorioSintetico;
  public
    { Public declarations }
    procedure ChamaTela(Status,Ordenar,Produto,Tchamada,Trelatorio:Integer);

  end;

var
  TRelFornecedores: TTRelFornecedores;

implementation

uses
  DMPRINCIPAL, Funcoes;

{$R *.dfm}

{ TTRelFornecedores }

procedure TTRelFornecedores.BlockRelatorio;
begin
  case RecebeChamada of
    1:
    begin
      RLBand6.Visible := False;
      RLBand2.Visible := False;
      RLBand9.Visible := False;
      RLBand11.Visible := False;
      RLBand10.Visible := False;
    end;
    2:
    begin
      case RecebeRelatorio  of
        0:
        begin
          RLBand11.Visible := False;
          RLBand10.Visible := False;
          RLGroup1.Visible := False;
          RLBand3.Visible := False;
        end;
        1:
        begin
          RLBand6.Visible := False;
          RLBand2.Visible := False;
          RLBand9.Visible := False;
          RLGroup1.Visible := False;
          RLBand3.Visible := False;
        end;
      end;
    end;
  end;
end;

procedure TTRelFornecedores.ChamaTela(Status,Ordenar,Produto,Tchamada,Trelatorio:Integer);
begin
  TRelFornecedores := TTRelFornecedores.Create(Application);
  with TRelFornecedores do
  begin
    OrdenaStatus := Status;
    OrdenaCampo := Ordenar;
    OrdenaProduto := Produto;
    RecebeChamada := Tchamada;
    RecebeRelatorio := Trelatorio;
    BlockRelatorio;

    case Tchamada  of
      1:
        DadosRelatorio;
      2:
      begin
        if Trelatorio = 0 then
          RelatorioAnalitico;
        if Trelatorio = 1 then
          RelatorioSintetico;
      end;
    end;

    if qFornecedores.IsEmpty then
    begin
      enviaMensagem('N?o existe informa??o referente a pesquisa efetuada!','Informa??o...',mtConfirmation,[mbOK]);
    end
    else
    if Tchamada = 1 then
      RLReport2.PreviewModal
    else
      RLReport1.PreviewModal;
    FreeAndNil(TRelFornecedores);
  end;
end;

procedure TTRelFornecedores.DadosRelatorio;
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
  with qFornecedores do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT F.COD_FORNECEDOR,F.NOME_FORNECEDOR,F.CNPJ_FORNECEDOR,');
    SQL.Add('CONVERT(VARCHAR(10),P.DATA_VALIDADE,103)AS DATA_VALIDADE,P.COD_PROD,P.DESCRICAO_PROD,P.PRECO_PROD');
    SQL.Add('FROM FORNECEDORES F ');
    SQL.Add('INNER JOIN PRODUTO P ON P.COD_FORNECEDOR = F.COD_FORNECEDOR');
    if OrdenaProduto  > 0 then
      SQL.Add(RepeteSQL + ' P.COD_PROD = '+ IntToStr(OrdenaProduto));
    case OrdenaStatus of
      0:
      begin
        RLLabel2.Caption := 'Relat?rio de Todos os Fornecedores';
      end;
      1:
      begin
        SQL.Add(RepeteSQL + ' F.ATIVO = 1');
        RLLabel2.Caption := 'Relat?rio de Fornecedores Ativos';
      end;
      2:
      begin
        SQL.Add(RepeteSQL + ' F.ATIVO = 0');
        RLLabel2.Caption := 'Relat?rio de Fornecedores Inativos';
      end;
    end;
    case OrdenaCampo of
      0:
      begin
        SQL.Add('ORDER BY F.COD_FORNECEDOR ASC');
        RLLabel3.Caption := 'Ordenado pelo C?digo';
      end;
      1:
      begin
        SQL.Add('ORDER BY F.NOME_FORNECEDOR ASC');
        RLLabel3.Caption := 'Ordenado pelo Nome';
      end;
      2:
      begin
        SQL.Add('ORDER BY F.CNPJ_FORNECEDOR ASC');
        RLLabel3.Caption := 'Ordenar pelo CNPJ';
      end;
    end;
    RLLabel23.Caption := ' Focus Desenvolvimento de Sistemas - Gerado em '+ FormatDateTime('dd/mm/yyyy hh:MM:ss',Now)+' .';
    Open;
    qFornecedores.FieldByName('PRECO_PROD').OnGetText :=qFornecedoresPRECO_PRODGetText;
  end;
end;

procedure TTRelFornecedores.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      Close;
  end;
end;

procedure TTRelFornecedores.qFornecedoresPRECO_PRODGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := 'R$' + FormatFloat('0.00',qFornecedores.FieldByName('PRECO_PROD').AsFloat);
end;

procedure TTRelFornecedores.RelatorioAnalitico;
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
  with qFornecedores do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_FORNECEDOR,NOME_FORNECEDOR,CNPJ_FORNECEDOR');
    SQL.Add('FROM FORNECEDORES');
    case OrdenaStatus of
      0:
      begin
        RLLabel2.Caption := 'Relat?rio de Todos os Fornecedores';
      end;
      1:
      begin
        SQL.Add(RepeteSQL+ ' ATIVO = 1');
        RLLabel2.Caption := 'Relat?rio de Fornecedores Ativos';
      end;
      2:
      begin
        SQL.Add(RepeteSQL+' ATIVO = 0');
        RLLabel2.Caption := 'Relat?rio de Fornecedores Inativos';
      end;
    end;
    if OrdenaProduto  > 0 then
      SQL.Add(RepeteSQL +' COD_FORNECEDOR = '+ IntToStr(OrdenaProduto));
    case OrdenaCampo of
      0:
      begin
        SQL.Add('ORDER BY COD_FORNECEDOR ASC');
        RLLabel3.Caption := 'Ordenado pelo C?digo';
      end;
      1:
      begin
        SQL.Add('ORDER BY NOME_FORNECEDOR ASC');
        RLLabel3.Caption := 'Ordenado pelo Nome';
      end;
      2:
      begin
        SQL.Add('ORDER BY CNPJ_FORNECEDOR ASC');
        RLLabel3.Caption := 'Ordenar pelo CNPJ';
      end;
    end;
    RLLabel7.Caption := ' Focus Desenvolvimento de Sistemas - Gerado em '+ FormatDateTime('dd/mm/yyyy hh:MM:ss',Now)+' .';
    Open;
  end;
end;

procedure TTRelFornecedores.RelatorioSintetico;
begin
  with qfornecedores do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT '+QuotedStr('ATIVO')+'AS STATUS, COUNT(COD_FORNECEDOR)AS COD_FORNECEDOR');
    SQL.Add('FROM FORNECEDORES');
    SQL.Add('WHERE ATIVO = 1');
    SQL.Add('UNION ALL');
    SQL.Add('SELECT '+QuotedStr('INATIVO')+'AS STATUS,COUNT(COD_FORNECEDOR)AS COD_FORNECEDOR');
    SQL.Add('FROM FORNECEDORES');
    SQL.Add('WHERE ATIVO = 0');
    RLLabel7.Caption := ' Focus Desenvolvimento de Sistemas - Gerado em '+ FormatDateTime('dd/mm/yyyy hh:MM:ss',Now)+' .';
    Open
  end;
end;

end.
