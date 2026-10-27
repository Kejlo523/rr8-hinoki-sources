# RR Q hinoki — kompilacja

Uruchomiono 2026-10-27 o 21:11 czasu lokalnego.

- Urządzenie: Xperia XA1 Dual G3112.
- Produkt: `rr_hinoki-userdebug`.
- Polecenie: `bash build-rr.sh 16`.
- Źródła: `/home/kejlo/xperia_XA1/source/resurrection-remix-Q-hinoki`.
- Bieżący log: `/home/kejlo/xperia_XA1/build-logs/rr-Q-hinoki-20261027-213438.log`.
- Stan: trwa; brak gotowego wyniku i testu na telefonie.

Kopie RisingOS zostały sprawdzone i zachowane w
`/media/kejlo/Dysk3/RisingOS-full-backup-20261027/`.
Po usunięciu zweryfikowanej zawartości starych katalogów NVMe miał 539 GiB
wolnego miejsca. Istniejące źródła i `out` LineageOS dla XA1 zachowano.

Pierwsze uruchomienia wykryły brak ścieżek do lokalnych ncurses5/libsigsegv2
i programu m4 oraz starą konfigurację kompilatora narzędzi kernela w RR.
Uzupełniono wrapper i przeniesiono poprawkę LineageOS wybierającą Clanga dla
HOST_CC/HOST_CXX. Konfiguracja kernela i generator parsera SELinux już
przechodzą; pełny build jest kontynuowany z zachowaniem `out`.

Przeniesiono także poprawkę whitelisty sys_rawio dla fastbootd z LineageOS
(`1d13a7ed`, autor David Anderson). Kontrola SELinux neverallow przechodzi.
