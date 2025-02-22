setup() {
    load '../test_helper/common-setup'
    _common_setup "Framework"

    source "$PROJECT_ROOT/Framework/fus.sh"
}

teardown() {
    :
}

#: << SKIP

@test "Globale Variablen" {

    # Wert von Variable ROOT_DIR ist bestimmtes Verzeichnis
    [[  -f "$ROOT_DIR/include/base.sh" ]]

    # Wert von Variable PROJECT_DIR ist bestimmtes Verzeichnis
    [[  -f "$PROJECT_DIR/Makefile" ]]
}

@test "Inklusionen" {
    [[ -v LightSkyBlue3_1  ]]
}

@test "Nachrichten" {

    # 2 Zu wenig Argumente
    run _
        assert_failure 2
        assert_output ""

    # 3 Zu viele Argumente
        assert_failure 2
        assert_output ""

    # 4 ok
    run _ "arg1_needed"
        assert_success
        assert_output "Es wird genau ein Argument benötigt"

    # 5 Kenner nicht da
    run _ "arg1_eeded"
        assert_failure 1
        assert_output "Nachricht für doc4you nicht gefunden"
}

@test "_am_root" {
    run _am_root
}


#SKIP