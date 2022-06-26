#!/bin/bash
#
# Copyright (c) 2022 John de Graaff - released under MIT license - see the end of this file
#
# This script auto increment a header file, that can be included in your projects
# Using the format as described by Semantic Version 2.0 format (Read more https://semver.org/)
# Note: this script does not implement pre-release tagging at this point
echo "# Let's increment the build number ..."
FILE=$1
if [ ${FILE} == ""]; then
  FILE="version.h"
fi
echo "# Processing file: '${FILE}' "

if [ -z "${FILE}" ]; then
	echo "# Usage: $0 [<filename> version.h] "
fi

# Create timestamp
# TIMESTAMP=$(date '+%d/%m/%Y')
TIMESTAMP=$(date '+%Y-%m-%d.%H:%M:%S')
# HOUR=$(date '+%H')
# MINUTE=$(date '+%M')
# SECOND=$(date '+%S')
# DAY=$(date '+%d')
# MONTH=$(date '+%m')
# YEAR=$(date '+%Y')
echo "# DateTime: ${TIMESTAMP} "

# clear version numbers
MAJOR=""
MINOR=""
PATCH=""
BUILD=""
VERSION=""

if [[ -f "${FILE}" ]]; then
	# echo Parse %1 for major.minor.patch-build values and parse them
	IFS=' '
	while read -r line
	do
	#	echo "# $line"
		read -ra tokens <<< "$line"
		val=${tokens[2]//[!0-9]/}
		case ${tokens[1]} in
				_VERSION_MAJOR)
						MAJOR=$val
				;;
			_VERSION_MINOR)
				MINOR=$val
				;;
			_VERSION_PATCH)
				PATCH=$val
				;;
			_VERSION_BUILD)
				BUILD=$val
				;;
		esac
	done <"${FILE}"
fi 

if [ "$MAJOR${MINOR}${PATCH}${BUILD}" == "" ] ;  then
        echo "# Initializing [${FILE}] to default values:"
        MAJOR=1
        MINOR=0
        PATCH=0
        BUILD=0
fi

VERSION="$MAJOR.${MINOR}.${PATCH}+${BUILD}"
echo "# Found version: ${VERSION}"

# now auto increment build number by 1
BUILD=$((BUILD+1))
VERSION="$MAJOR.${MINOR}.${PATCH}+${BUILD}"
echo "# Incrementing build: ${BUILD}"
echo "# new Version is: ${VERSION}"

# write the version numbers out to the file
echo "//The version number conforms to semver.org format">${FILE}
echo "#define _VERSION_MAJOR ${MAJOR}">>${FILE}
echo "#define _VERSION_MINOR ${MINOR}">>${FILE}
echo "#define _VERSION_PATCH ${PATCH}">>${FILE}
echo "#define _VERSION_BUILD ${BUILD}">>${FILE}
echo "#define _VERSION_DATETIME \"${TIMESTAMP}\"">>${FILE}
# echo "#define _VERSION_DATE \"${TIMESTAMP}\"">>${FILE}
# echo "#define _VERSION_TIME \"${HOUR}:${MINUTE}:${SECOND}\"">>${FILE}
echo "#define _VERSION_ONLY \"$MAJOR.${MINOR}.${PATCH}\"">>${FILE}
echo "#define _VERSION_NOBUILD \"$MAJOR.${MINOR}.${PATCH} (${TIMESTAMP})\"">>${FILE}
echo "#define _VERSION \"${VERSION} (${TIMESTAMP})\"">>${FILE}
echo "//The version information is created automatically, more information here: https://github.com/jdg71nl/autoinc-semver">>${FILE}

# clear version numbers
MAJOR=
MINOR=
PATCH=
BUILD=
VERSION=
TIMESTAMP=
# echo ${VERSION}

exit 0

# MIT License
#
# Copyright (c) 2022 John de Graaff
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
