#!/bin/bash
echo "print init system (runit and openrc only for now (experemental - s6)"
read -p "Your choice: " initsys
echo "print kernel (linux, linux-zen, linux-lts)"
read -p "Your choice: " kernel
echo print hostname
read -p "Your choice: " hostname
echo "print console font (cyr-sun16 for russian)"
read -p "Your choice: " consolfont
echo "print locale (for example ru_RU)"
read -p "Your choice: " local
echo "print timezone (example Europe/Moscow)"
read -p "Your choice: " tmzn
echo "print timezone (netman, connman, wpa_supplicant, none)"
read -p "Your choice: " netw
read -p "Extra packages? (e.g: nano, vim, sway): " extra
echo "Mountpoint (e.g: mnt)"
read -p "Your choice: " mnt
echo "Are you sure?"
echo "yes - contunue"
echo "any - exit with no changes"
read -p "Your choice: " answer
case $answer in
yes)
# пошло говно по трубам (yes)
# if yes
basestrap $mnt base base-devel $initsys elogind-$initsys $netw-$initsys $kernel $kernel-headers linux-firmware grub os-prober efibootmgr sudo dhcpcd $extra
case $initsys in
runit)
echo $hostname > /mnt/etc/hostname
;;
openrc)
echo $hostname > /mnt/etc/hostname
echo "hostname='$hostname'" > /mnt/etc/conf.d/hostname
;;
esac
echo "127.0.1.1 localhost.localdomain $hostname" >> /mnt/etc/hosts
echo FONT=$consolfont > /mnt/etc/vconsole.conf
echo LANG="$local.UTF-8" > /mnt/etc/locale.conf
echo "LC_COLLATE="C"" >> /mnt/etc/locale.conf
fstabgen -U /mnt >> /mnt/etc/fstab
  # язык
  # lang
if [ $local != en_US ]
then
echo $local.UTF-8 UTF-8 >> /mnt/etc/locale.gen
echo en_US.UTF-8 UTF-8 >> /mnt/etc/locale.gen
else
echo $local.UTF-8 UTF-8 >> /mnt/etc/locale.gen
fi
echo initsys=$initsys >> ./continue.sh
echo tmzn=$tmzn >> ./continue.sh
./telo.sh
mv ./continue.sh /mnt/continue.sh
artix-chroot /mnt -c 'bash /continue.sh'
;;
*)
# любой другой ответ
# if not yes
exit
;;
esac
exit
