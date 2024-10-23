unit ThreadFind;

interface

uses
  System.Classes, System.SysUtils;

type
 TfindObjet = class(TObject)
 public
  search:TSearchRec;
 end;

type
  TTreadFind = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute(); override;
  public
     Pattern:string;
     StartPath:string;
     attr:integer;
     callbackFunctions:TNotifyEvent;
  published
  end;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TTreadFind.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or

    Synchronize(
      procedure
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ TTreadFind }

procedure TTreadFind.Execute();
var founds:TSearchRec;
    simple:TObject;
    findObjet:TfindObjet;
begin
  findObjet:=TfindObjet.Create;
   try

  if FindFirst(StartPath, attr, founds) = 0 then
  Begin
    findObjet.search := founds;
    callbackFunctions(findObjet);
    while ((FindNext(founds)=0) and not CheckTerminated()) do
    Begin
        findObjet.search := founds;
        callbackFunctions(findObjet);
    End;

  End;
  finally
    findObjet.Free;
  end;

end;

end.
