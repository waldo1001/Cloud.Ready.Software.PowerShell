
# Download: https://wiki.openssl.org/index.php/Binaries

Set-location "C:\Program Files\OpenSSL-Win64\bin"

# best to do in cmd

openssl req -new -newkey rsa:2048 -nodes -out star_waldo_be.csr -keyout star_waldo_be.key -subj "/C=BE/ST=Antwerp/L=Vosselaar/O=Dynex bv/CN=*.waldo.be"
openssl pkcs12 -inkey star_waldo_be.key -in star_waldo_be.pem -export -out star_waldo_be.pfx

openssl pkcs12 -in star_waldo_be.pfx -out star_waldo_be.crt -nokeys -clcerts

openssl x509 -inform pem -in star_waldo_be.crt -outform der -out star_waldo_be.cer

#openssl pkcs12 -in star_waldo_be.pfx -nocerts -out star_waldo_be.key.pem

#openssl rsa -in wildcard.waldo.be.key.pem -out wildcard.waldo.be.key 
