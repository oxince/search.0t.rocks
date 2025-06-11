#!/bin/bash

read -p "Enter the IP address of your Solr server [127.0.0.1]: " ip
ip=${ip:-"127.0.0.1"}

read -p "Enter the Port address of your Solr server [8983]: " port
port=${port:-"8983"}

read -p "Enter the number of shards (each shard can handle 2,147,483,519 documents. If you don't know, use one per Solr host. You can add more later, but it will require learning Solr's SHARD command.) [4]: " shards
shards=${shards:-"4"}

read -p "Enter the replication factor (redundant copies of shards across hosts. 1 = No redundancy) [1]: " replicationFactor
replicationFactor=${replicationFactor:-"1"}

echo "Creating Database..."

# Create collection for data
curl -s "http://$ip:$port/solr/admin/collections?action=CREATE&name=BigData&numShards=$shards&replicationFactor=$replicationFactor&wt=json"

# Disable schemaless mode
echo "Disabling schema-less mode..."
curl -s "http://$ip:$port/solr/BigData/config" \
  -H "Content-Type: application/json" \
  -d '{"set-user-property": {"update.autoCreateFields":"false"}}'

# Function to add fields
add_field() {
  curl -s "http://$ip:$port/solr/BigData/schema?wt=json" \
    -X POST \
    -H "Content-Type: application/json" \
    --data-raw "$1"
}

# Now add all fields

add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"accuracy_radius","type":"pint"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"address","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"asn","type":"pint","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"asnOrg","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"autoBody","type":"string"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"autoClass","type":"string"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"autoMake","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"autoModel","type":"string"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"autoYear","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"birthYear","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"birthMonth","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"birthday","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"city","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"continent","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"country","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"dob","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"domain","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"emails","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"ethnicity","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"firstName","type":"text_general","uninvertible":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"middleName","type":"text_general","uninvertible":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"gender","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":false,"name":"income","type":"string"}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":true,"name":"ips","type":"string","multiValued":true,"omitNorms":true,"omitTermFreqAndPositions":true,"sortMissingLast":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"lastName","type":"text_general","uninvertible":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":true,"name":"latLong","type":"location","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":false,"uninvertible":false,"name":"line","type":"string"}}'
add_field '{"add-field":{"stored":true,"indexed":false,"uninvertible":false,"name":"links","type":"string","multiValued":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":true,"name":"location","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":false,"uninvertible":false,"name":"notes","type":"string","multiValued":true}}'
add_field '{"add-field":{"stored":true,"indexed":false,"uninvertible":false,"name":"party","type":"string","multiValued":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"passwords","type":"string","multiValued":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"phoneNumbers","type":"text_general"}}'
add_field '{"add-field":{"stored":true,"indexed":false,"uninvertible":false,"name":"photos","type":"string","multiValued":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"source","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"uninvertible":false,"name":"state","type":"string","docValues":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"usernames","type":"text_general","uninvertible":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"vin","type":"text_general","uninvertible":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"zipCode","type":"string","uninvertible":true}}'
add_field '{"add-field":{"stored":true,"indexed":true,"name":"VRN","type":"text_general","uninvertible":true}}'

echo "Schema successfully updated."
