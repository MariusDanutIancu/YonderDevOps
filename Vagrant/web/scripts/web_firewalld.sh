systemctl enable firewalld
systemctl start firewalld
setenforce 0

cp /home/vagrant/files/firewalld/go-interns.xml /etc/firewalld/services/go-interns.xml 
cp /home/vagrant/files/firewalld/hugo.xml /etc/firewalld/services/hugo.xml 

firewall-cmd --permanent --new-zone=yonder
firewall-cmd --reload

firewall-cmd --zone=yonder --permanent --add-service=ssh
firewall-cmd --zone=yonder --permanent --add-service=dhcp
firewall-cmd --zone=yonder --permanent --add-service=snmp
firewall-cmd --zone=yonder --permanent --add-service=http
firewall-cmd --zone=yonder --permanent --add-service=https
firewall-cmd --zone=yonder --permanent --add-service=hugo
firewall-cmd --zone=yonder --permanent --add-service=go-interns

firewall-cmd --zone=yonder --permanent --change-interface=eth0
firewall-cmd --zone=yonder --permanent --change-interface=eth1
firewall-cmd --zone=yonder --permanent --change-interface=wlol
firewall-cmd --set-default-zone=yonder

systemctl restart network
systemctl reload firewalld