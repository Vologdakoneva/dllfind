unit FindLauncher;

interface
uses Generics.Collections, ThreadFind, system.Classes;

type TFindLauncher = class


public
   ListThread : TList<TTreadFind>;
   constructor Create(Pattern, StartPath:string; attr:integer; callbackFunctions:TNotifyEvent);
   destructor Destroy; override;


end;

function ExecFind():integer;


implementation

constructor TFindLauncher.Create(Pattern, StartPath:string; attr:integer; callbackFunctions:TNotifyEvent);
Begin
     inherited Create;
     ListThread.Create();
End;

function ExecFind():integer;
Begin

End;

destructor TFindLauncher.Destroy;
var Elem: TTreadFind;
Begin
      for Elem in ListThread do
      begin
        Elem.Terminate;
      end;
      ListThread.Free;
End;
end.
