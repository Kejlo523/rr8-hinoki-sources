# RR Q hinoki — gotowa pełna paczka 2026-10-29

Stan: **sukces**. Ostatni dodatkowy `bacon` zakończył się o 18:59, po
ustaleniu wszystkich poprawek. Źródła pozostały na tych samych HEAD i bez
zmian roboczych przez końcowy przebieg. Zachowano `out` i produkt userdebug.

- Xperia XA1 Dual G3112 / hinoki, Resurrection Remix Q 8.7.3, Android 10.
- 33 patche w 11 projektach; dokładne odtworzenie wszystkich serii sprawdzone.
- Vanilla / Unofficial / test-keys, `Kejlo@endozero`, rzeczywisty SPL 2021-09-05.
- Katalog: `/home/kejlo/xperia_XA1/ROM/RR-Q-8.7.3-20261029-G3112/`.
- ROM: `RROS-Q-8.7.3-20261029-hinoki-Unofficial.zip`.
- Rozmiar: 1060688237 B.
- SHA-256: `ad02391536593537961e3224b52f31a4cf56083423dfb981c51ab6788d64f864`.
- Ostateczny log: `/home/kejlo/xperia_XA1/build-logs/rr-Q-hinoki-20261029-185650.log`.

## Kontrole gotowego zestawu

- Pełny ROM ZIP przeszedł CRC; metadane OTA obejmują hinoki / SDK29.
- Boot w ZIP-ie jest identyczny z osobnym boot.img.
- Boot/recovery mieszczą się w 40 MiB; geometria i DTB odpowiadają V27.
- Boot ma statyczny ARM64 first-stage init i fstab; target-files zachowują SAR.
- Pliki audio, OMX obu ABI, konfiguracje, init, zasoby SDK, Settings i
  LineageParts w target-files odpowiadają skompilowanym wynikom.
- init.mt6757.rc zawiera właściciela mediacodec:system dla /dev/Vcodec.
- Brak DeviceInfoHW/KernelAdiutor w target-files; ich dwa stare katalogi
  wynikowe zachowano w osobnej kopii poza out. Nie wykonywano installclean.
- Skompilowany SDK ma capability66; LineageParts zawiera poprawkę palety.
- Polityka zawiera ioctl0x6717 kamery i mediacodec; neverallow i testy Treble
  przeszły. Globalny SELinux Enforcing; domeny su/backuptool są permissive.
- Kopie ROM-u, boot i recovery zweryfikowano przez SHA-256.

Raport `rr-image-validation-20261029.json`, `final-source-freeze-20261029.json`,
manifesty i SHA256SUMS są obok ZIP-a. Obrazy kernela/vendor zachowują bazę V27.
Poprawki testowano na żywo; uruchomienie całej nowej paczki pozostaje do
potwierdzenia po instalacji. Losowe migotanie po AAL=0 nadal obserwujemy,
bez pomiaru oszczędności baterii. Więcej: `LIVE_TESTS.md`.

Stara paczka z 2026-10-27 pozostaje w swoim poprzednim katalogu.
Kopie RisingOS pozostają na `/media/kejlo/Dysk3/RisingOS-full-backup-20261027/`.
