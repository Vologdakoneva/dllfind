unit FindLauncher;

interface
uses Generics.Collections, ThreadFind, system.Classes;

type TFindLauncher = class


public
   ListThread : TList<TTreadFind>;
   constructor Create(Pattern, StartPath:string; attr:integer; callbackFunctions:TCallbackEvent);
   destructor Destroy; override;


end;

function ExecFind(Pattern, startpath:string; useRecurce:boolean; textTofind:string; CallBackFunc:TCallbackEvent):TFindLauncher;


implementation

constructor TFindLauncher.Create(Pattern, StartPath:string; attr:integer; callbackFunctions:TCallbackEvent);
Begin
    // inherited Create;
    ListThread:= TList<TTreadFind>.Create;

End;

function ExecFind(Pattern, startpath:string; useRecurce:boolean; textTofind:string; CallBackFunc:TCallbackEvent):TFindLauncher;
var treadfindOne:TTreadFind;
    ListOfStrings:TStringList;
    patternIem:string;
    launcher:TFindLauncher;
Begin
   launcher := TFindLauncher.Create(Pattern, startpath,0, nil);
   ListOfStrings:=TStringList.Create;
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := ',';
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Pattern;
   for patternIem in ListOfStrings do
   begin
    treadfindOne := TTreadFind.Create(true);
    treadfindOne.Pattern :=patternIem;
    treadfindOne.StartPath := startpath;
    treadfindOne.useRecurse := useRecurce;
    treadfindOne.Texttofind := textTofind;
    treadfindOne.callbackFunctions := CallBackFunc;
    treadfindOne.Execute();
    launcher.ListThread.Add(treadfindOne);
   end;
   ExecFind := launcher;
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
