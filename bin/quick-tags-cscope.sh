#!/bin/bash
#
# Run from a source dir to generate useful tags and cscope info for C/C++ (maybe also Java)
#
# Tags and cscope database are written into the current directory (or
# top-level repository directory if git is used).
#
# ARGUMENTS:
#
# Any arguments are treated as directory specifiers to be inspected.
# If no arguments are given, the current directory is used.  If git
# mode is not disabled with NO_GIT=1 and the current directory (or $1)
# is found to be within a git repository, git ls-files is used to
# enumerate candidate files rather than a recursive directory search
# -- as such, in this case, any further arguments are ignored.
#
# ENVIRONMENT:
#
# Set NO_LINKS=1 for the invocation to prevent following symbolic links.
# Use CTAGS_OPTS and/or CSCOPE_OPTS to provide additional options to
# the respective programs.  Set NO_GIT to prevent special git
# behavior.  Set FORCE_DIR=1 to use $1 as the directory in which to
# store the resulting files (implies NO_GIT).
#
if [ -z "$NO_LINKS" ]; then
   CTAGS_LINK_OPTS=()
   FIND_LINK_OPTS=()
else
   CTAGS_LINK_OPTS=(--links=no)
   FIND_LINK_OPTS=(-not -type l)
fi
if [ -z "$NO_GIT" ]; then
   if [[ "$OS" = *Windows* ]]; then NIL=NUL; else NIL=/dev/null; fi
   if REPO_ROOT=$(cd "$1" && git rev-parse --show-toplevel 2>$NIL); then
      rm -f "$REPO_ROOT/"cscope* "$REPO_ROOT/"tags
      if [ -n "$FORCE_DIR" ]
      then SRC_DIR="$(cd "$1" && pwd)"
      else SRC_DIR="$REPO_ROOT"
      fi
      echo >&2 "Locating files in '$SRC_DIR' with 'git'..."
      (cd "$SRC_DIR" && git ls-files --full-name '*.c??' '*.c' '*.h' '*.h??' '*.inl' '*.impl' '*.java') | sed "s|^|$REPO_ROOT/|" > "$REPO_ROOT"/cscope.files
      cd $REPO_ROOT
   fi
elif [ -n "$FORCE_DIR" ]; then
   cd "$1"
   rm -f cscope* tags
fi
[ -n "$REPO_ROOT" ] || { echo >&2 "Locating files in '$1' with 'find'..."; find . -regex '.*\.\([chi]\(pp\|xx\|\+\+\)?\|inl\|impl\|java\)' ${FIND_LINK_OPTS[@]} > cscope.files; }
echo >&2 "Updating tags..."
ctags -a -R ${CTAGS_LINK_OPTS[@]} -h '.h.H.hh.hpp.hxx.h++.inl' --langmap=c++:.c.cpp.cxx.c++.h.hpp.hxx.h++.inl.impl ${CTAGS_OPTS} -L cscope.files
echo >&2 "Updating cscope database..."
cscope -u -b -q ${CSCOPE_OPTS}
echo >&2 "Done."

