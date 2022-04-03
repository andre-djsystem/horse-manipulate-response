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

function ManipulateResponse(const AManipulateResponse: THorseManipulateResponse): THorseCallback; overload;
procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)} TNextProc {$ELSE} TProc {$ENDIF});

implementation

var
  ManipulateResponseCallBack: THorseManipulateResponse;

function ManipulateResponse(
  const AManipulateResponse: THorseManipulateResponse): THorseCallback;
begin
  ManipulateResponseCallBack := AManipulateResponse;
  Result := Middleware;
end;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  try
    Next;
  finally
    try
      ManipulateResponseCallBack(Res);
    except
      on E: exception do
      begin
        Res.Send(E.Message).Status(THTTPStatus.InternalServerError);
        raise EHorseCallbackInterrupted.Create;
      end;
    end;
  end;
end;

end.
