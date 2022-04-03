# horse-manipulate-response
<b>horse-manipulate-request</b> is a middleware to manipulate response in APIs developed with the <a href="https://github.com/HashLoad/horse">Horse</a> framework.

## ⚙️ Installation
Installation is done using the [`boss install`](https://github.com/HashLoad/boss) command:
``` sh
boss install https://github.com/andre-djsystem/horse-manipulate-response
```
If you choose to install manually, simply add the following folders to your project, in *Project > Options > Resource Compiler > Directories and Conditionals > Include file search path*
```
../horse-manipulate-response/src
```

## ✔️ Compatibility
This middleware is compatible with projects developed in:
- [X] Delphi
- [X] Lazarus

## ⚡️ Quickstart Delphi
```delphi
uses 
  Horse, 
  Horse.ManipulateResponse, // It's necessary to use the unit
  System.SysUtils;

begin
  // It's necessary to add the middleware in the Horse:
  THorse.Use(ManipulateResponse(
    procedure(Res: THorseResponse);
	begin
	  Res.RawWebResponse.CustomHeaders.Add('x-HandledResponse=True');
	end;));
    
  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('pong');
    end);

  THorse.Listen(9000);
end;
```

## ⚡️ Quickstart Lazarus
```delphi
{$MODE DELPHI}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Horse,
  Horse.ManipulateResponse, // It's necessary to use the unit
  SysUtils;

procedure GetPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('Pong');
end;

procedure HandleResponse(Res: THorseResponse);
begin
  Res.RawWebResponse.CustomHeaders.Add('x-HandledResponse=True');
end;  

begin
  // It's necessary to add the middleware in the Horse:
  THorse.Use(ManipulateResponse(HandleResponse))

  THorse.Get('/ping', GetPing);

  THorse.Listen(9000);
end.
```

## ⚠️ License
`horse-manipulate-response` is free and open-source middleware licensed under the [MIT License](https://github.com/andre-djsystem/horse-manipulate-response/blob/master/LICENSE). 

 


