#!/bin/bash

APP_DIR="/var/wwww/website"
RELEASE_DIR="${APP_DIR}/releases"
DATE=$(date +"%Y%m%d%H%s")
NEW_RELEASE_DIR="${RELEASE_DIR}/${DATE}"
REPO="git@anestesia-tech.gitlab.yandexcloud.net:anestesia/website.git"
COMMIT=$1

# check releases folder
[ -d "${RELEASE_DIR}" ] || mkdir ${RELEASE_DIR}

# create release
git clone --depth 1 ${REPO} ${NEW_RELEASE_DIR}
cd ${NEW_RELEASE_DIR}
git reset --hard ${COMMIT}

# create nginx conf
sudo cp ${APP_DIR}/nginx.conf /etc/nginx/sites-enabled/release
sudo sed -i "s/RELEASE/${DATE}/g" /etc/nginx/sites-enabled/release
sudo nginx -t
sudo nginx -s reload

# release
ln -nfs "${NEW_RELEASE_DIR}" "${APP_DIR}/current"