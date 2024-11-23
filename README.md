# list_application

Dette er Prosjekt Øvingen i IDATT2506.

## Testing på Android Emulator
Dette programmet var testet på fysisk Samsung S20 og emulator på Android Studio. 
For å teste programmet via emulator så last ned Android Studio, og gå til AVD Manager for å opprette nytt Android Virtual Device.
Klikk Configure > AVD Manager, eller hvis prosjektet er åpent klikk Tools > AVD Manager.
Klikk Create Virtual Device, og så velg en enhet, denne applikasjonen var testet på Pixel 6 Pro satt i Software for Graphics mode. 
Velg et System Image, min emulator kjørte Android API 35. Start emulatoren.


Hent Flutter pakker med:
'flutter pub get'
Og så kjør programmet med:
'flutter run'
For at dette skal fungere så må Flutter være satt i Path variables.

Det er potensielle problemer ved å kjøre app-en på emulatorer med hardware acceleratio aktivert. For å fikse dette kan
man kjøre programmet via 'flutter run --enable-software-rendering' i kommandolinjen.

Husk å laste ned Flutter:
https://docs.flutter.dev/get-started/install