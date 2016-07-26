program V8EngineProj;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Windows,
  Math,
  Classes,
  Generics.Collections,
  V8Interface in 'V8Interface.pas',
  SampleClasses in 'SampleClasses.pas',
  V8API in 'V8API.pas',
  V8Engine in 'V8Engine.pas',
  ScriptInterface in 'ScriptInterface.pas';

type

  TGlobalNamespace = class
  private
    FEng: TJSEngine;
    FSys: TJSSystemNamespace;
    FSomeHelper: TSomeObjectHelper;
    function GetSystem: TJSSystemNamespace;
  public
    constructor Create(Eng: TJSEngine);
    procedure log(str: string);
    property system: TJSSystemNamespace read GetSystem;
    [TGCAttr]
    function NewVectorList: TVectorList;
    [TGCAttr]
    function NewVector(x: double = 0; y: double = 0; z: double = 0): TVector3; overload;
    [TGCAttr]
    function NewVector(): TVector3; overload;
    [TGCAttr]
    function NewCallBackClass: TCallBackClass;
    [TGCAttr]
    function NewSomeObject: TSomeObject;
    function Length(vec: TVector3): double;
    function Multiplicate(arg1, arg2: double; arg3: double = 1.0): double;
  end;
{ TGlobalNamespace }

constructor TGlobalNamespace.Create(Eng: TJSEngine);
begin
  FEng := Eng;
  FSys := Eng.GetSystem;
  FSomeHelper := TSomeObjectHelper.Create;
  FEng.RegisterHelper(TSomeObject, FSomeHelper);
end;

function TGlobalNamespace.GetSystem: TJSSystemNamespace;
begin
  Result := FSys;
end;

procedure TGlobalNamespace.log(str: string);
begin
  FEng.Log.Add(str);
end;

function TGlobalNamespace.Multiplicate(arg1, arg2, arg3: double): double;
begin
  Result := arg1 * arg2 * arg3;
end;

function TGlobalNamespace.NewCallBackClass: TCallBackClass;
begin
  Result := TCallBackClass.Create;
end;

function TGlobalNamespace.NewSomeObject: TSomeObject;
begin
  Result := TSomeObject.Create;
end;

function TGlobalNamespace.NewVector: TVector3;
begin
  Result := TVector3.Create(0, 0, 0);
end;

function TGlobalNamespace.NewVectorList: TVectorList;
begin
  Result := TVectorList.Create(False);
end;

function TGlobalNamespace.Length(vec: TVector3): double;
begin
  Result := vec.Length;
end;

function TGlobalNamespace.NewVector(x, y, z: double): TVector3;
begin
  Result := TVector3.Create(x, y, z);
end;


var
  s: TStrings;
  Global: TGlobalNamespace;
  Eng: TJSEngine;
begin
//  Writeln('===========TEST==========');
  S := TStringList.Create;
  try
    Math.SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow,
      exUnderflow, exPrecision]);
    Eng := TJSEngine.Create;
    Global := TGlobalNamespace.Create(Eng);
    try
      Eng.AddGlobal(Global);
//      Writeln(GetCurrentDir);
//      if FileExists('EngineTestScript.js') then
//        s.LoadFromFile('EngineTestScript.js')
//      else
//        s.LoadFromFile('..\..\ScriptApp\Win32\Debug\EngineTestScript.js');
      Writeln(s.Text);
//      Eng.RunScript('"' + s.Text + '"', ParamStr(0));
      Eng.RunFile('EngineTestScript.js', ParamStr(0));
      // <<----send log to user-----
      if Eng.Log.Count > 0 then
      begin
        Writeln('=========================LOG=========================');
        Writeln(Eng.Log.Text);
        Writeln('=====================================================');
      end;
      // ------------------------->>
    finally
      Eng.Free;
      Global.Free;
    end;
  except
    writeln('err');
  end;
  s.Free;
  Writeln;
  Writeln('Press Enter for Exit');
  Readln;
end.
