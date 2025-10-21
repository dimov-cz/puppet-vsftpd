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
  validate_re($local_umask, '^[0-7]{3}$',
    "vsftpd::local_umask is <${local_umask}> and must be a valid three digit mode in octal notation."
  )
  validate_string($chown_username)
  validate_string($xferlog_file)
  validate_integer(0 + $idle_session_timeout)
  validate_integer(0 + $data_connection_timeout)
  validate_string($nopriv_user)
  validate_string($chroot_list_file)
  validate_integer(0 + $listen_port, 65535, 0)
  validate_string($pam_service_name)
  validate_integer(0 + $max_clients)
  validate_integer(0 + $max_per_ip)
  validate_integer(0 + $pasv_min_port, 65535, 0)
  validate_integer(0 + $pasv_max_port, 65535, 0)
  validate_string($ftp_username)
  validate_integer(0 + $accept_timeout)
  validate_integer(0 + $anon_max_rate)
  validate_string($anon_umask)
  validate_re($anon_umask, '^[0-7]{3}$',
    "vsftpd::anon_umask is <${anon_umask}> and must be a valid three digit mode in octal notation."
  )
  validate_integer(0 + $connect_timeout)
  validate_integer(0 + $delay_failed_login)
  validate_integer(0 + $delay_successful_login)
  validate_re($file_open_mode, '^[0-7]{4}$',
    "vsftpd::file_open_mode is <${file_open_mode}> and must be a valid four digit mode in octal notation."
  )
  validate_integer(0 + $ftp_data_port, 65535, 0)
  validate_integer(0 + $local_max_rate)
  validate_integer(0 + $max_login_fails)
  validate_integer(0 + $trans_chunk_size)
  validate_string($banned_email_file)
  validate_string($email_password_file)
  validate_string($guest_username)
  validate_string($message_file)
  validate_string($rsa_cert_file)
  validate_string($ssl_ciphers)
  validate_absolute_path($secure_chroot_dir_real)
  validate_string($userlist_file)
  validate_string($vsftpd_log_file)

  validate_re($anonymous_enable, '^(YES|NO)$',
    "vsftpd::anon_mkdir_write_enable is <${anon_mkdir_write_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($anonymous_enable, '^(YES|NO)$',
    "vsftpd::anonymous_enable is <${anonymous_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($local_enable, '^(YES|NO)$',
    "vsftpd::local_enable is <${local_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($write_enable, '^(YES|NO)$',
    "vsftpd::write_enable is <${write_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($anon_upload_enable, '^(YES|NO)$',
    "vsftpd::anon_upload_enable is <${anon_upload_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($anon_mkdir_write_enable, '^(YES|NO)$',
    "vsftpd::anon_mkdir_write_enable is <${anon_mkdir_write_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($dirmessage_enable, '^(YES|NO)$',
    "vsftpd::dirmessage_enable is <${dirmessage_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($xferlog_enable, '^(YES|NO)$',
    "vsftpd::xferlog_enable is <${xferlog_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($connect_from_port_20, '^(YES|NO)$',
    "vsftpd::connect_from_port_20 is <${connect_from_port_20}>. Must be either 'YES' or 'NO'.")

  validate_re($chown_uploads, '^(YES|NO)$',
    "vsftpd::chown_uploads is <${chown_uploads}>. Must be either 'YES' or 'NO'.")

  validate_re($xferlog_std_format, '^(YES|NO)$',
    "vsftpd::xferlog_std_format is <${xferlog_std_format}>. Must be either 'YES' or 'NO'.")

  validate_re($async_abor_enable, '^(YES|NO)$',
    "vsftpd::async_abor_enable is <${async_abor_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($ascii_upload_enable, '^(YES|NO)$',
    "vsftpd::ascii_upload_enable is <${ascii_upload_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($ascii_download_enable, '^(YES|NO)$',
    "vsftpd::ascii_download_enable is <${ascii_download_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($chroot_local_user, '^(YES|NO)$',
    "vsftpd::chroot_local_user is <${chroot_local_user}>. Must be either 'YES' or 'NO'.")

  validate_re($chroot_list_enable, '^(YES|NO)$',
    "vsftpd::chroot_list_enable is <${chroot_list_enable}>. Must be either 'YES' or 'NO'.")

  if $allow_writeable_chroot != undef {
    validate_re($allow_writeable_chroot, '^(YES|NO)$',
      "vsftpd::allow_writeable_chroot is <${allow_writeable_chroot}>. Must be either 'YES' or 'NO'.")
  }

  validate_re($ls_recurse_enable, '^(YES|NO)$',
    "vsftpd::ls_recurse_enable is <${ls_recurse_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($listen, '^(YES|NO)$',
    "vsftpd::listen is <${listen}>. Must be either 'YES' or 'NO'.")

  validate_re($userlist_enable, '^(YES|NO)$',
    "vsftpd::userlist_enable is <${userlist_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($userlist_deny, '^(YES|NO)$',
    "vsftpd::userlist_deny is <${userlist_deny}>. Must be either 'YES' or 'NO'.")

  validate_re($tcp_wrappers, '^(YES|NO)$',
    "vsftpd::tcp_wrappers is <${tcp_wrappers}>. Must be either 'YES' or 'NO'.")

  validate_re($hide_ids, '^(YES|NO)$',
    "vsftpd::hide_ids is <${hide_ids}>. Must be either 'YES' or 'NO'.")

  validate_re($setproctitle_enable, '^(YES|NO)$',
    "vsftpd::setproctitle_enable is <${setproctitle_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($text_userdb_names, '^(YES|NO)$',
    "vsftpd::text_userdb_names is <${text_userdb_names}>. Must be either 'YES' or 'NO'.")

  validate_re($ssl_request_cert, '^(YES|NO)$',
    "vsftpd::ssl_request_cert is <${ssl_request_cert}>. Must be either 'YES' or 'NO'.")

  validate_re($anon_other_write_enable, '^(YES|NO)$',
    "vsftpd::anon_other_write_enable is <${anon_other_write_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($anon_world_readable_only, '^(YES|NO)$',
    "vsftpd::anon_world_readable_only is <${anon_world_readable_only}>. Must be either 'YES' or 'NO'.")

  validate_re($background, '^(YES|NO)$',
    "vsftpd::background is <${background}>. Must be either 'YES' or 'NO'.")

  validate_re($check_shell, '^(YES|NO)$',
    "vsftpd::check_shell is <${check_shell}>. Must be either 'YES' or 'NO'.")

  validate_re($chmod_enable, '^(YES|NO)$',
    "vsftpd::chmod_enable is <${chmod_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($deny_email_enable, '^(YES|NO)$',
    "vsftpd::deny_email_enable is <${deny_email_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($dirlist_enable, '^(YES|NO)$',
    "vsftpd::dirlist_enable is <${dirlist_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($download_enable, '^(YES|NO)$',
    "vsftpd::download_enable is <${download_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($dual_log_enable, '^(YES|NO)$',
    "vsftpd::dual_log_enable is <${dual_log_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($force_dot_files, '^(YES|NO)$',
    "vsftpd::force_dot_files is <${force_dot_files}>. Must be either 'YES' or 'NO'.")

  validate_re($force_anon_data_ssl, '^(YES|NO)$',
    "vsftpd::force_anon_data_ssl is <${force_anon_data_ssl}>. Must be either 'YES' or 'NO'.")

  validate_re($force_anon_logins_ssl, '^(YES|NO)$',
    "vsftpd::force_anon_logins_ssl is <${force_anon_logins_ssl}>. Must be either 'YES' or 'NO'.")

  validate_re($force_local_data_ssl, '^(YES|NO)$',
    "vsftpd::force_local_data_ssl is <${force_local_data_ssl}>. Must be either 'YES' or 'NO'.")

  validate_re($force_local_logins_ssl, '^(YES|NO)$',
    "vsftpd::force_local_logins_ssl is <${force_local_logins_ssl}>. Must be either 'YES' or 'NO'.")

  validate_re($guest_enable, '^(YES|NO)$',
    "vsftpd::guest_enable is <${guest_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($listen_ipv6, '^(YES|NO)$',
    "vsftpd::listen_ipv6 is <${listen_ipv6}>. Must be either 'YES' or 'NO'.")

  validate_re($lock_upload_files, '^(YES|NO)$',
    "vsftpd::lock_upload_files is <${lock_upload_files}>. Must be either 'YES' or 'NO'.")

  validate_re($log_ftp_protocol, '^(YES|NO)$',
    "vsftpd::log_ftp_protocol is <${log_ftp_protocol}>. Must be either 'YES' or 'NO'.")

  validate_re($mdtm_write, '^(YES|NO)$',
    "vsftpd::mdtm_write is <${mdtm_write}>. Must be either 'YES' or 'NO'.")

  validate_re($no_anon_password, '^(YES|NO)$',
    "vsftpd::no_anon_password is <${no_anon_password}>. Must be either 'YES' or 'NO'.")

  validate_re($no_log_lock, '^(YES|NO)$',
    "vsftpd::no_log_lock is <${no_log_lock}>. Must be either 'YES' or 'NO'.")

  validate_re($one_process_model, '^(YES|NO)$',
    "vsftpd::one_process_model is <${one_process_model}>. Must be either 'YES' or 'NO'.")

  validate_re($passwd_chroot_enable, '^(YES|NO)$',
    "vsftpd::passwd_chroot_enable is <${passwd_chroot_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($pasv_addr_resolve, '^(YES|NO)$',
    "vsftpd::pasv_addr_resolve is <${pasv_addr_resolve}>. Must be either 'YES' or 'NO'.")

  validate_re($pasv_enable, '^(YES|NO)$',
    "vsftpd::pasv_enable is <${pasv_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($pasv_promiscuous, '^(YES|NO)$',
    "vsftpd::pasv_promiscuous is <${pasv_promiscuous}>. Must be either 'YES' or 'NO'.")

  validate_re($port_enable, '^(YES|NO)$',
    "vsftpd::port_enable is <${port_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($port_promiscuous, '^(YES|NO)$',
    "vsftpd::port_promiscuous is <${port_promiscuous}>. Must be either 'YES' or 'NO'.")

  validate_re($reverse_lookup_enable, '^(YES|NO)$',
    "vsftpd::reverse_lookup_enable is <${reverse_lookup_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($run_as_launching_user, '^(YES|NO)$',
    "vsftpd::run_as_launching_user is <${run_as_launching_user}>. Must be either 'YES' or 'NO'.")

  validate_re($secure_email_list_enable, '^(YES|NO)$',
    "vsftpd::secure_email_list_enable is <${secure_email_list_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($session_support, '^(YES|NO)$',
    "vsftpd::session_support is <${session_support}>. Must be either 'YES' or 'NO'.")

  validate_re($ssl_enable, '^(YES|NO)$',
    "vsftpd::ssl_enable is <${ssl_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($ssl_sslv2, '^(YES|NO)$',
    "vsftpd::ssl_sslv2 is <${ssl_sslv2}>. Must be either 'YES' or 'NO'.")

  validate_re($ssl_sslv3, '^(YES|NO)$',
    "vsftpd::ssl_sslv3 is <${ssl_sslv3}>. Must be either 'YES' or 'NO'.")

  validate_re($ssl_tlsv1, '^(YES|NO)$',
    "vsftpd::ssl_tlsv1 is <${ssl_tlsv1}>. Must be either 'YES' or 'NO'.")

  validate_re($syslog_enable, '^(YES|NO)$',
    "vsftpd::syslog_enable is <${syslog_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($tilde_user_enable, '^(YES|NO)$',
    "vsftpd::tilde_user_enable is <${tilde_user_enable}>. Must be either 'YES' or 'NO'.")

  validate_re($use_localtime, '^(YES|NO)$',
    "vsftpd::use_localtime is <${use_localtime}>. Must be either 'YES' or 'NO'.")

  validate_re($use_sendfile, '^(YES|NO)$',
    "vsftpd::use_sendfile is <${use_sendfile}>. Must be either 'YES' or 'NO'.")

  validate_re($virtual_use_local_privs, '^(YES|NO)$',
    "vsftpd::virtual_use_local_privs is <${virtual_use_local_privs}>. Must be either 'YES' or 'NO'.")

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
