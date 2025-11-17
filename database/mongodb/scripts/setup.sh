#!/bin/bash
echo "Waiting 30s for MongoDB instances to start..."
sleep 30

echo "Initializing replica set..."
# Connect to mongo1 with authentication

mongosh --host mongodb1 --port 27017 -u mongol -p mongol_password --authenticationDatabase admin <<EOF
rs.initiate({
  _id: "mongodbCluster1",
  members: [
    { _id: 0, host: "localhost:27027"},
    { _id: 1, host: "localhost:27028"},
    { _id: 2, host: "localhost:27029"}
  ]
});

// Wait for the replica set to initialize
sleep(2000);

// Check replica set status
rs.status();

// Verify authentication is working
db.auth('mongol', 'mongol_password');

// Output the connection string for reference
print("\n==========================================================");
print("MongoDB Replica Set is ready!");
print("Use the following connection string in MongoDB Compass:");
print("mongodb://mongol:mongol_password@localhost:27027,localhost:27028,localhost:27029/?authSource=admin&replicaSet=mongodbCluster1");
print("==========================================================\n");
EOF

echo "Connection string for MongoDB Compass:"
echo "mongodb://mongol:mongol_password@localhost:27027,localhost:27028,localhost:27029/?authSource=admin&replicaSet=mongodbCluster1"
