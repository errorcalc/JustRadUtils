unit UnitMain;

interface

procedure Register();

implementation

uses
  System.SysUtils, Vcl.ActnList, Vcl.Dialogs, Vcl.Forms, ToolsAPI, ToolsAPI.UI;

type
  TIDEWizard = class(TNotifierObject, IOTAWizard)
  private
    FActionList: TActionList;
    function DateTimeToInt64(): Int64;
    procedure OnMenuInsertDateTimeId(Sender: TObject);
    function BeginEdit(): IOTAEditView;
    procedure EndEdit(var EditView: IOTAEditView);
  public
    constructor Create();
    destructor Destroy(); override;
    function GetIDString(): string;
    procedure Execute();
    function GetName(): string;
    function GetState(): TWizardState;
  end;

procedure Register();
begin
  RegisterPackageWizard(TIDEWizard.Create);
end;

{ TIDEWizard }

constructor TIDEWizard.Create();
var
  EditorServices: IOTAEditorServices;
  EditorLocalMenu: INTAEditorLocalMenu;
  Action: TAction;
begin
  inherited Create();

  FActionList := TActionList.Create(nil);

  if Supports(BorlandIDEServices, IOTAEditorServices, EditorServices) then
  begin
    EditorLocalMenu := EditorServices.GetEditorLocalMenu();

    EditorLocalMenu.RegisterActionList(FActionList, 'JustRadUtilsMenu', cEdMenuCatClipboard);

    Action := TAction.Create(FActionList);
    Action.Name := 'JustRadUtilsMenuInsertDateTimeId';
    Action.Caption := 'Insert Int64 ID (YYYYMMDDhhnnss)';
    Action.Category := 'JustRadUtilsMenu';
    Action.OnExecute := OnMenuInsertDateTimeId;
    Action.Enabled := True;
    Action.ActionList := FActionList;
  end
end;

destructor TIDEWizard.Destroy();
var
  EditorServices: IOTAEditorServices;
  EditorLocalMenu: INTAEditorLocalMenu;
begin
  if Supports(BorlandIDEServices, IOTAEditorServices, EditorServices) then
  begin
    EditorLocalMenu := EditorServices.GetEditorLocalMenu();
    EditorLocalMenu.UnregisterActionList('JustRadUtilsMenu');
  end;

  FActionList.Free();

  inherited Destroy();
end;

function TIDEWizard.BeginEdit(): IOTAEditView;
var
  EditorServices: IOTAEditorServices;
  Buffer: IOTAEditBuffer;
  //Position: LongInt;
  //EditPosition: TOTAEditPos;
  //CharPosition: TOTACharPos;
begin
  Result := nil;

  if Supports(BorlandIDEServices, IOTAEditorServices, EditorServices) then
  begin
    Buffer := EditorServices.GetTopBuffer();

    if (Buffer = nil) or (Buffer.TopView = nil) then
    begin
      exit;
    end;

    Result := Buffer.TopView;

    //EditPosition := Buffer.TopView.CursorPos;
    //Buffer.TopView.ConvertPos(True, EditPosition, CharPosition);
    //Result.CopyTo(Buffer.TopView.CharPosToPos(CharPosition));
  end;
end;

procedure TIDEWizard.EndEdit(var EditView: IOTAEditView);
begin
  EditView.Paint();
  EditView := nil;
end;

function TIDEWizard.DateTimeToInt64(): Int64;
var
  DateTime: TDateTime;
  Y, M, D, H, N, S, MS: Word;
begin
  DateTime := Now();
  DecodeDate(DateTime, Y, M, D);
  DecodeTime(DateTime, H, N, S, MS);
  Result :=
    Int64(Y) * 10000000000 +
    Int64(M) * 100000000 +
    Int64(D) * 1000000 +
    Int64(H) * 10000 +
    Int64(N) * 100 +
    Int64(S);
end;

procedure TIDEWizard.OnMenuInsertDateTimeId(Sender: TObject);
var
  EditView: IOTAEditView;
begin
  EditView := BeginEdit();
  try
    if EditView = nil then
    begin
      exit;
    end;
    EditView.Position.InsertText(DateTimeToInt64.ToString());
  finally
    EndEdit(EditView);
  end;
end;

procedure TIDEWizard.Execute();
begin
end;

function TIDEWizard.GetIDString(): string;
begin
  Result := '[E631BAE4-A69B-41DC-BB21-827131FA7D4E]';
end;

function TIDEWizard.GetName(): string;
begin
  Result := 'JustRadUtils';
end;

function TIDEWizard.GetState(): TWizardState;
begin
  Result := [wsEnabled];
end;

end.
