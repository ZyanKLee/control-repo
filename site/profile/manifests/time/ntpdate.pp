# This class installs and runs once ntpdate
class profile::time::ntpdate (
  # If given a ntpdate cron jon is scheduled. Format: * * * * *
  String $crontab    = '',

  # Server to sync to (just one)
  String $ntp_server = 'pool.ntp.org',
) {

  ensure_packages('ntpdate')

  exec { "ntpdate -s ${ntp_server}":
    subscribe   => Package['ntpdate'],
    refreshonly => true,
  }
  if $crontab != '' {
    file { '/etc/cron.d/ntpdate':
      content => "${crontab} root ntpdate -s ${ntp_server}\n",
    }
  }
}
