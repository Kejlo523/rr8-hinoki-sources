# Resurrection Remix Q 8.7.3 — Xperia XA1 Dual G3112

Przeniesienie poprawek sprzętowych z portu LineageOS 17.1 hinoki V27 do
Resurrection Remix Q. Android 10, produkt `rr_hinoki-userdebug`.

## Stan

Pełna paczka z wszystkimi poprawkami gotowa 2026-10-29:
`/home/kejlo/xperia_XA1/ROM/RR-Q-8.7.3-20261029-G3112/`.
W zestawie są ROM ZIP, boot, recovery, SHA256SUMS, stan źródeł i raport kontroli.
Ostatni dodatkowy `bacon` wykonano po zakończeniu zmian: 33 patche w 11
projektach, bez zmiany HEAD i bez zmian roboczych podczas tego przebiegu.
Zachowano istniejący `out`; nie uruchamiano clean/clobber.

ZIP przeszedł CRC. Boot/recovery mieszczą się w partycjach, mają DTB/geometrię
V27 oraz statyczny first-stage init i ramdisk SAR. Sprawdzono rzeczywiste
pliki poprawek w target-files, nieobecność usuniętych APK oraz nowy wybór
koloru diody baterii. Szczegóły: `BUILD_STATUS.md`.

Poprawki testowano na G3112 przez ADB: sprzętowe AVC 1080p z audio i
odtwarzaniem, kreator microSD, RGB diody z paletą w menu oraz adb root.
Ta nowa pełna paczka wymaga jeszcze potwierdzenia uruchomienia po instalacji.
Szczegóły i ograniczenia: `LIVE_TESTS.md`.
Vanilla bez Google apps, userdebug / Unofficial / test-keys,
`Kejlo@endozero`. Rzeczywisty SPL `2021-09-05`, bez zmiany samej deklaracji.

RR zachowuje własne ustawienia, personalizację interfejsu, motywy i framework.
Wybrano go zamiast Paranoid Android Quartz, ponieważ RR Q bazuje na LineageOS
17.1 i pasuje do istniejącego BSP. Quartz ma inną bazę CAF i odwołania do
nieczynnych serwerów CodeAurora, więc wymagałby większej migracji.

## Katalogi

- Gotowe lokalne drzewo: `/home/kejlo/xperia_XA1/source/resurrection-remix-Q-hinoki`.
- Ten zestaw manifestów i poprawek: `/home/kejlo/xperia_XA1/source/rr-hinoki-port`.
- Niezmienione źródła referencyjne: `/home/kejlo/xperia_XA1/source/lineage-17.1-hinoki`.

Drzewo RR korzysta z obiektów Git istniejącego LineageOS przez `--reference`.
Nie usuwaj jego `.repo/project-objects`, dopóki RR korzysta z tych alternates.
Nie ma zależności od archiwizowanych katalogów RisingOS `s10e` / `samsung_a6`.

## Co przeniesiono

- Dokładne rewizje urządzenia, kernela, vendor blobs, toolchainów i portowanych
  projektów z manifestu V27 z 2026-09-21.
- System-as-root z rzeczywistym ramdiskiem boot i statycznym first-stage init,
  wraz z obsługą ramdisku przez narzędzia podpisywania target-files.
- Zgodność starego MediaTeka: kamera, audio, storage/sdcardfs, RIL/SIM,
  MTP z legacy USB gadget, Wi-Fi bez niezgodnego cross-DSO CFI.
- Poprawki SELinux, GNSS/SUPL, HWC, NFC i wykrywania słuchawek zawarte w
  istniejących drzewach urządzenia, kernela i vendor.
- DuckDuckGo i busybox z V27. Device Info HW i Kernel Adiutor usunięto
  z bieżących źródeł wraz z ich wyjątkami roota.
- Obejście braku ładowalnych modułów kernela w `vendor/rr/build/tasks/kernel.mk`.

Zmiany w projektach RR są osobnymi commitami gałęzi `rr-Q-hinoki` i plikami
`patches/`. Nie zastąpiono całego frameworka RR frameworkiem LineageOS.

Poprawkę `ro.audio.disable_sound_effects` dostosowano do klasy
`SoundEffectsHelper`, do której RR przeniósł obsługę efektów. Nie przywracano
starej implementacji `AudioService`. Obejście kończy ładowanie callbackiem,
zanim powstanie SoundPool.

Kernel i vendor pozostają dokładnie na rewizjach V27. Konfiguracja kernela
dalej nazywa się `lineage_hinoki_defconfig`; nazwa nie zmienia systemu na Lineage.
Oryginalny `lineage_hinoki.mk` pozostawiono jako plik referencyjny, lecz
`AndroidProducts.mk` rejestruje wyłącznie produkt RR.

