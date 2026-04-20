unit Horse.ManipulateResponse;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  SysUtils, Classes,
{$ELSE}
  System.SysUtils, System.Classes,
{$ENDIF}
  Horse;

type
  THorseManipulateResponse = {$IF NOT DEFINED(FPC)} reference to {$ENDIF} procedure(Res: THorseResponse);
  THorseManipulateReqRes = {$IF NOT DEFINED(FPC)} reference to {$ENDIF} procedure(Req: THorseRequest; Res: THorseResponse);

function ManipulateResponse(const AManipulateResponse: THorseManipulateResponse): THorseCallback; overload;
function ManipulateResponse(const AManipulate: THorseManipulateReqRes): THorseCallback; overload;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)} TNextProc {$ELSE} TProc {$ENDIF});

implementation

var
  ManipulateResponseCallBack: THorseManipulateResponse;
  ManipulateReqResCallBack: THorseManipulateReqRes;

function ManipulateResponse(
  const AManipulateResponse: THorseManipulateResponse): THorseCallback;
begin
  ManipulateResponseCallBack := AManipulateResponse;
  Result := Middleware;
end;

function ManipulateResponse(
  const AManipulate: THorseManipulateReqRes): THorseCallback;
begin
  ManipulateReqResCallBack := AManipulate;
  Result := Middleware;
end;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  try
    Next;
  finally
    try
      if Assigned(ManipulateResponseCallBack) then
        ManipulateResponseCallBack(Res)
      else if Assigned(ManipulateReqResCallBack) then
        ManipulateReqResCallBack(Req, Res);
    except
      on E: exception do
      begin
        Res.Send(E.Message).Status(THTTPStatus.InternalServerError);
        raise EHorseCallbackInterrupted.Create;
      end;
    end;
  end;
end;

initialization
  ManipulateResponseCallBack := nil;
  ManipulateReqResCallBack := nil;

end.