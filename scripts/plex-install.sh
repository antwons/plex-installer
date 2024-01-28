#!/bin/bash

#Part 1: Docker Install 

read -p "Would you like to install Docker & Docker Compose? (y/n): " install_docker

    if [[ "$install_docker" == "y" || "$install_docker" == "Y" ]]; then 
        echo "We are going to now install Docker and Docker-Compose"
        sleep 2
        read -p "But first we need to know, are you running Fedora? (y/n)" fedora
            if [[ "$fedora" == "y" || "$fedora" == "Y" ]]; then
                echo "Okay, we are running the Docker install for Fedora"
                sleep 2
                yum install sudo && sudo yum install git -y && sudo git clone https://github.com/antwons/Docker-Install.git && cd Docker-Install/scripts && bash menu.sh
            else
                echo "Okay, we are running the our basic Docker-Install"
                sleep 2
                apt install sudo && sudo apt install git -y && sudo git clone https://github.com/antwons/Docker-Install.git && cd Docker-Install/scripts && bash menu.sh
            fi
    else
        echo "Okay, you've opt'd away from installing Docker. Please note that this install can only use Docker to install our Plex Stack"
        sleep 2
    fi

clear
sleep 2
echo "Now we are going to install Plex!"

#Part 2: Plex Install 
clear
sleep 1

cd /home
mkdir plex
cd plex
mkdir config
mkdir shares
mkdir docker

cd /home/plex/shares
mkdir movies
mkdir tv_shows
mkdir downloads

cd /home/plex/shares
chmod 777 movies tv_shows downloads

#plex claim token
echo "Hi, we need your Plex Claim Token."
echo 
echo "To get this plex claim token, please go to https://www.plex.tv/claim/ and input that code."
echo
read -p "Please type in your plex claim token here: " claimtoken

cd /home/plex/docker
echo "version: \"2.1\"
services:
  plex:
    image: lscr.io/linuxserver/plex:latest
    container_name: plex
    network_mode: host
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Los_Angeles
      - VERSION=docker
      - PLEX_CLAIM=$claimtoken
    volumes:
      - /home/plex/config:/config
      - /home/plex/shares/tv_shows:/tv
      - /home/plex/shares/movies:/movies
    restart: always" >> plex_docker-compose.yml

docker compose -f plex_docker-compose.yml up -d

clear
sleep 2
echo "Now we are going to install Prowlarr"
sleep 2
clear

#Part 3: Prowlarr instal 

cd /home
mkdir prowlarr
cd prowlarr
mkdir config
mkdir docker

cd /home/prowlarr/docker
echo "version: \"2.1\"
services:
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Los_Angeles
    volumes:
      - /home/prowlarr/config:/config
    ports:
      - 9696:9696
    restart: always" >> prowlarr_docker-compose.yml
docker compose -f prowlarr_docker-compose.yml up -d

clear
sleep 2
echo "Now we are going to install Radarr & Sonarr" 

#Part 4a: Radar Install 
cd /home
mkdir radarr
cd radarr
mkdir config
mkdir docker
cd /home/radarr/docker
echo "version: \"2.1\"
services:
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Los_Angeles
    volumes:
      - /home/radarr/config:/config
      - /home/plex/shares/movies:/movies
      - /home/plex/shares/downloads:/downloads
    ports:
      - 7878:7878
    restart: always" >> radarr_docker-compose.yml
docker compose -f radarr_docker-compose.yml up -d

#Part 4b: Sonarr Install 
cd /home
mkdir sonarr
cd sonarr
mkdir config
mkdir docker
cd /home/sonarr/docker
echo "version: \"2.1\"
services:
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    # If you want to run PostgreSQL with Sonarr, use the below image -
    # - instead of the latest version
    # image: lscr.io/linuxserver/sonarr:develop
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Los_Angeles
    volumes:
      - /home/sonarr/config:/config
      - /home/plex/shares/tv_shows:/tv
      - /home/plex/shares/downloads:/downloads
    ports:
      - 8989:8989
    restart: always" >> sonarr_docker-compose.yml
