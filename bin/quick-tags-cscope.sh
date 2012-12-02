#!/bin/bash
#
# Run from a source dir to generate useful tags and cscope info for # C/C++ (maybe also Java)
#
# Tags and cscope database are written into the current directory.
#
# ARGUMENTS:
#
# Any arguments are treated as directory specifiers to be inspected.
# If no arguments are given, the current directory is used.
#
# ENVIRONMENT:
#
# Set NO_LINKS=1 for the invocation to prevent following symbolic links.
# Use CTAGS_OPTS and/or CSCOPE_OPTS to provide additional options to
# the respective programs.
#
if [ -z "$NO_LINKS" ]; then
   CTAGS_LINK_OPTS=()
   FIND_LINK_OPTS=()
else
   CTAGS_LINK_OPTS=(--links=no)
   FIND_LINK_OPTS=(-not -type l)
fi
ctags -R ${CTAGS_LINK_OPTS[@]} -h '.h.H.hh.hpp.hxx.h++.inl' --langmap=c++:.c.cpp.cxx.c++.h.hpp.hxx.h++.inl.impl ${CTAGS_OPTS} $@ || exit $?
find $@ -regex '.*\.\([chi]\(pp\|xx\|\+\+\)?\|inl\|impl\|java\)' ${FIND_LINK_OPTS[@]} > cscope.files || exit $?
cscope -b -q ${CSCOPE_OPTS}

