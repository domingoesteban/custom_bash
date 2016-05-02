#!/bin/bash

cite 'about-alias'
about-alias 'Some gcc and g++ aliases.'

# set cpp aliases
function _set_pkg_aliases()
{
  alias gccp='sh ${CUSTOM_BASH}/scripts/up/cpp/gccp.sh'
}

_set_pkg_aliases
