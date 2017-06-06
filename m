From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue,  6 Jun 2017 02:50:55 +0200
Message-Id: <20170606005108.5646-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v3 00/13] Unseeded In-Kernel Randomness Fixes
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>
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

Changes v2->v3:
  - Since this issue, in general, is going to take a long time to fully
    fix, the patch turning on the warning is now dependent on DEBUG_KERNEL
    so that the right people see the messages but the others aren't annoyed.
  - Fixed some inappropriate blocking for functions that load during module
    insertion. As discussed in [1], module insertion deferal is a topic for
    another patch set.
  - An interesting and essential patch has been added for invalidating the
    batched entropy pool after the crng initializes.
  - Some places that need randomness at bootup for just small integers would
    be better served by get_random_{u32,u64}, so this series makes those
    changes in a few places. It's useful here, since on some architectures
    that delivers better early randomness.

Jason A. Donenfeld (13):
  random: add synchronous API for the urandom pool
  random: add get_random_{bytes,u32,u64,int,long,once}_wait family
  random: invalidate batched entropy after crng init
  crypto/rng: ensure that the RNG is ready before using
  security/keys: ensure RNG is seeded before use
  iscsi: ensure RNG is seeded before use
  ceph: ensure RNG is seeded before using
  cifs: use get_random_u32 for 32-bit lock random
  rhashtable: use get_random_u32 for hash_rnd
  net/neighbor: use get_random_u32 for 32-bit hash random
  net/route: use get_random_int for random counter
  bluetooth/smp: ensure RNG is properly seeded before ECDH use
  random: warn when kernel uses unseeded randomness

 crypto/rng.c                              |  6 ++-
 drivers/char/random.c                     | 90 ++++++++++++++++++++++++++-----
 drivers/target/iscsi/iscsi_target_auth.c  | 14 +++--
 drivers/target/iscsi/iscsi_target_login.c | 22 +++++---
 fs/cifs/cifsfs.c                          |  2 +-
 include/linux/net.h                       |  2 +
 include/linux/once.h                      |  2 +
 include/linux/random.h                    | 26 +++++++++
 lib/Kconfig.debug                         | 16 ++++++
 lib/rhashtable.c                          |  2 +-
 net/bluetooth/hci_request.c               |  6 +++
 net/bluetooth/smp.c                       | 18 +++++--
 net/ceph/ceph_common.c                    |  6 ++-
 net/core/neighbour.c                      |  3 +-
 net/ipv4/route.c                          |  3 +-
 security/keys/encrypted-keys/encrypted.c  |  8 +--
 security/keys/key.c                       | 16 +++---
 17 files changed, 195 insertions(+), 47 deletions(-)

-- 
2.13.0
