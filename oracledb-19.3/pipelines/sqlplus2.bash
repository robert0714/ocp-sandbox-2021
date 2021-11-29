#!/bin/sh

# render a template configuration file
# expand variables + preserve formatting
render_template() {
  eval "echo \"$(cat $1)\""
}

user="c##BCRM9999"
render_template user-template.txt > user-template.sql