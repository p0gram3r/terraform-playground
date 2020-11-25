#!/bin/bash

random_string_32byte="`openssl rand -hex 32`"
random_string_16byte="`openssl rand -hex 16`"
token_first_6char="${random_string_16byte:0:6}"
token_last_16char="${random_string_16byte:7:16}"
token="${token_first_6char}.${token_last_16char}"

echo "{\"certificate_key\": \"${random_string_32byte}\", \"token\": \"${token}\"}"