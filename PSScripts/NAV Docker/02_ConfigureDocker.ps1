#Start Docker Service
get-service *Docker* | Where Status -eq 'Stopped' |Start-Service
