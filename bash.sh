#!/bin/bash

sed -i "s/.txt\[\]/\.asciidoc\[\]/g" `grep '.txt\[\]' -rl ./`

sed -i "s/examples/examples/g" `grep 'backup' -rl ./`
sed -i "s/examples/examples/g" `grep 'cypher' -rl ./`
sed -i "s/examples/examples/g" `grep 'cypher-plugin' -rl ./`
sed -i "s/examples/examples/g" `grep 'examples' -rl ./`
sed -i "s/examples/examples/g" `grep 'graph-algo' -rl ./`
sed -i "s/examples/examples/g" `grep 'gremlin-plugin' -rl ./`

sed -i "s/examples/examples/g" `grep 'ha' -rl ./`
sed -i "s/examples/examples/g" `grep 'kernel' -rl ./`
sed -i "s/examples/examples/g" `grep 'lucene-index' -rl ./`
sed -i "s/examples/examples/g" `grep 'management' -rl ./`
sed -i "s/examples/examples/g" `grep 'python-embedded' -rl ./`
sed -i "s/examples/examples/g" `grep 'server' -rl ./`
sed -i "s/examples/examples/g" `grep 'server-examples' -rl ./`
sed -i "s/examples/examples/g" `grep 'shell' -rl ./`
sed -i "s/examples/examples/g" `grep 'udc' -rl ./`


