# list_application

Dette er Prosjekt Øvingen i IDATT2506.

## Setup
Last ned Flutter ved å følge instruksjoner fra:
https://docs.flutter.dev/get-started/install

Last ned Android Studio:
https://developer.android.com/studio

## Testing på Android Emulator


Dette programmet var testet på fysisk Samsung S20 og emulator på Android Studio. 
For å teste programmet via emulator så last ned Android Studio, og gå til AVD Manager for å opprette nytt Android Virtual Device.
Klikk Configure > AVD Manager, eller hvis prosjektet er åpent klikk Tools > AVD Manager.
Klikk Create Virtual Device, og så velg en enhet, denne applikasjonen var testet på Pixel 6 Pro satt i Software for Graphics mode. 
Velg et System Image, min emulator kjørte Android API 35. Start emulatoren.

Mer nøyaktig instruksjoner fra:
https://docs.flutter.dev/get-started/install/windows/mobile#168-tab-panel


Hent Flutter pakker med:
'flutter pub get'
Og så kjør programmet med:
'flutter run'
For at dette skal fungere så må Flutter være satt i Path variables.


Det er potensielle problemer ved å kjøre app-en på emulatorer med hardware acceleration aktivert. Hvis det er problemer med å sette opp VM acceleration (https://developer.android.com/studio/run/emulator-acceleration#accel-vm)
kan man kjøre programmet via 'flutter run --enable-software-rendering' i kommandolinjen. 

## Features
- Legge til lister ved å trykke på "+" knappen.
- Slette lister ved å trykke på knappen med søppelkasse ikon
- Kategorisere elementer på listen i "Ikke fullført" og "Fullført". Trykk på elementet for å skifte det mellom sekjsonene.
- Long press på elementer i ikke fullført seksjonen for å kunne skifte rekkefølgen på dem.
- Elementer blir lagret i Json filer lokalt.