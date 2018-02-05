#!/bin/sh

# ./fix ------- Apply modifications
# ./fix -f  --- Force modifications
# ./fix -r  --- Revert modifications

pip install intelhex
pip install crcmod

TI_PATH="${HOME}/ti"

apply_fix() {
	script_path=$1
	script_name=$2
	echo "- Fix $script_name on $script_path"

	# Backup original script
	if [ ! -f ${script_path}/${script_name}.py.orig ]; then
		echo "  Creating bkp ${script_name}.py -> ${script_name}.py.orig"
		cp ${script_path}/${script_name}.py ${script_path}/${script_name}.py.orig

		# Remove not so good python version_control
		sed -i "s/^\([ ]\+\)\(version_control()\)/\1#\2 # removed by fix.sh script/g" ${script_name}.py
	fi

	# Skip if the file exists when not forcing it
	if [ ! -f ${script_path}/${script_name} ] || [ "${force_install}" = "1" ] ; then
		echo "  Copying wrapper -> ${script_name}"
		cp -f scripts/wrapper ${script_path}/${script_name}
		chmod +x ${script_path}/${script_name}
	fi
}

revert_fix() {
	script_path=$1
	script_name=$2
	echo "- Reverting changes on ${script_path}/${script_name}"
	mv ${script_path}/${script_name}.py.orig ${script_path}/${script_name}.py
	rm -f ${script_path}/${script_name}
}

force_install=0
revert_fix=0

case $1 in
	-r|re*)
		revert_fix=1
	;;
	-f|f*)
		force_install=1
	;;
esac

lib_search=$(find ~/ti -name lib_search.py)
frontier=$(find ~/ti -name frontier.py)
oad_image_tool=$(find ~/ti -name oad_image_tool.py)
scripts="$lib_search $frontier $oad_image_tool"
for script in $scripts; do
	script_path=$(dirname $script)
	script_name=$(basename $script)
	script_name="${script_name%.*}"
	if [ $revert_fix = 0 ]; then
		apply_fix $script_path $script_name
	else
		revert_fix $script_path $script_name
	fi
done
