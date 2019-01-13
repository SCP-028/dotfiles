abbr  v nvim
alias vim nvim
alias ... 'cd ../../'
alias .... 'cd ../../../'
alias la 'ls -trhla --color=always'

set -x PATH $HOME/miniconda3/bin $PATH
set -x PATH /usr/local/go/bin $PATH

# Taken from: https://blog.skk.moe/post/enable-proxy-on-ubuntu/
function proxy --description "Enable proxy in WSL"
    curl -s "https://api.ip.sb/geoip" | \
      jq '. | {Status: "oldIP", IP: .ip, Country: .country, Org: .organization}'
    set -gx ALL_PROXY "socks5://127.0.0.1:9090"
    set -gx all_proxy "socks5://127.0.0.1:9090"
    curl -s "https://api-ipv4.ip.sb/geoip" | \
      jq '. | {Status: "newIPv4", IP: .ip, Country: .country, Org: .organization}'
    curl -s "https://api-ipv6.ip.sb/geoip" | \
      jq '. | {Status: "newIPv6", IP: .ip, Country: .country, Org: .organization}'
end

function noproxy --description "Enable proxy in WSL"
    set -e ALL_PROXY 
    set -e all_proxy
    curl -s "https://api.ip.sb/geoip" | \
      jq '. | {IP: .ip, Country: .country, Org: .organization}'
end

# Taken from: https://github.com/dideler/dotfiles/blob/master/functions/extract.fish
function x  --description "Expand or extract bundled & compressed files"
  set --local ext (echo $argv[1] | awk -F. '{print $NF}')
  switch $ext
    case tar  # non-compressed, just bundled
      tar -xvf $argv[1]
    case gz
      if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with gzip
        tar -zxvf $argv[1]
      else  # single gzip
        gunzip $argv[1]
      end
    case tgz  # same as tar.gz
      tar -zxvf $argv[1]
    case bz2  # tar compressed with bzip2
      tar -jxvf $argv[1]
    case rar
      unrar x $argv[1]
    case zip
      unzip $argv[1]
    case '*'
      echo "unknown extension"
  end
end
