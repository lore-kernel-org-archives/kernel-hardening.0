From: Dan Aloni <dan@kernelim.com>
Date: Sat, 30 Dec 2017 19:57:59 +0200
Message-Id: <20171230175804.7354-1-alonid@gmail.com>
Subject: [kernel-hardening] [PATCH 0/5] RFC: Public key encryption of dmesg by the kernel
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Dan Aloni <dan@kernelim.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Dan Aloni <dan@kernelim.com>

Hi All,

There has been a lot of progress in recent times regarding the removal
of sensitive information from dmesg (pointers, etc.), so I figured - why
not encrypt it all? However, I have not found any existing discussions
or references regarding this technical direction.

I am not sure that desktop and power users would like to have their
kernel message encrypted, but there are scenarios such as in mobile
devices, where only the developers, makers of devices, may actually
benefit from access to kernel prints messages, and the users may be
more protected from exploits.

In its present form, it is an RFC, so that before investing more time
developing it further, I would receive comments regarding its viability
and suggestions for design.


Dan Aloni (5):
  crypto: fix memory leak in rsa-kcs1pad encryption
  certs: allow in-kernel access of trusted keys
  kernel/printk: allow kmsg to be encrypted using public key encryption
  tools: add dmesg decryption program
  docs: add dmesg encryption doc

 Documentation/admin-guide/dmesg-encryption.rst |  77 +++++
 certs/system_keyring.c                         |  56 +++-
 crypto/rsa-pkcs1pad.c                          |   9 -
 include/keys/system_keyring.h                  |   3 +
 include/uapi/linux/kmsg.h                      |  18 ++
 init/Kconfig                                   |  10 +
 kernel/printk/printk.c                         | 422 +++++++++++++++++++++++++
 tools/Makefile                                 |   5 +-
 tools/kmsg/.gitignore                          |   1 +
 tools/kmsg/Makefile                            |  14 +
 tools/kmsg/dmesg-decipher.c                    | 316 ++++++++++++++++++
 11 files changed, 920 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/admin-guide/dmesg-encryption.rst
 create mode 100644 include/uapi/linux/kmsg.h
 create mode 100644 tools/kmsg/.gitignore
 create mode 100644 tools/kmsg/Makefile
 create mode 100644 tools/kmsg/dmesg-decipher.c

-- 
2.13.6
