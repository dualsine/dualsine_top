#!/bin/bash
coffee -c 'js/global.coffee' 
haml index.haml -q --no-escape-attrs > index.html
sass css/global.scss > css/global.css
