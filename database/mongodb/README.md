# Setup MongoDB

# Create a keyfile for MongoDB
```bash
mkdir -p keyfile
openssl rand -base64 756 > keyfile/mongo-keyfile
chmod 400 keyfile/mongo-keyfile
chown 999:999 keyfile/mongo-keyfile
```

# Create a MongoDB replica set
```bash
docker-compose up -d
```

