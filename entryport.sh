#!/usr/bin/env bash

# 设置各变量
UUID=${UUID:-"69af46a6-d106-4fb1-9d86-65f301a79191"}
VMESS_WSPATH=${VMESS_WSPATH:-"/${UUID}-vm"}
VMESS_WARP_WSPATH=${VMESS_WARP_WSPATH:-"/${UUID}-vm_warp"}
VLESS_WSPATH=${VLESS_WSPATH:-"/${UUID}-vl"}
VLESS_WARP_WSPATH=${VLESS_WARP_WSPATH:-"/${UUID}-vl_warp"}
TROJAN_WSPATH=${TROJAN_WSPATH:-"/${UUID}-tj"}
TROJAN_WARP_WSPATH=${TROJAN_WARP_WSPATH:-"/${UUID}-tj_warp"}
SS_WSPATH=${SS_WSPATH:-"/${UUID}-ss"}
SS_WARP_WSPATH=${SS_WARP_WSPATH:-"/${UUID}-ss_warp"}

# 哪吒三个参数，不需要的话可以留空，删除或在这三行最前面加 # 以注释
NEZHA_SERVER= 
NEZHA_PORT=
NEZHA_KEY=

generate_config() {
  cat > config.json << EOF
{
    "log":{
        "access":"/dev/null",
        "error":"/dev/null",
        "loglevel":"none"
    },
    "inbounds":[
        {
            "port":8080,
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "flow":"xtls-rprx-vision"
                    }
                ],
                "decryption":"none",
                "fallbacks":[
                    {
                        "dest":3001
                    },
                    {
                        "dest":3002
                    },
                    {
                        "path":"${VLESS_WSPATH}",
                        "dest":3003
                    },
                    {
                        "path":"${VLESS_WARP_WSPATH}",
                        "dest":3004
                    },
                    {
                        "path":"${VMESS_WSPATH}",
                        "dest":3005
                    },
                    {
                        "path":"${VMESS_WARP_WSPATH}",
                        "dest":3006
                    },
                    {
                        "path":"${TROJAN_WSPATH}",
                        "dest":3007
                    },
                    {
                        "path":"${TROJAN_WARP_WSPATH}",
                        "dest":3008
                    },
                    {
                        "path":"${SS_WSPATH}",
                        "dest":3009
                    },
                    {
                        "path":"${SS_WARP_WSPATH}",
                        "dest":3010
                    }
                ]
            },
            "streamSettings":{
                "network":"tcp"
            }
        },
        {
            "port":3001,
            "listen":"127.0.0.1",
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}"
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "security":"none"
            }
        },
        {
            "tag":"to_warp",
            "port":3002,
            "listen":"127.0.0.1",
            "protocol":"socks",
            "settings":{
                "auth":"noauth",
                "udp":true
            }
        },
        {
            "port":3003,
            "listen":"127.0.0.1",
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "level":0
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "security":"none",
                "wsSettings":{
                    "path":"${VLESS_WSPATH}"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag":"from_vless_warp",
            "port":3004,
            "listen":"127.0.0.1",
            "protocol":"vless",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "level":0
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "security":"none",
                "wsSettings":{
                    "path":"${VLESS_WARP_WSPATH}"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "port":3005,
            "listen":"127.0.0.1",
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "alterId":0
                    }
                ]
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"${VMESS_WSPATH}"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag":"from_vmess_warp",
            "port":3006,
            "listen":"127.0.0.1",
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "alterId":0
                    }
                ]
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"${VMESS_WARP_WSPATH}"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "port":3007,
            "listen":"127.0.0.1",
            "protocol":"trojan",
            "settings":{
                "clients":[
                    {
                        "password":"${UUID}"
                    }
                ]
            },
            "streamSettings":{
                "network":"ws",
                "security":"none",
                "wsSettings":{
                    "path":"${TROJAN_WSPATH}"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag":"from_trojan_warp",
            "port":3008,
            "listen":"127.0.0.1",
            "protocol":"trojan",
            "settings":{
                "clients":[
                    {
                        "password":"${UUID}"
                    }
                ]
            },
            "streamSettings":{
                "network":"ws",
                "security":"none",
                "wsSettings":{
                    "path":"${TROJAN_WARP_WSPATH}"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "port":3009,
            "listen":"127.0.0.1",
            "protocol":"shadowsocks",
            "settings":{
                "clients":[
                    {
                        "method":"chacha20-ietf-poly1305",
                        "password":"${UUID}"
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"${SS_WSPATH}"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        },
        {
            "tag":"from_ss_warp",
            "port":3010,
            "listen":"127.0.0.1",
            "protocol":"shadowsocks",
            "settings":{
                "clients":[
                    {
                        "method":"chacha20-ietf-poly1305",
                        "password":"${UUID}"
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"${SS_WARP_WSPATH}"
                }
            },
            "sniffing":{
                "enabled":true,
                "destOverride":[
                    "http",
                    "tls"
                ],
                "metadataOnly":false
            }
        }
    ],
    "outbounds":[
        {
            "protocol":"freedom"
        },
        {
            "tag":"WARP",
            "protocol":"wireguard",
            "settings":{
                "secretKey":"GAl2z55U2UzNU5FG+LW3kowK+BA/WGMi1dWYwx20pWk=",
                "address":[
                    "172.16.0.2/32",
                    "2606:4700:110:8f0a:fcdb:db2f:3b3:4d49/128"
                ],
                "peers":[
                    {
                        "publicKey":"bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=",
                        "endpoint":"engage.cloudflareclient.com:2408"
                    }
                ],
                "mtu":1280
            }
        }
    ],
    "routing":{
        "domainStrategy":"AsIs",
        "rules":[
            {
                "type":"field",
                "domain":[
                    "domain:openai.com",
                    "domain:ai.com"
                ],
                "outboundTag":"WARP"
            },
            {
                "type":"field",
                "inboundTag":["to_warp", "from_vmess_warp", "from_vless_warp", "from_trojan_warp", "from_ss_warp"],
                "outboundTag":"WARP"
            }
        ]
    },
    "dns":{
        "servers":[
            "https+local://8.8.8.8/dns-query"
        ]
    }
}
EOF

  # WARP 优选IP
  n=0
  iplist=100
  while true; do
    temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
    n=$(($n + 1))
    if [ $n -ge $iplist ]; then
      break
    fi
    temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
    n=$(($n + 1))
    if [ $n -ge $iplist ]; then
      break
    fi
    temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
    n=$(($n + 1))
    if [ $n -ge $iplist ]; then
      break
    fi
    temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
    n=$(($n + 1))
    if [ $n -ge $iplist ]; then
      break
    fi
    temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
    n=$(($n + 1))
    if [ $n -ge $iplist ]; then
      break
    fi
    temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
    n=$(($n + 1))
    if [ $n -ge $iplist ]; then
      break
    fi
    temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
    n=$(($n + 1))
    if [ $n -ge $iplist ]; then
      break
    fi
  done
  while true; do
    if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
      break
    else
      temp[$n]=$(echo 162.159.192.$(($RANDOM % 256)))
      n=$(($n + 1))
    fi
    if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
      break
    else
      temp[$n]=$(echo 162.159.193.$(($RANDOM % 256)))
      n=$(($n + 1))
    fi
    if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
      break
    else
      temp[$n]=$(echo 162.159.195.$(($RANDOM % 256)))
      n=$(($n + 1))
    fi
    if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
      break
    else
      temp[$n]=$(echo 188.114.96.$(($RANDOM % 256)))
      n=$(($n + 1))
    fi
    if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
      break
    else
      temp[$n]=$(echo 188.114.97.$(($RANDOM % 256)))
      n=$(($n + 1))
    fi
    if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
      break
    else
      temp[$n]=$(echo 188.114.98.$(($RANDOM % 256)))
      n=$(($n + 1))
    fi
    if [ $(echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u | wc -l) -ge $iplist ]; then
      break
    else
      temp[$n]=$(echo 188.114.99.$(($RANDOM % 256)))
      n=$(($n + 1))
    fi
  done
  echo ${temp[@]} | sed -e 's/ /\n/g' | sort -u > ip.txt
  chmod +x warp-yxip && ./warp-yxip
  best_endpoint=$(cat result.csv | sed -n 2p | awk -F ',' '{print $1}')
  sed -i "s/engage.cloudflareclient.com:2408/${best_endpoint}/g" config.json
  chmod +x web.js
}

generate_nezha() {
  cat > nezha.sh << EOF
#!/usr/bin/env bash

# 哪吒的三个参数
NEZHA_SERVER=${NEZHA_SERVER}
NEZHA_PORT=${NEZHA_PORT}
NEZHA_KEY=${NEZHA_KEY}

# 检测是否已运行
check_run() {
    [[ \$(pidof nezha-agent) ]] && echo "哪吒客户端正在运行中" && exit
}

# 三个变量不全则不安装哪吒客户端
check_variable() {
    [[ -z "\${NEZHA_SERVER}" || -z "\${NEZHA_PORT}" || -z "\${NEZHA_KEY}" ]] && exit
}

# 下载最新版本 Nezha Agent
download_agent() {
    if [ ! -e nezha-agent ]; then
        URL=\$(wget -qO- -4 "https://api.github.com/repos/naiba/nezha/releases/latest" | grep -o "https.*linux_amd64.zip")
        wget -t 2 -T 10 -N \${URL}
        unzip -qod ./ nezha-agent_linux_amd64.zip && rm -f nezha-agent_linux_amd64.zip
    fi
    chmod +x nezha-agent
}

# 运行客户端
run() {
    [ -e nezha-agent ] && ./nezha-agent -s \${NEZHA_SERVER}:\${NEZHA_PORT} -p \${NEZHA_KEY}
}

check_run
check_variable
download_agent
run
wait
EOF
  chmod +x nezha.sh
}

generate_argo() {
  chmod +x cfd
  cat > argo.sh << EOF
#!/usr/bin/env bash

rm -rf argo_domain.txt &> /dev/null
status=\$(ps -ef | grep argo.sh | grep -v \$\$ | grep -v grep | awk '{ print \$2} ')
echo '\${status}'=\${status}
if [ ! -z \${status} ]; then
   echo "Already running!"
   exit 1
fi
ps -aux | grep cfd | grep -v grep &> /dev/null
if [ \$? -eq 1 ]; then
  ./cfd tunnel --edge-ip-version auto --no-autoupdate --protocol http2 --url http://localhost:8080 &
fi
while :
do
  CFD=\$(ss -nltp | grep cfd | grep -v grep)
  if [ \$? -eq 0 ]; then    
    ARGO_DOMAIN=\$(wget -qO- http://\$(echo \$CFD | awk -F ' ' '{print \$4}')/quicktunnel | cut -d\" -f4)
    echo \$ARGO_DOMAIN > argo_domain.txt
    break
  fi
done
EOF
  chmod +x argo.sh
}

generate_argo
generate_config
generate_nezha
[ -e nezha.sh ] && bash nezha.sh 2>&1 &
wait
