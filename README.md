 # Nextcloud Docker-Compose for Low Performance Systems Readme
 
 ***
 ***
 
 ## NOTE: the automatic repair option `docker exec --user www-data nextcloud-app php occ maintenance:repair` is not kind to low performance systems as it clears the image pre-generated previews. If you have a lot of images on your server try to avoid using it unless necessary.
 
 ## TLDR
 
Don't view this as a KISS approach newbie tutorial for getting Nextcloud to work on your Raspberry Pi.
This is a challenge project, with the primary goal being learning the ins and outs of docker, docker-compose, Linux and a real reward of an incredibly reliable and functional setup. I see many people recommending fairly powerful hardware for running a personal Nextcloud server, which is just not the case.

This challenge project shows how little horsepower is required to run Nextcloud, underlines the limitations and benefits.
This is not my career, I am just a hobbyist. I have much to learn, I will be wrong and may make things harder due to a lack of knowledge. Criticize to your hearts content, I welcome it but I leave this as is, onto my next project.

 1. Install AlpineOS and run: `setup-alpine`
 2. Add a new user: `adduser -s /bin/ash -G users *newuser*`
 3. Install sudo then uncomment `%wheel ALL=(ALL) ALL` from the sudo file: `apk add sudo` then `visudo`
 4. Edit the folowing files with vi:
    - **/etc/apk/repositories**
     // Uncomment http://mirrors.2f30.org/alpine/v##/community + http://mirrors.2f30.org/alpine/edge/testing 
    - **/etc/group**
     // Add newuser (or whatever name you chose) to the wheel group: `wheel:x:10:root,newuser`
    - **/etc/ssh/sshd_config**
     // Uncomment `Port 22` for ssh access
 5. Install docker: `apk add docker`
 6. Start docker and configure to start at boot: `service docker start` + `rc-update add docker boot`
 7. Install docker-compose: `apk add docker-compose`
 8. Clone the git repo: `git clone https://github.com/ShulaSharuba/NC-DC.git`
 9. Input the require information in the following .env files:
    - **db.env** // Input a password for the mysql root user and user
    - **web.env** // If you do not have a domain just enter in your host machine IP address (without ports)
    - **nc.env** // If you are testing or do not have an actual domain registered for letsencrypt, comment out OVERWRITEPROTOCOL=https. It is not required except for when granting access to devices using synchronization clients such as Nextcloud Desktop and the android app. 
 10. Edit docker-compose.yml. Review it and make changes where necessary and change the volume configuration to your liking. You **must** also create the directories for all bind volumes before running docker-compose
 11. Build it: `docker-compose up -d`. Make sure you are in the same directory as the .yml file
 12. Bring it down with: `docker-compose down`. This will retain your volumes and is safe to bring back up.
     
