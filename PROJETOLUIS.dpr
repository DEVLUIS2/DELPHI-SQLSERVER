program PROJETOLUIS;

uses
  Forms,
  Funcoes in 'Funcoes.pas',
  FuncoesDB in 'FuncoesDB.pas',
  Fornecedores in 'Fornecedores.pas' {TFornecedores},
  FornecedoresC in 'FornecedoresC.pas' {TFornecedoresC},
  Ini in 'Ini.pas' {TConfiguracao},
  FiltroTop10Produtos in 'FiltroTop10Produtos.pas' {TFiltroTop10Produtos},
  FiltroListagemFornecedores in 'FiltroListagemFornecedores.pas' {TFiltroListagemFornecedores},
  FiltroTop10Fornecedores in 'FiltroTop10Fornecedores.pas' {TFiltroTop10Fornecedores},
  RelatorioTop10Fornecedores in 'RelatorioTop10Fornecedores.pas' {TRelatorioTop10Fornecedores},
  FiltroCompraPeriodo in 'FiltroCompraPeriodo.pas' {TFiltroCompraPeriodo},
  FiltroCompraModelo2 in 'FiltroCompraModelo2.pas' {TFiltroCompraModelo2},
  RelatorioCompraPeriodo in 'RelatorioCompraPeriodo.pas' {TRelatorioCompraPeriodo},
  RelCompra in 'RelCompra.pas' {TRelCompra},
  RelCliente in 'RelCliente.pas' {TRelCliente},
  RelProduto in 'RelProduto.pas' {TRelProduto},
  Principal in 'Principal.pas' {TPrincipal},
  Produto in 'Produto.pas' {TProduto},
  ProdutoC in 'ProdutoC.pas' {TProdutoC},
  FiltroFornecedores in 'FiltroFornecedores.pas' {TFiltroFornecedores},
  RelFornecedores in 'RelFornecedores.pas' {TRelFornecedores},
  FiltroProduto in 'FiltroProduto.pas' {TFiltroProduto},
  FiltroCompra in 'FiltroCompra.pas' {TFiltroCompra},
  FiltroCliente in 'FiltroCliente.pas' {TFiltroCliente},
  DMPrincipal in 'DMPrincipal.pas' {TDMPrincipal: TDataModule},
  CompraC in 'CompraC.pas' {TCompraC},
  Compra in 'Compra.pas' {TCompra},
  ClienteC in 'ClienteC.pas' {TClienteC},
  Cliente in 'Cliente.pas' {TCliente},
  FiltroTop10Clientes in 'FiltroTop10Clientes.pas' {TFiltroTop10Clientes},
  RelatorioTop10Cliente in 'RelatorioTop10Cliente.pas' {TRelatorioTop10Cliente},
  RelatorioTop10Produto in 'RelatorioTop10Produto.pas' {TRelatorioTop10Produto},
  GraficoCliente in 'GraficoCliente.pas' {TGraficoCliente},
  GraficoProduto in 'GraficoProduto.pas' {TGraficoProduto},
  GraficoTop10Produto in 'GraficoTop10Produto.pas' {TGraficoTop10Produto},
  GraficoTop10Fornecedores in 'GraficoTop10Fornecedores.pas' {TGraficoTop10Fornecedores},
  GraficoCompraPeriodo in 'GraficoCompraPeriodo.pas' {TGraficoCompraPeriodo},
  GraficoClienteSintetico in 'GraficoClienteSintetico.pas' {TGraficoClienteSintetico},
  GraficoFornecedorSintetico in 'GraficoFornecedorSintetico.pas' {TGraficoSinteticoFornecedor},
  GraficoProdutoSintetico in 'GraficoProdutoSintetico.pas' {TGraficoProdutoSintetico},
  GraficoCompraPeriodoSintetico in 'GraficoCompraPeriodoSintetico.pas' {TGraficoCompraPeriodoSintetico};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '';
  Application.HelpFile := '';
  Application.CreateForm(TTDMPrincipal, TDMPrincipal);
  Application.Run;
end.
