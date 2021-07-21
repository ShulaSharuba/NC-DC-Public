For backups use push method.
> Run rsync from source and use root login credentials for destination (required for identical copy of /var)
> Change `/etc/ssh/sshd_config` and allow for root login

rsync -avxHAX
