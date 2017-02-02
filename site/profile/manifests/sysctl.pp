# This class manages sysctl
# It uses duritong-sysctl module
# Hiera data should be in this format:
# profile::sysctl::settings:
#   net.ipv4.tcp_keepalive_time:
#     value: 900
#   net.ipv4.conf.default.arp_filter:
#     value: 1
#
class profile::sysctl {
  $my_sysctl_defaults = {}
  $my_sysctl_settings = hiera_hash('profile::sysctl::settings', {})
  if $my_sysctl_settings != {} {
    $my_sysctl_settings.each |$k,$v| {
      ::tools::sysctl { $k:
        value => $v,
      }
    }
  }
}
