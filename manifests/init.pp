class pdbkup (
    String $install_dir,
) {

    include pdbkup::globus
    include pdbkup::cron

}
