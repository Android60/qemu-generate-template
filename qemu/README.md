# Generate template with QEMU

### Download image
```
wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
cp  base-image/jammy-server-cloudimg-amd64.img output-image/disk0.img

```
### Expand disk
```
qemu-img resize disk0.img +18GB
```

### Start an IMDS webserver
```
python3 -m http.server --directory cloud-init/
```

### Run QEMU
```
qemu-system-x86_64                                              \
    -display none                                               \
    -vnc :0                                                     \
    -net nic                                                    \
    -net user                                                   \
    -nic user,hostfwd=tcp::60022-:22                            \
    -machine accel=kvm:tcg                                      \
    -m 512                                                      \
    -nographic                                                  \
    -hda output-image/disk0.img                                 \
    -smbios type=1,serial=ds='nocloud;s=http://10.0.2.2:8000/'
```

### Run ansible-playbook


### Compress image
```
qemu-img convert -O qcow2 -c disk0.img compressed_image.qcow2
```
