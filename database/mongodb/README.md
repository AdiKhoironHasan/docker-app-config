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

docker exec -it db-mongo1 mongosh -u root -p example --authenticationDatabase admin
mongosh --host mongodb1 --port 17017 -u mongol -p mongol_password --authenticationDatabase admin
docker exec -it mongodb1 mongosh -u mongol -p mongol_password --authenticationDatabase admin

mongodb://mongol:mongol_password@mongodb1:17017,mongodb2:17018,mongodb3:17019/?authSource=admin&replicaSet=mongodbCluster1

mongodb://mongol:mongol_password@localhost:27027,localhost:27028,localhost:27029/?replicaSet=mongodbCluster1&authSource=admin
mongodb://mongol:mongol_password@0.0.0.0:27027,0.0.0.0:27028,0.0.0.0:27029/?replicaSet=mongodbCluster1&authSource=admin