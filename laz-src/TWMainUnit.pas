unit TWMainUnit;

{$mode objfpc}{$H+}

///////////////////////////////////////////////////////////////////////////////
// TurboWieszcz++ for Windows/Linux/WinCE/RaspberryPI/Darwin (PL), v2.0.2.6 Lazarus
// (c)2011-2022 Noniewicz.com, Jakub Noniewicz aka MoNsTeR/GDC
// FREEWARE
// last FPC used: 3.0.4 (Win), 3.0.0 (Linux Debian), 2.6.4 (Raspberry PI)
// 3.0.0 (winCE), ? (Darwin)
///////////////////////////////////////////////////////////////////////////////
// based directly on:
// previous version written for Commodore C-64 sometime in 1993
// by me (Jakub Noniewicz) and Freeak (Wojtek Kaczmarek)
// which was based on:
// idea presented in "Magazyn Amiga" magazine and implemented by Marek Pampuch.
// also inspired by version written for iPhone by Tomek (Grych) Gryszkiewicz.
// and versions written in C, JavaScript, Pascal, PHP and as CGI
// by Tomek (Grych) Gryszkiewicz.
///////////////////////////////////////////////////////////////////////////////
//created: 20110501
//update: 20110501 1910-2015 = 65
//update: 20110501 2050-2220 = 90
//update: 20110501 2320-0130 = 130
//update: 20110502 0340-0425 = 45
//update: 20110502 0450-0505 = 15
//update: 20110502 0740-0850 = 70
//update: 20110612 1550-1555 = 5
//update: 20120101 2350-2351 = 1
//---- total = 415+6 = 421 m ~= 7 h
//update: 20140619 1430-1435 = 5
//update: 20140719 1140-1155 = 15
//---- total = 421+20 = 441 m ~= 7.5 h
//update: 20150509 1555-1820 = 145
//update: 20150510 1150-1300 = 70
//update: 20150510 1430-1545 = 75
//update: 20150510 2040-2130 = 50
//---- total = 441+340 = 781 m = 13 h
//update: 20151018 2030-2105 = 35
//update: 20151025 1300-1330 = 30
//update: 20151129 1740-1810 = 30
//---- total = 781+95 = 876 m = ~14.5 h
//
//update: 20171010 1745-1805 = 20 (BDS 2 LAZ start)
//update: 20171010 2150-2315 = 85
//
//update: 20180409 2110-2115 = 5
//update: 20180409 2235-2305 = 30
//update: 20180410 1410-1415 = 5
//update: 20180410 1800-2040 = 160
//update: 20180410 2130-2300 = 90
//update: 20180410 2335-0000 = 25
//update: 20180411 0000-0045 = 45
//---
//update: 20201127 2245-2325 = 40 (Darwin try #1)
//---
//update: 20220513 1135-1136 = 1

//note: old custom opts (after conversion) were:
//-dBorland -dVer150 -dDelphi7 -dCompiler6_Up -dPUREPASCAL
//now less, some were bad!
//note: richmemo package is required (Win32/Linux/Darwin)
//http://wiki.freepascal.org/RichMemo#Installation
//note: RaspberryPi / Linux - needs gtk2
//note: Darwin - needs Cocoa
//note: RPI icon: file in home Desktop
(*
[Desktop Entry]
Name=Turbo Wieszcz++
Comment=My application which does this
Icon=/home/pi/tw-rpi/TurboWieszcz.ico
Exec=/home/pi/tw-rpi/TurboWieszcz-arm-linux
Type=Application
Encoding=UTF-8
Terminal=false
Categories=None;
*)
//note: on winCE TMemo is used instead on TRichMemo
//note: winCE requires FPC 3.0.0, code compiled with 3.0.4 does not work!


{todo:
# main:
.- [!] open src [wyczyscic kod + komentarze]
.- [!] jeszcze wiecej danych wlasnych? (np. paryjotyczne - OK)
# later/future:
- [!] [for myself 1st] print to canvas - own ask size + nice font scale with antialias
- opt to save cfg to have same wiersz later
- tez video gen
- tlo + zmienialne / or DrawThemeBackground ?
- store settings / reset ?
- www as links ?
- wince - make some more opts working
}

{CHANGELOG:
# 1.0.0.0 - 1.0.0.2
- all base stuff + some fixes
# 2.0.0.3
- changes in about
- more titles
- save as bmp/jpg
- opcja bez PL znakow (dla fontow np. jak Futurama)
- FIX: zapamietywanie fontu wiersz->about->wiersz
- opcja auto play nowy wiersz co 25s
- small menu reorganization
- 19->23 wersow std [279841 unikalnych zwrotek]
- opcja czytanie wlasnych zrodlowych wersow z pliku XML
# 2.0.1.4
- aktualizacja o (niektore) tksty z wersji na ZX Spectrum
- fix: duplicate (czy android tez?) "A w mroku świecą zębiska"
- fix: "Wookoło dzikie piarżyska" -> "Wokoło dzikie piarżyska"
# 2.0.2.5
- BDS 2 LAZ refactor and below fixes
- fix: TRichEdit -> TRichMemo
- fix: nopl v UTF8
- fix: XML
- fix: ile zrwotek - no lame
- fix: carret scroll /selStart
- jpg save [???] - dziala jednak!
- new: added hints
- new: btns w popup - click zeby open
- new: save as png
- new: updated about
- new: added fpc build infos
- hide save img on non win32 platforms
- build/test on linux/rpi - OK!
- wince version (with limits)
- build/test on wince

# EOFFIX
}

interface

uses
  LCLIntf, LCLType, LMessages,
  SysUtils, Classes, Controls, Forms, Messages, Graphics,
  Dialogs, Menus, StdCtrls, ComCtrls,
  LazUTF8,
  {$IFDEF WIN32}
  ActiveX,
  {$ENDIF}
  Variants,
  dom, XMLRead, //old delphi was: xmldom, XMLIntf, XMLDoc,
  {$IFDEF WIN32}
  RichEdit,
  {$ENDIF}
  ExtCtrls, RichMemo;

