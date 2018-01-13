From: Dan Aloni <dan@kernelim.com>
Date: Sat, 13 Jan 2018 23:34:34 +0200
Message-Id: <20180113213441.52047-1-dan@kernelim.com>
Subject: [kernel-hardening] [PATCHv2 0/7] RFC: Public key encryption of dmesg by the kernel
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Changes from v1 [1]:

 - Made suggested fixes following a review from Randy Dunlap
 - Modified the ASCII encoding of cipher text to base64 instead of hex,
   with newlines replaced by '~' ; updated dmesg-decipher for it too
 - Moved base64 code from fs/ceph to lib, and improved it a bit
 - Improved checks that we are not overflowing the user buffer when
   using copy_to_user to in the added code
 - Added some prints when errors in dmesg-decipher
 - Fixes to Makefile at tools/ for building 'kmsg' (should it
   build by default in target 'all'? There is an openssl depdendency.)
 - checkpatch.pl linting

[1] https://lwn.net/Articles/742412/

Dan Aloni (7):
  crypto: fix memory leak in rsa-kcs1pad encryption
  Move net/ceph/armor to lib/ and add docs
  base64-armor: add bounds checking
  certs: allow in-kernel access of trusted keys
  printk: allow kmsg to be encrypted using public key encryption
  tools: add dmesg decryption program
  docs: add dmesg encryption doc

 Documentation/admin-guide/dmesg-encryption.rst | 116 +++++++
 Documentation/admin-guide/index.rst            |   1 +
 Documentation/ioctl/ioctl-number.txt           |   1 +
 certs/system_keyring.c                         |  56 ++-
 crypto/rsa-pkcs1pad.c                          |   9 -
 include/keys/system_keyring.h                  |   3 +
 include/linux/base64-armor.h                   |  70 ++++
 include/uapi/linux/kmsg.h                      |  18 +
 init/Kconfig                                   |  11 +
 kernel/printk/printk.c                         | 451 +++++++++++++++++++++++++
 lib/Kconfig                                    |   7 +
 lib/Makefile                                   |   1 +
 net/ceph/armor.c => lib/base64-armor.c         |  29 +-
 net/ceph/Kconfig                               |   1 +
 net/ceph/Makefile                              |   2 +-
 net/ceph/crypto.c                              |   3 +-
 net/ceph/crypto.h                              |   4 -
 tools/Makefile                                 |   9 +-
 tools/kmsg/.gitignore                          |   1 +
 tools/kmsg/Makefile                            |  14 +
 tools/kmsg/dmesg-decipher.c                    | 354 +++++++++++++++++++
 21 files changed, 1139 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/admin-guide/dmesg-encryption.rst
 create mode 100644 include/linux/base64-armor.h
 create mode 100644 include/uapi/linux/kmsg.h
 rename net/ceph/armor.c => lib/base64-armor.c (75%)
 create mode 100644 tools/kmsg/.gitignore
 create mode 100644 tools/kmsg/Makefile
 create mode 100644 tools/kmsg/dmesg-decipher.c

-- 
2.14.3
