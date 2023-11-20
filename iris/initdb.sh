#!/bin/bash

cat << EOF | iris terminal IRIS
DO $SYSTEM.SQL.Schema.ImportDDL("/irisrun/repo/script.sql",,"IRIS")
EOF

exit=$?

iris stop IRIS quietly

exit $exit