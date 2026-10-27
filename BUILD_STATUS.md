# RR Q hinoki — kompilacja

Uruchomiono 2026-10-27 o 21:11 czasu lokalnego.

- Urządzenie: Xperia XA1 Dual G3112.
- Produkt: `rr_hinoki-userdebug`.
- Polecenie: `bash build-rr.sh 16`.
- Źródła: `/home/kejlo/xperia_XA1/source/resurrection-remix-Q-hinoki`.
- Bieżący log: `/home/kejlo/xperia_XA1/build-logs/rr-Q-hinoki-20261027-222925.log`.
- Stan: trwa; brak gotowego wyniku i testu na telefonie.

Kopie RisingOS zostały sprawdzone i zachowane w
`/media/kejlo/Dysk3/RisingOS-full-backup-20261027/`.
Po usunięciu zweryfikowanej zawartości starych katalogów NVMe miał 539 GiB
wolnego miejsca. Istniejące źródła i `out` LineageOS dla XA1 zachowano.

Pierwsze uruchomienia wykryły brak ścieżek do lokalnych ncurses5/libsigsegv2
i programu m4 oraz starą konfigurację kompilatora narzędzi kernela w RR.
Uzupełniono wrapper i przeniesiono poprawkę LineageOS wybierającą Clanga dla
HOSTCC/HOSTCXX. Konfiguracja kernela i generator parsera SELinux już
przechodzą; pełny build jest kontynuowany z zachowaniem `out`.

Przeniesiono także poprawkę whitelisty sys_rawio dla fastbootd z LineageOS
(`1d13a7ed`, autor David Anderson). Kontrola SELinux neverallow przechodzi.

Po pierwszym dojściu do 98% ujawnił się brak API finalizeWorkProfileProvisioning
w starszym frameworku RR. Przeniesiono pełny backport Q z LineageOS
(`4f9a87b9`, autor Jonathan Scott); ManagedProvisioning już się kompiluje.
Poprawiono także dwa uszkodzone znaczniki portugalskiego rr_strings.xml,
przez które 1101 tłumaczeń było traktowanych jak jeden stylowany napis.
Wynikowa tabela zasobów Settings nie zawiera już STRING_TOO_LARGE.

Usługa MMS z aktualnego Lineage wymagała także zgodnego interfejsu IMms.
Przeniesiono kompletny backport przekazywania userId: interfejs, SmsManager
i MmsServiceBroker (`bbb0014d`, autor Nikhil Kumar). Kompilacja jest wznawiana
z gotowych wyników; natywne biblioteki i kernel pozostają zachowane.
