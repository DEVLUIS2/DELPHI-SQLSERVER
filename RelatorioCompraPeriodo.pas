unit RelatorioCompraPeriodo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, DB, ADODB, jpeg, ExtCtrls;

type
  TTRelatorioCompraPeriodo = class(TForm)
    rlSintetico: TRLReport;
    RLBand2: TRLBand;
    RLBand1: TRLBand;
    RLBand3: TRLBand;
    RLPanel21: TRLPanel;
    RLPanel10: TRLPanel;
    RLDBText3: TRLDBText;
    qCompra: TADOQuery;
    dsCompra: TDataSource;
    RLBand4: TRLBand;
    RLBand5: TRLBand;
    RLPanel11: TRLPanel;
    RLLabel8: TRLLabel;
    RLPanel13: TRLPanel;
    RLPanel15: TRLPanel;
    RLPanel25: TRLPanel;
    RLLabel14: TRLLabel;
    RLDBResult1: TRLDBResult;
    RLPanel20: TRLPanel;
    RLPanel5: TRLPanel;
    RLPanel7: TRLPanel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    rlAnalitico: TRLReport;
    RLBand6: TRLBand;
    RLBand7: TRLBand;
    RLPanel14: TRLPanel;
    RLDBResult2: TRLDBResult;
    RLPanel16: TRLPanel;
    RLLabel12: TRLLabel;
    RLBand8: TRLBand;
    RLPanel17: TRLPanel;
    RLLabel13: TRLLabel;
    RLBand9: TRLBand;
    RLBand10: TRLBand;
    RLPanel18: TRLPanel;
    RLPanel19: TRLPanel;
    RLPanel24: TRLPanel;
    RLPanel26: TRLPanel;
    RLPanel22: TRLPanel;
    RLPanel23: TRLPanel;
    RLPanel27: TRLPanel;
    RLPanel28: TRLPanel;
    RLLabel15: TRLLabel;
    RLLabel16: TRLLabel;
    RLLabel17: TRLLabel;
    RLLabel18: TRLLabel;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLPanel29: TRLPanel;
    RLPanel9: TRLPanel;
    RLLabel10: TRLLabel;
    RLPanel6: TRLPanel;
    RLLabel7: TRLLabel;
    RLPanel8: TRLPanel;
    RLLabel9: TRLLabel;
    RLPanel12: TRLPanel;
    RLLabel11: TRLLabel;
    RLPanel30: TRLPanel;
    Image1: TImage;
    RLPanel31: TRLPanel;
    RLPanel3: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel1: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel4: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel32: TRLPanel;
    Image2: TImage;
    RLDBMemo1: TRLDBMemo;
    procedure qCompraVALOR_TOTAL_COMPRAGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure qCompraTOTALGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    ReceData,RecebeData2:TDateTime;
    RecebeRelatorio,RecebeOrdem: Integer;
    procedure Relatorio;
    procedure Analitico;
    { Private declarations }
  public
    procedure ChamaTela(DataI,DataF:TDateTime;TipoRelatorio,Ordem:Integer);
    { Public declarations }
  end;

var
  TRelatorioCompraPeriodo: TTRelatorioCompraPeriodo;

implementation

uses
  DMPRINCIPAL, Funcoes, FuncoesDB;

{$R *.dfm}

{ TTRelCompraPeriodo }

procedure TTRelatorioCompraPeriodo.Analitico;
  function RepeteSQL:string;
  begin
    if rlAnalitico.Tag = 0 then
    begin
      rlAnalitico.Tag := 1;
      Result := ' WHERE ';
    end
    else
      Result := ' AND ';
  end;
