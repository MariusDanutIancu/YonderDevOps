---
title: "Go intern rpm package"
date: 2018-01-28T21:48:10+01:00
anchor: "go_intern_rpm_package"
weight: 71
---

1) Move to directory

```bash
cd /home/vagrant
```

2) Install packages

```bash
yum -y install gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools dos2unix
```

3) Clone go-interns repository

```bash
git clone https://github.com/aso930/go-interns.git
```

4) Move to go-interns directory

```bash
cd /home/vagrant/go-interns
```

5) Create go-intern.service file

```bash
[Unit]
Description=go-intern-service

[Service]
ExecStart=/opt/go-interns/main
WorkingDirectory=/opt/go-interns
Type=simple
KillMode=process
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=go-intern
User=gouser

[Install]
WantedBy=multi-user.target
```

6) Create go-intern.conf file

```php
if $programname == 'go-intern' then /var/log/go-intern/go-intern.log
if $programname == 'go-intern' then ~
```

7) Change script to unix style

```bash
dos2unix build.sh
```

8) Create temporary rpm directory

```bash
mkdir /tmp/go-interns-1.0
```

9) Copy needed files to the temporary directory

```bash
cp build.sh /tmp/go-interns-1.0
cp conf.json /tmp/go-interns-1.0
cp main.go /tmp/go-interns-1.0
cp go-intern.service /tmp/go-interns-1.0
cp go-intern.conf /tmp/go-interns-1.0
cp -r templates /tmp/go-interns-1.0
```

10) Create rpm tree

```bash
rpmdev-setuptree
```

11) Change directory

```bash
cd /tmp/
```

12) Create an arhive

```bash
tar -cvzf go-interns-1.0.tar.gz go-interns-1.0
```

13) Move arhive

```bash
mv /tmp/go-interns-1.0.tar.gz /root/rpmbuild/SOURCES
```

14) Create the go-intern.spec file

```bash
touch /root/rpmbuild/SPECS/go-intern.spec
```

```ruby
Name:           go-interns
Version:        1.0
Release:        1%{?dist}
Summary:        go-interns app
License:        GPLv3+
URL:            https://yonder_devops.com/%{name}
Source0:        https://yonder_devops.com/%{name}/releases/%{name}-%{version}.tar.gz

BuildRequires:  bash

%define debug_package %{nil}

%description
Go-intern description


%prep
%setup -q


%build
bash build.sh


%install

mkdir -p %{buildroot}/opt/%{name}/
mkdir -p %{buildroot}/opt/%{name}/templates/

install -m 0755 main %{buildroot}/opt/%{name}
install -m 0755 templates/* %{buildroot}/opt/%{name}/templates/
install -m 0755 conf.json %{buildroot}/opt/%{name}
install -m 0755 go-intern.service %{buildroot}/opt/%{name}
install -m 0755 go-intern.conf %{buildroot}/opt/%{name}

%post
useradd gouser

cp /opt/%{name}/go-intern.service /etc/systemd/system/go-intern.service
cp /opt/%{name}/go-intern.conf /etc/rsyslog.d/go-intern.conf

systemctl daemon-reload
systemctl restart rsyslog.service
systemctl enable go-intern.service
systemctl restart go-intern.service

%files
/opt/%{name}/main
/opt/%{name}/conf.json
/opt/%{name}/templates/*
/opt/%{name}/go-intern.service
/opt/%{name}/go-intern.conf

%changelog
* Mon Jul 09 2018 Marius Iancu <marius.danut94@gmail.com> - 1.0
- First go-interns package
```

15) Check rpm

```bash
rpmlint /root/rpmbuild/SPECS/go-intern.spec
```

16) Build rpm

```bash
rpmbuild -bb /root/rpmbuild/SPECS/go-intern.spec
```

17) Move rpm to home directory

```bash
mv /root/rpmbuild/RPMS/x86_64/go-interns-1.0-1.el7.x86_64.rpm /home/vagrant/
```

18) Install go-intern

```bash
rpm -ivh /home/vagrant/go-interns-1.0-1.el7.x86_64.rpm
```

19) Change directory

```bash
cd /opt/go-interns
```

20) Edit conf.json file

```bash
{
    "DBName": "2018",
    "User": "postgres",
    "Password": "password1994",
    "Host": "10.143.20.4",
    "Port": "5432"
}
```

21) Restart services

```bash
systemctl daemon-reload
systemctl restart rsyslog.service
systemctl restart go-intern.service
```




