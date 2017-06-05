From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon,  5 Jun 2017 05:47:49 +0200
Message-Id: <20170605034757.4803-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH RFC v2 0/8] get_random_bytes_wait family of APIs
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

As discussed in [1], there is a problem with get_random_bytes being
used before the RNG has actually been seeded. The solution for fixing
this appears to be multi-pronged. One of those prongs involves adding
a simple blocking API so that modules that use the RNG in process
context can just sleep (in an interruptable manner) until the RNG is
ready to be used. This winds up being a very useful API that covers
a few use cases, 5 of which are included in this patch set.

[1] http://www.openwall.com/lists/kernel-hardening/2017/06/02/2

Changes v1->v2:
  - Rather than support both interruptable and non-interruptable
    waiting and also timeouts, we just support the case that people
    will actually use: ordinary interruptable waiting. This simplifies
    the API a bit.
  - This patch set now has a few examples of where it might be useful.

Jason A. Donenfeld (8):
  random: add synchronous API for the urandom pool
  random: add get_random_{bytes,u32,u64,int,long,once}_wait family
  random: warn when kernel uses unseeded randomness
  crypto/rng: ensure that the RNG is ready before using
  security/keys: ensure RNG is seeded before use
  iscsi: ensure RNG is seeded before use
  bluetooth/smp: ensure RNG is properly seeded before ECDH use
  ceph: ensure RNG is seeded before using

 crypto/rng.c                              |  6 +++--
 drivers/char/random.c                     | 44 ++++++++++++++++++++++---------
 drivers/target/iscsi/iscsi_target_auth.c  | 14 +++++++---
 drivers/target/iscsi/iscsi_target_login.c | 22 ++++++++++------
 include/linux/net.h                       |  2 ++
 include/linux/once.h                      |  2 ++
 include/linux/random.h                    | 26 ++++++++++++++++++
 lib/Kconfig.debug                         | 15 +++++++++++
 net/bluetooth/hci_request.c               |  6 +++++
 net/bluetooth/smp.c                       | 18 ++++++++++---
 net/ceph/ceph_common.c                    |  6 ++++-
 security/keys/encrypted-keys/encrypted.c  |  8 +++---
 security/keys/key.c                       | 13 ++++++---
 13 files changed, 145 insertions(+), 37 deletions(-)

-- 
2.13.0
