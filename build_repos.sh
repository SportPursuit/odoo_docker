#!/bin/bash

CWD=$(pwd)
BUILD_DIR="/tmp/docker_build"
ODOO_DIR="../odoo"

rm -f build/repos.tar.gz
rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"


# Link all the appropriate addon directories into the build dir
for repo in $(ls $ODOO_DIR)
do
    if [ "$repo" != "odoo" ] && [ "$repo" != "sp_odoo" ] && [ "$repo" != "credativ-addons" ] && [ -d "$ODOO_DIR/$repo" ]; then
        for addon in $(ls "$ODOO_DIR/$repo")
        do
            if [ -d "$ODOO_DIR/$repo/$addon" ] && [ "$addon" != "__unported__" ]; then
                ln -s "$CWD/$ODOO_DIR/$repo/$addon" "$BUILD_DIR/"
            fi
        done
    fi
done


# For Odoo we want the whole directory
ln -s "$CWD/$ODOO_DIR/odoo" "$BUILD_DIR/"

# The
for addon in $(ls "$ODOO_DIR/sp_odoo/addons")
do
    ln -s "$CWD/$ODOO_DIR/sp_odoo/addons/$addon" "$BUILD_DIR/"
done

tar --exclude .git --exclude .idea -hczLf build/repos.tar.gz -C "$BUILD_DIR" .
