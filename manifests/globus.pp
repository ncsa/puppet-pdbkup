class pdbkup::globus (
    String $cli_config,
) {

    file { '/root/.globus.cfg' :
        ensure  => link,
        target  => $cli_config,
        replace => yes,
    }


}
