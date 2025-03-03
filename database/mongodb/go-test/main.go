package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"go.mongodb.org/mongo-driver/mongo/readpref"
)

func main() {
	// Replace with your actual WSL IP if needed
	uri := "mongodb://root:example@localhost:27017,localhost:27018,localhost:27019/?authSource=admin&replicaSet=rs0"

	// Create a context with timeout for database operations
	// ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	// defer cancel()

	ctx := context.Background()

	// Connect to MongoDB
	client, err := mongo.Connect(ctx, options.Client().ApplyURI(uri))
	if err != nil {
		log.Fatalf("Failed to connect to MongoDB: %v", err)
	}
	defer func() {
		if err = client.Disconnect(ctx); err != nil {
			log.Fatalf("Failed to disconnect: %v", err)
		}
	}()

	// Check the connection
	err = client.Ping(ctx, readpref.Primary())
	if err != nil {
		log.Fatalf("Failed to ping MongoDB: %v", err)
	}
	fmt.Println("Successfully connected to MongoDB replica set!")

	// Print replica set status
	db := client.Database("admin")
	result := db.RunCommand(ctx, bson.D{{Key: "replSetGetStatus", Value: 1}})

	var status bson.M
	if err := result.Decode(&status); err != nil {
		log.Fatalf("Failed to get replica set status: %v", err)
	}

	fmt.Println("\nReplica Set Status:")
	fmt.Printf("Name: %s\n", status["set"])

	// Print members status
	members := status["members"].(bson.A)
	fmt.Println("\nMembers:")
	for _, m := range members {
		member := m.(bson.M)
		fmt.Printf("  Host: %s, State: %s\n",
			member["name"],
			stateString(int(member["state"].(int32))))
	}

	// Try to write and read data
	fmt.Println("\nTesting write/read operations:")
	testCollection := client.Database("test").Collection("test_collection")

	// Insert a test document
	doc := bson.D{{Key: "test", Value: "connection"}, {Key: "timestamp", Value: time.Now()}}
	insertResult, err := testCollection.InsertOne(ctx, doc)
	if err != nil {
		log.Fatalf("Failed to insert document: %v", err)
	}
	fmt.Printf("Inserted document with ID: %v\n", insertResult.InsertedID)

	// Read the document back
	filter := bson.D{{Key: "test", Value: "connection"}}
	var resultData bson.M
	err = testCollection.FindOne(ctx, filter).Decode(&resultData)
	if err != nil {
		log.Fatalf("Failed to find document: %v", err)
	}
	fmt.Printf("Found document: %v\n", resultData)
}

// Helper function to convert numeric state to string
func stateString(state int) string {
	states := map[int]string{
		0:  "STARTUP",
		1:  "PRIMARY",
		2:  "SECONDARY",
		3:  "RECOVERING",
		5:  "STARTUP2",
		6:  "UNKNOWN",
		7:  "ARBITER",
		8:  "DOWN",
		9:  "ROLLBACK",
		10: "REMOVED",
	}
	if name, ok := states[state]; ok {
		return name
	}
	return fmt.Sprintf("UNKNOWN(%d)", state)
}
