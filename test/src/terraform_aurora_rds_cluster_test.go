package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Testing the creation of Aurora RDS Cluster

func TestAuroraRDSCluster(t *testing.T) {
	//Create terraform options for Aurora RDS Cluster
	terraformAuroraRDSOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../examples/aurora-postgres-cluster",
		Upgrade:      true,
	})
	//Destroy the resources after testing
	defer func() {
		terraform.Destroy(t, terraformAuroraRDSOptions)
	}()

	terraform.InitAndPlan(t, terraformAuroraRDSOptions)
	terraform.ApplyAndIdempotent(t, terraformAuroraRDSOptions)

	auroraRDSClusterArn := terraform.Output(t, terraformAuroraRDSOptions, "rds_cluster_arn")
	// Verify we're getting back the outputs we expect
	assert.Contains(t, auroraRDSClusterArn, "terratest")

	auroraRDSClusterSecret := terraform.Output(t, terraformAuroraRDSOptions, "rds_cluster_secret_id")
	// check if the secret was created and its arn contains terratest
	assert.Contains(t, auroraRDSClusterSecret, "terratest")

}
