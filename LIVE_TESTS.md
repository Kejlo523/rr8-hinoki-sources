# Testy na Xperia XA1 Dual G3112 — 2026-10-28

Telefon działa na RR Q z 2026-10-27 i Magisk 28.1. Poprawki najpierw testowano
przez ADB, następnie zapisano w źródłach. Nie czyszczono `out`, nie zmieniano
produktu `rr_hinoki-userdebug` ani kernela. Pełny nowy ROM ZIP z 33 patchami zbudowano 2026-10-29 po tych testach;
sprawdzono CRC i rzeczywiste pliki wynikowe. Jego uruchomienie po instalacji
nie zostało jeszcze potwierdzone.

## Wyniki

- Device Info HW i Kernel Adiutor usunięto z produktu, plików APK oraz wyjątków
  Zygote/seapp. Na telefonie odinstalowano je dla użytkownika 0; APK starego
  obrazu systemowego znikną po instalacji nowej paczki.
- ADB root działa po odtworzeniu prawdziwych właściwości debug. W źródłach init
  omija ukrywanie `ro.debuggable` dla userdebug/eng; zachowanie user niezmienione.
- Diody: capability 64 -> 66 dodaje RGB baterii. W LineageParts są kontrolki
  kolorów; wybranie niebieskiego i zielonego sprawdzono w sysfs. Przywrócono
  poprzedni czerwony kolor użytkownika.
- Menu diody: 2026-10-29 użytkownik zgłosił puste okno edycji. LineageParts
  sprawdzał RGB powiadomień zamiast baterii. Poprawiono kontrolkę i dialog,
  przekazując rzeczywistą obsługę RGB baterii; nie dodawano fałszywej zdolności
  RGB powiadomień. Przyrostowy build LineageParts: 15 kroków / 13 s.
  APK zainstalowany przez ADB: paleta, HEX i kolorowe ikony są widoczne.
  Zapisany z menu kolor #00ffd6 odczytano z ustawień; sysfs: R0 G255 B214.
  Zielony został także fizycznie potwierdzony przez użytkownika. Przy 81%
  działa „Ładowanie”; kolor „W pełni naładowana” stosowany jest od 90%/FULL.
- Migotanie: AAL (adaptacyjne przetwarzanie treści) wyłączone przez
  `persist.sys.aal.function=0`. Usługa potwierdza funkcję 0. Zwykła automatyczna
  jasność pozostaje dostępna. Użytkownik: „Jeszcze trudno ocenić”; brak dowodu
  ostatecznego usunięcia losowego objawu. Brak pomiaru oszczędności baterii.
- MicroSD: kreator kończył się NPE po chwilowym błędzie odczytu metadanych.
  Poprawka ponawia montowanie nowego woluminu, obsługuje brak woluminu i błąd
  benchmarku. Za zgodą użytkownika sformatowano SanDisk 32 GB jako private:
  retry mount zadziałało, benchmark 7574 ms, ostrzeżenie, potem ekran Ready.
  Nie przenoszono aplikacji/danych z głównej pamięci. Karta realnie przekracza
  próg 2000 ms; nie ukrywamy tego. Pierwotne `sys.debug.storage_slow` było
  nieustawione, nie 1 (wcześniejsza interpretacja odczytu była błędna).
- Mikrofon: legacy HAL odrzucał syntetyczne `bottom=`/`back=`, startInput -22.
  Dla MT6757 AudioPolicyManager zachowuje puste adresy z konfiguracji płyty.
  AudioRecord CAMCORDER 48000/stereo odczytał 4096 próbek bez błędu.
- AVC encode: `/dev/Vcodec` należało do media:system, a OMX działa jako
  mediacodec. Docelowo mediacodec:system, 0660; dodano rejestrację enkodera.
  MediaCodec ByteBuffer 320x240 i Surface 720p/1080p kończą się z EOS.
- Aparat: usunięto wymuszanie raw 480x320@15 i przywrócono metadata/profile.
  Snap nagrał 1080p@30 ze ścieżką AAC stereo. Software decode potwierdził
  120 różnych klatek; samo policzenie zakodowanych klatek nie było dostatecznym
  testem odtwarzania — użytkownik zgłosił wcześniej stojący obraz.
- AVC decode: przywrócono tylko zwykły AVC w pluginie, XML i mtk_omx_core.cfg.
  MediaCodec odczytał 120 różnych klatek w 1521 ms (software 9405 ms).
  Galeria: wcześniej 242/246 klatek odrzuconych, po poprawce 5/172, czas
  odtwarzania 5999 ms dla pliku 5775 ms. Użytkownik potwierdził normalny obraz
  i dźwięk. Pozostałe dekodery MTK nadal wyłączone do osobnych testów.
- SELinux: Enforcing. Kamera i kompozytor są klientami HAL PQ; dopuszczono
  dokładny ioctl M4U 0x6717 dla kamery i mediacodec, zamiast wyłączać SELinux.

## Trwałość na obecnym telefonie

Settings zainstalowano jako podpisaną aktualizację systemowej aplikacji.
AAL jest trwałą właściwością. Potwierdzone pliki zasobów/OMX/audio i uprawnienia
zabezpiecza moduł Magiska `rr_hinoki_live_20261028`, tylko dla sum kontrolnych
oryginalnego RR 20261027. Po zmianie któregokolwiek docelowego pliku moduł
pomija wszystkie nakładki; nie zastępuje bibliotek ani zasobów nowego ROM-u.
W nowych źródłach poprawki działają bez tego modułu.

Kopia plików modułu i oryginałów oraz szczegółowe logi są w:
`/home/kejlo/xperia_XA1/diagnostics/rr-live-20261028-144527/`.
Moduł można wyłączyć w Magisk i zrestartować telefon. AAL i aktualizacja
Settings są od niego niezależne.

Weryfikacja po restarcie zakończona 2026-10-29: moduł aktywny, wszystkie
kontrole SHA-256 przeszły, `/dev/Vcodec` ma właściciela mediacodec:system,
`adb root` działa, SELinux Enforcing, AAL funkcja 0, karta jest zamontowana,
a aktualizacja Settings pozostała zainstalowana. Mikrofon ponownie odczytał
4096 próbek; sprzętowy AVC odczytał 120 różnych klatek w 1518 ms.
Stary init nie uruchamia trybu late_start Magiska, dlatego jednorazową
korektę właściciela urządzenia uruchamia post-fs-data. Skrypt kończy się
po rozruchu; nie pozostawia stałego procesu odpytującego urządzenie.
Wykryto też błąd parsera ioctl w Magisk 28.1: cyfry po `0x` parsuje
jako dziesiętne. Moduł podaje `0x26391`, co w tej konkretnej wersji
daje właściwy ioctl `0x6717`. Moduł odmawia działania z inną wersją
Magiska. Źródłowa polityka ROM-u używa zwykłego poprawnego `0x6717`.

## Pozostałe ograniczenia

Pełny dual-SIM, inne kodeki, wszystkie ścieżki zdjęć aparatu i zużycie energii
nie zostały ponownie zweryfikowane. W starych logach rozruchu występuje też
NumberFormatException w PhoneUtils dla `modem_sys1_ps1`; wymaga osobnej pracy.
Diagnostyczne `dumpsys` starego HAL audio może trafić w pusty callback debug.
To nie jest deklaracja pełnej stabilności całego portu.
