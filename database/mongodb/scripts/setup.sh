#!/bin/bash
echo "Waiting for MongoDB instances to start..."
sleep 30

# Get WSL IP address dynamically
#MY_IP=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
MY_IP=localhost
echo "Using WSL IP address: ${MY_IP}"

echo "Initializing replica set..."
# Connect to mongo1 with authentication
mongosh --host mongo1 --port 27017 -u root -p example --authenticationDatabase admin <<EOF
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "${MY_IP}:27017", priority: 2 },
    { _id: 1, host: "${MY_IP}:27018", priority: 1 },
    { _id: 2, host: "${MY_IP}:27019", priority: 1 }
  ]
});

// Wait for the replica set to initialize
sleep(2000);

// Check replica set status
rs.status();

// Verify authentication is working
db.auth('root', 'example');

// Output the connection string for reference
print("\n==========================================================");
print("MongoDB Replica Set is ready!");
print("Use the following connection string in MongoDB Compass:");
print("mongodb://root:example@${MY_IP}:27017,${MY_IP}:27018,${MY_IP}:27019/?authSource=admin&replicaSet=rs0");
print("==========================================================\n");
EOF

echo "MongoDB replica set initialized with WSL IP: ${MY_IP}"
echo "Connection string for MongoDB Compass:"
echo "mongodb://root:example@${MY_IP}:27017,${MY_IP}:27018,${MY_IP}:27019/?authSource=admin&replicaSet=rs0"
