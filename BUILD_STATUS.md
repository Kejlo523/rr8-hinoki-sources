# RR Q hinoki — wynik kompilacji

Stan: **zakończona sukcesem**, 2026-10-27. Bez testu na telefonie.

- Urządzenie: Xperia XA1 Dual G3112 / hinoki.
- System: Resurrection Remix Q 8.7.3, Android 10, SPL `2021-09-05`.
- Produkt: `rr_hinoki-userdebug`, Unofficial, Vanilla, test-keys.
- Autor/host: `Kejlo@endozero`.
- Polecenie: `bash build-rr.sh 16`; bez czyszczenia `out`.
- Źródła: `/home/kejlo/xperia_XA1/source/resurrection-remix-Q-hinoki`.
- Końcowy log: `/home/kejlo/xperia_XA1/build-logs/rr-Q-hinoki-20261027-222925.log`.
- Wyniki: `/home/kejlo/xperia_XA1/ROM/RR-Q-8.7.3-20261027-G3112/`.

ROM: `RROS-Q-8.7.3-20261027-hinoki-Unofficial.zip`, 1 064 935 400 bajtów.
SHA-256: `f4f5ba0cddae72d6c44054484a21c4c73dca3a6a23450e846cd266080f2321eb`.
Obok są `boot.img`, `recovery.img`, `SHA256SUMS`, `BUILD_INFO.txt` i raport
`rr-image-validation-20261027.json`.

## Kontrole

- Pełny ZIP przeszedł kontrolę CRC; metadane OTA obejmują hinoki.
- Boot w ZIP-ie odpowiada samodzielnemu `boot.img`.
- Boot i recovery mieszczą się w partycjach; geometria i DTB odpowiadają V27.
- Boot ma poprawny ramdisk ze statycznym ARM64 first-stage init i fstab.
- Target-files zachowują metadane rzeczywistego ramdisku system-as-root.
- Kompilacja polityki SELinux z kontrolą neverallow przeszła. Domyślny tryb
  to enforcing; domeny debug/OTA `su` i `backuptool` są permissive.
- Zasoby skompilowanego Settings nie zawierają `STRING_TOO_LARGE`.
- Kopie gotowych obrazów i ZIP-a mają sumy zgodne z oryginalnymi wynikami.

20 patchy w 10 projektach obejmuje przeniesienie BSP V27 oraz zgodność API
ManagedProvisioning/MMS z pobranymi aplikacjami LineageOS. Poprawiono również
narzędzia hosta kernela i dwa uszkodzone znaczniki tłumaczeń Settings.
Kernel i vendor zachowano na dokładnych rewizjach V27.

Nie flashowano XA1 i nie testowano uruchomienia, rozmów, sprzętu ani baterii.
Pozostają ograniczenia bazy: niepełny dual-SIM, programowe kodeki wideo,
programowe nagrywanie AVC oraz NFC-A bez Beam/P2P. Prywatne klucze nie są
częścią pakietu; wynik używa standardowego certyfikatu deweloperskiego.

Kopie RisingOS zweryfikowano i zachowano w
`/media/kejlo/Dysk3/RisingOS-full-backup-20261027/`, po czym usunięto zawartość
starych katalogów z NVMe. Istniejące źródła i `out` LineageOS XA1 zachowano.
