#!/bin/bash
# sudo vim /etc/locale.gen
# sudo locale-gen

locales=("en_US.utf8" "en_GB.utf8" "fr_FR.utf8" "de_DE.utf8" "es_ES.utf8" "ja_JP.utf8" "ru_RU.utf8" "en_DK.utf8")

unset LC_ALL
sudo cp /etc/locale.gen{,.bak}

for locale in "${locales[@]}"
do
    echo "Changing to $locale"
    sudo locale-gen $locale >/dev/null
    export LC_TIME=$locale 2>/dev/null
    # export LC_ALL=$locale
    date
    echo ""
done

# restore
sudo mv /etc/locale.gen{.bak,}
sudo locale-gen >/dev/null
