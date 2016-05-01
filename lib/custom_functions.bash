# Functions loading various enable files
# NOTE: This fuctions are adapted from https://github.com/Bash-it/bash-it.

function _load_custom_bash_files() {
  subdirectory="$1"
  if [ ! -d "${CUSTOM_BASH}/${subdirectory}" ]
  then
    continue
  fi
  FILES="${CUSTOM_BASH}/${subdirectory}/*.bash"
  for config_file in $FILES
  do
    if [ -e "${config_file}" ]; then
      source $config_file
    fi
  done
}

# Function for reloading aliases
function reload_aliases() {
  _load_custom_bash_files "aliases"
}

# Function for reloading auto-completion
function reload_completion() {
  _load_custom_bash_files "completion"
}

# Function for reloading plugins
function reload_plugins() {
  _load_custom_bash_files "plugins"
}

custom-bash ()
{
    about 'Custom-bash help and maintenance'
    param '1: verb [one of: help | show | enable | disable | update | search ] '
    param '2: component type [one of: alias(es) | completion(s) | plugin(s) ] or search term(s)'
    param '3: specific component [optional]'
    example '$ custom-bash show plugins'
    example '$ custom-bash help aliases'
    example '$ custom-bash enable plugin git [tmux]...'
    example '$ custom-bash disable alias hg [tmux]...'
    example '$ custom-bash update'
    example '$ custom-bash search ruby [rake]...'
    typeset verb=${1:-}
    shift
    typeset component=${1:-}
    shift
    typeset func
    case $verb in
         show)
             func=_custom-bash-$component;;
         enable)
             func=_enable-$component;;
         disable)
             func=_disable-$component;;
         help)
             func=_help-$component;;
         search)
             _custom-bash-search $component $*
             return;;
         update)
             func=_custom-bash_update;;
         *)
             reference custom-bash
             return;;
    esac

    # pluralize component if necessary
    if ! _is_function $func; then
        if _is_function ${func}s; then
            func=${func}s
        else
            if _is_function ${func}es; then
                func=${func}es
            else
                echo "oops! $component is not a valid option!"
                reference custom-bash
                return
            fi
        fi
    fi

    if [ x"$verb" == x"enable" -o x"$verb" == x"disable" ];then
        for arg in "$@"
        do
            $func $arg
        done
    else
        $func $*
    fi
}

_is_function ()
{
    _about 'sets $? to true if parameter is the name of a function'
    _param '1: name of alleged function'
    _group 'lib'
    [ -n "$(LANG=C type -t $1 2>/dev/null | grep 'function')" ]
}

_custom-bash-aliases ()
{
    _about 'summarizes available custom_bash aliases'
    _group 'lib'

    _custom-bash-describe "aliases" "an" "alias" "Alias"
}

_custom-bash-completions ()
{
    _about 'summarizes available custom_bash completions'
    _group 'lib'

    _custom-bash-describe "completion" "a" "completion" "Completion"
}

_custom-bash-plugins ()
{
    _about 'summarizes available custom_bash plugins'
    _group 'lib'

    _custom-bash-describe "plugins" "a" "plugin" "Plugin"
}

_custom-bash_update() {
  _about 'updates Custom-bash'
  _group 'lib'

  cd "${CUSTOM_BASH}"
  if [ -z $CUSTOM_BASH_REMOTE ]; then
    CUSTOM_BASH_REMOTE="origin"
  fi
  git fetch &> /dev/null
  local status="$(git rev-list master..${CUSTOM_BASH_REMOTE}/master 2> /dev/null)"
  if [[ -n "${status}" ]]; then
    git pull --rebase &> /dev/null
    if [[ $? -eq 0 ]]; then
      echo "custom-bash successfully updated!"
      reload
    else
      echo "Error updating custom-bash, please, check if your custom-bash installation folder (${CUSTOM_BASH}) is clean."
    fi
  else
    echo "custom-bash is up to date, nothing to do."
  fi
  cd - &> /dev/null
}

# This function returns list of aliases, plugins and completions in custom-bash,
# whose name or description matches one of the search terms provided as arguments.
#
# Usage:
#    ❯ custom-bash search term1 [term2]...
# Example:
#    ❯ custom-bash search ruby rbenv rvm gem rake
#  aliases: bundler
#  plugins: chruby chruby-auto rbenv ruby rvm
#  completions: gem rake
#

_custom-bash-search() {
  _about 'searches for given terms amongst custom-bash plugins, aliases and completions'
  _param '1: term1'
  _param '2: [ term2 ]...'
  _example '$ _custom-bash-search ruby rvm rake bundler'

  declare -a _components=(aliases plugins completions)
  for _component in "${_components[@]}" ; do
    _custom-bash-search-component  "${_component}" "$*"
  done
}