type
  TTryb = (ABAB, ABBA, AABB);

  { TFormTW }

  TFormTW = class(TForm)
    JakoPNG1: TMenuItem;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    TBnX: TToolButton;
    TBnNew: TToolButton;
    TBnDec: TToolButton;
    TBnInc: TToolButton;
    TBnA: TToolButton;
    TBnSave: TToolButton;
    SaveDlg1: TSaveDialog;
    Popup1: TPopupMenu;
    Powt1: TMenuItem;
    trybABAB: TMenuItem;
    trybABBA: TMenuItem;
    trybAABB: TMenuItem;
    N1: TMenuItem;
    Czcionka1: TMenuItem;
    FontDlg1: TFontDialog;
    PopupMenuSave: TPopupMenu;
    JakoRTF1: TMenuItem;
    JakoBMP1: TMenuItem;
    N2: TMenuItem;
    Polskieznaki1: TMenuItem;
    Bezpolskichznakw1: TMenuItem;
    JakoJGP1: TMenuItem;
    N3: TMenuItem;
    Timer1: TTimer;
    N4: TMenuItem;
    Automat1: TMenuItem;
    OpenDialog1: TOpenDialog;
    N5: TMenuItem;
    Wczytajdane1: TMenuItem;
    procedure JakoPNG1Click(Sender: TObject);
    procedure TBnNewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TBnDecClick(Sender: TObject);
    procedure TBnIncClick(Sender: TObject);
    procedure TBnAClick(Sender: TObject);
    procedure Powt1Click(Sender: TObject);
    procedure TBnSaveClick(Sender: TObject);
    procedure TBnXClick(Sender: TObject);
    procedure trybABABClick(Sender: TObject);
    procedure trybABBAClick(Sender: TObject);
    procedure trybAABBClick(Sender: TObject);
    procedure Czcionka1Click(Sender: TObject);
    procedure JakoRTF1Click(Sender: TObject);
    procedure JakoBMP1Click(Sender: TObject);
    procedure Polskieznaki1Click(Sender: TObject);
    procedure Bezpolskichznakw1Click(Sender: TObject);
    procedure JakoJGP1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Automat1Click(Sender: TObject);
    procedure Wczytajdane1Click(Sender: TObject);
  private
    {$IFDEF WINCE}
    RichEdit1: TMemo;
    {$ELSE}
    RichEdit1: TRichMemo;
    {$ENDIF}
    procedure CreateMemo;
  public
    fontname: string;
    currentLimit: integer;
    titleLimit: integer;
    nopl: boolean;
    ile: integer;
    title_id: integer;
    powtorzeniaOk: boolean;
    tryb: TTryb;
    numer: array[0..3] of array of integer;
    ending: array[0..1] of array of integer;
    data: array[0..3] of array of string;
    titles: array of string;
    procedure SubInit;
    procedure Init;
    function checkUniqOK(z, w, value: integer): boolean;
    procedure setrndrow(z, w: integer);
    function Koniec(z, w: integer; s: string): string;
    function Strofa(z, w, w0: integer): string;
    function Zwrotka(z: integer): string;
    procedure ShowIle;
    procedure DecIle;
    procedure IncIle;
    function Title: string;
    procedure Generuj(nowy: boolean);
    {$IFDEF WINCE}
    procedure WriteColor(s: string; size: integer; xcolor: TColor; ed: TMemo);
    {$ELSE}
    procedure WriteColor(s: string; size: integer; xcolor: TColor; ed: TRichMemo);
    {$ENDIF}
    {$IFDEF WIN32}
    procedure PaintAndSaveToBmp;
    procedure PaintAndSaveToJpg;
    procedure PaintAndSaveToPng;
    {$ENDIF}
    function LoadXML(FileName: string): integer;
  end;

var
  FormTW: TFormTW;

implementation

{$R *.lfm}


const
//dflt unique possibilities per row = max zwrotek
      XLIMIT = 32; //new 201510
      
      MANTRA = 'OM MANI PEME HUNG';
      DFLT_FILE = 'TurboWieszcz.rtf';
      DFLT_FILE_IMG = 'TurboWieszcz';
      CRLF = #13#10;
      AUTO_TIMER = 25*1000;
      ECNT1 = 5;  //wiecej kropek zeby zmienic rozklad prawdopodob.
      ENDINGS1: array[0..ECNT1-1] of string = ('.', '...', '.', '!', '.');
      ECNT2 = 5;
      ENDINGS2: array[0..ECNT2-1] of string = ('', '...', '', '!', '');
      TCNT = 33; //old pre 201510 = 29;
      TITLES0: array[0..TCNT-1] of string = (
              'Zagłada',
              'To już koniec',
              'Świat ginie',
              'Z wizytą w piekle',
              'Kataklizm',
              'Dzień z życia...',
              'Masakra',
              'Katastrofa',
              'Wszyscy zginiemy...',
              'Pokój?',
              'Koniec',
              'Koniec ludzkości',
              'Telefon do Boga',
              'Wieczne ciemności',
              'Mrok',
              'Mrok w środku dnia',
              'Ciemność',
              'Piorunem w łeb',
              'Marsz troli',
              'Szyderstwa Złego',
              'Okrponości świata',
              'Umrzeć po raz ostatni',
              'Potępienie',
              'Ból mózgu',
              'Wieczne wymioty',
              'Zatrute dusze',
              'Uciekaj',
              'Apokalipsa',
              'Złudzenie pryska',
              'Makabra',
              'Zagłada świata',
              'Śmierć',
              'Spokój'
      );
//ABAB, ABBA, AABB
      TRYB2ORDER: array[TTryb] of array[0..3] of integer =
                  ((0,1,2,3), (0,1,3,2), (0,2,1,3));


//unused titles:
//"Nabuchodonozor"
//"Boski wiatr"
//"Kotlina"
//"Mistrz i ..."
//"Niepokorni"
//"Wilk szary"



