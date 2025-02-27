# Generate template with QEMU

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