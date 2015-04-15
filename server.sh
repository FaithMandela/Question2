#!/bin/bash

cd $(dirname $0)

java -Xmx256m -jar build/baraza.jar server ./projects/
