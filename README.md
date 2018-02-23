# customized ca

demonstrate ca workflow, please note that only self-signed root certificate 
and leaf certificate is generated, there is no intermedia certiifcate.



### create self-signed root certificate

```bash
./create_self_signed_cert.sh
```



### create self-signed-root-certificate-signed certificate

```bash
./create_web_cert.sh
```


### deploy

* copy pem and key file from workspace/output_certs to nginx conf dir

```text
file path: workspace/output_certs/combined_cert.pem
file path: workspace/root_ca_perm_key/web_cert_key
```

* setup nginx as:

```conf
server {
    listen 443;
    server_name tech.lixinchuxing.com;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_dhparam /etc/nginx/ssl/dhparam.pem;

    ssl_certificate /home/andrewyi/lxcx/combined_cert.pem;
    # ssl_certificate /home/andrewyi/lxcx/01.pem;
    ssl_certificate_key /home/andrewyi/lxcx/web_cert_key;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    access_log /var/log/nginx/lxcx.access.log;
    error_log /var/log/nginx/lxcx.error.log;

    root /home/andrewyi/lxcx/www;
    index index.php index.html index.htm;

    location / {
            try_files $uri $uri/ /index.html;
    }

    error_page 404 /404.html;

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
          root /usr/share/nginx/www;
    }
}
```

### import self-signed root certificate into local machine key store

```text
file path: workspace/root_ca_perm_key/root_cert.pem
```

### set dns in local machine

### access from web
