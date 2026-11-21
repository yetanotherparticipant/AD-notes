# AD-notes

## Patchers notes

### SAST

- https://github.com/semgrep/semgrep (btw, installing from pypi should work)
- https://github.com/pycqa/bandit
- https://github.com/securego/gosec.git

## Admin notes

```bash
mkdir -p /srv/git
git init --bare /srv/git/ad.git
# git clone ssh://user@vulnbox/srv/git/ad.git

mkdir -p /srv/ad/deploy
git clone /srv/git/ad.git /srv/ad/deploy
git -C /srv/ad/deploy switch -c main --track origin/main

cp scripts/deploy.sh /usr/local/bin/deploy # btw, need to rewrite this shit before AD start, because it is kinda not very flexible
cat <<'EOF' > /srv/git/ad.git/hooks/post-receive
#!/usr/bin/env bash
set -euo pipefail

while read -r oldrev newrev refname; do
    # Deploy only main
    [[ "$refname" == "refs/heads/main" ]] || continue

    # Ignore branch deletion
    [[ "$newrev" != "0000000000000000000000000000000000000000" ]] || continue

    /usr/local/bin/deploy "$newrev"
done
EOF
```

NFS

server

```bash
apt install nfs-kernel-server
mkdir /mnt/nfs
chown nobody:nogroup /mnt/nfs
chmod 777 /mnt/nfs

exportfs -a
systemctl restart nfs-kernel-server
```

client

```bash
apt install nfs-common
mkdir /mnt/nfs
mount -t nfs vulnbox:/mnt/nfs /mnt/nfs
```
