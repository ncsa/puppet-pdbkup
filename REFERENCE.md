# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`pdbkup`](#pdbkup): 
* [`pdbkup::cron`](#pdbkupcron): 
* [`pdbkup::globus`](#pdbkupglobus): 

## Classes

### pdbkup

The pdbkup class.

#### Parameters

The following parameters are available in the `pdbkup` class.

##### `install_dir`

Data type: `String`



### pdbkup::cron

The pdbkup::cron class.

#### Parameters

The following parameters are available in the `pdbkup::cron` class.

##### `enable_daily_jobs`

Data type: `Boolean`



##### `enable_often_jobs`

Data type: `Boolean`



##### `often_start_hour`

Data type: `Integer[0,23]`



##### `often_frequency`

Data type: `Integer[1,12]`



### pdbkup::globus

The pdbkup::globus class.

#### Parameters

The following parameters are available in the `pdbkup::globus` class.

##### `cli_config`

Data type: `String`



