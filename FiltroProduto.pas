unit FiltroProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, rxToolEdit, DateUtils,IniFiles;

type
  TTFiltroProduto = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnRelatorio: TBitBtn;
    btnCancelar: TBitBtn;
    Panel3: TPanel;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edtDataIni: TDateEdit;
    edtDataFim: TDateEdit;
    Panel4: TPanel;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label1: TLabel;
    btnPesquisaProduto: TBitBtn;
    btnLimpaProduto: TBitBtn;
    edCodProduto: TEdit;
    edDescricaoProduto: TEdit;
    Panel5: TPanel;
    GroupBox2: TGroupBox;
    rg1: TRadioGroup;
    cbOrdenacao: TComboBox;
    GroupBox3: TGroupBox;
    ComboBox1: TComboBox;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRelatorioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtDataIniKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDataFimKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtDataIniExit(Sender: TObject);
    procedure edtDataFimExit(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure edCodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure btnLimpaProdutoClick(Sender: TObject);
    procedure edCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnPesquisaProdutoClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    ArquivoI: TIniFile;
    { Private declarations }
  public
    { Public declarations }
    procedure chamaTela;
  end;

var
  TFiltroProduto: TTFiltroProduto;

implementation

uses
  RELPRODUTO, Funcoes, Fornecedores, DMPRINCIPAL, PRODUTO, GraficoProduto, GraficoProdutoSintetico;

{$R *.dfm}

{ TForm2 }

procedure TTFiltroProduto.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TTFiltroProduto.btnLimpaProdutoClick(Sender: TObject);
begin
  edCodProduto.ReadOnly := False;
  edCodProduto.Clear;
  edDescricaoProduto.Clear;
  btnLimpaProduto.Enabled := False;
  btnPesquisaProduto.Enabled := True;
  if edCodProduto.CanFocus then
    edCodProduto.SetFocus;
end;

procedure TTFiltroProduto.btnPesquisaProdutoClick(Sender: TObject);
  var InfoProduto: integer;
begin
  InfoProduto := StrToInt(TProduto.TransfereProduto);
  if InfoProduto > 0 then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_PROD,DESCRICAO_PROD');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PROD = '+IntToStr(InfoProduto));
      Open;
      if not IsEmpty then
      begin
        edCodProduto.Text := FieldByName('COD_PROD').AsString;
        edDescricaoProduto.Text := FieldByName('DESCRICAO_PROD').AsString;
        btnPesquisaProduto.Enabled := False;
        btnLimpaProduto.Enabled := True;
        edCodProduto.ReadOnly := True;
        if btnRelatorio.CanFocus then
          btnRelatorio.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroProduto.btnRelatorioClick(Sender: TObject);
