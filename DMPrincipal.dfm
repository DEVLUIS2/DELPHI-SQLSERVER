object TDMPrincipal: TTDMPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 224
  Width = 309
  object qGeneric: TADOQuery
    Connection = Connection
    Parameters = <>
    Left = 32
    Top = 112
  end
  object Connection: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security In' +
      'fo=False;User ID=SA;Initial Catalog=ESTAGIARIO_LUIS;Data Source=' +
      'localhost;Use Procedure for Prepare=1;Auto Translate=True;Packet' +
      ' Size=4096;Workstation ID=LEANDRO-PC;Use Encryption for Data=Fal' +
      'se;Tag with column collation when possible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 208
    Top = 112
  end
  object Comand: TADOCommand
    Connection = Connection
    Parameters = <>
    Left = 144
    Top = 112
  end
end
