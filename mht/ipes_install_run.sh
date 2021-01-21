#!/bin/bash

__ipes_install() {
	if [ -n "$(uname -a | grep x86_64)" ]; then
	#x86_64
		url=https://ipes-tus.iqiyi.com/update/ipes-linux-amd64-llc-latest.tar.gz
		file_path=/kuaicdn/res/ipes-linux-amd64-llc-latest.tar.gz
	elif [ -n "$(uname -a | grep aarch64)" ]; then
	#arm64
		url=https://ipes-tus.iqiyi.com/update/ipes-linux-arm64-llc-latest.tar.gz
		file_path=/kuaicdn/res/ipes-linux-arm64-llc-latest.tar.gz
	elif [ -n "$(uname -a | grep armv7)" ]; then 
	#arm32
		url=https://ipes-tus.iqiyi.com/update/ipes-linux-arm-llc-latest.tar.gz
		file_path=/kuaicdn/res/ipes-linux-arm-llc-latest.tar.gz
    else
        echo $(uname -a)
        echo "unsupported architecture"
        echo "ipes install failed, exit 1"
        exit 1
    fi
    echo $(uname -a)
    echo $url
    mkdir -p /kuaicdn/res /kuaicdn/app /kuaicdn/disk >/dev/null 2>&1
    rm -rf /kuaicdn/app/ipes >/dev/null 2>&1

    curl -Lo $file_path $url
    tar zxf $file_path -C /kuaicdn/app >/dev/null 2>&1
}

if [ -z "$(command -v curl)" ]; then
    apt-get update
    apt install curl
fi
if [ -z "$(command -v crontab)" ]; then
    apt install crontab
fi


if [ ! -f "/kuaicdn/app/ipes/bin/ipes" ]; then
    __ipes_install && sync
fi

# 开始设置进程路径
cache_dir=/mht_cache
if [ ! -f $cache_dir ]; then
    mkdir -p $cache_dir
fi
cacheDirs=$(ls -la $cache_dir | grep cache | awk '{print $9}')
awk6=$(cat /proc/self/mounts | grep -E '^/dev/.*/cache/' | awk '{print $2}')
yml_path='/kuaicdn/app/ipes/var/db/ipes/happ-conf/custom.yml'

echo 'args:' >$yml_path
# 开始添加进程
for path in $cacheDirs; do
    # echo $path
    echo "  - '${cache_dir}/${path}'" >>$yml_path
done

# 防止没有磁盘，程序随意新建进程路径
testss=$(cat $yml_path)
if [ "$testss"x == "args:"x ]; then
    echo "  - '/tmp/ipes_data'" >>$yml_path
fi

/kuaicdn/app/ipes/bin/ipes start

_clientid=$(find /kuaicdn/app/ipes/var/db/ipes/ -name happ | awk '{print $0" -d"}' | sh | grep '^[0-9a-zA-Z]\{32\}')
echo '猕猴桃 clientid: 请看下一行'
find /kuaicdn/app/ipes/var/db/ipes/ -name happ | awk '{print $0" -d"}' | sh | grep '^[0-9a-zA-Z]\{32\}'
tail -f /dev/null