
#!/bin/bash

for directory in "build/MinervaDemo.xcframework/"*; do
    if [ -d "${directory}" ]; then
        echo "${directory}"
    fi
done
