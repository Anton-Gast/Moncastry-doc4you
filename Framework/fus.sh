#!/usr/bin/env bash
#x_shellcheck disable=all
# :: Funktionssammlung für Framework doc4you
  # :name: fus
  # :type: module
  # :desc: Enthält Funktionen, die für mehrere Skripte dieses Projekts nützlich
  #        sind
  # :deps: SCRIPT_DIR/fus4sh/base.sh (mit colors.dat u. messages.dat)
#
# SOURCES: fus4sh inkludieren; MSG und MSG_MAP füllen und exportieren
  # :impl: Die Reihenfolge ist zu beachten.
  #        MSG und MSG_MAP werden in base.sh deklariert
  #           in msgs.dat gefüllt
  #           hier readonly gesetzt
  #
  # Der folgende source-path funktioniert falls fus4sh ins Projekt gelinkt ist
  # Möglicherweise muß man ihn direct über die SOURCE Anweisung verschieben
  # shellcheck source-path=SCRIPTDIR/../fus4sh
  show_functions=1
  root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
  root_dir="${root_dir%/Framework}" # entfernt trailing "/Framework"
  script_dir="$(printenv SCRIPT_DIR)"  || :
  if [[ -f "${script_dir}/fus4sh/include/base.sh" ]]; then
    # SCRIPT_DIR ist unabhängig von diesem Projekt
    # Shellcheck kann nicht mit Variablen
    # Es liest Direktiven auch aus Konfigurationsdateien .shellcheckrc
    # Wir geben die nötigen Direktiven aus, fall kein .shellcheckrc existiert
    if ! [[ -f "${root_dir}/.shellcheckrc" ]]; then
        echo "fus4sh wird durch \"SCRIPT_DIR\" als \"${SCRIPT_DIR}/fus4sh\""
        echo "eingebunden. Shellcheck kann Pfade nicht über Variablen auflösen."
        echo "Es kann diese Pfade aus seiner Konfigurationsdatei lesen."
        echo ""
        echo "Dieses Script mit der Option -c aufgerufen erstellt sie:"
        echo "${root_dir}/Framework/fus.sh -c"
        echo ""
        echo "Manuell können Sie so verfahren:"
        echo "Legen Sie eine Datei \"${root_dir}/.shellcheckrc\" an."
        echo "Schreiben Sie folgende zwei Textzeilen in diese Datei: "
        echo ""
        echo "source-path=${SCRIPT_DIR}"
        echo "source-path=${SCRIPT_DIR}/fus4sh"
        echo ""
        show_functions=0
    fi
  else # fus4sh ist in die Projektwurzel verlinkt
      script_dir="${root_dir}"
  fi
  #script_dir="/home/user/Skripte"                   # Direkte Anpassung
  #shellcheck source-path=/home/user/Skripte         # Direkte Anpassung
  #shellcheck source-path=/home/user/Skripte/fus4sh  # Direkte Anpassung
. "${script_dir}/fus4sh/include/base.sh"
  unset script_dir
  unset root_dir
. "./Framework/msgs.dat"
    #shellcheck disable=2090
    export MSG;export MSG_MAP
#
# :: Schreibt .shellcheckrc
  # :name: create_config
  # :type: procedure
create_config() {
    cfg_file="${PROJECT_DIR}/.shellcheckrc"
    if [[ -f "${cfg_file}" ]]; then
        echo "Schreibe ${cfg_file} neu"
    else
        echo "Erzeuge ${cfg_file}"
    fi
    echo "source-path=${SCRIPT_DIR}" > "${cfg_file}"
    echo "source-path=${SCRIPT_DIR}/fus4sh" >> "${cfg_file}"
}
#
# :: Gibt die Hilfe aus
  # :name: help_fus
  # :type: procedure
  # :scop: readonly
help_fus() {
  local description
  read -r -d '' description <<- DESCRIPTION
	AUFRUF: fus.sh -h
	        fus.sh --help
	        fus.sh -c create config, erzeugt die Shellcheck Konfiguration
	        fus.sh

	BESCHREIBUNG
	    Diese Datei ist in erster Linie eine Funktionssammlung. Dazu wird sie
	    in andere Scripte inkludiert.

	    Als Funktionssammlung verlinkt sie in "fus4sh", ein weiteres Projekt
	    der Moncastry-Suite. Dieses wird über die Umgebungsvariable "SCRIPT_DIR"
	    gefunden oder über einen symbolischen Link:
	        ln -s ${SCRIPT_DIR}/fus4sh ${PROJECT_DIR}

	    Bei Aufruf mit der Option -c wird die Shellcheck Konfigurationsdatei
	    ${PROJECT_DIR}/.shellcheckrc (neu) erzeugt. Eine vorhandene
	    .shellcheckrc wird dabei überschrieben. .shellcheckrc wird nur gebraucht,
	    wenn Scripte dieses Projektes mit shellcheck überprüft werden sollen und
	    dann nur, falls fus4sh über die Umgebungsvariable "SCRIPT_DIR" eingebunden
	    ist.

	    Wenn diese Datei als Script aufgerufen wird, zeigt sie die implementierten
	    Funktionen mit einer Kurzbeschreibung an.
	DESCRIPTION

  _help "${description}"
};readonly -f help_fus
#
# :: Gibt den Namen der Datei aus und alle implementierten Funktionen
  # :name: main_fus
  # :type: procedure
  # :desc: Gibt den Namen der Datei aus und gibt danach die Namen aller
  #        implementierten Funktionen mit einer Kurzbeschreibung aus.
  # :impl: Das Einlesen des Heredoc mit der Umleitung "<<-" bewirkt, dass
  #        die Tabulatoren am Zeilenanfang entfernt werden.
main_fus() {
  # shellcheck disable=2046 disable=2312
  set -- $( _long2short_opts "$@" )
  while getopts ch opt; do { case ${opt} in
      c) create_config; exit;;
      h) help_fus; exit;;
      ?) help_fus; exit 2;;
      *) help_fus; exit 2;; # für shellcheck
  esac } done
  shift $((OPTIND-1))

  if ((show_functions > 0 )); then
  echo "in fus.sh"

  cat <<- AUSGABE
	Funktionen in dieser Sammlung
	=============================
  create_config                    Schreibt .shellcheckrc
	AUSGABE
  fi
}; readonly -f main_fus
#
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  # Wird nur aufgerufen, wenn die Datei direkt als Skript gestartet wird.
  # Wir weder aufgerufen, wenn sie inkludiert wird, noch wenn sie getestet wird.
    main_fus "$@"
fi