_custom-bash-search-component() {
  _about 'searches for given terms amongst a given component'
  _param '1: component type, one of: [ aliases | plugins | completions ]'
  _param '2: term1'
  _param '3: [ term2 ]...'
  _example '$ _custom-bash-search-component aliases rake bundler'

  _component=$1
  local func=_custom-bash-${_component}
  local help=$($func)

  shift
  declare -a terms=($@)
  declare -a matches=()
  local _grep=$(which egrep || which grep)
  for term in "${terms[@]}"; do
    local term_match=($(echo "${help}"| ${_grep} -i -- ${term} | cut -d ' ' -f 1  | tr '\n' ' '))
    [[ "${#term_match[@]}" -gt 0 ]] && {
      matches=(${matches[@]} ${term_match[@]})
    }
  done
  [[ -n "$NO_COLOR" && color_on="" ]]  || color_on="\e[1;32m"
  [[ -n "$NO_COLOR" && color_off="" ]] || color_off="\e[0;0m"

  if [[ "${#matches[*]}" -gt 0 ]] ; then
    printf "%-12s: ${color_on}%s${color_off}\n" "${_component}" "$(echo -n ${matches[*]} | tr ' ' '\n' | sort | uniq | tr '\n' ' ' | sed 's/ $//g')"
  fi
  unset matches
}

