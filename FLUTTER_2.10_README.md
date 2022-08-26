Текущее состояние перевода проекта на новую версию Flutter. 

1. Кодовая база проекта переведена на Null-safety, обновлены используемые пакеты, deprecated-методы и свойства заменены на актуальные.

2. Заменены самописные библиотеки на стандартные:
1) receive_sharing  (https://github.com/afterlogic/receive_sharing) -> receive_sharing_intent (pub.dev)

3. Обновлены пакеты/плагины:
1) crypto_stream (https://github.com/afterlogic/flutter_crypto_stream) ветка "flutter_2.10"
2) build_variant (https://github.com/afterlogic/build_variant) ветка "flutter_2.10"
3) localizator (https://github.com/afterlogic/flutter_localizator.git) ветка "flutter_2.10"
4) aurora_logger (https://github.com/afterlogic/aurora_logger_flutter) ветка "master", предыдущее состояние сохранено в ветке
   "flutter_2.2.3"
5) aurora_ui_kit (https://github.com/afterlogic/aurora_ui_kit_flutter) ветка "master", предыдущее состояние сохранено в ветке
   "flutter_2.2.3"

4. Текущие вопросы:
1) пакет build_variant после обновления не все свойства заменяет согласно входному build_variant.yaml

5. Осталось:
1) проверить корректность работы цветовых тем для разных конфигураций
2) проверить/обновить плагин yubico_flutter (https://github.com/afterlogic/yubico_flutter)
3) заменить самописный пакет localizator на стандартное решение
