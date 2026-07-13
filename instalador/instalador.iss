; Instalador da tradução PT-BR — FINAL FANTASY X-2 HD Remaster (Steam)
; Copia apenas arquivos da tradução para a pasta do jogo, sem alterar dados originais.

#define MyAppName "Tradução PT-BR - FINAL FANTASY X-2 HD Remaster"
#define MyAppVersion "1.0"
#define MyAppPublisher "Carlos Alexandre de Oliveira"
#define NomePastaJogo "FINAL FANTASY FFX&FFX-2 HD Remaster"
#define SteamAppId "359870"

[Setup]
AppId={{C4E8A1F3-9B2D-4F6E-A7C0-3D5E8B1F9A2C}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#NomePastaJogo}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=admin
UninstallFilesDir={commonappdata}\FFX2-Traducao-PTBR
UninstallDisplayName={#MyAppName}
WizardStyle=modern
WizardImageFile=assets\wizard-imagem.bmp
WizardSmallImageFile=assets\wizard-logo.bmp
SetupIconFile=assets\icone.ico
Compression=lzma2
SolidCompression=yes
OutputDir=saida
OutputBaseFilename=FFX2-Traducao-PTBR-Setup
UsePreviousAppDir=yes
ChangesAssociations=no
AllowNoIcons=yes
AlwaysShowDirOnReadyPage=yes

[Languages]
Name: "portuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
Source: "..\arquivos-do-jogo\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[UninstallDelete]
Type: files; Name: "{app}\hook.log"

[Code]
const
  NOME_PASTA_JOGO = '{#NomePastaJogo}';
  STEAM_APP_ID = '{#SteamAppId}';

var
  CaminhoJogoDetectado: String;
  AjudaDirExibida: Boolean;

function ValidarPastaJogo(const Caminho: String): Boolean;
begin
  Result :=
    (Caminho <> '') and
    DirExists(Caminho) and
    FileExists(Caminho + '\FFX-2.exe') and
    FileExists(Caminho + '\FFX2_Data.vbf');
end;

function NormalizarCaminho(const Caminho: String): String;
begin
  Result := Caminho;
  StringChangeEx(Result, '/', '\', True);
  if (Result <> '') and (Result[Length(Result)] = '\') then
    Delete(Result, Length(Result), 1);
end;

function ExtrairStringsAspas(const Linha: String): TArrayOfString;
var
  I, Inicio: Integer;
  Dentro: Boolean;
  Lista: TArrayOfString;
begin
  SetArrayLength(Lista, 0);
  Dentro := False;
  Inicio := 0;

  for I := 1 to Length(Linha) do
  begin
    if Linha[I] = '"' then
    begin
      if not Dentro then
        Inicio := I + 1
      else
      begin
        SetArrayLength(Lista, GetArrayLength(Lista) + 1);
        Lista[GetArrayLength(Lista) - 1] := Copy(Linha, Inicio, I - Inicio);
      end;
      Dentro := not Dentro;
    end;
  end;

  Result := Lista;
end;

function ExtrairValorVDF(const Linha, Chave: String): String;
var
  Partes: TArrayOfString;
begin
  Result := '';
  if Pos('"' + LowerCase(Chave) + '"', LowerCase(Linha)) = 0 then
    Exit;

  Partes := ExtrairStringsAspas(Linha);
  if GetArrayLength(Partes) >= 2 then
  begin
    if CompareText(Partes[0], Chave) = 0 then
      Result := Partes[1]
    else if StrToIntDef(Partes[0], -1) >= 0 then
      Result := Partes[1];
  end;

  StringChangeEx(Result, '\\', '\', True);
end;

function BibliotecaJaListada(const Bibliotecas: TArrayOfString; const Caminho: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to GetArrayLength(Bibliotecas) - 1 do
    if CompareText(NormalizarCaminho(Bibliotecas[I]), NormalizarCaminho(Caminho)) = 0 then
    begin
      Result := True;
      Exit;
    end;
end;

procedure AdicionarBiblioteca(var Bibliotecas: TArrayOfString; const Caminho: String);
var
  Normalizado: String;
begin
  Normalizado := NormalizarCaminho(Caminho);
  if (Normalizado <> '') and DirExists(Normalizado) and
     not BibliotecaJaListada(Bibliotecas, Normalizado) then
  begin
    SetArrayLength(Bibliotecas, GetArrayLength(Bibliotecas) + 1);
    Bibliotecas[GetArrayLength(Bibliotecas) - 1] := Normalizado;
  end;
end;

function ObterCaminhoSteam(): String;
var
  Valor: String;
begin
  Result := '';
  if RegQueryStringValue(HKEY_CURRENT_USER, 'Software\Valve\Steam', 'SteamPath', Valor) then
    Result := NormalizarCaminho(Valor)
  else if RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SOFTWARE\WOW6432Node\Valve\Steam', 'InstallPath', Valor) then
    Result := NormalizarCaminho(Valor);
end;

procedure LerBibliotecasSteam(const CaminhoSteam: String; var Bibliotecas: TArrayOfString);
var
  ArquivoVDF: String;
  Linhas: TArrayOfString;
  Partes: TArrayOfString;
  I: Integer;
  CaminhoLib: String;
begin
  SetArrayLength(Bibliotecas, 0);
  AdicionarBiblioteca(Bibliotecas, CaminhoSteam);

  ArquivoVDF := CaminhoSteam + '\steamapps\libraryfolders.vdf';
  if not FileExists(ArquivoVDF) then
    Exit;

  if LoadStringsFromFile(ArquivoVDF, Linhas) then
    for I := 0 to GetArrayLength(Linhas) - 1 do
    begin
      CaminhoLib := ExtrairValorVDF(Linhas[I], 'path');
      if CaminhoLib = '' then
      begin
        { Formato antigo do VDF: "1" "D:\SteamLibrary" (sem chave "path") }
        Partes := ExtrairStringsAspas(Linhas[I]);
        if (GetArrayLength(Partes) >= 2) and (StrToIntDef(Partes[0], -1) >= 0) and
           (Pos('\', Partes[1]) > 0) then
        begin
          CaminhoLib := Partes[1];
          StringChangeEx(CaminhoLib, '\\', '\', True);
        end;
      end;
      if CaminhoLib <> '' then
        AdicionarBiblioteca(Bibliotecas, CaminhoLib);
    end;
end;

function LerInstallDirDoManifest(const CaminhoBiblioteca: String): String;
var
  Manifesto: String;
  Linhas: TArrayOfString;
  I: Integer;
begin
  Result := '';
  Manifesto := CaminhoBiblioteca + '\steamapps\appmanifest_' + STEAM_APP_ID + '.acf';
  if not FileExists(Manifesto) then
    Exit;

  if LoadStringsFromFile(Manifesto, Linhas) then
    for I := 0 to GetArrayLength(Linhas) - 1 do
    begin
      Result := ExtrairValorVDF(Linhas[I], 'installdir');
      if Result <> '' then
        Exit;
    end;
end;

function MontarCaminhosCandidatos(const CaminhoBiblioteca: String): TArrayOfString;
var
  Candidatos: TArrayOfString;
  InstallDir: String;
begin
  SetArrayLength(Candidatos, 0);

  SetArrayLength(Candidatos, 1);
  Candidatos[0] := CaminhoBiblioteca + '\steamapps\common\' + NOME_PASTA_JOGO;

  InstallDir := LerInstallDirDoManifest(CaminhoBiblioteca);
  if InstallDir <> '' then
  begin
    SetArrayLength(Candidatos, GetArrayLength(Candidatos) + 1);
    Candidatos[GetArrayLength(Candidatos) - 1] :=
      CaminhoBiblioteca + '\steamapps\common\' + InstallDir;
  end;

  Result := Candidatos;
end;

function DetectarPastaJogo(): String;
var
  CaminhoSteam: String;
  Bibliotecas: TArrayOfString;
  Candidatos: TArrayOfString;
  I, J: Integer;
  Caminho: String;
begin
  Result := '';
  CaminhoSteam := ObterCaminhoSteam();
  if CaminhoSteam = '' then
    Exit;

  LerBibliotecasSteam(CaminhoSteam, Bibliotecas);

  for I := 0 to GetArrayLength(Bibliotecas) - 1 do
  begin
    Candidatos := MontarCaminhosCandidatos(Bibliotecas[I]);
    for J := 0 to GetArrayLength(Candidatos) - 1 do
    begin
      Caminho := NormalizarCaminho(Candidatos[J]);
      if ValidarPastaJogo(Caminho) then
      begin
        Result := Caminho;
        Exit;
      end;
    end;
  end;
end;

function ProcessoEmExecucao(const NomeProcesso: String): Boolean;
var
  CodigoSaida: Integer;
begin
  Result := False;
  if Exec('cmd.exe',
    '/C tasklist /FI "IMAGENAME eq ' + NomeProcesso + '" | find /I "' + NomeProcesso + '"',
    '', SW_HIDE, ewWaitUntilTerminated, CodigoSaida) then
    Result := (CodigoSaida = 0);
end;

function PastaEstaVazia(const Caminho: String): Boolean;
var
  Busca: TFindRec;
begin
  Result := True;
  if not DirExists(Caminho) then
    Exit;

  if FindFirst(Caminho + '\*', Busca) then
  try
    repeat
      if (Busca.Name <> '.') and (Busca.Name <> '..') then
      begin
        Result := False;
        Break;
      end;
    until not FindNext(Busca);
  finally
    FindClose(Busca);
  end;
end;

procedure RemoverPastaSeVazia(const Caminho: String);
begin
  if DirExists(Caminho) and PastaEstaVazia(Caminho) then
    RemoveDir(Caminho);
end;

procedure RemoverPastasVaziasRecursivo(const Caminho: String);
var
  Busca: TFindRec;
  SubPasta: String;
begin
  if not DirExists(Caminho) then
    Exit;

  if FindFirst(Caminho + '\*', Busca) then
  try
    repeat
      if (Busca.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0) and
         (Busca.Name <> '.') and (Busca.Name <> '..') then
      begin
        SubPasta := Caminho + '\' + Busca.Name;
        RemoverPastasVaziasRecursivo(SubPasta);
      end;
    until not FindNext(Busca);
  finally
    FindClose(Busca);
  end;

  RemoverPastaSeVazia(Caminho);
end;

function InitializeSetup(): Boolean;
begin
  CaminhoJogoDetectado := DetectarPastaJogo();
  AjudaDirExibida := False;
  Result := True;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpSelectDir then
  begin
    if CaminhoJogoDetectado <> '' then
      WizardForm.DirEdit.Text := CaminhoJogoDetectado
    else if not AjudaDirExibida then
    begin
      WizardForm.SelectDirLabel.Caption :=
        WizardForm.SelectDirLabel.Caption + #13#10#13#10 +
        'Não encontramos o jogo automaticamente. Para localizar a pasta correta:' + #13#10 +
        'Steam > clique com o botão direito em "FINAL FANTASY X/X-2 HD Remaster" >' + #13#10 +
        'Gerenciar > Procurar arquivos locais.';
      AjudaDirExibida := True;
    end;
  end
  else if CurPageID = wpFinished then
  begin
    WizardForm.FinishedLabel.Caption :=
      'Instalação concluída!' + #13#10#13#10 +
      'Abra o jogo pela Steam e escolha FFX-2 — já estará em português.' + #13#10#13#10 +
      'Quando você abrir o jogo, um arquivo chamado hook.log vai aparecer na pasta do jogo. ' +
      'Isso é normal e indica que a tradução foi carregada.' + #13#10#13#10 +
      'Nota: no Steam Deck ou Linux (Proton), é necessário um passo manual extra — adicionar' + #13#10 +
      'WINEDLLOVERRIDES=dinput8=n,b %command%' + #13#10 +
      'nas opções de inicialização da Steam. Este instalador Windows não cobre essa plataforma.';
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  CaminhoEscolhido: String;
begin
  Result := True;

  if CurPageID = wpSelectDir then
  begin
    CaminhoEscolhido := NormalizarCaminho(WizardForm.DirEdit.Text);
    if not ValidarPastaJogo(CaminhoEscolhido) then
    begin
      MsgBox(
        'Não encontrei o FFX-2 nesta pasta.' + #13#10#13#10 +
        'Confira se é a pasta certa: ela deve conter o arquivo FFX-2.exe.' + #13#10#13#10 +
        'Dica: na Steam, clique com o botão direito no jogo > Gerenciar > Procurar arquivos locais.',
        mbError, MB_OK);
      Result := False;
    end;
  end;
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  Result := '';
  NeedsRestart := False;

  if ProcessoEmExecucao('FFX-2.exe') or ProcessoEmExecucao('FFX.exe') then
    Result :=
      'O jogo ou o launcher parece estar aberto.' + #13#10#13#10 +
      'Feche o jogo (e o launcher) e tente novamente.';
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  PastaJogo: String;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    PastaJogo := ExpandConstant('{app}');
    RemoverPastasVaziasRecursivo(PastaJogo + '\data\mods');
    RemoverPastasVaziasRecursivo(PastaJogo + '\modules');
  end;
end;
