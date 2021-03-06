unit RelatorioTop10Cliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, DB, ADODB, DateUtils, jpeg, ExtCtrls;

type
  TTRelatorioTop10Cliente = class(TForm)
    RLReport1: TRLReport;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLPanel5: TRLPanel;
    RLLabel5: TRLLabel;
    RLPanel6: TRLPanel;
    RLLabel6: TRLLabel;
    RLPanel7: TRLPanel;
    RLLabel7: TRLLabel;
    RLBand3: TRLBand;
    RLPanel8: TRLPanel;
    RLDBText1: TRLDBText;
    RLPanel9: TRLPanel;
    RLPanel10: TRLPanel;
    RLDBText3: TRLDBText;
    RLBand4: TRLBand;
    RLPanel11: TRLPanel;
    RLLabel8: TRLLabel;
    RLBand5: TRLBand;
    RLPanel23: TRLPanel;
    RLLabel13: TRLLabel;
    qTopCliente: TADOQuery;
    dsTopCliente: TDataSource;
    RLPanel4: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel12: TRLPanel;
    RLDBText4: TRLDBText;
    RLDBResult1: TRLDBResult;
    RLPanel13: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel14: TRLPanel;
    RLLabel9: TRLLabel;
    RLPanel16: TRLPanel;
    RLPanel1: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel3: TRLPanel;
    RLPanel15: TRLPanel;
    LPeriodo: TRLLabel;
    RLPanel17: TRLPanel;
    Image1: TImage;
    RLDBMemo1: TRLDBMemo;
    procedure qTopClienteVALORTOTAL_COMPRAGetText(Sender: TField;
      var Text: string; DisplayText: Boolean);
    procedure qTopClienteVALORTOTALGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    RecebeData,RecebeData2: TDateTime;
    { Private declarations }
  public
    procedure ChamaTela(Data1,Data2:TDateTime;Relatorio:Integer);
    procedure PassaDados;
    { Public declarations }
  end;

var
  TRelatorioTop10Cliente: TTRelatorioTop10Cliente;

implementation

uses
  DMPRINCIPAL, Funcoes, FuncoesDB;

{$R *.dfm}

{ TTRClienteCompra }

procedure TTRelatorioTop10Cliente.ChamaTela(Data1,Data2:TDateTime;Relatorio:Integer);
begin
  TRelatorioTop10Cliente := TTRelatorioTop10Cliente.Create(Application);
  with TRelatorioTop10Cliente do
  begin
    RecebeData := Data1;
    RecebeData2 := Data2;
    PassaDados;
    if qTopCliente.IsEmpty then
    begin
      enviaMensagem('N?o Existe registro','Infroma??o...',mtInformation,[mbOK]);
      Exit;
    end
    else
      RLReport1.PreviewModal;
    FreeAndNil(TRelatorioTop10Cliente);
  end;
end;

procedure TTRelatorioTop10Cliente.PassaDados;
  var Soma,Valor: Integer;
begin
  with qTopCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP(10) C.COD_CLI,C.RG_CLI,C.NOME_CLI,SUM(CP.VALORTOTAL_COMPRA)AS '+QuotedStr('VALOR TOTAL')+'');
    SQL.Add('FROM CLIENTE C');
    SQL.Add('INNER JOIN COMPRA CP ON CP.COD_CLI = C.COD_CLI');
    SQL.Add('WHERE CP.DATA_COMPRA BETWEEN '+dateTextSql(recebedata)+' AND '+dateTextSql(RecebeData2)+'');
    SQL.Add('GROUP BY C.COD_CLI,C.NOME_CLI,C.RG_CLI');
    SQL.Add('ORDER BY [Valor Total] DESC');
    Open;
    if not IsEmpty then
    begin
      First;
      while not qTopCliente.Eof do
      begin
        valor := StrToInt(FieldByName('VALOR TOTAL').AsString);
        Soma := Soma + Valor;
        qTopCliente.Next;
      end;
    end;
    qTopCliente.FieldByName('VALOR TOTAL').OnGetText := qTopClienteVALORTOTAL_COMPRAGetText;
    RLLabel4.Caption := 'R$ '+FormatFloat('0.00',Soma)+' ';
    LPeriodo.Caption := ' Per?odo: De: '+DateTimeToStr(RecebeData)+' At?: '+DateTimeToStr(RecebeData2)+'';
    RLLabel8.Caption := ' Focus Desenvolvimento de Sistemas - Gerado em '+FormatDateTime('dd/mm/yyyy hh:mm:ss',Now)+''
  end;
end;

procedure TTRelatorioTop10Cliente.qTopClienteVALORTOTALGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := 'R$' + FormatFloat('0.00',qTopCliente.FieldByName('VALOR TOTAL').AsFloat);
end;

procedure TTRelatorioTop10Cliente.qTopClienteVALORTOTAL_COMPRAGetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text := 'R$' + FormatFloat('0.00',qTopCliente.FieldByName('VALOR TOTAL').AsFloat);
end;


end.
