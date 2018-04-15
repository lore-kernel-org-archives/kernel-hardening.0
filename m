From: Joao Moreira <jmoreira@suse.de>
Subject: [PATCH 0/4] x86/crypto: Fix function prototypes
Date: Sun, 15 Apr 2018 01:15:38 -0300
Message-Id: <20180415041542.5364-1-jmoreira@suse.de>
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

One way of fixing this situation is through converting the function
prototypes to the one used in the pointer declaration, what means converting
function arguments from a given '<type> *' to a 'void *', and later casting
its uses accordingly throughout the function scope.

Given the above, the current efforts to improve the Linux security, and the
upcoming kernel support to compilers with CFI features, fix prototypes in
x86/crypto algorithms: camellia, cast6, serpent, and twofish.

This patch does not introduce semantic changes to the cryptographic
algorithms, yet, if someone finds relevant, the affected algorithms were
tested with the help of tcrypt.ko without any visible harm.

Joao Moreira (4):
  x86/crypto: camellia: Fix function prototypes
  x86/crypto: cast6: Fix function prototypes
  x86/crypto: serpent: Fix function prototypes
  x86/crypto: twofish: Fix function prototypes

 arch/x86/crypto/camellia_aesni_avx2_glue.c | 25 ++++++++---------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 21 +++++++--------
 arch/x86/crypto/camellia_glue.c            |  6 ++---
 arch/x86/crypto/cast6_avx_glue.c           | 22 ++++++---------
 arch/x86/crypto/serpent_avx2_glue.c        | 14 +++++-----
 arch/x86/crypto/serpent_avx_glue.c         | 19 ++++++-------
 arch/x86/crypto/twofish_avx_glue.c         | 30 +++++++++------------
 arch/x86/crypto/twofish_glue.c             |  7 +++--
 arch/x86/crypto/twofish_glue_3way.c        | 10 +++----
 arch/x86/include/asm/crypto/camellia.h     | 43 +++++++++++++-----------------
 arch/x86/include/asm/crypto/serpent-avx.h  | 25 ++++++++---------
 arch/x86/include/asm/crypto/serpent-sse2.h | 30 +++++++++------------
 arch/x86/include/asm/crypto/twofish.h      |  9 +++----
 13 files changed, 108 insertions(+), 153 deletions(-)

-- 
2.12.0