(* old, pre-UTF8
function tonopl(s: string): string;
var s1: string;
    i: integer;
begin
  s1 := s;
  for i := 1 to length(s1) do   //ąę śńć źż ół = ae snc zz ol
    case ord(s1[i]) of
      185: s1[i] := 'a';
      234: s1[i] := 'e';
      156: s1[i] := 's';
      241: s1[i] := 'n';
      230: s1[i] := 'c';
      159: s1[i] := 'z';
      191: s1[i] := 'z';
      243: s1[i] := 'o';
      179: s1[i] := 'l';

      165: s1[i] := 'A';
      202: s1[i] := 'E';
      140: s1[i] := 'S';
      209: s1[i] := 'N';
      198: s1[i] := 'C';
      143: s1[i] := 'Z';
      175: s1[i] := 'Z';
      211: s1[i] := 'O';
      163: s1[i] := 'L';
    end;

  Result := s1;
end; { tonopl }
*)


//ąę śńć źż ół = ae snc zz ol - but UTF8
//note: utf8 only - old - get from arch strlibplo
function tonopl(s: string): string;
begin
  result := s;
  result := UTF8StringReplace(result, 'ą', 'a', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'ę', 'e', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'ś', 's', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'ń', 'n', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'ć', 'c', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'ź', 'z', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'ż', 'z', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'ó', 'o', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'ł', 'l', [rfReplaceAll]);

  result := UTF8StringReplace(result, 'Ą', 'A', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'Ę', 'E', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'Ś', 'S', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'Ń', 'N', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'Ć', 'C', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'Ź', 'Z', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'Ż', 'Z', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'Ó', 'O', [rfReplaceAll]);
  result := UTF8StringReplace(result, 'Ł', 'L', [rfReplaceAll]);
end;

//---

procedure TFormTW.CreateMemo;
begin
  {$IFDEF WINCE}
  RichEdit1 := TMemo.Create(self);
  RichEdit1.Parent := self;
  RichEdit1.Left := 0;
  RichEdit1.Height := 560;
  RichEdit1.Top := 21;
  RichEdit1.Width := 640;
  RichEdit1.Align := alClient;
  RichEdit1.Font.CharSet := EASTEUROPE_CHARSET;
  RichEdit1.Font.Color := clWindowText;
  RichEdit1.Font.Height := -16;
  RichEdit1.Font.Name := 'Tahoma';
  RichEdit1.Font.Quality := fqAntialiased;
  RichEdit1.HideSelection := False;
  RichEdit1.ParentFont := False;
  RichEdit1.ReadOnly := True;
  RichEdit1.ScrollBars := ssBoth;
  RichEdit1.TabOrder := 1;
  {$ELSE}
  RichEdit1 := TRichMemo.Create(self);
  RichEdit1.Parent := self;
  RichEdit1.Left := 0;
  RichEdit1.Height := 560;
  RichEdit1.Top := 21;
  RichEdit1.Width := 640;
  RichEdit1.Align := alClient;
  RichEdit1.Font.CharSet := EASTEUROPE_CHARSET;
  RichEdit1.Font.Color := clWindowText;
  RichEdit1.Font.Height := -16;
  RichEdit1.Font.Name := 'Tahoma';
  RichEdit1.Font.Quality := fqAntialiased;
  RichEdit1.HideSelection := False;
  RichEdit1.ParentFont := False;
  RichEdit1.ReadOnly := True;
  RichEdit1.ScrollBars := ssBoth;
  RichEdit1.TabOrder := 1;
  RichEdit1.ZoomFactor := 1;
  {$ENDIF}
end;

//---

procedure TFormTW.TBnNewClick(Sender: TObject);
begin
  Generuj(true);
end; { TBnNewClick }

procedure TFormTW.TBnDecClick(Sender: TObject);
begin
  DecIle;
end; { TBnDecClick }

procedure TFormTW.TBnIncClick(Sender: TObject);
begin
  IncIle;
end; { TBnIncClick }

procedure TFormTW.TBnAClick(Sender: TObject);
var s: string;
begin
  RichEdit1.Clear;
  RichEdit1.Font.Name := 'Tahoma';

  WriteColor('TurboWieszcz++', 22, RGB(224, 100, 0), RichEdit1);

  s := '';
//  s := s + 'Darmowy Generator Wierszy,'+CRLF+
  s := s + 'Generator poezji (FREEWARE),'+CRLF+
           'wersja Lazarus dla Windows/Linux/RaspberryPI/WinCE, v2.0.2.6'+CRLF+
           'Platforma: ' + {$i %FPCTARGETOS%} + '/' + {$i %FPCTARGETCPU%} +
           ', FPC: ' + {$I %FPCVERSION%}+ CRLF+
           ''+CRLF+
           '(c)2011-2022 Noniewicz.com, Jakub Noniewicz aka MoNsTeR/GDC'+CRLF;
  s := s + 'http://www.noniewicz.com/'+CRLF;
  s := s + 'Dodatkowe strofy (c): Grych, Freeak, Monster, Fred i Marek Pampuch.'+CRLF;
  s := s + ''+CRLF;
  s := s + 'Oparty na poprzedniej wersji napisanej na Commodore C-64'+CRLF;
  s := s + 'gdzieś w 1993 przeze mnie i Wojtka (Freeak-a) Kaczmarka,'+CRLF;
  s := s + 'opartej z kolei na pomyśle zaprezentowanym w czasopiśmie'+CRLF;
  s := s + '"Magazyn Amiga" autorstwa Marka Pampucha.'+CRLF;
  s := s + ''+CRLF;
  s := s + 'Zainspirowany również wersją napisaną na iPhone-a'+CRLF;
  s := s + 'przez Tomka (Grycha) Gryszkiewicza:'+CRLF;
  s := s + 'http://www.tg.pl/iPhone/turboWieszcz/'+CRLF;
  s := s + ''+CRLF;
  s := s + 'Są też (moje) wersje:'+CRLF;
  s := s + '- Commodore C-64 (1993)'+CRLF;
  s := s + '- Android (2011)'+CRLF;
  s := s + '- ZX Spectrum (2015)'+CRLF;
  s := s + '- ZX81 (2017)'+CRLF;
  s := s + '- Amstrad CPC (2017)'+CRLF;
  s := s + '- Python (2017)'+CRLF;
  s := s + '- Fortran (2017)'+CRLF;
  s := s + '- Arduino (2018)'+CRLF;

  s := s + ''+CRLF;
  s := s + 'Historia programu w magazynie Ha!art 47 3/2014:'+CRLF;
  s := s + 'http://www.ha.art.pl/czasopismo/numery-czasopisma/4054-ha-art-47-3-2014'+CRLF;
  s := s + ''+CRLF;
  s := s + 'Program powinien działać na wszystkich typowych'+CRLF+
           'wersjach Windows (od 95 w górę), na ReactOS'+CRLF+
           'oraz na typowych Linux-ach i Raspberry PI'+CRLF+
           'Program nie zapamiętuje ustawień!';

  WriteColor(s, 9, clBlack, RichEdit1);

  RichEdit1.SelStart := 0;
