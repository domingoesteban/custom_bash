#!/bin/bash

cite 'about-alias'
about-alias 'Some bash aliases.'

# set bash aliases
function _set_pkg_aliases()
{
  alias vrep='sh /home/domingo/Packages/V-REP_PRO_EDU_V3_3_0_64_Linux/vrep.sh'
  alias gazebocore='optirun /usr/bin/gazebo'
  alias gzservercore='optirun /usr/bin/gzserver'
  alias gzclientcore='optirun /usr/bin/gzclient'
  alias gzclientcore='optirun /usr/bin/gzclient'

  HAS_OPTIRUN=true;
  type optirun >/dev/null 2>&1 || { HAS_OPTIRUN=false; }
  if [ $HAS_OPTIRUN == true ]; then
    alias matlab='optirun matlab'
    alias matlab-nodesktop='optirun matlab -nodesktop'
  else
    alias matlab-nodesktop='matlab -nodesktop'
  fi


}

_set_pkg_aliases

