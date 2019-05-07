From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Date: Tue,  7 May 2019 09:13:14 -0700
Message-Id: <20190507161321.34611-1-keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>, Joao Moreira <jmoreira@suse.de>, Eric Biggers <ebiggers@google.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

It is possible to indirectly invoke functions with prototypes that do
not match those of the respectively used function pointers by using void
types or casts. This feature is frequently used as a way of relaxing
function invocation, making it possible that different data structures
are passed to different functions through the same pointer.

Despite the benefits, this can lead to a situation where functions with a
given prototype are invoked by pointers with a different prototype. This
is undesirable as it may prevent the use of heuristics such as prototype
matching-based Control-Flow Integrity, which can be used to prevent
ROP-based attacks.

One way of fixing this situation is through the use of inline helper
functions with prototypes that match the one in the respective invoking
pointer.

Given the above, the current efforts to improve the Linux security,
and the upcoming kernel support to compilers with CFI features, this
creates macros to be used to build the needed function definitions,
to be used in camellia, cast6, serpent, twofish, and aesni.

-Kees (and Joao)

v3:
- no longer RFC
- consolidate macros into glue_helper.h
- include aesni which was using casts as well
- remove XTS_TWEAK_CAST while we're at it

v2:
- update cast macros for clarity

v1:
- initial prototype

Joao Moreira (4):
  crypto: x86/crypto: Use new glue function macros
  crypto: x86/camellia: Use new glue function macros
  crypto: x86/twofish: Use new glue function macros
  crypto: x86/cast6: Use new glue function macros

Kees Cook (3):
  crypto: x86/glue_helper: Add static inline function glue macros
  crypto: x86/aesni: Use new glue function macros
  crypto: x86/glue_helper: Remove function prototype cast helpers

 arch/x86/crypto/aesni-intel_glue.c         | 31 ++++-----
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 73 +++++++++-------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 63 +++++++------------
 arch/x86/crypto/camellia_glue.c            | 21 +++----
 arch/x86/crypto/cast6_avx_glue.c           | 65 +++++++++----------
 arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++----------
 arch/x86/crypto/serpent_avx_glue.c         | 58 ++++++-----------
 arch/x86/crypto/serpent_sse2_glue.c        | 27 +++++---
 arch/x86/crypto/twofish_avx_glue.c         | 71 ++++++++-------------
 arch/x86/crypto/twofish_glue_3way.c        | 28 ++++-----
 arch/x86/include/asm/crypto/camellia.h     | 64 ++++++-------------
 arch/x86/include/asm/crypto/glue_helper.h  | 34 ++++++++--
 arch/x86/include/asm/crypto/serpent-avx.h  | 28 ++++-----
 arch/x86/include/asm/crypto/twofish.h      | 22 ++++---
 include/crypto/xts.h                       |  2 -
 15 files changed, 283 insertions(+), 369 deletions(-)

-- 
2.17.1
