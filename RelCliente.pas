unit RelCliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RLReport, jpeg, DB, ADODB, DateUtils, ExtCtrls;

type
  TTRelCliente = class(TForm)
    qCliente: TADOQuery;
    dsCliente: TDataSource;
    RLReport1: TRLReport;
    s: TRLBand;
    RLBand2: TRLBand;
    RLPanel5: TRLPanel;
    RLPanel6: TRLPanel;
    RLPanel7: TRLPanel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLBand3: TRLBand;
    RLPanel8: TRLPanel;
    RLPanel9: TRLPanel;
    RLPanel10: TRLPanel;
    RLDBText1: TRLDBText;
    RLDBText3: TRLDBText;
    RLBand4: TRLBand;
    RLPanel11: TRLPanel;
    RLLabel8: TRLLabel;
    RLBand5: TRLBand;
    RLPanel23: TRLPanel;
    RLLabel13: TRLLabel;
    RLPanel24: TRLPanel;
    RLDBResult1: TRLDBResult;
    RLBand1: TRLBand;
    RLPanel4: TRLPanel;
    RLLabel1: TRLLabel;
    RLPanel12: TRLPanel;
    RLLabel9: TRLLabel;
    RLBand6: TRLBand;
    RLPanel13: TRLPanel;
    RLDBText4: TRLDBText;
    RLPanel14: TRLPanel;
    RLDBText5: TRLDBText;
    RLPanel15: TRLPanel;
    RLPanel1: TRLPanel;
    RLLabel2: TRLLabel;
    RLPanel2: TRLPanel;
    RLLabel3: TRLLabel;
    RLPanel3: TRLPanel;
    RLLabel4: TRLLabel;
    RLPanel16: TRLPanel;
    Image1: TImage;
    RLDBMemo1: TRLDBMemo;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
     Ordenastatus,OrdenaCampo,RecebeRelatorio,RecebeCliente:Integer;
     procedure DadosRelatorio;
     procedure RelatorioSintetico;
     procedure BloquearRelatorio;
  public
    { Public declarations }
    procedure ChamaTela(Status,Ordenar,Relatorio,Cliente: Integer);

  end;

var
  TRelCliente: TTRelCliente;

implementation

uses
  DMPRINCIPAL, Funcoes;

{$R *.dfm}

{ TTRCliente }

procedure TTRelCliente.BloquearRelatorio;
begin
  case RecebeRelatorio of
    0:
    begin
      RLBand1.Visible := False;
      RLBand6.Visible := False;
    end;
    1:
    begin
      RLBand2.Visible := False;
      RLBand3.Visible := False;
    end;
    2://Relat?rio Gr?fico
    begin

    end;
  end;
end;

procedure TTRelCliente.ChamaTela(Status,Ordenar,Relatorio,Cliente:Integer);
begin
  TRelCliente := TTRelCliente.Create(Application);
  with TRelCliente do
  begin
    Ordenastatus := Status;
    OrdenaCampo := Ordenar;
    RecebeRelatorio := Relatorio;
    RecebeCliente := Cliente;
    BloquearRelatorio;
    case Relatorio of
      0:
      begin
        DadosRelatorio;
      end;
      1:
      begin
        RelatorioSintetico;
      end;
      2://Relat?rio Gr?fico
      begin

      end;
    end;

    if qCliente.IsEmpty then
    begin
      enviaMensagem('N?o existe informa??o referente a pesquisa efetuada','Informa??o...',mtConfirmation,[mbOK]);
      Exit;
    end
    else
      RLReport1.PreviewModal;
    FreeAndNil(TRelCliente);
  end;
end;

procedure TTRelCliente.DadosRelatorio;
  function FiltroSQL:string;
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
  with qCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COD_CLI,NOME_CLI,RG_CLI');
    SQL.Add('FROM CLIENTE');
    if RecebeCliente > 0 then
      SQL.Add(FiltroSQL + 'COD_CLI = '+ IntToStr(RecebeCliente));
    case Ordenastatus of
      0:
      begin
        RLLabel3.Caption := 'Relat?rio de Todos os Cliente';
      end;
      1:
      begin
        SQL.Add(FiltroSQL +' ATIVO = 1');
        RLLabel3.Caption := 'Relat?rio de Clientes Ativos';
      end;
      2:
      begin
        SQL.Add(FiltroSQL +' ATIVO = 0');
        RLLabel3.Caption := 'Relat?rios de Clientes Inativos';
      end;
    end;
    case OrdenaCampo of
      0:
      begin
        SQL.Add('ORDER BY COD_CLI ASC');
        RLLabel4.Caption := 'Ordenado pelo C?digo';
      end;
      1:
      begin
        SQL.Add('ORDER BY NOME_CLI ASC');
        RLLabel4.Caption := 'Ordenado pelo Nome';
      end;
    end;
    RLLabel8.Caption := '  Focus Desenvolvimento de Sistemas - Gerado em ' + FormatDateTime('dd/mm/yyyy hh:MM:ss',Now) + ' .';
    Open;
  end;
end;

procedure TTRelCliente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      Close;
  end;
end;

procedure TTRelCliente.RelatorioSintetico;
begin
  with qCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT '+QuotedStr('ATIVO')+'AS STATUS, COUNT(COD_CLI)AS COD_CLI');
    SQL.Add('FROM CLIENTE');
    SQL.Add('WHERE ATIVO = 1');
    SQL.Add('UNION ALL');
    SQL.Add('SELECT '+QuotedStr('INATIVO')+'AS STATUS, COUNT(COD_CLI)AS COD_CLI');
    SQL.Add('FROM CLIENTE');
    SQL.Add('WHERE ATIVO = 0');
    RLLabel8.Caption := '  Focus Desenvolvimento de Sistemas - Gerado em ' + FormatDateTime('dd/mm/yyyy hh:MM:ss',Now) + ' .';
    Open;
  end;
end;

end.
