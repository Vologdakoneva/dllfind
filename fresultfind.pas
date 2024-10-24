unit fresultfind;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList,
  ThreadFind;
type
 TfindObjet = class(TObject)
 public
   seaerchrec:TSearchRec;
   basePath:string;
 end;

type
  TCallbackEvent = procedure(Sender: TfindObjet) of object;
  TfunctionExec = function(Pattern, startpath:string;useRecurce:boolean; textTofind:string; CallBackFunc:TCallbackEvent) :TTreadFind; stdcall;

  TfFindEzec = class(TForm)
    Button1: TButton;
    ResList: TListView;
    FolderSelect: TButtonedEdit;
    ImageList1: TImageList;
    patternEdit: TButtonedEdit;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    chRecurse: TCheckBox;
    chText: TCheckBox;
    textfind: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FolderSelectRightButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ResListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure chTextClick(Sender: TObject);
  private
    { Private declarations }
    functionExec:TfunctionExec;
    procedure terminate;
  public
    { Public declarations }
    threadserch:TTreadFind;
    procedure CallbackFromDll(Sender: TfindObjet);
  end;

var
  fFindEzec: TfFindEzec;

implementation

{$R *.dfm}




procedure TfFindEzec.Button1Click(Sender: TObject);
 var libh:integer;
begin
   terminate;
   ResList.Items.Clear;
   libh :=  LoadLibrary('finddll.dll');
   @functionExec := GetProcAddress(libh, 'ExecFinds');
   threadserch:= functionExec(patternEdit.Text, ExcludeTrailingBackslash( FolderSelect.Text ), chRecurse.Checked, textfind.Text, CallbackFromDll);
end;

procedure TfFindEzec.FolderSelectRightButtonClick(Sender: TObject);

begin
 with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
      FolderSelect.Text := FileName;
  finally
    Free;
  end;

end;

procedure TfFindEzec.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := TCloseAction.caFree;
end;

procedure TfFindEzec.FormShow(Sender: TObject);
begin
  ResList.Items.Clear;
end;

procedure TfFindEzec.ResListCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);

begin

    Compare := CompareText(inttostr(Item1.ImageIndex*-1)+Item1.Caption,inttostr(Item2.ImageIndex*-1)+Item2.Caption)


end;

procedure TfFindEzec.terminate;
begin
  if assigned(threadserch) then
  Begin
    threadserch.Free;
    threadserch:=nil;
  End;
end;

procedure TfFindEzec.Button2Click(Sender: TObject);
begin
//
terminate;
end;

procedure TfFindEzec.CallbackFromDll(Sender: TfindObjet);
var findObjet:TfindObjet;
     sss:string;
     Item:TListItem;
begin
   Item:=ResList.Items.Add;
   Item.Caption := Sender.seaerchrec.Name;
   if Sender.seaerchrec.Attr = faDirectory then
     Item.ImageIndex:=2 else Item.ImageIndex:=-1;
   Item.SubItems.Add(Sender.basePath);

//   ResList.AlphaSort;
end;

procedure TfFindEzec.chTextClick(Sender: TObject);
begin
  textfind.Enabled := chText.Checked;
  if not chText.Checked then
    textfind.Text:='';
end;

end.
