#!/usr/bin/env bats

# Setup and teardown
setup() {
    export TEST_DIR=$(mktemp -d)
    export IMAGE_NAME="${IMAGE_NAME:-local/ep:latest}"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "basic variable substitution" {
    echo 'Value: ${TEST_VAR}' > "$TEST_DIR/config.txt"
    
    run docker run --rm \
        -e TEST_VAR=hello \
        -v "$TEST_DIR:/test" \
        "$IMAGE_NAME" \
        ep /test/config.txt
    
    [ "$status" -eq 0 ]
    
    result=$(cat "$TEST_DIR/config.txt")
    [ "$result" = "Value: hello" ]
}

@test "default value handling" {
    echo 'Database: ${DB_HOST:-localhost}' > "$TEST_DIR/config.txt"
    
    run docker run --rm \
        -v "$TEST_DIR:/test" \
        "$IMAGE_NAME" \
        ep /test/config.txt
    
    [ "$status" -eq 0 ]
    
    result=$(cat "$TEST_DIR/config.txt")
    [ "$result" = "Database: localhost" ]
}

@test "backup creation" {
    echo 'Value: ${TEST_VAR}' > "$TEST_DIR/config.txt"
    
    run docker run --rm \
        -e TEST_VAR=hello \
        -v "$TEST_DIR:/test" \
        "$IMAGE_NAME" \
        ep -b /test/config.txt
    
    [ "$status" -eq 0 ]
    [ -f "$TEST_DIR/config.txt.bak" ]
    
    # Original content should be in backup
    backup_content=$(cat "$TEST_DIR/config.txt.bak")
    [ "$backup_content" = "Value: \${TEST_VAR}" ]
    
    # Processed content should be in original file
    processed_content=$(cat "$TEST_DIR/config.txt")
    [ "$processed_content" = "Value: hello" ]
}

@test "strict mode fails on missing variables" {
    echo 'Value: ${MISSING_VAR}' > "$TEST_DIR/config.txt"
    
    run docker run --rm \
        -v "$TEST_DIR:/test" \
        "$IMAGE_NAME" \
        ep -s /test/config.txt
    
    [ "$status" -ne 0 ]
}

@test "escaped variables are not processed" {
    echo 'Escaped: \${TEST_VAR}' > "$TEST_DIR/config.txt"
    
    run docker run --rm \
        -e TEST_VAR=hello \
        -v "$TEST_DIR:/test" \
        "$IMAGE_NAME" \
        ep /test/config.txt
    
    [ "$status" -eq 0 ]
    
    result=$(cat "$TEST_DIR/config.txt")
    [ "$result" = "Escaped: \${TEST_VAR}" ]
}

@test "dry run outputs to stdout" {
    echo 'Value: ${TEST_VAR}' > "$TEST_DIR/config.txt"
    
    run docker run --rm \
        -e TEST_VAR=hello \
        -v "$TEST_DIR:/test" \
        "$IMAGE_NAME" \
        ep -d /test/config.txt
    
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Value: hello" ]]
    
    # Original file should be unchanged
    original_content=$(cat "$TEST_DIR/config.txt")
    [ "$original_content" = "Value: \${TEST_VAR}" ]
}

@test "multiple files with glob pattern" {
    echo 'env=${ENV}' > "$TEST_DIR/app.conf"
    echo 'environment=${ENV}' > "$TEST_DIR/db.conf"
    
    run docker run --rm \
        -e ENV=production \
        -v "$TEST_DIR:/test" \
        "$IMAGE_NAME" \
        ep '/test/*.conf'
    
    [ "$status" -eq 0 ]
    
    app_result=$(cat "$TEST_DIR/app.conf")
    db_result=$(cat "$TEST_DIR/db.conf")
    [ "$app_result" = "env=production" ]
    [ "$db_result" = "environment=production" ]
}

@test "exec functionality works" {
    echo 'Message: ${MESSAGE}' > "$TEST_DIR/output.txt"
    echo 'Message: ${MESSAGE}${MESSAGE}' > "$TEST_DIR/output_exec.txt"
    
    run docker run --rm \
        -e MESSAGE=hello \
        -v "$TEST_DIR:/test" \
        "$IMAGE_NAME" \
        ep -b /test/output.txt -- /usr/local/bin/ep -d /test/output_exec.txt
    
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Message: hellohello" ]]
}

@test "version information available" {
    run docker run --rm "$IMAGE_NAME" ep --help
    
    [ "$status" -eq 0 ]
    [[ "$output" =~ "envplate" ]]
}

@test "container uses scratch base (minimal size)" {
    run docker images "$IMAGE_NAME" --format "{{.Size}}"
    
    [ "$status" -eq 0 ]
    # Size should be less than 20MB for a scratch-based image
    size_mb=$(echo "$output" | sed 's/MB//' | cut -d'.' -f1)
    [ -n "$size_mb" ]
    [ "$size_mb" -lt 20 ]
}
