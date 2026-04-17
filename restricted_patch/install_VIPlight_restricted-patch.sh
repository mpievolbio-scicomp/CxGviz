#!/usr/bin/env bash

# reading first position parameter as the VIP environment to be patched
appEnvPath="${1:-~/.conda/envs/VIP_Du}"
appEnvPath=$(realpath ${appEnvPath/\~/$HOME})

patchPath=$(readlink -e $(dirname $0))
echo $patchPath

# source $appEnvPath/etc/profile.d/conda.sh
# conda activate
# which python

strPath="$(python -c 'import site; print(site.getsitepackages()[0])')"

cd $strPath/server
ln -sf $patchPath/interface_restricted.html common/web/static/interface_restricted.html
mv default_config.py default_config_prepatch.py
ln -sf $patchPath/default_config.py default_config.py
mv common/config/dataset_config.py common/config/dataset_config_prepatch.py
ln -sf $patchPath/dataset_config.py common/config/dataset_config.py
mv common/config/server_config.py common/config/server_config_prepatch.py
ln -sf $patchPath/server_config.py common/config/server_config.py
mv cli/launch.py cli/launch_prepatch.py
ln -sf $patchPath/launch.py cli/launch.py
mv app/app.py app/app_prepatch.py
ln -sf $patchPath/app.py app/app.py
mv common/web/templates/index.html common/web/templates/index_prepatch.html
ln -sf $patchPath/index.html common/web/templates/index.html

echo "Patching completed!"
