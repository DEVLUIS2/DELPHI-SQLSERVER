unit Ini;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,IniFiles, StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  TTConfiguracao = class(TForm)
    Panel1: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    cbCpf: TCheckBox;
    cbDataNascimento: TCheckBox;
    cbEstoque: TCheckBox;
    Panel3: TPanel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ArquivoIni: TIniFile;
    procedure ChamaTela;

  end;

var
  TConfiguracao: TTConfiguracao;

implementation

uses
  CLIENTE;

{$R *.dfm}

{ TForm1 }

procedure TTConfiguracao.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTConfiguracao.btnSalvarClick(Sender: TObject);
begin
  ArquivoIni := TIniFile.Create('D:\FOCUS\Ini\config.ini');
  ArquivoIni.WriteBool('CLIENTE','CPF',cbCpf.Checked);
  ArquivoIni.WriteBool('CLIENTE','DATA_NASC',cbDataNascimento.Checked);
  ArquivoIni.WriteBool('PRODUTO','ESTOQUE',cbEstoque.Checked);
  ArquivoIni.Free;
  Close;

end;

procedure TTConfiguracao.ChamaTela;
begin
  TConfiguracao := TTConfiguracao.Create(Application);
  with TConfiguracao do
  begin
    ShowModal;
    FreeAndNil(TConfiguracao);
  end;
end;

procedure TTConfiguracao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      Close;
    VK_F5:
      if (btnSalvar.Visible) and (btnSalvar.Enabled) then
        btnSalvar.Click;
  end;
end;

procedure TTConfiguracao.FormShow(Sender: TObject);
var cpf,DataNascimento: Boolean;
begin
  ArquivoIni := TIniFile.Create('D:\FOCUS\Ini\config.ini');
  cbDataNascimento.Checked := StrToBool(ArquivoIni.ReadString('CLIENTE','DATA_NASC',''));
  cbCpf.Checked := StrToBool(ArquivoIni.ReadString('CLIENTE','CPF',''));
  cbEstoque.Checked := StrToBool(ArquivoIni.ReadString('PRODUTO','ESTOQUE',''));
  ArquivoIni.Free;
end;

end.
