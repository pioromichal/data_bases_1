# Instrukcja uruchomienia / Launch Instructions

## Wymagania wstępne / Prerequisites
Postępuj zgodnie z oficjalną dokumentacją Oracle:
[Przewodnik instalacji Oracle Instant Client](https://docs.oracle.com/en/database/oracle/oracle-database/23/lacli/install-instant-client-using-zip.html)
Follow the official Oracle documentation for installation:
[Oracle Instant Client Installation Guide](https://docs.oracle.com/en/database/oracle/oracle-database/23/lacli/install-instant-client-using-zip.html)

## Pobierz wymagany plik / Download the Required File
Pobierz następujący plik:
Download the following file:
[instantclient-basic-linux.x64-23.6.0.24.10.zip](https://download.oracle.com/otn_software/linux/instantclient/2360000/instantclient-basic-linux.x64-23.6.0.24.10.zip)

## Utwórz folder i wypakuj plik / Create a Folder and Extract the File
```bash
sudo mkdir -p /opt/oracle/
sudo unzip instantclient-basic-linux.x64-23.6.0.24.10.zip -d /opt/oracle/
```

## Ustaw zmienne środowiskowe / Set Environment Variables
```bash
echo 'export LD_LIBRARY_PATH=/opt/oracle/instantclient_23_6:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
```

```bash
sudo sh -c "echo /opt/oracle/instantclient_23_6 > /etc/ld.so.conf.d/oracle-instantclient.conf"
sudo ldconfig
```

## Zainstaluj wymagane biblioteki / Install Required Libraries
```bash
sudo apt install libaio1
pip install cx_Oracle rich
```