_custom-bash-describe ()
{
    _about 'summarizes available custom_bash components'
    _param '1: subdirectory'
    _param '2: preposition'
    _param '3: file_type'
    _param '4: column_header'
    _example '$ _custom-bash-describe "plugins" "a" "plugin" "Plugin"'

    subdirectory="$1"
    preposition="$2"
    file_type="$3"
    column_header="$4"

    typeset f
    typeset enabled
    printf "%-20s%-10s%s\n" "$column_header" 'Enabled?' 'Description'
    for f in $CUSTOM_BASH/$subdirectory/available/*.bash
    do
        if [ -e $CUSTOM_BASH/$subdirectory/enabled/$(basename $f) ]; then
            enabled='x'
        else
            enabled=' '
        fi
        printf "%-20s%-10s%s\n" "$(basename $f | cut -d'.' -f1)" "  [$enabled]" "$(cat $f | metafor about-$file_type)"
    done
    printf '\n%s\n' "to enable $preposition $file_type, do:"
    printf '%s\n' "$ custom-bash enable $file_type  <$file_type name> [$file_type name]... -or- $ bash-it enable $file_type all"
    printf '\n%s\n' "to disable $preposition $file_type, do:"
    printf '%s\n' "$ custom-bash disable $file_type <$file_type name> [$file_type name]... -or- $ bash-it disable $file_type all"
}

_disable-plugin ()
{
    _about 'disables custom_bash plugin'
    _param '1: plugin name'
    _example '$ disable-plugin rvm'
    _group 'lib'

    _disable-thing "plugins" "plugin" $1
}

_disable-alias ()
{
    _about 'disables custom_bash alias'
    _param '1: alias name'
    _example '$ disable-alias git'
    _group 'lib'

    _disable-thing "aliases" "alias" $1
}

_disable-completion ()
{
    _about 'disables custom_bash completion'
    _param '1: completion name'
    _example '$ disable-completion git'
    _group 'lib'

    _disable-thing "completion" "completion" $1
}

_disable-thing ()
{
    _about 'disables a custom_bash component'
    _param '1: subdirectory'
    _param '2: file_type'
    _param '3: file_entity'
    _example '$ _disable-thing "plugins" "plugin" "ssh"'

    subdirectory="$1"
    file_type="$2"
    file_entity="$3"

    if [ -z "$file_entity" ]; then
        reference "disable-$file_type"
        return
    fi

    if [ "$file_entity" = "all" ]; then
        typeset f $file_type
        for f in $CUSTOM_BASH/$subdirectory/available/*.bash
        do
            plugin=$(basename $f)
            if [ -e $CUSTOM_BASH/$subdirectory/enabled/$plugin ]; then
                rm $CUSTOM_BASH/$subdirectory/enabled/$(basename $plugin)
            fi
        done
    else
        typeset plugin=$(command ls $CUSTOM_BASH/$subdirectory/enabled/$file_entity.*bash 2>/dev/null | head -1)
        if [ -z "$plugin" ]; then
            printf '%s\n' "sorry, $file_entity does not appear to be an enabled $file_type."
            return
        fi
        rm $CUSTOM_BASH/$subdirectory/enabled/$(basename $plugin)
    fi

    printf '%s\n' "$file_entity disabled."
}

_enable-plugin ()
{
    _about 'enables custom_bash plugin'
    _param '1: plugin name'
    _example '$ enable-plugin rvm'
    _group 'lib'

    _enable-thing "plugins" "plugin" $1
}

_enable-alias ()
{
    _about 'enables custom_bash alias'
    _param '1: alias name'
    _example '$ enable-alias git'
    _group 'lib'

    _enable-thing "aliases" "alias" $1
}

_enable-completion ()
{
    _about 'enables custom_bash completion'
    _param '1: completion name'
    _example '$ enable-completion git'
    _group 'lib'

    _enable-thing "completion" "completion" $1
}

_enable-thing ()
{
    cite _about _param _example
    _about 'enables a custom_bash component'
    _param '1: subdirectory'
    _param '2: file_type'
    _param '3: file_entity'
    _example '$ _enable-thing "plugins" "plugin" "ssh"'

    subdirectory="$1"
    file_type="$2"
    file_entity="$3"

    if [ -z "$file_entity" ]; then
        reference "enable-$file_type"
        return
    fi

    if [ "$file_entity" = "all" ]; then
        typeset f $file_type
        for f in $CUSTOM_BASH/$subdirectory/available/*.bash
        do
            plugin=$(basename $f)
            if [ ! -h $CUSTOM_BASH/$subdirectory/enabled/$plugin ]; then
                ln -s ../available/$plugin $CUSTOM_BASH/$subdirectory/enabled/$plugin
            fi
        done
    else
        typeset plugin=$(command ls $CUSTOM_BASH/$subdirectory/available/$file_entity.*bash 2>/dev/null | head -1)
        if [ -z "$plugin" ]; then
            printf '%s\n' "sorry, $file_entity does not appear to be an available $file_type."
            return
        fi

        plugin=$(basename $plugin)
        if [ -e $CUSTOM_BASH/$subdirectory/enabled/$plugin ]; then
            printf '%s\n' "$file_entity is already enabled."
            return
        fi

        mkdir -p $CUSTOM_BASH/$subdirectory/enabled

        ln -s ../available/$plugin $CUSTOM_BASH/$subdirectory/enabled/$plugin
    fi

    printf '%s\n' "$file_entity enabled."
}

_help-completions()
{
  _about 'summarize all completions available in custom-bash'
  _group 'lib'

  _custom-bash-completions
}

_help-aliases()
{
    _about 'shows help for all aliases, or a specific alias group'
    _param '1: optional alias group'
    _example '$ alias-help'
    _example '$ alias-help git'

    if [ -n "$1" ]; then
        cat $CUSTOM_BASH/aliases/available/$1.aliases.bash | metafor alias | sed "s/$/'/"
    else
        typeset f
        for f in $CUSTOM_BASH/aliases/enabled/*
        do
            typeset file=$(basename $f)
            printf '\n\n%s:\n' "${file%%.*}"
            # metafor() strips trailing quotes, restore them with sed..
            cat $f | metafor alias | sed "s/$/'/"
        done
    fi
}

_help-plugins()
{
    _about 'summarize all functions defined by enabled custom-bash plugins'
    _group 'lib'

    # display a brief progress message...
    printf '%s' 'please wait, building help...'
    typeset grouplist=$(mktemp /tmp/grouplist.XXXX)
    typeset func
    for func in $(typeset_functions)
    do
        typeset group="$(typeset -f $func | metafor group)"
        if [ -z "$group" ]; then
            group='misc'
        fi
        typeset about="$(typeset -f $func | metafor about)"
        letterpress "$about" $func >> $grouplist.$group
        echo $grouplist.$group >> $grouplist
    done
    # clear progress message
    printf '\r%s\n' '                              '
    typeset group
    typeset gfile
    for gfile in $(cat $grouplist | sort | uniq)
    do
        printf '%s\n' "${gfile##*.}:"
        cat $gfile
        printf '\n'
        rm $gfile 2> /dev/null
    done | less
    rm $grouplist 2> /dev/null
}

_help-update () {
  _about 'help message for update command'
  _group 'lib'

  echo "Check for a new version of Custom-bash and update it."
}

all_groups ()
{
    about 'displays all unique metadata groups'
    group 'lib'

    typeset func
    typeset file=$(mktemp /tmp/composure.XXXX)
    for func in $(typeset_functions)
    do
        typeset -f $func | metafor group >> $file
    done
    cat $file | sort | uniq
    rm $file
}

if ! type pathmunge > /dev/null 2>&1
then
  function pathmunge () {
    about 'prevent duplicate directories in you PATH variable'
    group 'lib helpers'
    example 'pathmunge /path/to/dir is equivalent to PATH=/path/to/dir:$PATH'
    example 'pathmunge /path/to/dir after is equivalent to PATH=$PATH:/path/to/dir'

    if ! [[ $PATH =~ (^|:)$1($|:) ]] ; then
      if [ "$2" = "after" ] ; then
        export PATH=$PATH:$1
      else
        export PATH=$1:$PATH
      fi
    fi
  }
fi
