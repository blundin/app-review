# Operations Evidence

Commands the user runs to give the review server and platform evidence. Give only the sections that match the system map. Write them in fish unless the user names another shell; the remote side of `ssh` runs in the server's own shell, so quote remote commands in single quotes.

Ask the user to redact secrets, tokens, and personal data before pasting output. Any check the user skips becomes an Unverified finding.

## Contents
- Single server (VPS such as a DigitalOcean droplet)
- Containers on the server
- Google Cloud Run and Cloud SQL
- TLS and headers
- Email sender authentication
- Questions no command answers

## Single server

```fish
set host USER@SERVER_IP
ssh $host 'cat /etc/os-release | head -4; uptime'
ssh $host 'apt list --upgradable 2>/dev/null | head -30; systemctl is-enabled unattended-upgrades 2>&1'
ssh $host 'sudo ss -tlnp'
ssh $host 'sudo ufw status verbose 2>&1'
ssh $host 'ps -eo user,comm | sort -u | head -60'
ssh $host 'systemctl list-units --type=service --state=running --no-pager'
ssh $host 'sudo crontab -l 2>&1; ls -la /etc/cron.d; systemctl list-timers --no-pager'
ssh $host 'df -h; free -h'
ssh $host 'journalctl -p err --since "7 days ago" --no-pager | tail -50'
ssh $host 'ruby -v 2>&1; node -v 2>&1; python3 --version 2>&1; psql --version 2>&1'
```

Log in as the user who deploys, not root; if `root` is the only login that works, that is itself a security finding. When `sudo` asks for a password, add `-t` to that `ssh` call.

What each shows: OS version and support status, pending security updates, listening ports and the processes behind them, the host firewall, which users run which processes, running services, scheduled jobs (including any backup job), disk and memory headroom, recent errors, and runtime versions.

For DigitalOcean, also check the provider side. Droplet backups and cloud firewalls live outside the server:

```fish
doctl compute droplet list --format Name,Features,Region,Memory,Disk
doctl compute firewall list
```

## Containers on the server

```fish
ssh $host 'docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
ssh $host 'docker inspect --format "{{.Name}} user={{.Config.User}} restart={{.HostConfig.RestartPolicy.Name}}" $(docker ps -q)'
```

Fish leaves `$(docker ps -q)` alone inside single quotes, so the server's shell expands it.

## Google Cloud Run and Cloud SQL

```fish
gcloud run services describe SERVICE --region REGION --format yaml
gcloud run revisions list --service SERVICE --region REGION --limit 5
gcloud sql instances describe INSTANCE --format "yaml(settings.backupConfiguration,databaseVersion)"
gcloud sql backups list --instance INSTANCE --limit 5
```

The service description includes environment variables. Ask the user to redact values and keep the names, since names show whether secrets come from Secret Manager or plain environment variables.

## TLS and headers

```fish
curl -sI https://DOMAIN | head -25
echo | openssl s_client -connect DOMAIN:443 -servername DOMAIN 2>/dev/null | openssl x509 -noout -dates -issuer
```

Claude can often run these itself when its tools reach the domain.

## Email sender authentication

```fish
dig +short TXT SENDING_DOMAIN
dig +short TXT _dmarc.SENDING_DOMAIN
dig +short TXT SELECTOR._domainkey.SENDING_DOMAIN
```

The DKIM selector comes from the email provider's domain settings.

## Questions no command answers

Ask these directly and record the answers as claims:

- When was a restore from backup last tested, and how long did it take?
- How would you learn the app is down before a user tells you?
- How do you deploy, and how would you undo a bad deploy?
- Who else could operate this system if you were unavailable for two weeks?
