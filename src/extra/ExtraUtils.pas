// ------------------------------------------------------------------------------//
// //
// ������ ��� ���������� ���� ���������� �����������                       //
// (c) DimaGVRH, Dnepr city, 2019                                          //
// //
// ------------------------------------------------------------------------------//
unit ExtraUtils;

interface

uses Classes;

function StrToPChar(string_: String): PChar;
function GetStrToSep(St1: string; Sym1, Sym2: char; Var Pos: integer): string; overload;
function GetStrToSep(St1: string; Sym: char; Var Pos: integer): string; overload;
function GetStrToSep(St1: string; Sym: char; Pos: smallint): string; overload;
function GetStrToSep(St1: string; Sym: char): string; overload;
function GetSymPos(St1: string; Sym: char; StartI: integer = 0): smallint;
function ExtractWord(const AString: string; const ADelimiter: char): TStringList;
function base64Decode(const Text: ansiString): ansiString;
function DecodeBase64(Value: String): String;
function GetStringFromFileStream(FileStream: TFileStream): String;
function BoolToStr(const Value: boolean): string;

implementation

uses IdCoder3to4, IdCoderMIME, SysUtils;

// ------------------------------------------------------------------------------//
// ������������ ��� �������������� String � PChar                //
// ------------------------------------------------------------------------------//
function StrToPChar(string_: String): PChar;
begin
  string_ := string_ + #0;
  result := StrPCopy(@string_[1], string_);
end;

// ------------------------------------------------------------------------------//
// ������������ ��� ��������� ������ �� TFileStream               //
// ------------------------------------------------------------------------------//
function GetStringFromFileStream(FileStream: TFileStream): String;
var
  Str: String;
begin
  FileStream.Position := 0;
  SetLength(Str, FileStream.Size);
  FileStream.Read(Str[1], FileStream.Size);
  result := Str;
end;

// ------------------------------------------------------------------------------//
// ������������ ��� ������������� ������ BASE64                 //
// ------------------------------------------------------------------------------//
function base64Decode(const Text: ansiString): ansiString;
var
  Decoder: TIdDecoderMime;
begin
  Decoder := TIdDecoderMime.Create(nil);
  try
    result := Decoder.DecodeString(Text);
  finally
    FreeAndNil(Decoder)
  end
end;

// ------------------------------------------------------------------------------//
// ������������ ����������� ������ � BASE64                     //
// ------------------------------------------------------------------------------//
function DecodeBase64(Value: String): String;
const
  b64alphabet: PChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  function DecodeChunk(const Chunk: String): String;
  var
    W: LongWord;
    i: Byte;
  begin
    W := 0;
    result := '';
    for i := 1 to 4 do
      if Pos(Chunk[i], b64alphabet) <> 0 then
        W := W + Word((Pos(Chunk[i], b64alphabet) - 1)) shl ((4 - i) * 6);
    for i := 1 to 3 do
      result := result + Chr(W shr ((3 - i) * 8) and $FF);
  end;

begin
  result := '';
  if Length(Value) mod 4 <> 0 then
    Exit;
  while Length(Value) > 0 do
  begin
    result := result + DecodeChunk(Copy(Value, 0, 4));
    Delete(Value, 1, 4);
  end;
end;

// ------------------------------------------------------------------------------//
// ������������ �������������� ���� ������ Bool � ��� ������ String       //
// ------------------------------------------------------------------------------//
function BoolToStr(const Value: boolean): string;
const
  Values: array [boolean] of string = ('False', 'True');
begin
  result := Values[Value];
end;

// ------------------------------------------------------------------------------//
// ������������ ��� ��������� ������ �����, ������� �������� � ����. ���������. //
// ------------------------------------------------------------------------------//
function ExtractWord(const AString: string; const ADelimiter: char): TStringList;
var
  i, k: integer;
  astringList: TStringList;
begin
  astringList := TStringList.Create();
  i := 1;
  for k := 1 to Length(AString) do
  begin
    if (AString[k] = ADelimiter) then
    begin
      astringList.Add(Copy(AString, i, k - i));
      i := k + 1;
    end;
    if (k = Length(AString)) then
      astringList.Add(Copy(AString, i, k - i + 1));
  end;
  result := astringList;
end;

// ------------------------------------------------------------------------------//
// ������������ ��� ��������� ������� ������� � ������             //
// ------------------------------------------------------------------------------//
function GetSymPos(St1: string; Sym: char; StartI: integer = 0): smallint;
var
  i: smallint;
begin
  result := 0;
  i := StartI;
  while (i <= Length(St1)) AND (result = 0) do
  begin
    if (i > 0) AND (St1[i] = Sym) then
      result := i;
    i := i + 1;
  end;
end;

// ------------------------------------------------------------------------------//
// ������������ ��� ��������� ����� �� �����������                //
// ------------------------------------------------------------------------------//
function GetStrToSep(St1: string; Sym1, Sym2: char; Var Pos: integer): string;
var
  St2: string;
begin
  St2 := '';
  while (Pos <= Length(St1)) AND (St1[Pos] <> Sym1) AND (St1[Pos] <> Sym2) do
  begin
    St2 := St2 + St1[Pos];
    Pos := Pos + 1;
  end;
  Pos := Pos + 1;
  result := St2;
end;

// ------------------------------------------------------------------------------//
// ������������ ��� ��������� ����� �� �����������                //
// ------------------------------------------------------------------------------//
function GetStrToSep(St1: string; Sym: char; Var Pos: integer): string;
var
  St2: string;
begin
  St2 := '';
  while (Pos <= Length(St1)) AND (St1[Pos] <> Sym) do
  begin
    St2 := St2 + St1[Pos];
    Pos := Pos + 1;
  end;
  Pos := Pos + 1;
  result := St2;
end;

// ------------------------------------------------------------------------------//
// ������������ ��� ��������� ����� �� �����������                //
// ------------------------------------------------------------------------------//
function GetStrToSep(St1: string; Sym: char; Pos: smallint): string;
var
  St2: string;
  _pos: smallint;
begin
  St2 := '';
  _pos := Pos;
  while (_pos <= Length(St1)) AND (St1[_pos] <> Sym) do
  begin
    St2 := St2 + St1[_pos];
    _pos := _pos + 1;
  end;
  result := St2;
end;

// ------------------------------------------------------------------------------//
// ������������ ��� ��������� ����� �� �����������                //
// ------------------------------------------------------------------------------//
function GetStrToSep(St1: string; Sym: char): string;
var
  St2: string;
  i: integer;
begin
  St2 := '';
  i := 1;
  while (i <= Length(St1)) AND (St1[i] <> Sym) do
  begin
    St2 := St2 + St1[i];
    i := i + 1;
  end;
  result := St2;
end;

end.