begin
  if (RadioGroup1.ItemIndex = 2) and (ComboBox1.ItemIndex = 0) then
  begin
    enviaMensagem('Selecione um tipo de gr?fico para visualizar','Informa??o',mtConfirmation,[mbOK]);
    if ComboBox1.CanFocus then
      ComboBox1.SetFocus;
    Exit;
  end;
  if (RadioGroup1.ItemIndex = 2)then
  begin
    case ComboBox1.ItemIndex of
      1:
      begin
        TGraficoProduto.ChamaTela(rg1.ItemIndex);
        Exit;
      end;
      2:
      begin
        TGraficoProdutoSintetico.ChamaTela;
        Exit;
      end;
    end;
  end;
  if validarData(edtDataIni.Text) and validarData(edtDataFim.Text) then
  begin
    if (cbOrdenacao.ItemIndex = 0) and (cbOrdenacao.Enabled = True) then
    begin
      enviaMensagem('Selecione Uma Ordena??o','Informa??o',mtWarning,[mbOK]);
      if cbOrdenacao.CanFocus then
        cbOrdenacao.SetFocus;
      Exit;
    end;
    if Empty(edCodProduto.Text) then
      TRelProduto.ChamaTela(rg1.ItemIndex,cbOrdenacao.ItemIndex,RadioGroup1.ItemIndex,0,edtDataIni.Date,edtDataFim.Date)
    else
      TRelProduto.ChamaTela(rg1.ItemIndex,cbOrdenacao.ItemIndex,RadioGroup1.ItemIndex,StrToInt(edCodProduto.Text),edtDataIni.Date,edtDataFim.Date)
  end
  else
  begin
    enviaMensagem('Data Inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
    Exit;
  end;
end;

procedure TTFiltroProduto.chamaTela;
begin
  TFiltroProduto := TTFiltroProduto.Create(APPLICATION);
  with TFiltroProduto do
  begin
    ShowModal;
    FreeAndNil(TFiltroProduto);
  end;
end;

procedure TTFiltroProduto.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex = 2 then
    rg1.Enabled := False
  else
    rg1.Enabled := True;
end;

procedure TTFiltroProduto.edCodProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_F3:
      if (btnPesquisaProduto.Visible) and (btnPesquisaProduto.Enabled) then
        btnPesquisaProduto.Click;
    VK_F6:
      if (btnLimpaProduto.Visible) and (btnLimpaProduto.Enabled) then
        btnLimpaProduto.Click;
  end;
end;

procedure TTFiltroProduto.edCodProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in[#13,#48..#57,#8]) then
    key := #0;
  if (key = #13) and not(Empty(edCodProduto.Text)) then
  begin
    with TDMPrincipal.qGeneric do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT COD_PROD,DESCRICAO_PROD');
      SQL.Add('FROM PRODUTO');
      SQL.Add('WHERE COD_PROD = '+edCodProduto.Text);
      Open;
      if not IsEmpty then
      begin
        edCodProduto.Text := FieldByName('COD_PROD').AsString;
        edDescricaoProduto.Text := FieldByName('DESCRICAO_PROD').AsString;
        edCodProduto.ReadOnly := True;
        btnLimpaProduto.Enabled := True;
        btnPesquisaProduto.Enabled := False;
        if btnRelatorio.CanFocus then
          btnRelatorio.SetFocus;
      end;
    end;
  end;
end;

procedure TTFiltroProduto.edtDataFimExit(Sender: TObject);
begin
  if not(validarData(edtDataFim.Text)) then
  begin
    if btnCancelar.Focused then
      btnCancelar.Click
    else
    begin
      enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
      if edtDataFim.CanFocus then
        edtDataFim.SetFocus;
      Exit;
    end;
  end;
end;

procedure TTFiltroProduto.edtDataFimKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.CanFocus) then
      begin
        btnCancelar.SetFocus;
        Close;
      end;
  end;
end;

procedure TTFiltroProduto.edtDataIniExit(Sender: TObject);
begin
  if not(validarData(edtDataIni.Text)) then
  begin
    if btnCancelar.Focused then
      btnCancelar.Click
    else
    begin
      enviaMensagem('Data inv?lida!','Informa??o...',mtConfirmation,[mbOK]);
      if edtDataIni.CanFocus then
        edtDataIni.SetFocus;
      Exit;
    end;
  end;
end;

procedure TTFiltroProduto.edtDataIniKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if btnCancelar.CanFocus then
      begin
        btnCancelar.SetFocus;
        Close;
      end;
  end;
end;

procedure TTFiltroProduto.FormCreate(Sender: TObject);
  var Estoque: Boolean;
begin
  edtDataIni.Date:= StartOfTheMonth(Date);
  edtDataFim.Date:= EndOfTheMonth(Date);
  ArquivoI := TIniFile.Create('D:\FOCUS\Ini\config.ini');
  Estoque := StrToBool(ArquivoI.ReadString('PRODUTO','ESTOQUE',''));
  ArquivoI.Free;

  if Estoque = True then
  begin
    with cbOrdenacao do
    begin
      Items[0] := 'Selecione...';
      Items[1] := 'C?digo';
      Items[2] := 'Descri??o';
      Items[3] := 'Pre?o';
      Items[4] := 'Estoque';
      ItemIndex := 0;
    end;
  end;
end;

procedure TTFiltroProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:
      if (btnCancelar.Visible) and (btnCancelar.Enabled) then
        btnCancelar.Click;
    VK_F5:
      if (btnRelatorio.Visible) and (btnRelatorio.Enabled) then
        btnRelatorio.Click;
  end;
end;
procedure TTFiltroProduto.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex = 0 then
  begin
    edtDataIni.Enabled := True;
    edtDataFim.Enabled := True;

    btnPesquisaProduto.Enabled := True;
    edCodProduto.Enabled := True;
    edDescricaoProduto.Enabled := True;

    rg1.Enabled := True;
    cbOrdenacao.Enabled := True;
    GroupBox3.Visible := False;
  end
  else
  if RadioGroup1.ItemIndex = 1 then
  begin
    GroupBox3.Visible := False;

    rg1.Enabled := False;
    cbOrdenacao.Enabled := False;

    btnPesquisaProduto.Enabled := False;
    btnLimpaProduto.Enabled := False;
    edCodProduto.Enabled := False;
    edDescricaoProduto.Enabled := False;

    edtDataIni.Enabled := False;
    edtDataFim.Enabled := False;
  end
  else
  if RadioGroup1.ItemIndex = 2 then
  begin
    GroupBox3.Visible := True;

    edtDataIni.Enabled := False;
    edtDataFim.Enabled := False;

    cbOrdenacao.Enabled := False;

    btnPesquisaProduto.Enabled := False;
    btnLimpaProduto.Enabled := False;
    edCodProduto.Enabled := False;
    edDescricaoProduto.Enabled := False;
  end
end;

end.
