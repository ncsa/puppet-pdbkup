class pdbkup::cron (
    Boolean $enable_daily_jobs,
    Boolean $enable_often_jobs,
    Integer[0,23] $often_start_hour,
    Integer[1,12] $often_frequency,
) {

    # Cron Defaults
    Cron {
        ensure      => present,
        user        => 'root',
        minute      => 0,
        hour        => absent,
        monthday    => absent,
        month       => absent,
        weekday     => absent,
        environment => [ 'DATE=date +%y%m%d_%H%M%S' ],
    }

    # Ensure /root/cron directory exists
    ensure_resource( 'file', '/root/cron', { ensure   => 'directory',
                                             owner    => 'root',
                                             group    => 'root',
                                             mode     => '0700',
                                           }
    )

    # Ensure /root/cronlogs directory exists
    $cronlogs = '/root/cronlogs'
    ensure_resource( 'file', $cronlogs, { ensure   => 'directory',
                                             owner    => 'root',
                                             group    => 'root',
                                             mode     => '0700',
                                           }
    )


    # pdbkup run cmd
    $run = "${pdbkup::install_dir}/bin/run.sh"

    ### DAILY JOBS
    if $enable_daily_jobs == true {
        $ensure_daily = present
    }
    else {
        $ensure_daily = absent
    }

#    # TESTING
#    cron { 'atest' :
#        ensure  => $ensure_daily,
#        command => "echo a test 1>${cronlogs}/\$(\$DATE)_atest.out 2>&1",
#        minute  => absent,
#    }

    # Wrap up completed archives
    cron { 'pdbkup_wrapup' :
        ensure  => $ensure_daily,
        command => "${run} bkup -d wrapup 1>${cronlogs}/\$(\$DATE)_bkup_wrapup.out 2>&1",
        hour    => 0,
    }

    # Clean up completed transfers
    cron { 'pdbkup_txfr_clean' :
        ensure  => $ensure_daily,
        command => "${run} txfr -d clean 1>${cronlogs}/\$(\$DATE)_txfr_clean.out 2>&1",
        hour    => 0,
    }

    # Purge cruft
    cron { 'pdbkup_purge' :
        ensure  => $ensure_daily,
        command => "${run} bkup -d purge 1>${cronlogs}/\$(\$DATE)_bkup_purge 2>&1",
        hour    => 0,
        minute  => 15,
    }

    # Start new transfers
    cron { 'pdbkup_txfr_startnew' :
        ensure  => $ensure_daily,
        command => "${run} txfr -d startnew 1>${cronlogs}/\$(\$DATE)_txfr_startnew 2>&1",
        hour    => 0,
        minute  => 30,
    }

    # Initialize new backups
    $init_filename = '/root/cron/pdbkup_init.sh'
    file { $init_filename :
        ensure  => $ensure_daily,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => epp( 'pdbkup/pdbkup_init.epp', {
            'runcmd' => $run,
            }
        ),
    }
    cron { 'pdbkup_init' :
        ensure  => $ensure_daily,
        command => "${init_filename} 1>${cronlogs}/\$(\$DATE)_pdbkup_init.out 2>&1",
        hour    => 2,
        minute  => 30,
    }


    ### OFTEN JOBS
    $start_hours = range( $often_start_hour, 23, $often_frequency )

    # Allow disabled cron jobs to be removed from node so they no longer run
    if $enable_often_jobs == true {
        $ensure_often = present
    }
    else {
        $ensure_often = absent
    }

    # Start workers
    cron { 'pdbkup_startworker' :
        ensure  => $ensure_often,
        command => "${run} bkup startworker -d 1>${cronlogs}/\$(\$DATE)_bkup_startworker 2>&1",
        hour    => $start_hours,
        minute  => 30,
    }

}