docker compose -f sonarr_docker-compose.yml up -d

clear
sleep 2
echo "Now we are going to install QBITTORRENT"

#part 5: Qbittorrent install 
cd /home
mkdir qbit
cd qbit
mkdir config
mkdir docker
cd /home/qbit/docker
echo "version: \"2.1\"
services:
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Los_Angeles
      - WEBUI_PORT=8080
    volumes:
      - /home/qbit/config:/config
      - /home/plex/shares/downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: always" >> qbit_docker-compose.yml
docker compose -f qbit_docker-compose.yml up -d

echo "The username to login to QBITTORRENT is admin and password is found in the logs of Qbit"
sleep 4
clear
sleep 2
echo "Now we are going to install Ombi"

#Part 6: Ombi install 
cd /home
mkdir ombi
cd ombi
mkdir config
mkdir docker
cd /home/ombi/docker
echo "version: \"2.1\"
services:
  ombi:
    image: lscr.io/linuxserver/ombi:latest
    container_name: ombi
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Los_Angeles
    volumes:
      - /home/ombi/config:/config
    ports:
      - 3579:3579
    restart: always" >> ombi_docker-compose.yml
docker compose -f ombi_docker-compose.yml up -d 

clear
sleep 2
read -p "Would you like to install Unpackerr? Please note that after this installer, there is some configuration that you'll need to do for unpackerr. (y/n)" unpackerrinstall
    if [[ "$unpackerrinstall" == "y" || "$unpackerrinstall" == "Y" ]]; then
        clear
        sleep 2
        echo "Now we will install unpackerr" 
        cd /home
        mkdir unpackerr
        cd unpackerr
        mkdir config
        mkdir docker
        cd /home/unpackerr/docker
        echo "version: \"3.7\"
            services:

            unpackerr:
                image: golift/unpackerr
                container_name: unpackerr
                volumes:
                # You need at least this one volume mapped so Unpackerr can find your files to extract.
                # Make sure this matches your -arr apps; the folder mount (/downloads or /data) should be identical.
                - /home/plex/shares/downloads:/downloads
                restart: always
                # Get the user:group correct so unpackerr can read and write to your files.
                user: 1000:1000
                environment:
                - TZ=${TZ}
                # General config
                - UN_DEBUG=false
                - UN_LOG_FILE=
                - UN_LOG_FILES=10
                - UN_LOG_FILE_MB=10
                - UN_INTERVAL=2m
                - UN_START_DELAY=1m
                - UN_RETRY_DELAY=5m
                - UN_MAX_RETRIES=3
                - UN_PARALLEL=1
                - UN_FILE_MODE=0644
                - UN_DIR_MODE=0755
                # Sonarr Config
                - UN_SONARR_0_URL=http://sonarr:8989
                - UN_SONARR_0_API_KEY=[GET FROM SONARR>GENERAL]
                - UN_SONARR_0_PATHS_0=/home/plex/shares/downloads
                - UN_SONARR_0_PROTOCOLS=torrent
                - UN_SONARR_0_TIMEOUT=10s
                - UN_SONARR_0_DELETE_ORIG=false
                - UN_SONARR_0_DELETE_DELAY=5m
                # Radarr Config
                - UN_RADARR_0_URL=http://radarr:7878
                - UN_RADARR_0_API_KEY=[GET FROM RADARR>GENERAL]
                - UN_RADARR_0_PATHS_0=/home/plex/shares/downloads
                - UN_RADARR_0_PROTOCOLS=torrent
                - UN_RADARR_0_TIMEOUT=10s
                - UN_RADARR_0_DELETE_ORIG=false
                - UN_RADARR_0_DELETE_DELAY=5m

                security_opt:
                - no-new-privileges:true" >> unpackerr_docker-compose.yml
        docker compose -f unpackerr_docker-compose.yml up -d
    else
        echo "Okay, then we will continue"
    fi
clear
sleep 2

#end of script 
