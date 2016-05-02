#!/bin/bash

cite 'about-alias'
about-alias 'Some bash aliases.'

# set bash aliases
function _set_pkg_aliases()
{
  alias sourcebashrc='source ~/.bashrc'
}

_set_pkg_aliases

