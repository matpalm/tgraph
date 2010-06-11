set -x
mkdir db 2>/dev/null
mongod --dbpath=db
