unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, StdCtrls, FileCtrl, Buttons, DBCtrls, DB, jpeg;

type
  TTPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    MANUTENO1: TMenuItem;
    RELATRIOS1: TMenuItem;
    SAIR1: TMenuItem;
    CLIENTE1: TMenuItem;
    PRODUTO1: TMenuItem;
    COMPRA1: TMenuItem;
    Fornecedores1: TMenuItem;
    CLiente2: TMenuItem;
    Produto2: TMenuItem;
    Fornecedores2: TMenuItem;
    Compra2: TMenuItem;
    Configuracao: TMenuItem;
    Listagem1: TMenuItem;
    OP101: TMenuItem;
    Listagem2: TMenuItem;
    op102: TMenuItem;
    Listagem3: TMenuItem;
    op103: TMenuItem;
    Listagem4: TMenuItem;
    op104: TMenuItem;
    N331: TMenuItem;
    N421Modelo11: TMenuItem;
    N422Modelo21: TMenuItem;
    procedure SAIR1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CLIENTE4Click(Sender: TObject);
    procedure PRODUTO4Click(Sender: TObject);
    procedure Fornecedores3Click(Sender: TObject);
    procedure CLIENTE1Click(Sender: TObject);
    procedure PRODUTO1Click(Sender: TObject);
    procedure Fornecedores1Click(Sender: TObject);
    procedure COMPRA1Click(Sender: TObject);
    procedure ConfiguracaoClick(Sender: TObject);
    procedure Analitico2Click(Sender: TObject);
    procedure Analitico3Click(Sender: TObject);
    procedure Listagem1Click(Sender: TObject);
    procedure OP101Click(Sender: TObject);
    procedure Listagem2Click(Sender: TObject);
    procedure op102Click(Sender: TObject);
    procedure N331Click(Sender: TObject);
    procedure Listagem3Click(Sender: TObject);
    procedure N421Modelo11Click(Sender: TObject);
    procedure op103Click(Sender: TObject);
    procedure N422Modelo21Click(Sender: TObject);
    procedure Listagem4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure chamaTela();
  end;

var
  TPrincipal: TTPrincipal;

implementation

uses Cliente, Produto, Compra, FiltroCliente, FiltroCompra, FiltroProduto,
  RelCliente, RelCompra, RelProduto, Fornecedores, FiltroFornecedores, Ini, DMPrincipal, FiltroTop10Produtos, FiltroListagemFornecedores, FiltroTop10Fornecedores, FiltroCompraModelo2, FiltroCompraPeriodo, RelFornecedores, FiltroTop10Clientes, RelatorioTop10Cliente;

{$R *.dfm}

procedure TTPrincipal.Analitico2Click(Sender: TObject);
begin
  TFiltroProduto.chamaTela;
end;

procedure TTPrincipal.Analitico3Click(Sender: TObject);
begin
  TFiltroProduto.chamaTela;
end;


procedure TTPrincipal.chamaTela;
begin
  TPRINCIPAL:=TTPRINCIPAL.Create(Application);
  with TPRINCIPAL do
  begin
    ShowModal;
    FreeAndNil(TPRINCIPAL);
  end;
end;

procedure TTPrincipal.CLIENTE1Click(Sender: TObject);
begin
  TCliente.chamaTela;
end;

procedure TTPrincipal.CLIENTE4Click(Sender: TObject);
begin
  TFiltroCliente.chamaTela
end;

procedure TTPrincipal.COMPRA1Click(Sender: TObject);
begin
  TCompra.chamaTela;
end;

procedure TTPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:Close;
  end;
end;

procedure TTPrincipal.Fornecedores1Click(Sender: TObject);
begin
  TFornecedores.chamaTela;
end;

procedure TTPrincipal.Fornecedores3Click(Sender: TObject);
begin
  TFiltroFornecedores.chamaTela;
end;

procedure TTPrincipal.Listagem1Click(Sender: TObject);
begin
  TFiltroCliente.chamaTela;
end;

procedure TTPrincipal.Listagem2Click(Sender: TObject);
begin
  TFiltroProduto.chamaTela;
end;

procedure TTPrincipal.Listagem3Click(Sender: TObject);
begin
  TFiltroListagemFornecedores.ChamaTela;
end;

procedure TTPrincipal.Listagem4Click(Sender: TObject);
begin
  TFiltroCompraPeriodo.ChamaTela;
end;

procedure TTPrincipal.N331Click(Sender: TObject);
begin
  TFiltroFornecedores.chamaTela;
end;

procedure TTPrincipal.N421Modelo11Click(Sender: TObject);
begin
  TFiltroCompra.chamaTela;
end;

procedure TTPrincipal.N422Modelo21Click(Sender: TObject);
begin
  TFiltroCompraModelo2.ChamaTela;
end;

procedure TTPrincipal.OP101Click(Sender: TObject);
begin
  TFiltroTop10Clientes.ChamaTela;
end;

procedure TTPrincipal.op102Click(Sender: TObject);
begin
  TFiltroTop10Produtos.ChamaTela;
end;

procedure TTPrincipal.op103Click(Sender: TObject);
begin
  TFiltroTop10Fornecedores.ChamaTela;
end;

procedure TTPrincipal.PRODUTO1Click(Sender: TObject);
begin
  TProduto.chamaTela;
end;

procedure TTPrincipal.PRODUTO4Click(Sender: TObject);
begin
  TFiltroProduto.chamaTela;
end;

procedure TTPrincipal.SAIR1Click(Sender: TObject);
begin
  Close;
end;

procedure TTPrincipal.ConfiguracaoClick(Sender: TObject);
begin
  TConfiguracao.Chamatela;
end;

end.
