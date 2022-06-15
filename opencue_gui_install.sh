#!/bin/bash
echo "Make sure your current directory is the desired install folder."
echo "Find current releases here:"
echo "https://github.com/AcademySoftwareFoundation/OpenCue/releases"

TMP=/tmp/opencue_install

echo "Enter url to CueGUI tarball:"
read CUEGUI_URL
CUEGUI_TAR=$TMP/$(basename "$CUEGUI_URL")
CUEGUI_DIR=$TMP/$(basename "$CUEGUI_URL" .tar.gz)

echo "Enter url to CueSubmit tarball:"
read CUESUBMIT_URL
CUESUBMIT_TAR=$TMP/$(basename "$CUESUBMIT_URL")
CUESUBMIT_DIR=$TMP/$(basename "$CUESUBMIT_URL" .tar.gz)

echo "Enter url to PyCue taball:"
read PYCUE_URL
PYCUE_TAR=$TMP/$(basename "$PYCUE_URL")
PYCUE_DIR=$TMP/$(basename "$PYCUE_URL" .tar.gz)

echo "Enter url to PyOutline tarball:"
read PYOUTLINE_URL
PYOUTLINE_TAR=$TMP/$(basename "$PYOUTLINE_URL")
PYOUTLINE_DIR=$TMP/$(basename "$PYOUTLINE_URL" .tar.gz)

rm -rf $TMP
mkdir -p $TMP

rm -rf opencue_env
rm cuegui.sh
cat > cuegui.sh << 'EOT'
#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
source $SCRIPT_DIR/opencue_env/bin/activate
CUEBOT_HOSTS=$1 cuegui
EOT
chmod +x cuegui.sh

rm cuesubmit.sh
cat > cuesubmit.sh << 'EOT'
#!/bin/bash
SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
source $SCRIPT_DIR/opencue_env/bin/activate
CUEBOT_HOSTS=$1 cuesubmit
EOT
chmod +x cuesubmit.sh

wget -P $TMP $PYCUE_URL
wget -P $TMP $PYOUTLINE_URL
wget -P $TMP $CUEGUI_URL
wget -P $TMP $CUESUBMIT_URL

tar xvzf $PYCUE_TAR -C $TMP
tar xvzf $PYOUTLINE_TAR -C $TMP
tar xvzf $CUEGUI_TAR -C $TMP
tar xvzf $CUESUBMIT_TAR -C $TMP

virtualenv opencue_env
source opencue_env/bin/activate

cd $PYCUE_DIR
pip install -r requirements.txt
python setup.py install

cd $PYOUTLINE_DIR
pip install -r requirements.txt
python setup.py install

cd $CUEGUI_DIR
pip install -r requirements.txt
pip install -r requirements_gui.txt
python setup.py install

cd $CUESUBMIT_DIR
pip install -r requirements.txt
pip install -r requirements_gui.txt
python setup.py install

rm -rf $TMP
