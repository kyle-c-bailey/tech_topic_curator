class Phrase < ApplicationRecord
  has_many :phrase_entries, dependent: :destroy

  SOFTWARE_OS = ['windows', 'win7', 'win 7', 'win 10', 'win10', 'win 8', 'win8', 'mac os', 'osx', 'ubuntu', 'linux', 'opensuse', 'debian', 'freebsd', 'symbian', 'openbsd', 'bsd', 'netbsd', 'sunos', 'ios', 'android', 'os x']
  BIG_COMPANIES = ['Alphabet', 'Amazon', 'AMD', 'Apple', 'Cisco', 'Dell', 'Foxconn', 'Google', 'HP', 'HPE', 'Huawei', 'IBM', 'Intel', 'Lenovo', 'LG', 'Linksys', 'Logitech', 'Mac', 'Microsoft', 'Netgear', 'Panasonic', 'Samsung', 'SanDisk', 'Seagate', 'Sony', 'Toshiba']
  PRODUCT = ['Aironet', 'AirWatch', 'Amazon S3', 'AnyConnect', 'AppRiver', 'ASA 5505', 'Astaro', 'Asterisk', 'AutoCAD', 'Avast', 'AVG', 'Axcient', 'Azure', 'Backblaze', 'Backup Exec', 'BackupAssist', 'Bitdefender', 'Bomgar', 'Carbonite', 'CentOS', 'cisco 5505', 'Citrix', 'CloneZilla', 'Crystal Reports', 'DameWare', 'DBAN', 'dd wrt', 'dd-wrt', 'ddwrt', 'Debian', 'designjet', 'DisplayLink', 'dl380', 'Dropbox', 'DynDNS', 'EC2', 'Egnyte', 'Elastix', 'Epicor', 'ESET', 'ESXi', 'esxi', 'Evernote', 'EveryCloud', 'Exchange Server', 'Faronics', 'FileZilla', 'Firebox', 'Fortigate', 'Fortinet', 'FreeNAS', 'FreePBX', 'g3', 'g5', 'g6', 'GoDaddy', 'GoToMeeting', 'GoToMyPC', 'Hamachi', 'hyper v', 'Hyper-V', 'hyperv', 'Intune', 'Joomla', 'KACE', 'Kaspersky', 'KeePass', 'LastPass', 'Lepide', 'Lepide', 'Linux Mint', 'LogMeIn', 'Lotus Notes', 'Lucidchart', 'Lync', 'MailMeter', 'Mailstore', 'Malwarebytes', 'Meraki', 'Mitel3000', 'Mitel5000', 'ml350', 'Mozy', 'MXToolbox', 'MySql', 'Nagios', 'NETAPP', 'NetWorker', 'Netwrix', 'Nmap', 'NSA 24', 'NSA 240', 'NSA 45', 'Office 2007', 'Office 365', 'Open Mesh', 'OpenDNS', 'openfire', 'Opsview', 'ownCloud', 'PDQ', 'PDQ', 'PGP', 'Postini', 'probook', 'procurve', 'proliant', 'PRTG', 'QuickBooks', 'Rackspace', 'ReadyNAS', 'shadow protect', 'ShadowProtect', 'Shoretel', 'SoftLayer', 'SonicWALL TZ', 'SpamTitan', 'SpinRite', 'Splashtop', 'SQL Server', 'StarWind', 'StarWind Virtual SAN', 'SuSE', 'TeamViewer', 'TightVNC', 'tp link', 'Tp-Link', 'tplink', 'Trend Micro', 'TrueCrypt', 'UltraVnc', 'UniFi', 'Unitrends', 'Untangle', 'UserLock', 'vCenter', 'Veeam', 'Verisign', 'vipre', 'VirtualBox', 'VMWARE', 'vnc', 'VoicePulse', 'vSphere', 'WatchGuard', 'WebEx', 'Webroot', 'Wireshark', 'Wordpress', 'XenApp', 'XenServer', 'YubiKey', 'Zimbra', 'Zoolz']

  def count
    self.phrase_entries.count
  end

  def software_os?
    self.content.split.each do |word|
      return true if SOFTWARE_OS.include?(word.downcase)
    end
    false
  end

  def product?
    PRODUCT.include?(self.content.downcase) || PRODUCT.include?(self.content)
  end

  def big_company?
    self.content.split.each do |word|
      return true if BIG_COMPANIES.include?(word)
    end
    false
  end

  def self.create_or_increment(content, entry_id)
    phrase = Phrase.where(content: content).take
    unless phrase.present?
      phrase = Phrase.create!(content: content)
    end
    PhraseEntry.create!(phrase_id: phrase.id, entry_id: entry_id)
  end
end
