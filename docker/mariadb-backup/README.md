# UL MariaDB Backup
Erzeugt Sicherungen über `docker exec` in einem laufenden MariaDB Container (z.B. per Cron vom Hostsystem ausgeführt).

## Voraussetzungen
Der Docker-Container muss ein unter `/backups` eingehängtes Volume besitzen, in dem die Sicherungen abgelegt werden können:

```yaml
volumes:
  ul-mariadb-data:

services:
  mariadb:
    # ...
    volumes:
      - ul-mariadb-data:/var/lib/mysql
      - /home/u-labs/backups/mariadb:/backups
    # ...
```
Darin legt das Skript bei Ausführung ein Verzeichnis mit dem Zeitstempel zu Beginn der Sicherung an, z.B. `16.05.2024_19-31-01`. Für jede Datenbank außer `information_schema` und `performance_schema` (werden dynamisch beim Start vom SQL-Server ausgelesen) erfolgt eine Sicherung in eine SQL-Datei. Für all diese Operationen kommt der `root` Benutzer zum Einsatz (verbunden über die `MYSQL_ROOT_PASSWORD` Umgebungsvariable), damit Zugriff auf sämtliche DBs besteht.

## Verwendung
Als nicht benannter Parameter wird der Name des MariaDB Containers übergeben:
```bash
/home/u-labs/ul-tools/docker/mariadb-backup/start.sh ul-mariadb
```