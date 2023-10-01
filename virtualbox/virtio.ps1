
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"

$URI = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"

Invoke-WebRequest $URI -outfile .\latest-virtio-win.iso -passthru -UseBasicParsing | Select-Object -Expand headers

$URI = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso"
Invoke-WebRequest $URI -outfile .\stable-virtio-win.iso -passthru -UseBasicParsing | Select-Object -Expand headers