end; { TBnAClick }

procedure TFormTW.FormCreate(Sender: TObject);
var say: string;
begin
  say := MANTRA;

  CreateMemo;

  ile := 4;
  trybABAB.Checked := true;
  tryb := ABAB;
  powtorzeniaOk := false;
  Polskieznaki1.Checked := true;
  nopl := false;

  {$IFNDEF WIN32}
  self.JakoBMP1.Visible := false;
  self.JakoJGP1.Visible := false;
  self.JakoPNG1.Visible := false;
  {$ENDIF}

  {$IFDEF WINCE}
  ToolBar1.Wrapable := true;
  self.Czcionka1.Visible := false;
  TBnSave.Visible := false;
  Wczytajdane1.Visible := false;
  {$ELSE}
  ToolBar1.Wrapable := false;
  self.Constraints.MinWidth := 480;
  self.Constraints.MinHeight := 128;
  {$ENDIF}

  fontname := RichEdit1.Font.Name;
  randomize;
  Init;
end; { FormCreate }

procedure TFormTW.SubInit;
var i: integer;
begin
  for i := 0 to 3 do setlength(data[i], currentLimit);

  setlength(numer[0], currentLimit);
  setlength(numer[1], currentLimit);
  setlength(numer[2], currentLimit);
  setlength(numer[3], currentLimit);

  setlength(ending[0], currentLimit);
  setlength(ending[1], currentLimit);

  setlength(titles, titleLimit);
end; { SubInit }

procedure TFormTW.Init;
var i: integer;
begin
  currentLimit := XLIMIT;
  titleLimit := TCNT;
  SubInit;

//tytuly dflt
  for i := 0 to high(TITLES0) do
    titles[i] := TITLES0[i];

///////////////////////////////////////////////
//po 10
       data[0][0]  := 'Czy na te zbrodnie nie będzie kary?'; //updated
       data[0][1]  := 'Opustoszały bagna, moczary';
       data[0][2]  := 'Na nic się modły zdadzą ni czary';
       data[0][3]  := 'Z krwi mordowanych sączą puchary';
       data[0][4]  := 'To nietoperze, węże, kalmary';
       data[0][5]  := 'Próżno nieszczęśni sypią talary';
       data[0][6]  := 'Za co nam znosić takie ciężary';
       data[0][7]  := 'Złowrogo iskrzą kóbr okulary';
       data[0][8]  := 'Próżno swe modły wznosi wikary';	//new
       data[0][9]  := 'Pustoszą sny twoje złe nocne mary';	//new
       data[0][10] := 'Próżno nieszczęśnik sypie talary'; //grych
       data[0][11] := 'Przedziwnie tka się życia logarytm'; //grych
       data[0][12] := 'Już Strach wypuścił swoje ogary'; //grych
       data[0][13] := 'Niebawem zginiesz w szponach poczwary'; //grych
       data[0][14] := 'Wbijają pale złote kafary'; //grych
       data[0][15] := 'Życie odkrywa swoje przywary'; //grych
       data[0][16] := 'Na dnie ponurej, pustej pieczary'; //grych
       data[0][17] := 'Apokalipsy nadeszły czary'; //frk
       data[0][18] := 'Upadły anioł wspomina chwałę'; //frk
       data[0][19] := 'Życie ukrywa swoje przywary'; //grych LAME but used
       data[0][20] := 'Dziwnych owadów wzlatują chmary'; //new 201505
       data[0][21] := 'Bombowce biorą nasze namiary'; //201505 restored
       data[0][22] := 'Nie da się chwycić z czartem za bary'; //201505 restored
       //from zx ver 201510 jn
       data[0][23] := 'Próżno frajerzy sypią talary';
       data[0][24] := 'Nie da sie wyrwać czartom towaru';
       data[0][25] := 'Po co nam sączyć podłe browary';
       data[0][26] := 'Diler już nie dostarczy towaru';
       data[0][27] := 'Lokomotywa nie ma już pary';
       data[0][28] := 'Gdy nie każdego stać na browary';
       data[0][29] := 'Pożarł Hilary swe okulary';
       data[0][30] := 'Spowiły nas trujące opary';
       data[0][31] := 'To nie jest całka ani logarytm';

//zx - unused here       
//       data[0][?] := 'Smutno patrzysz na puste bazary';
//       data[0][?] := 'I oto giniesz w paszczy poczwary';
//       data[0][?] := 'A na te zbrodnie nie będzie kary';
//       data[0][?] := 'Przedziwnie tkany życia logarytm';
//       data[0][?] := 'Juz Strach wypuszcza swoje ogary';

//unused - OLD
//Runęły mądrości filary //frk - BAD
//Przestróg nie słucha lud ogłupiały

