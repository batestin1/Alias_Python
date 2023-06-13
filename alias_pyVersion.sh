#!/bin/bash

echo "Checking for python on your system"
sleep 1
check_python_version() {
    version=$1
    if ! command -v python$version &> /dev/null; then
        sudo apt-get install -y python$version > /dev/null 2>&1
    fi
}

check_python_version 3.7

check_python_version 3.10
echo "System checked"
sleep 1
clear
available_versions=$(ls /usr/bin/python* | grep -oP "python\d\.\d+" | sort -u)

echo "Available Python versions:"

versions_array=($available_versions)


for i in "${!versions_array[@]}"; do
    echo "$(($i + 1)): ${versions_array[$i]}"
done

read -p "Enter the number corresponding to the Python version you want to use for the 'py' alias: " python_choice

if [[ "$python_choice" =~ ^[1-9][0-9]*$ && $python_choice -le ${#versions_array[@]} ]]; then
    python_version=${versions_array[$(($python_choice - 1))]}
    alias_line="alias py='$python_version'"


    if grep -Fxq "$alias_line" ~/.bashrc; then
        echo "Alias 'py' is already configured for Python $python_version."
    else
        sed -i '/alias py=/d' ~/.bashrc

        echo -e "\n# Alias to run Python $python_version\n$alias_line" >> ~/.bashrc
        echo "Successfully configured 'py' alias for Python $python_version."
    fi

    source ~/.bashrc

    echo "Concluded."
else
    echo "Invalid choice. Leaving."
fi
