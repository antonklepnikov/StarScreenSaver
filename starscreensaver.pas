program StarScreenSaver;    { starscreensaver.pas }
uses crt;  // Including crt library;

const
    kDelayDurationAdd = 5;  // Delay time in milliseconds.
    kDelayDurationRem = 5;  // Delay time in milliseconds.
    kDelayDurationError = 3000;  // Delay for reading error message.
    kMinScrFill = 20;  // "Percentage" of minimum screen fill (integer, 5 means 20%).
    kMaxScrFill = 5;  // "Percentage" of maximum screen fill (integer, 2 means 50%).
    kColorCount = 15;  // Value of text colors (all colors except black).

type
    CellOfScreenArray = array of array of boolean;  // Type "array" (two-dimensional) for main database.
    AllColorsArray = array [1..kColorCount] of word; // Type "array" for all available colors database.

{ This function calculate "percentage" of screen fill: }
function FillCellsOfScreen(var a: CellOfScreenArray; scrWidth, scrHeight: integer): integer;
var
    i, j, totalCells, cellsCount: integer;
begin
    totalCells := scrWidth * scrHeight;
    cellsCount := 0;
    for i := 1 to scrWidth do
        for j := 1 to ScrHeight do
            if a[i, j] then
                cellsCount := cellsCount + 1;
    if cellsCount = 0 then
        cellsCount := 1;
    FillCellsOfScreen := totalCells div cellsCount
end;

{ This procedure print random color * in random position on the screen and add true to cells of array-db: }
procedure PrintRandomColorStar(var arColor: AllColorsArray; var arDb: CellOfScreenArray);
var
    cX, cY, cC: integer;
begin
    repeat
        cX := random(ScreenWidth) + 1;
        cY := random(ScreenHeight) + 1
    until not arDb[cX, cY];
    if (cX = ScreenWidth) and (cY = ScreenHeight) then
        exit;
    cC := random(kColorCount) + 1;
    GotoXY(cX, cY);
    TextColor(arColor[cC]);
    write('*');
    arDb[cX, cY] := true;
end;

{ This procedure print backspace (remove *) in random position on the screen and add FALSE to cells of array-db: }
procedure RemoveRandomStar(var arDb: CellOfScreenArray);
var
    cX, cY: integer;
begin
    repeat
        cX := random(ScreenWidth) + 1;
        cY := random(ScreenHeight) + 1
    until arDb[cX, cY];
    if (cX = ScreenWidth) and (cY = ScreenHeight) then
        exit;
    GotoXY(cX, cY);
    TextColor(Black);
    write(' ');
    arDb[cX, cY] := false;
end;

{ Main: }
var
    cellsDb: CellOfScreenArray;
    allColors: AllColorsArray =
    (
        Blue, Green, Cyan,
        Red, Magenta, Brown, LightGray,
        DarkGray, LightBlue, LightGreen, LightCyan,
        LightRed, LightMagenta, Yellow, White
    );
    scrW, scrH, i, j: integer;

begin
randomize;
clrscr;
scrW := ScreenWidth;
scrH := ScreenHeight;

{ Checking for screen orientation: } 
if (ScrW < ScrH) or (ScrW = ScrH) then
    begin
        writeln('Do you have a vertical screen orientation?;)');
        writeln('Turn it around and try again!');
        delay(kDelayDurationError);
        clrscr;
        exit
    end;

{ Initializing an array for main DB (INDEXING STARTS FROM ZERO!): }
SetLength(cellsDb, scrW + 1, scrH + 1);

{ Preparing the array and variables (blank screen): }
for i := 1 to scrW do
    for j := 1 to scrH do
        cellsDb[i, j] := false;

{ Main cycle in main block: }
while not KeyPressed do
begin
    if FillCellsOfScreen(cellsDb, scrW, scrH) > kMaxScrFill then
    begin
        PrintRandomColorStar(allColors, cellsDb);
        delay(kDelayDurationAdd)
    end
    else
        while FillCellsOfScreen(cellsDb, scrW, scrH) < kMinScrFill do
        begin
            if KeyPressed then
                break;
            RemoveRandomStar(cellsDb);
            delay(kDelayDurationRem)
        end    
end;
write(#27'[0m');
clrscr
end.
