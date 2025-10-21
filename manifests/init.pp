# Class: vsftpd
#
# Install, enable and configure a vsftpd FTP server instance.
#
# Parameters:
#  see vsftpd.conf(5) for details about what the available parameters do.
# Sample Usage :
#  include vsftpd
#  class { 'vsftpd':
#    anonymous_enable  => 'NO',
#    write_enable      => 'YES',
#    ftpd_banner       => 'Marmotte FTP Server',
#    chroot_local_user => 'YES',
#  }
#
class vsftpd (
  $package_name              = 'vsftpd',
  $package_ensure            = 'installed',
  $service_name              = 'vsftpd',
  $template                  = 'vsftpd/vsftpd.conf.erb',

  # vsftpd.conf options
  $local_max_rate            =  '0',
  $max_clients               =  '0',
  $max_per_ip                =  '0',
  $anon_max_rate             =  '0',
  $trans_chunk_size          =  '0',
  $delay_successful_login    =  '0',
  $delay_failed_login        =  '1',
  $max_login_fails           =  '3',
  $accept_timeout            =  '60',
  $connect_timeout           =  '60',
  $idle_session_timeout      =  '300',
  $data_connection_timeout   =  '300',

  $ftp_data_port             =  '20',
  $listen_port               =  '21',
  $pasv_min_port             =  '0',
  $pasv_max_port             =  '0',

  $file_open_mode            =  '0666',
  $anon_umask                =  '077',
  $local_umask               =  '077',

  $guest_username            =  'ftp',
  $pam_service_name          =  'ftp',
  $ftp_username              =  'ftp',
  $chown_username            =  'root',
  $nopriv_user               =  'nobody',
  $message_file              =  '.message',
  $ssl_ciphers               =  'DES-CBC3-SHA',
  $xferlog_file              =  '/var/log/xferlog',
  $vsftpd_log_file           =  '/var/log/vsftpd.log',
  $userlist_file             =  '/etc/vsftpd/user_list',
  $chroot_list_file          =  '/etc/vsftpd/chroot_list',
  $banned_email_file         =  '/etc/vsftpd/banned_emails',
  $email_password_file       =  '/etc/vsftpd/email_passwords',
  $rsa_cert_file             =  '/usr/share/ssl/certs/vsftpd.pem',

  $force_local_data_ssl      =  'YES',
  $dirlist_enable            =  'YES',
  $download_enable           =  'YES',
  $ssl_request_cert          =  'YES',
  $userlist_deny             =  'YES',
  $anonymous_enable          =  'YES',
  $listen                    =  'YES',
  $anon_world_readable_only  =  'YES',
  $background                =  'YES',
  $port_enable               =  'YES',
  $check_shell               =  'YES',
  $chmod_enable              =  'YES',
  $use_sendfile              =  'YES',
  $mdtm_write                =  'YES',
  $reverse_lookup_enable     =  'YES',
  $ssl_tlsv1                 =  'YES',
  $force_local_logins_ssl    =  'YES',
  $pasv_enable               =  'YES',

  $local_enable              =  'NO',
  $write_enable              =  'NO',
  $anon_upload_enable        =  'NO',
  $anon_mkdir_write_enable   =  'NO',
  $dirmessage_enable         =  'NO',
  $xferlog_enable            =  'NO',
  $connect_from_port_20      =  'NO',
  $chown_uploads             =  'NO',
  $xferlog_std_format        =  'NO',
  $async_abor_enable         =  'NO',
  $ascii_upload_enable       =  'NO',
  $ascii_download_enable     =  'NO',
  $chroot_local_user         =  'NO',
  $chroot_list_enable        =  'NO',
  $ls_recurse_enable         =  'NO',
  $userlist_enable           =  'NO',
  $tcp_wrappers              =  'NO',
  $hide_ids                  =  'NO',
  $anon_other_write_enable   =  'NO',
  $setproctitle_enable       =  'NO',
  $text_userdb_names         =  'NO',
  $deny_email_enable         =  'NO',
  $dual_log_enable           =  'NO',
  $force_dot_files           =  'NO',
  $force_anon_data_ssl       =  'NO',
  $force_anon_logins_ssl     =  'NO',
  $guest_enable              =  'NO',
  $listen_ipv6               =  'NO',
  $lock_upload_files         =  'NO',
  $log_ftp_protocol          =  'NO',
  $no_anon_password          =  'NO',
  $no_log_lock               =  'NO',
  $one_process_model         =  'NO',
  $passwd_chroot_enable      =  'NO',
  $pasv_addr_resolve         =  'NO',
  $pasv_promiscuous          =  'NO',
  $port_promiscuous          =  'NO',
  $run_as_launching_user     =  'NO',
  $secure_email_list_enable  =  'NO',
  $session_support           =  'NO',
  $ssl_enable                =  'NO',
  $ssl_sslv2                 =  'NO',
  $ssl_sslv3                 =  'NO',
  $syslog_enable             =  'NO',
  $tilde_user_enable         =  'NO',
  $use_localtime             =  'NO',
  $virtual_use_local_privs   =  'NO',

  $secure_chroot_dir         =  undef,
  $pasv_address              =  undef,
  $hide_file                 =  undef,
  $banner_file               =  undef,
  $cmds_allowed              =  undef,
  $anon_root                 =  undef,
  $allow_writeable_chroot    =  undef,
  $deny_file                 =  undef,
  $dsa_cert_file             =  undef,
  $dsa_private_key_file      =  undef,
  $ftpd_banner               =  undef,
  $listen_address            =  undef,
  $listen_address6           =  undef,
  $local_root                =  undef,
  $rsa_private_key_file      =  undef,
  $user_config_dir           =  undef,
  $user_sub_token            =  undef,
  $directives                = {},
) {

  case $facts['os']['name'] {
    'RedHat',
    'CentOS',
    'Amazon': {
      $confdir = '/etc/vsftpd'
    }
    'Debian',
    'Ubuntu': {
      $confdir = '/etc'
    }
    default: {
      $confdir = '/etc/vsftpd'
    }
  }

  # Validate all the parameters!

  if $secure_chroot_dir == undef {
    case $facts['os']['name'] {
      'RedHat',
      'CentOS',
      'Amazon': {
        $secure_chroot_dir_real = '/usr/share/empty'
      }
      'Debian',
      'Ubuntu': {
        $secure_chroot_dir_real = '/var/run/vsftpd/empty'
      }
      default: {
        $secure_chroot_dir_real = '/usr/share/empty'
      }
    }
  }
  else {
    $secure_chroot_dir_real = $secure_chroot_dir
  }

  # Runtime validations for pattern-based parameters
  unless $local_umask =~ /^[0-7]{3}$/ {
    fail("vsftpd::local_umask is <${local_umask}> and must be a valid three digit mode in octal notation.")
  }

  unless $anon_umask =~ /^[0-7]{3}$/ {
    fail("vsftpd::anon_umask is <${anon_umask}> and must be a valid three digit mode in octal notation.")
  }

  unless $file_open_mode =~ /^[0-7]{4}$/ {
    fail("vsftpd::file_open_mode is <${file_open_mode}> and must be a valid four digit mode in octal notation.")
  }

  package { $package_name: ensure => $package_ensure }

  service { $service_name:
    ensure    => running,
    require   => Package[$package_name],
    enable    => true,
    hasstatus => true,
  }

  file { $secure_chroot_dir_real:
    ensure  => 'directory',
    mode    => '0555',
    owner   => 'root',
    group   => 'root',
    require => Package[$package_name],
    notify  => Service[$service_name],
  }

  file { "${confdir}/vsftpd.conf":
    require => Package[$package_name],
    content => template($template),
    notify  => Service[$service_name],
  }

}
