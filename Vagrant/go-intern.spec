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

# config
cat <<EOF > /home/vagrant/go-interns/conf.json
{
    "DBName": "2018",
    "User": "postgres",
    "Password": "password1994",
    "Host": "10.143.20.4",
    "Port": "5432"
}
EOF

touch /etc/systemd/system/go-intern.service
cat <<EOF > /etc/systemd/system/go-intern.service
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
EOF

mkdir -p /var/log/go-intern
touch /etc/rsyslog.d/go-intern.conf
cat <<EOF > /etc/rsyslog.d/go-intern.conf
if \$programname == 'go-intern' then /var/log/go-intern/go-intern.log
if \$programname == 'go-intern' then ~
EOF

%post
useradd gouser

systemctl daemon-reload
systemctl restart rsyslog.service
systemctl enable go-intern.service
systemctl start go-intern.service


%files
/opt/%{name}/conf.json
/opt/%{name}/templates/*
/opt/%{name}/main


%changelog
* Mon Jul 09 2018 Marius Iancu <marius.danut94@gmail.com> - 1.0
- First go-interns package