unit SampleClasses;

interface

uses ScriptInterface, Generics.Collections, RTTI;

type

  TVector2 = record
    x, y: double;
  end;

  TVector3 = class
  private
    Fx: double;
    Fy: double;
    Fz: double;
    procedure Setx(const Value: double);
    procedure Sety(const Value: double);
    procedure Setz(const Value: double);
    function GetGetself: TVector3;
  public
    constructor Create(x, y, z: double);
    property x: double read Fx write Setx;
    property y: double read Fy write Sety;
    property z: double read Fz write Setz;
    property getSelf: TVector3 read GetGetself;
    function Length: double;
    [TGCAttr]
    function Copy: TVector3;
    function ToV2: TVector2;
  end;

  TVectorList = class(TObjectList<TVector3>)
  end;

  TCallBackClass = class
  private
    FOnClick: TOptionCallback;
    procedure SetOnClick(const Value: TOptionCallback);
  public
    procedure MakeClick;
    property OnClick: TOptionCallback read FOnClick write SetOnClick;
  end;

  TSomeObject = class
  private
    FSomeValue: Double;
  public
    property Value: Double read FSomeValue write FSomeValue;
  end;

  TSomeObjectHelper = class(TJSClassExtender)
  private
  public
    function ValueSqr: double;
  end;


implementation

{ TVector3 }

//class operator TVector3.Add(v1, v2: TVector3): TVector3;
//begin
//  Result := TVector3.Create(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
//end;

function TVector3.Copy: TVector3;
begin
  Result := TVector3.Create(Fx, Fy, Fz);
end;

constructor TVector3.Create(x, y, z: double);
begin
  Fx := x;
  Fy := y;
  Fz := z;
end;

function TVector3.GetGetself: TVector3;
begin
  Result := Self;
end;

function TVector3.Length: double;
begin
  Result := Sqrt(x*x + y*y + z*z);
end;

procedure TVector3.Setx(const Value: double);
begin
  Fx := Value;
end;

procedure TVector3.Sety(const Value: double);
begin
  Fy := Value;
end;

procedure TVector3.Setz(const Value: double);
begin
  Fz := Value;
end;

function TVector3.ToV2: TVector2;
begin
  Result.x := Fx;
  Result.y := Fy;
end;

{ TCallBackClass }

procedure TCallBackClass.MakeClick;
var
  opt: TScriptOption;
begin
  opt := TScriptOption.Create;
  try
    FOnClick.Call(opt);
  finally
    opt.Free;
  end;
end;

procedure TCallBackClass.SetOnClick(const Value: TOptionCallback);
begin
  FOnClick := Value;
end;

{ TSomeObjectHelper }

function TSomeObjectHelper.ValueSqr: double;
begin
  Result := -1;
  if Source is TSomeObject then
    Result := Sqr((Source as TSomeObject).Value);
end;

end.