***
***

 ## Fluff

 The docker-compose file is derived from [this example](https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy-self-signed-ssl/mariadb/fpm) from the official [Nextcloud Github repo](https://github.com/nextcloud/docker). It comes packaged with:
 
 > Nginx reverse-proxy
 
 > Let's Encrypt auto-renewing SSL certificate
 
 > MariaDB mysql database
 
 > Crontab fix for docker
 
 > Redis (No idea what this is used for, still beyond me)
 
 This is originally meant to be run on AlpineOS with a [LBU](https://wiki.alpinelinux.org/wiki/Alpine_local_backup) (data) installation running the OS from a USB drive (min 1 GB, recommended 2GB) using the on-board 8GB EMMC as the /var directory on a [Dell Wyse 3040 Terminal](https://www.dell.com/en-ca/work/shop/wyse-endpoints-and-software/wyse-3040-thin-client/spd/wyse-3040-thin-client/xcto3040thinclient2ca), however alternative OS's and hardware can absolutely be used. 
 
 This system is great for setting up a personal Nextcloud server that will not leave a mark on your power bill, while performing great for almost everything Nextcloud has to throw at it. Unfortunately the lack of user upgradable components turns this device into a tricky project for a Nextcloud server. My hope is that this README can help guide anyone else looking to install self-hosted services for personal use on a system with limited resources (ie Raspberry Pi).
 
 This projecy is a little bit nitpicky here and there, there are many other less complex solutions you can go with. I personally found this to be an excellent learning experience being my first time working with docker and AlpineOS.
 
 #### Specs for system comparison - Can it run?
 
 - **[Intel Atom x5-Z8350](https://ark.intel.com/content/www/us/en/ark/products/93361/intel-atom-x5-z8350-processor-2m-cache-up-to-1-92-ghz.html) (soldered-on)**
    - Pros:
      - Low power consumptions (9W load, 4W idle!).
      - Streams videos without hickups.
      - Works with desktop and mobile file sync clients.
      - Local gigabit network speeds for file transfers (400 - 800Mbs avg.).
      - Handles almost everything Nextcloud has to offer with a few *exceptions*.
    - Cons
      - Struggles with on the fly image preview generation - Recommend installing and running [preview-generator](https://apps.nextcloud.com/apps/previewgenerator)
      - Large file transfers over the network adapter on a local gigabit network taxes CPU resources. This can cause stuttering when streaming poorly compressed videos and jumps in upload/download speeds for large files.
 - **2GB non-upgradable DDR3 1600**
   - I have not encountered any problems using 2 GB of ram with nextcloud other than reduced gigabit network speeds with less available cache.
 - **8GB internal eMMC flash**
   - Pros
     - None
   - Cons
     - 8GB formatted is not suitable to install AlpineOS with Nextcloud despite having the data directory on an external HDD. YES it is possible but WILL be high maintenance. **Don't waste your time**. This is why I went with the [LBU](https://wiki.alpinelinux.org/wiki/Alpine_local_backup) installation for this system.
     - No upgrade options for on-board SATA, either eSATA or M.2 does make this a fairly challenging case. Alternatively a USB external HDD could be used as the OS drive however the lack of SMART data being accessible makes the flexible LBU install more appealing to reduce downtime and work required in case of drive failure.
    
#### The Rig


> Dell Wyse 3040

> USB 3.0 1TB external HDD

> USB 2.0 2GB stick

> Time - more than responsible

***
***
 
## AlpineOS configuration ([source](http://web.ist.utl.pt/joao.leao.guerreiro/post/alpinedocker/))
 
 1. [Download AlpineOS for your architecture](https://alpinelinux.org/downloads/) and create bootable usb using dd, gparted or [rufus](https://rufus.ie/) (Windows).
 2. Login as root and begin the setup by typing `setup-alpine`. More setup details can be found on the wiki [here (installation)](https://wiki.alpinelinux.org/wiki/Installation), [here (setup scritps)](https://wiki.alpinelinux.org/wiki/Alpine_setup_scripts) and [here (howtos)](https://wiki.alpinelinux.org/wiki/Tutorials_and_Howtos).
 - Set your hostname, ip address, dns (search domain can be left blank), timezone, SSH daemon and proxy (optional) when prompted.
 - For the repository mirror I suggest using option `-f` to find the fastest mirror.
 - **For the disk mode you have 3 options:**
   - Sys Disk Mode - This is the traditional installation mode to a storage device other than the installation USB.
   - Diskless Mode - This is LBU (Local Backup Utility) only mode meaning the entire OS is loaded into ram on each boot.
   - **Data Disk Mode - This mode is similar to Diskless Mode, however you will need to select a separate disk for the /var directory and swap partitions. You WILL want to use this if your RAM is limited. This is what I use for this guide as this puts to use the 8GB eMMC flash for docker and a little bit of cache.**
   - Accept defaults for all other prompts.
 3. Add a new user: `adduser -s /bin/ash -G users *newuser*`.
 4. Install sudo then uncomment `%wheel ALL=(ALL) ALL` from the sudo file: `apk add sudo` then `visudo`.
 5. Edit the folowing files with vi:
    - **/etc/apk/repositories**
     // Uncomment http://mirrors.2f30.org/alpine/v##/community + http://mirrors.2f30.org/alpine/edge/testing 
    - **/etc/group**.
     // Add newuser (or whatever name you chose) to the wheel group: `wheel:x:10:root,newuser`.
    - **/etc/ssh/sshd_config**.
     // Uncomment `Port 22` for ssh access.
 6. Install docker: `apk add docker`.
 7. Start docker and configure to start at boot: `service docker start` + `rc-update add docker boot`.
 8. Install docker-compose: `apk add docker-compose`.
 
#### About LBU

Familiarize yourself with the [LBU](https://wiki.alpinelinux.org/wiki/Alpine_local_backup) command. Any changes made to the systems configuration settings (/etc including `setup-alpine`) will not be applied until you commit those changes. This can be very handy for noob mistakes, for example when I wanted to issue `chown -R 82:root ./*` but instead issued `chown -R 82:root /*`, a devistating mistake that would have required re-installing the host operating system. Since I was using LBU I simply had to power cycle the system without commiting my changes and everything was back to normal minus the /var directory which was easy to fix. This is why I recommend LBU for beginners who are looking for a sandbox environment to mess around with outside of VM checkpoints.

##### Useful LBU commands

- `lbu commit` // This is the primary use of lbu, any changes made to the system will not be retained after a restart unless you commit the changes first. 
- `lbu status` // Shows the directories and files to be committed (changes made that are not yet saved to the usb).
- `lbu list` // Shows all directories that will be saved to the usb media.
- `lbu include` // Include a directory for backup. Make sure you are aware of the size of the data first before committing.
- `lbu exclude` // Excludes a directory for backup.

I include my users home folder as that's where I clone the repo.

***
***

## docker-compose.yml

#### Containers

The docker-compose file will create 7 containers:

> **app:**
> 
> The official nextcloud:fpm-alpine container.
> 
>> **Environment Variables**
>>
>> The container environment variables can be found in **nc.env**.
>> Variables `MYSQL_HOST=db` and `REDIS_HOST=redis` can remain unchanged.
>> For testing purposed, comment out `OVERWRITEPROTOCOL=https`.
>> You will need to enable this with working SSL in order to allow sync clients (such as the android app) to connect to your server.
>
>> **Volumes**
>> 
>> **/etc/localtime:/etc/localtime:ro** // Synchronizes local time - Comment this out when testing with docker desktop
>> 
>> **nextcloud:/var/www/html** // Main Nextcloud directory.
>> It is good practice to backup this entire directory in case of catastrophic failure.
>> It contains everything you need for a recovery MINUS the database.

> **proxy:**
> 
> The Nginx reverse-proxy container. 
> In the /proxy folder on the repo you will find the Dockerfile and uploadsize.conf which will bake the max allowed upload size into the docker image. 
> Any changes you wish to make can be done by adding them to this .conf file or to create a new .conf file before running docker-compose. 
> If you have already run docker-compose then simply delete the proxy image and it will rebuild itself. 
>
>> **Volumes** // Shared between containers **proxy:** and **letsencrypt:**
>> 
>> **/etc/localtime:/etc/localtime:ro** // Synchronizes local time - Comment this out when testing with docker desktop
>> 
>> **html:/usr/share/nginx/html** // Location of [default site](https://gist.github.com/leommoore/2701379)
>>
>> **certs:/etc/nginx/certs:ro** // SSL certs and keys.
>>
>> **vhost.d:/etc/nginx/vhost.d** // Shared configuration directory for containers.
>>
>> **/var/run/docker.sock:/tmp/docker.sock:ro** // [Unix Socket](https://medium.com/better-programming/about-var-run-docker-sock-3bfd276e12fd)

> **letsencrypt:**
> 
> The letsencrypt container will generate auto-renewing signed SSL certificates for your domain, like so you don't have to deal with all the browsers telling you how dangerous your site is.
> There is a weekly limit on how many certs you can generate per domain and IP address.
> For testing you should make sure you're not deleting your certificates so that you do not get black-listed (only a week but still).
>
>> Environment variables are taken from the **web:** container
>
>> **Volumes** // Shared between containers **proxy:** and **letsencrypt:**
>> 
>> **/etc/localtime:/etc/localtime:ro** // Synchronizes local time - Comment this out when testing with docker desktop
>> 
>> **html:/usr/share/nginx/html** // Location of [default site](https://gist.github.com/leommoore/2701379)
>>
>> **certs:/etc/nginx/certs:ro** // SSL certs and keys.
>>
>> **vhost.d:/etc/nginx/vhost.d** // Shared configuration directory for containers.
>>
>> **/var/run/docker.sock:/tmp/docker.sock:ro** // [Unix Socket](https://medium.com/better-programming/about-var-run-docker-sock-3bfd276e12fd)

> **db:**
> 
> The maria-db mysql container.
> The bind volume is simply for convenience when backing up and restoring the database.
> This is not necessary however I find it a pain in the ass trying to use docker exec to output the database backups to and from the host to the container.
> 
>> **Environment Variables**
>> 
>> The container environment variables can be found in **db.env**.
>> Set your `MYSQL_PASSWORD=` user password and `MYSQL_ROOT_PASSWORD=` root password.
>
>> **Volumes**
>> 
>> **/etc/localtime:/etc/localtime:ro** // Synchronizes local time - Comment this out when testing with docker desktop
>> 
>> **db:/var/lib/mysql** // Database.
>> This does not need to be bound to a directory on the host, but it MUST exist as a volume.

> **web:**
> 
> This is the nginx web server for Nextcloud.
> I am not certain exactly what the purpose of this is, however it appears to be required when using the nextcloud:fpm-alpine image.
> The container environment variables can be found in web.env.
> 
>> **Environment Variables**
>> 
>> The container environment variables can be found in **web.env**.
>> Set your `VIRTUAL_HOST=` and `LETSENCRYPT_HOST=` as either your domain or IP address.
>> The `LETSENCRYPT_EMAIL=` variable only needs to be set once you want to issue a cert for your domain.
>> **I HAVE NOT TESTED WITH A STATIC PUBLIC IP**.
>
>> **Volumes**
>> 
>> **/etc/localtime:/etc/localtime:ro** // Synchronizes local time - Comment this out when testing with docker desktop
>> 
>> **nextcloud:/var/www/html:ro** // Read only access to the Nextcloud root directory.

> **cron:**
> 
> This container is required for cron to work properly with nextcloud:fpm-alpine.
>
>> **Volumes**
>> 
>> **/etc/localtime:/etc/localtime:ro** // Synchronizes local time - Comment this out when testing with docker desktop
>> 
>> **nextcloud:/var/www/html** // Main Nextcloud directory.

> **redis:**
> 
> This may not be required, however it was included in the official Nextcloud docker-compose example.
> I am not sure exactly what this does (don't break unless broke).
>
>> **Volumes**
>> 
>> **/etc/localtime:/etc/localtime:ro** // Synchronizes local time - Comment this out when testing with docker desktop

***
***

## Understanding the Volumes and Binds

From my lack of understanding and as the docker docs don't allow for proper visualization of volumes and binds, here is my take on the subject.
This might not be the correct way to understand volumes and mounts, however for the purposes of practicality and for docker-compose this should be helpful for those who don't want to dig too deeply into it.

TLDR: Use bind volumes for external drives and named volumes if the host will be running on the same drive as the nextcloud directory.

 **1. Mounted volumes**: 

 - Mounted volumes are managed entirely by the host in a classical fashion.
   This means that docker does not manage these volumes, you will not find them in /var/lib/docker/volumes/.
   This kind of volume is great for using existing resources on the host.
  
 - If the directory does not exist then it will be created when you run `docker-compose up`.
  
 - If the directory exists then all of its contents will remain unchanged.

 - This is not a recommended volume type in general, it also makes permissions a greater challenge in certain situations.

 - Mounted volumes **DO NOT** need to be declared in the docker-compose yaml under `volumes:`.
    

 - Example: `/etc/localtime:/etc/localtime:ro` //
   This will synchronize the containers clocks with the hosts.
   When running on docker desktop something like this will need to be commented out as the Windows file system will not appreciate you trying to make a Linux out of it (kind of offensive really, show a little respect).
   
 **2. Named volumes**: 
    
 - Named volumes are managed entirely by docker in /var/lib/docker/volumes/.
   This means that docker does the heavy lifting and waves its wand to apply high level magic to the volume.
   This poses a challenge with systems that need multiple storage devices, one work-around would be to mount the /var/lib/docker/volumes/*volume-name* to an external drive, however this adds complexity with permissions and many other things could go wrong.
   I have not found success with this method for external drives.
    
 - Named volumes **MUST** be declared in the docker-compose yaml under `volumes:`. 
   

 - Example: `vhost.d:/etc/nginx/vhost.d`

 **3. Bind volumes**:

 - Bind volumes (or bind mounts) are managed partially by docker.
   They are bound to a "device", meaning that they are provided a path to exists in the docker-compose yaml.
   This is exactly what you are going to want to use if you want your data directory to run on an external drive. 
  
 - If the directory does not exist then docker-compose will fail with errors. 
   The directory **MUST** exist beforehand.
   You will need to ensure that your external drive is mounted to the directory of your choice, that the external drive will mount on boot in /etc/fstab and that the permissions and ownership of the directory are set correctly depending on your setup (this will be covered in the next section).
   

- Example:

        nextcloud:
            driver: local
            driver_opts:
                type: none
                o: bind
                device: /mnt/nextcloud

***
***

## External Storage Mounting and Permissions with Bind Volumes

*It is important to ask before mounting, otherwise apply hand to face*

Bind volumes require the directory to be present, however the directories are going to be accessed by the containers and their users (in this case www-data).

#### Mounting the external storage

First you'll want to find the UUID of your external drive.
Why not just /dev/sdx#? Because there's a chance that depending on when you plugged things in or how you configured thing that the device could change its assigned drive mount letter. 
This is because this assignment is dynamic and not static. Using the UUID will eliminate any potential problems this could arise.

Use command `blkid` and choose your external drive:

`/dev/sdb1: UUID="9f02aa15-dd35-42a4-842f-fe0c04dc8522" TYPE="ext4"`

Copy this part but remove the quotations around the ID: `UUID=9f02aa15-dd35-42a4-842f-fe0c04dc8522`

Now edit /etc/fstab `vi /etc/fstab`. Here is a sample output:
```
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during curtin installation
/dev/disk/by-uuid/b86aebd4-b239-454e-bde5-eeb52eeea200 / ext4 defaults 0 0
# /boot/efi was on /dev/sda1 during curtin installation
/dev/disk/by-uuid/4B66-4503 /boot/efi vfat defaults 0 0
/swap.img       none    swap    sw      0       0
```

Now to add your external drive to the file system table.
This will automatically mount the external drive when the system boots. [More information here](https://help.ubuntu.com/community/Fstab).

```
/dev/disk/by-uuid/b86aebd4-b239-454e-bde5-eeb52eeea200 / ext4 defaults 0 0
# /boot/efi was on /dev/sda1 during curtin installation
/dev/disk/by-uuid/4B66-4503 /boot/efi vfat defaults 0 0
/swap.img       none    swap    sw      0       0
UUID=9f02aa15-dd35-42a4-842f-fe0c04dc8522   /mnt    ext4    defaults    0   0
```

Breaking it down further:

`UUID=9f02aa15-dd35-42a4-842f-fe0c04dc8522 -tab- /directory/to/mount -tab- filesystem_type -tab- defaults -tab- 0 -tab- 0`

Make sure you tab in between each entry and not using the space bar.
Ensure the path is correct, followed by the filesystem type shown by `blkid` then `defaults` `0` `0`.

To mount the drive without rebooting, use the mount command: `mount -a`

***

### Permissions and ownership

For the bind volumes, you will need to ensure the permissions on the host are reflective of the containers permissions.
With Nextcloud, you will also need to set the ownership of the directories to the correct user, otherwise it will complain that you have improper security configuration.

#### nextcloud directory

The root Nextcloud uses `rwxrwxrwx` or 777 permissions. This is already set in the container, we will need to set this on the host.
We will also need to change the ownership of the directory to the web user (www-data ID=82) part of the root group.

With other Linux distros, setting the ownership of the file would be done by using the web user www-data.
This is not the case in Alpine OS as there is no www-data user by default. You could create one, however it is easier to take the user ID of the containers www-data user.
From my understanding the user ID will be consistent across Linux distros, however you can check the ID by reading from /etc/passwd or by using the command `id -u username`.

On the host issue these commands (this example uses the path /mnt/nextcloud): 

*Careful with these commands as a typo can ruin your day*

`chmod 777 /mnt/nextcloud`

`chown -R 82:root /mnt/nextcloud`

#### certs directory

This directory is optional, it is simply there to transfer existing certificates when migrating to a new host.

By creating this directory with the root user, the permissions and ownership should be set correctly (at least on Alpine, not certain if that matters).

Otherwise on the host issue these commands (this example uses the path /mnt/certs):

`chmod 755 /mnt/certs`

`chown -R root:root /mnt/certs`

#### db directory

This directory is also optional, it is simply there to make database backups and recovery a little easier.
I would personally recommend against using a bind volume for the database as backups are still possible without it.

On the host issue these commands (this example uses the path /mnt/db):

`chmod 755 /mnt/db`

`chown -R 999:ping /mnt/db`

***
***

## Backups and Recovery

This repo offers a good option for incremental backups using rsync.

https://github.com/pedroetb/rsync-incremental-backup.git
