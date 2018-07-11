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