unit DMPrincipal;

interface

uses
  SysUtils, Classes, ADODB, DB;

type
  TTDMPrincipal = class(TDataModule)
    qGeneric: TADOQuery;
    Connection: TADOConnection;
    Comand: TADOCommand;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TDMPrincipal: TTDMPrincipal;

implementation

uses PRINCIPAL;

{$R *.dfm}

procedure TTDMPrincipal.DataModuleCreate(Sender: TObject);
begin
  TPrincipal.chamaTela;
end;

end.
