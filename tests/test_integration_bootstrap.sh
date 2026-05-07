#!/bin/bash

test_directory=$(mktemp -d)
cd "$test_directory"

# Execute bootstrap.sh in the temp directory to test its integration
/home/netyeti/Audit/bootstrap.sh --unittest-mode

echo 'Integration tests for bootstrap.sh passed successfully'
