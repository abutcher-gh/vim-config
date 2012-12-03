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
# mode is not disabled with NO_GIT=1 and the current directory is
# found to be within a git repository, git ls-files is used to
# enumerate candidate files rather than a recursive directory search
# -- as such, in this case, any arguments are ignored.
#
# ENVIRONMENT:
#
# Set NO_LINKS=1 for the invocation to prevent following symbolic links.
# Use CTAGS_OPTS and/or CSCOPE_OPTS to provide additional options to
# the respective programs.  Set NO_GIT to prevent special git
# behavior.
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
   if REPO_ROOT=$(git rev-parse --show-toplevel 2>$NIL); then
      cd "$REPO_ROOT"
      rm -f cscope* tags
      git ls-files '*.c??' '*.c' '*.h' '*.h??' '*.inl' '*.impl' '*.java' | sed "s|^|$PWD/|" > cscope.files
      set -- $(cat cscope.files)
   fi
else
   rm -f cscope* tags
fi
ctags -R ${CTAGS_LINK_OPTS[@]} -h '.h.H.hh.hpp.hxx.h++.inl' --langmap=c++:.c.cpp.cxx.c++.h.hpp.hxx.h++.inl.impl ${CTAGS_OPTS} $@ || exit $?
[ -n "$REPO_ROOT" ] || { find $@ -regex '.*\.\([chi]\(pp\|xx\|\+\+\)?\|inl\|impl\|java\)' ${FIND_LINK_OPTS[@]} > cscope.files; } || exit $?
cscope -u -b -q ${CSCOPE_OPTS}