## Odtworzenie na świeżym katalogu

Manifest bazowy RR:
`https://github.com/ResurrectionRemix/platform_manifest.git`, gałąź `Q`,
commit `a5df4c516aea680f8fb49c523116a61490f2a21f`.

Przykład (wyłącznie w nowym katalogu, nie w istniejącym drzewie LineageOS):

```bash
mkdir -p /home/kejlo/xperia_XA1/source/rr-hinoki-fresh
cd /home/kejlo/xperia_XA1/source/rr-hinoki-fresh
repo init -u https://github.com/ResurrectionRemix/platform_manifest.git \
  -b a5df4c516aea680f8fb49c523116a61490f2a21f --depth=1 --no-clone-bundle
mkdir -p .repo/local_manifests
cp /home/kejlo/xperia_XA1/source/rr-hinoki-port/hinoki.xml \
  .repo/local_manifests/hinoki.xml
repo sync -c --no-tags --no-clone-bundle -j4
git -C vendor/sony/mt6757-common lfs install --local --force
git -C vendor/sony/mt6757-common lfs pull hinoki-kejlo
bash /home/kejlo/xperia_XA1/source/rr-hinoki-port/apply-patches.sh "$PWD"
```

`hinoki.xml` przypina sprzęt i wszystkie projekty objęte patchami do konkretnych
commitów. Pozostałe projekty wybiera manifest upstream.

`manifest-base-pinned.xml` przypina **wszystkie 783 projekty** do pobranych
rewizji. Dla powtarzalnego odtworzenia użyj go zamiast lokalnego `hinoki.xml`:
po pierwszym `repo init`, przed synchronizacją, w nowym katalogu bez lokalnych
manifestów wykonaj:

```bash
cp /home/kejlo/xperia_XA1/source/rr-hinoki-port/manifest-base-pinned.xml \
  .repo/manifests/hinoki-pinned.xml
repo init -m hinoki-pinned.xml
repo sync -c --no-tags --no-clone-bundle -j4
git -C vendor/sony/mt6757-common lfs install --local --force
git -C vendor/sony/mt6757-common lfs pull hinoki-kejlo
bash /home/kejlo/xperia_XA1/source/rr-hinoki-port/apply-patches.sh "$PWD"
```

`manifest-working-local.xml` jest raportem aktualnych HEAD po nałożeniu
poprawek. Zawiera lokalne commity, których nie wysłano na GitHub, więc **nie
służy do synchronizowania nowego drzewa**. Manifest bazowy nie ma tego problemu.

Skrypt najpierw sprawdza czystość i bazę wszystkich modyfikowanych projektów.
Odmawia pracy na innym HEAD, nie resetuje katalogów i nie usuwa cudzych zmian.
Nie uruchamiaj go ponownie na już przygotowanym lokalnym drzewie RR.
Po nałożeniu poprawek zwykły `repo sync` może odczepić lokalne gałęzie; przed
aktualizacją zachowaj commity i świadomie przenieś je na nową bazę.

Zestaw 33 wyeksportowanych patchy sprawdzono przez odtworzenie zmian w
osobnych indeksach Git: drzewa wszystkich jedenastu projektów odpowiadają
bieżącym commitom. Pierwszy audyt sprawdził też 38 plików XML urządzenia, 1655 wejściowych
plików BSP/vendor i obecność wszystkich 783 projektów. Nowszą kontrolę
rzeczywistych wyników kompilacji opisuje `BUILD_STATUS.md`.

Sprawdzono też 805 bibliotek vendor: wszystkie mają nagłówek ELF. Repo
domyślnie wyłącza smudge Git LFS, dlatego baza diagnostyczna modemu `.EDB`
wymaga osobnego `git lfs pull`. W przygotowanym drzewie jest już pełny plik
61 840 499 B o SHA-256
`14b96ddc6bbc0579621011bed9af3dcb95af8371a93b4af2007226ff6049e159`,
zgodnym ze wskaźnikiem LFS. Nie pozostały wskaźniki LFS w plikach vendor.

## Budowanie

Pełny build z izolowanym środowiskiem i logiem:

```bash
bash /home/kejlo/xperia_XA1/source/rr-hinoki-port/build-rr.sh 16
```

Pierwszy argument to liczba zadań, drugi opcjonalny argument to inny katalog
źródeł RR. Skrypt używa dołączonych JDK 9/8, wykonuje `source build/envsetup.sh`,
`lunch rr_hinoki-userdebug` i `m -j16 bacon`. Ustawia autora `Kejlo`, host
`endozero`, typ `Unofficial` i względne `OUT_DIR=out`. Przed pierwszym buildem
sprawdza dostępność co najmniej 120 GiB miejsca. Nie dziedziczy zmiennych
produktu, Javy, GMS ani SPL ze środowiska RisingOS.

