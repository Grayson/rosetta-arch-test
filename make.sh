#!/usr/bin/env bash

main() {
	local machine_arch=$(arch)
	for arch in x86_64 arm64; do
		mkdir -p $arch
		cc -c -Wall -arch $arch -o ./$arch/lib.o lib.c
		cc -Wall -arch $arch -o ./$arch/rosetta-test test.c ./$arch/lib.o
		arch -$machine_arch ./$arch/rosetta-test 2> /dev/null # Prevent "silent" Rosetta activation
		local result=$?

		echo "Executing $arch on $machine_arch resulted in $result"

		# Expect failures when mismatching archs
		if [[ $result -eq 1 && $arch == $machine_arch ]]; then
			exit -1
		fi
	done
}

main "$@"