///////////////////////////////////////////////
//po 8
       data[1][0]  := 'Już na arenę krew tryska';
       data[1][1]  := 'Już piana cieknie im z pyska';
       data[1][2]  := 'Już hen w oddali gdzieś błyska';
       data[1][3]  := 'Śmierć w kącie czai się bliska';
       data[1][4]  := 'Niesamowite duchów igrzyska';
       data[1][5]  := 'Już zaciskając łapiska';
       data[1][6]  := 'Zamiast pozostać w zamczyskach';
       data[1][7]  := 'Rzeka wylewa z łożyska';
       data[1][8]  := 'Nieszczęść wylała się miska';	//new
       data[1][9]  := 'Już zaciskając zębiska'; //my
       data[1][10] := 'Otwarta nieszczęść walizka'; //grych
       data[1][11] := 'Niczym na rzymskich boiskach'; //grych
       data[1][12] := 'Czart wznieca swe paleniska'; //my
       data[1][13] := 'A w mroku świecą zębiska'; //grych - fix
       data[1][14] := 'Zewsząd dochodzą wyzwiska'; //grych
       data[1][15] := 'Świętych głód wiary przyciska'; //my
       data[1][16] := 'Ponuro patrzy z ich pyska'; //grych
       data[1][17] := 'Mgła stoi na uroczyskach'; //frk
       data[1][18] := 'Kości pogrzebią urwiska'; //frk
       data[1][19] := 'Głód wiary tak nas przyciska'; //grych - BAD - fixed
       data[1][20] := 'Runęły skalne zwaliska';
       data[1][21] := 'Czart rozpala paleniska'; //grych - BAD fixed 201505
//       data[1][22] := 'A w mroku świecą zębiska'; //grych - BAD fixed [DUPLICATE] removed 20151129
       data[1][22] := 'A w mroku słychać wyzwiska'; //added 20151129
       //zx new 201510 jn
       data[1][23] := 'Znów pusta żebraka miska';
       data[1][24] := 'Diabelskie to są igrzyska';
       data[1][25] := 'Nie powiedz diabłu nazwiska';
       data[1][26] := 'Najgłośniej słychać wyzwiska';
       data[1][27] := 'Diabelskie mają nazwiska';
       data[1][28] := 'Tam uciekają ludziska';
       data[1][29] := 'Tak rzecze stara hipiska';
       data[1][30] := 'Gdzie dawne ludzi siedliska';
       data[1][31] := 'Najgłośniej piszczy hipiska';

///////////////////////////////////////////////
//po 10
       data[2][0]  := 'Rwą pazurami swoje ofiary';
       data[2][1]  := 'Nic nie pomoże tu druid stary';
       data[2][2]  := 'To nocne zjawy i senne mary';
       data[2][3]  := 'Niegroźne przy nich lwowskie batiary';
       data[2][4]  := 'Pod wodzą księżnej diablic Tamary';
       data[2][5]  := 'Z dala straszliwe trąbia fanfary';
       data[2][6]  := 'Skąd ich przywiodły piekła bezmiary';
       data[2][7]  := 'Zaś dookoła łuny, pożary';
       data[2][8]  := 'A twoje ciało rozszarpie Wilk Szary';	//new
       data[2][9]  := 'Tu nie pomoże już siła wiary'; //my
       data[2][10] := 'Tak cudzych nieszczęść piją nektary'; //grych
       data[2][11] := 'Wszystko zalewa wrzący liparyt'; //grych
       data[2][12] := 'Zabójcze są ich niecne zamiary'; //my
       data[2][13] := 'Zatrute dusze łączą się w pary'; //grych
       data[2][14] := 'Świat pokazuje swoje wymiary'; //grych
       data[2][15] := 'Z życiem się teraz weźmiesz za bary'; //my
       data[2][16] := 'Brak uczuć, chęci, czasem brak wiary'; //grych
       data[2][17] := 'Wspomnij, co mówił Mickiewicz stary'; //frk
       data[2][18] := 'Spalonych lasów straszą hektary'; //frk
       data[2][19] := 'Z życiem się dzisiaj weźmiesz za bary'; //grych - BAD - fixed
       data[2][20] := 'Ksiądz pozostaje nagle bez wiary'; //jn 201505 new
       data[2][21] := 'Papież zaczyna odprawiać czary'; //jn 201505 new
       data[2][22] := 'Tu nie pomoże paciorek, stary'; //jn 201505 new
       //zx new 201510 jn
       data[2][23] := 'Niegroźne przy nich nawet Atari';
       data[2][24] := 'Takie są oto piekła bezmiary';
       data[2][25] := 'A teraz nagle jesteś już stary';
       data[2][26] := 'Mordercy liczą swoje ofiary';
       data[2][27] := 'I bez wartości są już dolary';
       data[2][28] := 'Gdzie się podziały te nenufary';
       data[2][29] := 'Upada oto dąb ten prastary';
       data[2][30] := 'Bystro śmigają nawet niezdary';
       data[2][31] := 'Już nieruchome ich awatary';

//zx unused here
//       data[2][?] := 'Powodź zalewa wielkie obszary';
//       data[2][?] := 'I uderzają z siłą Niagary';
//       data[2][?] := 'Tak nas zabiją groźne pulsary';
//       data[2][?] := 'Tu nie pomoże elektryk stary';
//       data[2][?] := 'Pod wodzą księżnej diablic Azary';
//       data[2][?] := 'Pomnij, a mówił Mickiewicz stary';
//       data[2][?] := 'Cudze nieszczęście moje nektary';
//       data[2][?] := 'Brak uczuć, chęci a także wiary';
//       data[2][?] := 'Aż rozpadają się i filary';

