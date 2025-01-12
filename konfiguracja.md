Instrukcja:
https://docs.oracle.com/en/database/oracle/oracle-database/23/lacli/install-instant-client-using-zip.html

Pobrać ten plik:
https://download.oracle.com/otn_software/linux/instantclient/2360000/instantclient-basic-linux.x64-23.6.0.24.10.zip

Utworzyć folder i wypakować:
```bash
sudo mkdir -p /opt/oracle/
sudo unzip instantclient-basic-linux.x64-23.6.0.24.10.zip -d /opt/oracle/
```

Zmienna środowiskowa:
```bash
echo 'export LD_LIBRARY_PATH=/opt/oracle/instantclient_23_6:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc
```

```bash
sudo sh -c "echo /opt/oracle/instantclient_23_6 > /etc/ld.so.conf.d/oracle-instantclient.conf"
sudo ldconfig
```

```bash
sudo apt install libaio1 
pip install cx_Oracle 
```