Starszy Clang używany przez RenderScript wymaga `libncurses.so.5` i
`libtinfo.so.5`. Na tym komputerze biblioteki są już w
`/home/kejlo/.local/legacy-build-libs/lib/x86_64-linux-gnu`; wrapper udostępnia
ten katalog przez `LD_LIBRARY_PATH`. Na innym hoście przygotuj biblioteki ABI 5
albo dostosuj tę ścieżkę. Nie zastępuj ich dowiązaniami do ABI 6.
Narzędzie `m4` korzysta również z `libsigsegv.so.2`, dostępnej lokalnie w
`/home/kejlo/.local/libsigsegv/usr/lib/x86_64-linux-gnu`; ten katalog także
jest uwzględniony w wrapperze.
`M4` wskazuje jawnie na `/home/kejlo/.local/bin/m4`, ponieważ dołączony Bison
domyślnie szuka `/usr/bin/m4`. Generator parsera SELinux sprawdzono z tą
lokalną konfiguracją.

Logi zapisuje w `/home/kejlo/xperia_XA1/build-logs/`. Wyniki trafią do
`out/target/product/hinoki/`, a ZIP do `RROS-Q-8.7.3-*-hinoki-Unofficial.zip`.

Nie wykonuj `clean`, `clobber`, `installclean` ani usuwania `out` w istniejących
projektach. Nowe źródła RR mają oddzielny katalog wyjściowy.

GApps nie dodano. Nie ustawiaj `WITH_GMS=true` bez osobno przygotowanego
pasującego `vendor/partner_gms`: samo ustawienie zmiennej nie pobiera aplikacji.

## Podpisywanie i instalacja

Istniejący wrapper `../android_hinoki_manifest/tools/sign-release.sh` można
zastosować po pierwszym udanym buildzie do target-files RR, podając jako
pierwszy argument nowe drzewo RR. Zachowuje ramdisk i podpisuje OTA/APK własnymi
kluczami. Nie kopiuj ani nie publikuj prywatnych kluczy z
`/home/kejlo/xperia_XA1/signing-keys`. Podpisanie zmienionego systemu kluczem
nie dodaje brakujących poprawek bezpieczeństwa.

Pierwszą instalację RR należy traktować jako zmianę dystrybucji; wcześniej
wykonaj kopię danych. Użytkownik zainstalował RR oraz Magisk 28.1.
Obecne poprawki testowano na tym systemie; nie flashowano nowego kernela.
Pełny ZIP z 2026-10-29 zawiera zapisane w źródłach poprawki.

## Ograniczenia odziedziczone z V27

- Podstawowa ścieżka jednej karty SIM; pełny dual-SIM pozostaje niedokończony.
- Sprzętowe H.264/AVC: enkoder i dekoder działają w testach 1080p na G3112.
  Pozostałe stare dekodery wideo MTK nadal wyłączone do osobnej walidacji.
- Nagrywanie ekranu nie było ponownie sprawdzane po uruchomieniu enkodera AVC.
- NFC ograniczono do stabilnego NFC-A; Beam/P2P i równoległe rozszerzenia NXP
  pozostają wyłączone w konfiguracji sprzętu.
- Domyślny tryb SELinux to enforcing; polityka wersji userdebug zawiera domeny
  `su` i `backuptool` w trybie permissive. Kontrola neverallow przechodzi.
  Poprawiono odmowy PQ/M4U wykryte w testach aparatu, kompozytora i AVC.
  To nie jest pełny audyt całej odziedziczonej polityki.
- Wyłączenie AAL jest aktywne, ale użytkownik nie potwierdził jeszcze
  ostatecznego ustąpienia losowego migotania. Poboru energii nie zmierzono.
- Karta microSD rzeczywiście przekracza próg testu szybkości; poprawka
  zapobiega awarii kreatora, nie ukrywa ostrzeżenia o wolnym nośniku.

## Źródła i autorzy

- [Resurrection Remix manifest Q](https://github.com/ResurrectionRemix/platform_manifest/tree/Q)
- [Manifest i poprawki V27 użytkownika](https://github.com/Kejlo523/android_hinoki_manifest)
- [Kernel MT6757](https://github.com/Kejlo523/android_kernel_sony_mt6757)
- LineageOS, Resurrection Remix, SonyMTKDev i autorzy zachowani w commitach
  oraz nagłówkach źródeł.