///////////////////////////////////////////////
//po 8
       data[3][0]  := 'Wnet na nas też przyjdzie kryska';
       data[3][1]  := 'Znikąd żadnego schroniska';
       data[3][2]  := 'Powietrze tnie świst biczyska';
       data[3][3]  := 'Rodem z czarciego urwiska';
       data[3][4]  := 'I swąd nieznośny się wciska';
       data[3][5]  := 'Huk, jak z wielkiego lotniska';
       data[3][6]  := 'Złowroga brzmią ich nazwiska';
       data[3][7]  := 'W kącie nieśmiało ktoś piska';
       data[3][8]  := 'Ktoś obok morduje liska';	//new
       data[3][9]  := 'Krwią ociekają zębiska'; //my
       data[3][10] := 'Wokoło dzikie piarżyska'; //grych, 20151129 fix JN
       data[3][11] := 'I żądza czai się niska'; //grych
       data[3][12] := 'Diabeł cię dzisiaj wyzyska'; //grych
       data[3][13] := 'Płoną zagłady ogniska'; //grych
       data[3][14] := 'Gwałt niech się gwałtem odciska!'; //grych
       data[3][15] := 'Stoisz na skraju urwiska'; //my
       data[3][16] := 'Tam szatan czarta wyiska'; //grych
       data[3][17] := 'Uciekaj, przyszłość jest mglista'; //frk, 20151025 changed
       data[3][18] := 'Nadziei złudzenie pryska'; //frk
       data[3][19] := 'Wydziobią oczy ptaszyska'; //grych - BAD fixed
       data[3][20] := 'Padają łby na klepisko'; //new 201505 - restored
       data[3][21] := 'Śmierć zbiera żniwo w kołyskach'; //new 201505 - restored
       data[3][22] := 'Coś znowu zgrzyta w łożyskach'; //jn new 201505
       //zx new 201510 jn
       data[3][23] := 'Spadasz z wielkiego urwiska';
       data[3][24] := 'Lawa spod ziemi wytryska';
       data[3][25] := 'Wokoło grzmi albo błyska';
       data[3][26] := 'Fałszywe złoto połyska';
       data[3][27] := 'Najwięcej czart tu uzyska';
       data[3][28] := 'Owieczki Zły tu pozyska';
       data[3][29] := 'Owieczki spadły z urwiska';
       data[3][30] := 'Snują się dymy z ogniska';
       data[3][31] := 'To czarne lecą ptaszyska';

end; { Init }

procedure TFormTW.FormShow(Sender: TObject);
begin
  Panel1.Font.Color := RGB(224, 110, 0);
  ShowIle;
  Generuj(true);
end; { FormShow }

function TFormTW.Koniec(z, w: integer; s: string): string;
var chk: boolean;
begin
  chk := true;
  if length(s) > 0 then
    if s[length(s)] in ['?', '!'] then chk := false;

  result := '';
  if (w = 1) and chk then result := ENDINGS2[ending[0][z]];
  if (w = 3) and chk then result := ENDINGS1[ending[1][z]];
end; { Koniec }

function TFormTW.Strofa(z, w, w0: integer): string;
var s: string;
begin
  s := data[w][numer[w, z]];
  result := ' '+s+Koniec(z, w0, s)+CRLF;  //tu byl crash?
end; { Strofa }

function TFormTW.Zwrotka(z: integer): string;
begin
  result := Strofa(z, TRYB2ORDER[tryb][0], 0)+
            Strofa(z, TRYB2ORDER[tryb][1], 1)+
            Strofa(z, TRYB2ORDER[tryb][2], 2)+
            Strofa(z, TRYB2ORDER[tryb][3], 3);
end; { Zwrotka }

procedure TFormTW.Timer1Timer(Sender: TObject);
begin
  Generuj(true);
end; { Timer1Timer }

function TFormTW.Title: string;
begin
  result := ' ' + titles[title_id];
end; { Title }

procedure TFormTW.trybAABBClick(Sender: TObject);
begin
  trybAABB.Checked := true;
  tryb := AABB;
end; { trybAABBClick }

procedure TFormTW.trybABABClick(Sender: TObject);
begin
  trybABAB.Checked := true;
  tryb := ABAB;
end; { trybABABClick }

procedure TFormTW.trybABBAClick(Sender: TObject);
begin
  trybABBA.Checked := true;
  tryb := ABBA;
end; { trybABBAClick }

procedure TFormTW.Generuj(nowy: boolean);
var fs, z, w: integer;
begin
  RichEdit1.Clear;
  RichEdit1.Font.Name := fontname;

  if (ile < 1) then exit;

  if nowy then
  begin
    title_id := random(titleLimit);

    for z := 1 to ile do
    begin
      for w := 0 to 3 do numer[w][z-1] := -1;
      ending[0][z-1] := random(ECNT2);
      ending[1][z-1] := random(ECNT1);
    end;

    //set rnd
    for z := 1 to ile do
      for w := 0 to 3 do
        setrndrow(z-1, w);
  end;

  fs := RichEdit1.Font.Size;

  //title
  WriteColor('', 6, clBlack, RichEdit1);
  WriteColor(Title, fs*2, clBlack, RichEdit1);
  WriteColor('', fs, clBlack, RichEdit1);

  //build
  for z := 1 to ile do
    WriteColor(zwrotka(z-1), fs, clBlack, RichEdit1);

  //scroll to top
  RichEdit1.SelStart := 0;
  {$IFDEF WIN32}
  //will it work wo this?
//  SendMessage(RichEdit1.handle, EM_SCROLLCARET, 0, 0);
  {$ENDIF}

  //copy
(*
  RichEdit1.SelStart := 0;
  RichEdit1.SelectAll;
  RichEdit1.CopyToClipboard;
  RichEdit1.SelLength := 0;
*)
end; { Generuj }

procedure TFormTW.ShowIle;
begin
  Panel1.Caption := 'Zwrotek: ' + inttostr(ile) + ' ';
end; { ShowIle }

procedure TFormTW.Czcionka1Click(Sender: TObject);
begin
  FontDlg1.Font.Assign(RichEdit1.Font);
  if FontDlg1.Execute then
  begin
    RichEdit1.Font.Assign(FontDlg1.Font);
    fontname := RichEdit1.Font.Name;
    Generuj(false);
  end;
end; { Czcionka1Click }

procedure TFormTW.DecIle;
begin
  dec(ile);
  if (ile = 0) then ile := 1;
  ShowIle;
end; { DecIle }

procedure TFormTW.IncIle;
begin
  inc(ile);
  if (ile = currentLimit) then ile := currentLimit-1;
  ShowIle;
end; { IncIle }

procedure TFormTW.JakoBMP1Click(Sender: TObject);
begin
  {$IFDEF WIN32}
  PaintAndSaveToBmp;
  {$ENDIF}
end; { JakoBMP1Click }

procedure TFormTW.JakoJGP1Click(Sender: TObject);
begin
  {$IFDEF WIN32}
  PaintAndSaveToJpg;
  {$ENDIF}
end; { JakoJGP1Click }

procedure TFormTW.JakoPNG1Click(Sender: TObject);
begin
  {$IFDEF WIN32}
  PaintAndSaveToPng;
  {$ENDIF}
end;

