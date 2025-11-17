#!/bin/bash
sleep 10

# initiate replica set
mongosh --host mongodb1:27017 <<EOF
  var cfg = {
    "_id": "myReplicaSet",
    "version": 1,
    "members": [
      {
        "_id": 0,
        "host": "mongodb1:27017",
        "priority": 2
      },
      {
        "_id": 1,
        "host": "mongodb2:27017",
        "priority": 0
      },
      {
        "_id": 2,
        "host": "mongodb3:27017",
        "priority": 0
      }
    ]
  };

  rs.initiate(cfg);

  rs.status();

  use admin;

  db.createUser({
    user: "root",
    pwd: "example",
    roles: [{ role: "root", db: "admin" }]
  });

  db.system.users.find().pretty();
EOF

