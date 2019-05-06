From: Joao Moreira <jmoreira@suse.de>
Subject: [RFC PATCH v2 0/4] x86/crypto: Fix crypto function casts
Date: Mon,  6 May 2019 16:19:46 -0300
Message-Id: <20190506191950.9521-1-jmoreira@suse.de>
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

It is possible to indirectly invoke functions with prototypes that do not
match those of the respectively used function pointers by using void types.
This feature is frequently used as a way of relaxing function invocation,
making it possible that different data structures are passed to different
functions through the same pointer.

Despite the benefits, this can lead to a situation where functions with a
given prototype are invoked by pointers with a different prototype, what is
undesirable as it may prevent the use of heuristics such as prototype
matching-based Control-Flow Integrity, which can be used to prevent
ROP-based attacks.

One way of fixing this situation is through the use of helper functions
with prototypes that match the one in the respective invoking pointer.

Given the above, the current efforts to improve the Linux security, and the
upcoming kernel support to compilers with CFI features, fix the prototype
casting of x86/crypto algorithms camellia, cast6, serpent and twofish with
the use of a macro that generates the helper function.

This patch does not introduce semantic changes to the cryptographic
algorithms, yet, if someone finds relevant, the affected algorithms were
tested with the help of tcrypt.ko without any visible harm.


Joao Moreira (4):
  Fix serpent crypto function prototypes
  Fix camellia crypto function prototypes
  Fix twofish crypto function prototypes
  Fix cast6 crypto function prototypes

 arch/x86/crypto/camellia_aesni_avx2_glue.c | 69 ++++++++--------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 45 +++++++--------
 arch/x86/crypto/camellia_glue.c            | 19 +++---
 arch/x86/crypto/cast6_avx_glue.c           | 54 +++++++----------
 arch/x86/crypto/serpent_avx2_glue.c        | 68 ++++++++++------------
 arch/x86/crypto/serpent_avx_glue.c         | 63 ++++++++------------
 arch/x86/crypto/serpent_sse2_glue.c        | 24 +++++---
 arch/x86/crypto/twofish_avx_glue.c         | 65 ++++++++++-----------
 arch/x86/crypto/twofish_glue_3way.c        | 33 ++++++-----
 arch/x86/include/asm/crypto/camellia.h     | 93 +++++++++++++++---------------
 arch/x86/include/asm/crypto/serpent-avx.h  | 39 ++++++++-----
 arch/x86/include/asm/crypto/serpent-sse2.h | 10 ++++
 arch/x86/include/asm/crypto/twofish.h      | 33 ++++++++---
 include/crypto/cast6.h                     | 23 +++++++-
 14 files changed, 320 insertions(+), 318 deletions(-)

-- 
2.16.4
