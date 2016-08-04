unit SampleClasses;

interface

uses ScriptInterface, Generics.Collections, RTTI;

type

  //just vectors
  TVector2 = record
    x, y: double;
  end;

  TVector3 = record
  public
    x: double;
    y: double;
    z: double;
    constructor Create(ax, ay, az: double);
    function Length: double;
    [TGCAttr]
    function Copy: TVector3;
    function ToV2: TVector2;
  end;

  TVectorList = class(TList<TVector3>)
  end;

  //class with callback
  TCallBackClass = class
  private
    FOnValueChange: TOptionCallback;
    FValue: double;
    procedure SetOnValueChange(const Value: TOptionCallback);
    procedure SetValue(const Value: double);
  public
    property Value: double read FValue write SetValue;
    property OnValueChange: TOptionCallback read FOnValueChange write SetOnValueChange;
  end;

  //some classes
  TSomeObject = class
  private
    FSomeValue: Double;
  public
    property Value: Double read FSomeValue write FSomeValue;
  end;

  TSomeChild = class(TSomeObject)
  end;

  //some helpers
  TSomeObjectHelper = class(TJSClassExtender)
  private
  public
    function ValueSqr: double;
  end;

  TSomeChildHelper = class(TJSClassExtender)
  public
    function ValueX2:Double;
  end;

  //class with custom attributes
  TSomeAttrObject = class
  public
    [TMethodForbiddenAttr]
    function GetForbiddenNumber: integer;
    function GetNumber: integer;
  end;

implementation

{ TVector3 }

function TVector3.Copy: TVector3;
begin
  Result := TVector3.Create(x, y, z);
end;

constructor TVector3.Create(ax, ay, az: double);
begin
  x := ax;
  y := ay;
  z := az;
end;

function TVector3.Length: double;
begin
  Result := Sqrt(x*x + y*y + z*z);
end;

function TVector3.ToV2: TVector2;
begin
  Result.x := x;
  Result.y := y;
end;

{ TCallBackClass }

procedure TCallBackClass.SetOnValueChange(const Value: TOptionCallback);
begin
  FOnValueChange := Value;
end;

procedure TCallBackClass.SetValue(const Value: double);
begin
  if FOnValueChange.Assigned then
    FOnValueChange.Call(nil);
  FValue := Value;
end;

{ TSomeObjectHelper }

function TSomeObjectHelper.ValueSqr: double;
begin
  Result := -1;
  if Source is TSomeObject then
    Result := Sqr((Source as TSomeObject).Value);
end;

{ TSomeChildHelper }

function TSomeChildHelper.ValueX2: Double;
begin
  Result := -1;
  if Source is TSomeObject then
    Result := (Source as TSomeObject).Value * 2;
end;

{ TSomeAttrObject }

function TSomeAttrObject.GetForbiddenNumber: integer;
begin
  Result := -1;
end;

function TSomeAttrObject.GetNumber: integer;
begin
  Result := 1;
end;

end.