procedure TFormTW.JakoRTF1Click(Sender: TObject);
begin
  SaveDlg1.FileName := DFLT_FILE;
  SaveDlg1.DefaultExt := 'rtf';
  SaveDlg1.Filter := 'RTF (*.rtf)|*.rtf';
  if SaveDlg1.Execute then
  try
    RichEdit1.Lines.SaveToFile(SaveDlg1.FileName);
  except
    On E: Exception do
      showmessage('Problem przy zapisie do pliku:'#13#10+E.Message);
  end;
end; { JakoRTF1Click }

procedure TFormTW.Polskieznaki1Click(Sender: TObject);
begin
  Polskieznaki1.Checked := true;
  nopl := false;
  Generuj(false);  
end; { Polskieznaki1Click }

procedure TFormTW.Powt1Click(Sender: TObject);
begin
  Powt1.Checked := not Powt1.Checked;
  powtorzeniaOk := Powt1.Checked;  //consistency?
end; { Powt1Click }

procedure TFormTW.TBnSaveClick(Sender: TObject);
var p: TPoint;
begin
  p := TBnSave.ClientToScreen(point(0, 0));
  TBnSave.DropdownMenu.Popup(p.x, p.y + TBnSave.Height);
end;

procedure TFormTW.TBnXClick(Sender: TObject);
var p: TPoint;
begin
  p := TBnX.ClientToScreen(point(0, 0));
  TBnX.DropdownMenu.Popup(p.x, p.y + TBnX.Height);
end;

procedure TFormTW.Automat1Click(Sender: TObject);
begin
  Timer1.Interval := AUTO_TIMER;
  Timer1.Enabled := not Timer1.Enabled;
  Automat1.Checked := not Automat1.Checked;
end; { Automat1Click }

procedure TFormTW.Bezpolskichznakw1Click(Sender: TObject);
begin
  Bezpolskichznakw1.Checked := true;
  nopl := true;
  Generuj(false);
end; { Bezpolskichznakw1Click }

function TFormTW.checkUniqOK(z, w, value: integer): boolean;
var i: integer;
    r: boolean;
begin
  r := true;
  if not powtorzeniaOk then
    for i := 0 to z-1 do
      if (numer[w][i] = value) then r := false;
  result := r;
end; { checkUniqOK }

procedure TFormTW.setrndrow(z, w: integer);
begin
  repeat
    numer[w][z] := random(currentLimit);
  until (z = 0) or checkUniqOK(z, w, numer[w][z]);
end; { setrndrow }

procedure TFormTW.Wczytajdane1Click(Sender: TObject);
var res: integer;
begin
  if OpenDialog1.Execute then
  begin
    res := LoadXML(OpenDialog1.FileName);
    if res <> 0 then
    begin
      Init; //fallback to default on error
      MessageDlg('Błąd ładowania danych z XML!', mtError, [mbOK], 0);
    end
    else
    begin
      if (ile >= currentLimit) then ile := currentLimit-1;
      ShowIle;
    end;
  end;
end; { Wczytajdane1Click }

{$IFDEF WINCE}
procedure TFormTW.WriteColor(s: string; size: integer; xcolor: TColor; ed: TMemo);
{$ELSE}
procedure TFormTW.WriteColor(s: string; size: integer; xcolor: TColor; ed: TRichMemo);
{$ENDIF}
begin
  if assigned(ed) then
  begin
    ed.SelStart := length(ed.Lines.Text);
    if nopl then
      ed.SelText := tonopl(s+CRLF)
    else
      ed.SelText := s+CRLF;
    {$IFDEF WINCE}
    //no color/style for winCE
    {$ELSE}
    ed.SetRangeParams(ed.SelStart, ed.SelLength, [tmm_Color, tmm_Size], ed.Font.Name, size, xcolor, [], []);
    {$ENDIF}
  end;
end; { WriteColor }

{$IFDEF WIN32}

//http://forum.4programmers.net/Delphi_Pascal/155775-Z_rich_edita_do_bitmapy
function PrintToCanvas(ACanvas: TCanvas; FromChar, ToChar: integer;
                      ARichEdit: TRichMemo; AWidth, AHeight: integer): Longint;
var Range: TFormatRange;
begin
  FillChar(Range, SizeOf(TFormatRange), 0);
  Range.hdc        := ACanvas.handle;
  Range.hdcTarget  := ACanvas.Handle;
  Range.rc.left    := 0;
  Range.rc.top     := 0;
  Range.rc.right   := AWidth * 1440 div Screen.PixelsPerInch;
  Range.rc.Bottom  := AHeight * 1440 div Screen.PixelsPerInch;
  Range.chrg.cpMax := ToChar;
  Range.chrg.cpMin := FromChar;
  Result := SendMessage(ARichedit.Handle, EM_FORMATRANGE, 1, Longint(@Range));
  SendMessage(ARichEdit.handle, EM_FORMATRANGE, 0, 0);
end; { PrintToCanvas }

procedure TFormTW.PaintAndSaveToBmp;
var bmp: TBitmap;
begin
  if ile > 4 then
  begin
    Showmessage('Zapis jako obrazek działa tylko dla maksymalnie 4 zwrotek.');
    exit;
  end;

  bmp := TBitmap.Create;
  bmp.width := RichEdit1.width;
  bmp.height := RichEdit1.height;
  bmp.PixelFormat := pf24Bit;
  bmp.Canvas.Brush.Style := bsSolid;
  bmp.Canvas.Brush.Color := clWhite;
  bmp.Canvas.FillRect(RECT(0, 0, bmp.width, bmp.height));

  SaveDlg1.FileName := DFLT_FILE_IMG+'-'+FormatDateTime('yyyymmdd-hhnnss', now)+'.bmp';
  SaveDlg1.DefaultExt := 'bmp';
  SaveDlg1.Filter := 'Obraz BMP (*.bmp)|*.bmp';
  if SaveDlg1.Execute then
  try
    PrintToCanvas(bmp.Canvas, 0, length(RichEdit1.Text)-1, RichEdit1, bmp.Width, bmp.Height);
    bmp.SaveToFile(SaveDlg1.FileName);
  except
  end;

  bmp.Free;
end; { PaintAndSaveToBmp }

procedure TFormTW.PaintAndSaveToJpg;
var bmp: TBitmap;
    jpg: TJpegImage;
begin
  if ile > 4 then
  begin
    Showmessage('Zapis jako obrazek działa tylko dla maksymalnie 4 zwrotek.');
    exit;
  end;

  jpg := TJpegImage.Create;
  bmp := TBitmap.Create;
  bmp.width := RichEdit1.width;
  bmp.height := RichEdit1.height;
  bmp.PixelFormat := pf24Bit;
  bmp.Canvas.Brush.Style := bsSolid;
  bmp.Canvas.Brush.Color := clWhite;
  bmp.Canvas.FillRect(RECT(0, 0, bmp.width, bmp.height));

  SaveDlg1.FileName := DFLT_FILE_IMG+'-'+FormatDateTime('yyyymmdd-hhnnss', now)+'.jpg';
  SaveDlg1.DefaultExt := 'jpg';
  SaveDlg1.Filter := 'Obraz JPG (*.jpg)|*.jpg';
  if SaveDlg1.Execute then
  try
    PrintToCanvas(bmp.Canvas, 0, length(RichEdit1.Text)-1, RichEdit1, bmp.Width, bmp.Height);
    jpg.Assign(bmp);
    jpg.SaveToFile(SaveDlg1.FileName);
  except
  end;

  bmp.Free;
  jpg.Free;
end; { PaintAndSaveToJpg }

procedure TFormTW.PaintAndSaveToPng;
var bmp: TBitmap;
    png: TPortableNetworkGraphic;  //png: tpngobject;
begin
  if ile > 4 then
  begin
    Showmessage('Zapis jako obrazek działa tylko dla maksymalnie 4 zwrotek.');
    exit;
  end;

  png := TPortableNetworkGraphic.Create;  //png := tpngobject.Create;
  bmp := TBitmap.Create;
  bmp.width := RichEdit1.width;
  bmp.height := RichEdit1.height;
  bmp.PixelFormat := pf24Bit;
  bmp.Canvas.Brush.Style := bsSolid;
  bmp.Canvas.Brush.Color := clWhite;
  bmp.Canvas.FillRect(RECT(0, 0, bmp.width, bmp.height));

  SaveDlg1.FileName := DFLT_FILE_IMG+'-'+FormatDateTime('yyyymmdd-hhnnss', now)+'.png';
  SaveDlg1.DefaultExt := 'png';
  SaveDlg1.Filter := 'Obraz PNG (*.png)|*.png';
  if SaveDlg1.Execute then
  try
    PrintToCanvas(bmp.Canvas, 0, length(RichEdit1.Text)-1, RichEdit1, bmp.Width, bmp.Height);
    png.Assign(bmp);
    png.SaveToFile(SaveDlg1.FileName);
  except
  end;

  bmp.Free;
  png.Free;
end; { PaintAndSaveToPng }

{$ENDIF}

function TFormTW.LoadXML(FileName: string): integer;
var FXML: TXMLDocument;
    n, i, cnt: integer;
    s: string;
    data_tmp: array[0..3] of array of string;
    error: boolean;
    ndata: array [1..4] of TDOMNode;
    ntitles, root: TDOMNode;
    node: TDOMNode;
begin
  FXML := nil;
  ndata[1] := nil;
  ndata[2] := nil;
  ndata[3] := nil;
  ndata[4] := nil;
  ntitles := nil;

  try
    ReadXMLFile(FXML, FileName);

    root := FXML.FindNode('wieszcz');
    ntitles := root.FindNode('tytul');
    ndata[1] := root.FindNode('wers1');
    ndata[2] := root.FindNode('wers2');
    ndata[3] := root.FindNode('wers3');
    ndata[4] := root.FindNode('wers4');

    cnt := 0;
    setlength(titles, 0);
    if ntitles <> nil then
      for i := 0 to ntitles.ChildNodes.Count - 1 do
      begin
        s := ntitles.ChildNodes[i].TextContent;
        if trim(s) <> '' then
        begin
          inc(cnt);
          setlength(titles, cnt);
          titles[cnt-1] := s;
        end;
      end;
    titleLimit := cnt;

    //fix for bad user XML
    if titleLimit = 0 then
    begin
      titleLimit := 1;
      setlength(titles, 1);
      titles[0] := 'Bez tytułu';
    end;

    for n := 1 to 4 do
    begin
      setlength(data_tmp[n-1], 0);
      cnt := 0;
      if ndata[n] <> nil then
        for i := 0 to ndata[n].ChildNodes.Count - 1 do
        begin
          s := ndata[n].ChildNodes[i].TextContent;
          if trim(s) <> '' then
          begin
            inc(cnt);
            setlength(data_tmp[n-1], cnt);
            data_tmp[n-1][cnt-1] := s;
          end;
        end;
    end;

    currentLimit := 0;
    for n := 1 to 4 do
      if length(data_tmp[n-1]) > currentLimit then
        currentLimit := length(data_tmp[n-1]);

    //fix for bad user XML
    error := false;
    if currentLimit = 0 then
    begin
      currentLimit := 4;
      error := true;
    end;

    SubInit;

    for n := 1 to 4 do
      for i := 0 to currentLimit-1 do
        data[n-1][i] := '--- brak wersu ---';

    if error then
    begin
      for n := 1 to 4 do
        for i := 0 to currentLimit-1 do
          data[n-1][i] := 'Brak danych '+inttostr(n)+'/'+inttostr(i+1);
    end
    else
    begin
      for n := 1 to 4 do
        for i := 0 to high(data_tmp[n-1]) do
          data[n-1][i] := data_tmp[n-1][i];
    end;

    result := 0;
  except
    on E: Exception do
    begin
      //showmessage('DEBUG: ERR: '+E.Message);
      result := -1;
    end;
  end;
  if assigned(FXML) then
    FXML.Free;
end; { LoadXML }


initialization
 {$IFDEF WIN32}
 CoInitialize(nil);
 {$ENDIF}

finalization
  {$IFDEF WIN32}
  CoUnInitialize;
  {$ENDIF}

end.

