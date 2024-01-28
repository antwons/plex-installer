<img src="https://github.com/antwons/plex-installer/blob/V0.1/branding/design-de18c445-f454-49b1-b383-fa7684c38d83.png?raw=true"> 

### To start using our installer, please copy the following code
> Ubuntu, Debain & Centos installer
```
sudo apt install -y git && git clone https://https://github.com/antwons/plex-installer.git && cd plex-installer && cd scripts && bash plex-install.sh
```
> Fedora Installer
```
yum install -y git && git clone https://https://github.com/antwons/plex-installer.git && cd plex-installer && cd scripts && bash plex-install.sh
```
### FAQ's 

#### *What does this script do exactly?*
> This script will install Docker and Docker compose to begin with. Once installed, we will move forward with installing Plex, Radarr, Sonarr, Qbittorrent & Ombi. Then we will ask if you want to install Unpackerr.
> 
> During the Docker and Docker compose install, you will be prompted to also install Portainer or Portainer-Agent. Once Portainer is installed or you've opted out of it, it will then grab you IP address and sever you with your machines current IP address along with the URL to go to if you did download Portainer.
> 
>During the Plex install, you will need to go to https://www.plex.tv/claim/ in-order to get the claim token needed for your Plex Server to start. Then the rest of the install goes very smoothly with little to no interactions.
>
> At the end of our install, your IP address will show up along with the URL to go to your Portainer Instance or add to your exisiting Portainer instance. 
#### *Why did you make this?*
> I made this install as a project for a all-in-one install for Plex. My friends and I use Plex often and I though that it would be great to have an all-in-one installer for some of our newer friends with little to no experience installing Plex!

#### *If I'm having any issues, who do I reach out to?* 
> Any issues that you are having, shoudl immediately be moved over to our issues tab and create a issue. Think of this like our helpdesk tickets. I will review these daily and get back to you asap!


