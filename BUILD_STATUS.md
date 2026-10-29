# RR Q hinoki — stan 2026-10-29

Źródła zawierają **32 patche w 10 projektach**. Potwierdzone poprawki z telefonu
są zapisane jako commity. Obecny pełny ZIP nadal pochodzi z 2026-10-27 i ma
wcześniejszy zestaw 20 patchy. Nie wykonano nowego `bacon` po testach na żywo.

## Istniejąca pełna paczka

- Xperia XA1 Dual G3112 / hinoki, Resurrection Remix Q 8.7.3, Android 10.
- `rr_hinoki-userdebug`, Unofficial, Vanilla, test-keys, `Kejlo@endozero`.
- Rzeczywisty SPL `2021-09-05`; nie podnoszono samej deklaracji.
- Udany log: `/home/kejlo/xperia_XA1/build-logs/rr-Q-hinoki-20261027-222925.log`.
- Katalog: `/home/kejlo/xperia_XA1/ROM/RR-Q-8.7.3-20261027-G3112/`.
- ZIP: `RROS-Q-8.7.3-20261027-hinoki-Unofficial.zip`, 1 064 935 400 B.
- SHA-256: `f4f5ba0cddae72d6c44054484a21c4c73dca3a6a23450e846cd266080f2321eb`.

Pełny ZIP przeszedł CRC; OTA obejmuje hinoki; boot w ZIP-ie odpowiada osobnemu
obrazowi. Geometria boot/recovery i DTB odpowiadają V27. Zweryfikowano statyczny
ARM64 first-stage init, fstab i zachowanie ramdisku SAR. Raport jest obok ROM-u:
`rr-image-validation-20261027.json`. Te kontrole dotyczą starej paczki.

## Późniejsze kompilacje przyrostowe

W tym samym `out`, bez clean/clobber, wykonano:

- Settings z poprawką kreatora microSD: sukces, log `rr-Q-Settings-live-20261028-152717.log`.
- `libstagefrighthw` oraz oba etapy init: sukces, log `rr-Q-native-live-20261028-160157.log`.
- Polityka SELinux oraz `libaudiopolicymanagerdefault`: sukces,
  `rr-Q-audio-policy-live-20261028-163023.log`.
- `libmediaplayerservice`: sukces, `rr-Q-camera-live-20261028-163719.log`.
- Docelowy plugin AVC, konfiguracje i SELinux: sukces,
  `rr-Q-avc-decoder-live-20261028-164438.log` (41 s).

Logi są w `/home/kejlo/xperia_XA1/build-logs/`. Kontrole neverallow, sepolicy_tests
oraz treble_sepolicy_tests 26/27/28 przeszły. Urządzenie pozostaje Enforcing;
odziedziczone domeny debug/OTA `su` i `backuptool` są permissive.

## Testy i ograniczenia

Użytkownik potwierdził poprawne odtwarzanie obrazu i dźwięku po uruchomieniu
sprzętowego dekodera AVC. Kreator formatowania microSD ukończono na telefonie
za zgodą użytkownika, z rzeczywistym ostrzeżeniem o szybkości karty.
Trwałość poprawek po restarcie potwierdzono 2026-10-29.
Szczegóły: `LIVE_TESTS.md`. Losowe migotanie po wyłączeniu AAL nadal obserwujemy.

Kernel i vendor zachowano na dokładnych rewizjach V27; rejestrację AVC
nadpisuje jawna konfiguracja urządzenia. Żadnych prywatnych kluczy w pakiecie.
Kopie RisingOS pozostają na `/media/kejlo/Dysk3/RisingOS-full-backup-20261027/`.
Istniejące źródła i `out` LineageOS XA1 zachowano.
