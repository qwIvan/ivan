#!/bin/sh

#自动翻墙脚本，配合shadowsocks-libev的ss-redir使用。需要ipset
server_IP1=45.127.93.239

chnroute_file=/home/ivan/chnroute.txt

update(){
  curl 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | grep ipv4 | grep CN | awk -F\| '{ printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > $chnroute_file
  echo "127.0.0.1/24" >> $chnroute_file
}

if [[ -r $chnroute_file ]]; then
  current=`date +%s`
  last_modified=`stat -c "%Y" $chnroute_file`
  if [[ $(($current-$last_modified)) -gt 604800 ]]; then
    if ping -q -c 1 -W 1 ftp.apnic.net >/dev/null; then
      update
    fi
  fi
else
  update
fi

start_rule(){
	sudo iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS
}

stop_rule(){
	sudo iptables -t nat -D OUTPUT -p tcp -j SHADOWSOCKS
}

add_tables(){
	sudo iptables -t nat -N SHADOWSOCKS

	sudo iptables -t nat -A SHADOWSOCKS -d $server_IP1 -j RETURN

	sudo iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
	sudo iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

	sudo ipset create chnroute hash:net
	cat $chnroute_file | sudo xargs -I ip ipset add chnroute ip

	sudo iptables -t nat -A SHADOWSOCKS -m set --match-set chnroute dst -j RETURN

	sudo iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1080

	start_rule
}
sudo iptables -t nat -C OUTPUT -p tcp -j SHADOWSOCKS || add_tables