begin
  rlAnalitico.Tag := 0;
  with qcompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT C.COD_CLI,C.NOME_CLI,');
    SQL.Add('CONVERT(VARCHAR(10),CP.DATA_COMPRA,103)AS DATA_COMPRA,');
    SQL.Add('SUM(CP.VALORTOTAL_COMPRA)AS VALOR_TOTAL_COMPRA');
    SQL.Add('FROM CLIENTE C');
    SQL.Add('INNER JOIN COMPRA CP ON CP.COD_CLI = C.COD_CLI');
    SQL.Add('WHERE DATA_COMPRA BETWEEN '+dateTextSql(ReceData)+' AND '+dateTextSql(RecebeData2)+'');
    SQL.Add('GROUP BY C.COD_CLI,C.NOME_CLI,DATA_COMPRA');
    case RecebeOrdem  of
      0:
      begin
        SQL.Add('ORDER BY C.COD_CLI ASC');
        RLLabel9.Caption := 'Ordenado por c?digo';
      end;
      1:
      begin
        SQL.Add('ORDER BY C.NOME_CLI ASC');
        RLLabel9.Caption := 'Ordenado por nome';
      end;
      2:
      begin
        SQL.Add('ORDER BY DATA_COMPRA');
        RLLabel9.Caption := 'Ordenado por data da compra';
      end;
      3:
      begin
        SQL.Add('ORDER BY VALOR_TOTAL_COMPRA');
        RLLabel9.Caption := 'Ordenado por valor da compra';
      end;
    end;
    Open;
    RLLabel11.Caption := ' Per?odo: De: '+DateToStr(ReceData)+'  At?: '+DateToStr(RecebeData2)+'';
    RLLabel13.Caption := '  Focus Desenvolvimento de Sistemas - Gerado em '+FormatDateTime('dd/mm/yyyy hh:mm:ss',Now)+' .';
    qCompra.FieldByName('VALOR_TOTAL_COMPRA').OnGetText := qCompraVALOR_TOTAL_COMPRAGetText;
  end;
end;

procedure TTRelatorioCompraPeriodo.ChamaTela(DataI,DataF:TDateTime;TipoRelatorio,Ordem:Integer);
begin
  TRelatorioCompraPeriodo := TTRelatorioCompraPeriodo.Create(Application);
  with TRelatorioCompraPeriodo do
  begin
    ReceData := DataI;
    RecebeData2 := DataF;
    RecebeRelatorio := TipoRelatorio;
    RecebeOrdem := Ordem;
    case TipoRelatorio of
      0:
      begin
        Analitico;
      end;
      1:
      begin
        Relatorio;
      end;
    end;
    if qCompra.IsEmpty then
    begin
      enviaMensagem('Nenhum registro encontrado','Informa??o',mtConfirmation,[mbOK]);
      Exit;
    end
    else
    if TipoRelatorio = 0 then
      rlAnalitico.PreviewModal
    else
      rlSintetico.PreviewModal;
    FreeAndNil(TRelatorioCompraPeriodo);
  end;
end;

procedure TTRelatorioCompraPeriodo.qCompraTOTALGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := 'R$' + FormatFloat('0.00',qCompra.FieldByName('TOTAL').AsFloat);
end;

procedure TTRelatorioCompraPeriodo.qCompraVALOR_TOTAL_COMPRAGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  text := 'R$' + FormatFloat('0.00',qCompra.FieldByName('VALOR_TOTAL_COMPRA').AsFloat);
end;

procedure TTRelatorioCompraPeriodo.Relatorio;
begin
  with qCompra do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT SUM(QUANTIDADE_COMPRA)AS '+QuotedStr('QUANTIDADE DE COMPRA')+',');
    SQL.Add('CONVERT(VARCHAR(10),CP.DATA_COMPRA,103)AS'+QuotedStr('DATA_COMPRA')+',');
    SQL.Add('SUM(VALORTOTAL_COMPRA)AS'+QuotedStr('TOTAL')+'');
    SQL.Add('FROM CLIENTE C');
    SQL.Add('INNER JOIN COMPRA CP ON CP.COD_CLI = C.COD_CLI');
    SQL.Add('WHERE DATA_COMPRA BETWEEN '+dateTextSql(ReceData)+' AND '+dateTextSql(RecebeData2)+' ');
    SQL.Add('GROUP BY CP.DATA_COMPRA');
    RLLabel4.Caption := ' Per?odo: De: '+DateToStr(ReceData)+'  At?: '+DateToStr(RecebeData2)+'';
    RLLabel8.Caption := '  Focus Desenvolvimento de Sistemas - Gerado em '+FormatDateTime('dd/mm/yyyy hh:mm:ss',Now)+' .';
    Open;
    qCompra.FieldByName('TOTAL').OnGetText := qCompraTOTALGetText;
  end;
end;

end.
