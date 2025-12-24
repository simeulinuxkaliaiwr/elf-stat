#!/usr/bin/env bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[33m'
NC='\033[0m'

BINARY="./build/elf-stat"
TEST_FILE="tests/test_data.txt"
TEST_DIR="tests/test_folder"

printf "${YELLOW} --- Inicializing Tests of Integrity: ELF-STAT ---${NC}\n"

if [[ ! -f "$BINARY" ]]; then
    echo -e "${RED}Error: Binary not found in $BINARY. Run 'make' first.${NC}"
    exit 1
fi

touch "$TEST_FILE"
chmod 644 "$TEST_FILE"
mkdir -p "$TEST_DIR"
chmod 755 "$TEST_DIR"

function check_result() {
    local label="$1"
    local expected="$2"
    local actual="$3"

    if [[ "$expected" == "$actual" && -n "$actual" ]]; then
        echo -e "[ ${GREEN}OK${NC} ] $label: $actual"
    else
        echo -e "[ ${RED}FAIL${NC} ] $label"
        echo "   Expected: $expected"
        echo "   Received: $actual"
        return 1
    fi
}

echo -e "\nTest 1: Regular file (644)"
EXPECTED_PERMS=$(stat -c "%A" "$TEST_FILE")
ACTUAL_PERMS=$("$BINARY" "$TEST_FILE" | grep -iE "Modo|Mode" | awk '{print $2}')
check_result "Permissions" "$EXPECTED_PERMS" "$ACTUAL_PERMS"

echo -e "\nTest 2: Directory (755)"
EXPECTED_DIR_PERMS=$(stat -c "%A" "$TEST_DIR") 
ACTUAL_DIR_PERMS=$("$BINARY" "$TEST_DIR" | grep -iE "Modo|Mode" | awk '{print $2}')
check_result "Permissions of the directory" "$EXPECTED_DIR_PERMS" "$ACTUAL_DIR_PERMS"

echo -e "\nTest 3: User identity"
EXPECTED_UID=$(id -u)
ACTUAL_UID=$("$BINARY" "$TEST_FILE" | grep -iE "UID" | awk '{print $2}')
check_result "UID of the current user" "$EXPECTED_UID" "$ACTUAL_UID"

echo -e "\nTest 4: File Size"
echo "Conteudo de Teste" > "$TEST_FILE" 
EXPECTED_SIZE=$(stat -c "%s" "$TEST_FILE")
ACTUAL_SIZE=$("$BINARY" "$TEST_FILE" | grep -iE "Tamanho|Size" | awk '{print $2}')
check_result "File Size" "$EXPECTED_SIZE" "$ACTUAL_SIZE"

rm "$TEST_FILE"
rmdir "$TEST_DIR"

echo -e "\n${YELLOW}--- Tests Completed ---${NC}"
