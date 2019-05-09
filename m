Date: Wed, 8 May 2019 18:53:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509015340.GA693@sol.localdomain>
References: <20190507161321.34611-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 07, 2019 at 09:13:14AM -0700, Kees Cook wrote:
> It is possible to indirectly invoke functions with prototypes that do
> not match those of the respectively used function pointers by using void
> types or casts. This feature is frequently used as a way of relaxing
> function invocation, making it possible that different data structures
> are passed to different functions through the same pointer.
> 
> Despite the benefits, this can lead to a situation where functions with a
> given prototype are invoked by pointers with a different prototype. This
> is undesirable as it may prevent the use of heuristics such as prototype
> matching-based Control-Flow Integrity, which can be used to prevent
> ROP-based attacks.
> 
> One way of fixing this situation is through the use of inline helper
> functions with prototypes that match the one in the respective invoking
> pointer.
> 
> Given the above, the current efforts to improve the Linux security,
> and the upcoming kernel support to compilers with CFI features, this
> creates macros to be used to build the needed function definitions,
> to be used in camellia, cast6, serpent, twofish, and aesni.
> 
> -Kees (and Joao)

Did you try enabling -Wcast-function-type?  It seems you missed some cases:

arch/x86/crypto/sha256_ssse3_glue.c: In function ‘sha256_update’:
arch/x86/crypto/sha256_ssse3_glue.c:62:10: warning: cast between incompatible function types from ‘void (*)(u32 *, const char *, u64)’ {aka ‘void (*)(unsigned int *, const char *, long long unsigned int)’} to ‘void (*)(struct sha256_state *, const u8 *, int)’ {aka ‘void (*)(struct sha256_state *, const unsigned char *, int)’} [-Wcast-function-type]
          (sha256_block_fn *)sha256_xform);
          ^
arch/x86/crypto/sha256_ssse3_glue.c: In function ‘sha256_finup’:
arch/x86/crypto/sha256_ssse3_glue.c:77:11: warning: cast between incompatible function types from ‘void (*)(u32 *, const char *, u64)’ {aka ‘void (*)(unsigned int *, const char *, long long unsigned int)’} to ‘void (*)(struct sha256_state *, const u8 *, int)’ {aka ‘void (*)(struct sha256_state *, const unsigned char *, int)’} [-Wcast-function-type]
           (sha256_block_fn *)sha256_xform);
           ^
arch/x86/crypto/sha256_ssse3_glue.c:78:32: warning: cast between incompatible function types from ‘void (*)(u32 *, const char *, u64)’ {aka ‘void (*)(unsigned int *, const char *, long long unsigned int)’} to ‘void (*)(struct sha256_state *, const u8 *, int)’ {aka ‘void (*)(struct sha256_state *, const unsigned char *, int)’} [-Wcast-function-type]
  sha256_base_do_finalize(desc, (sha256_block_fn *)sha256_xform);
                                ^
  CC      arch/x86/crypto/sha512_ssse3_glue.o
arch/x86/crypto/sha512_ssse3_glue.c: In function ‘sha512_update’:
arch/x86/crypto/sha512_ssse3_glue.c:61:10: warning: cast between incompatible function types from ‘void (*)(u64 *, const char *, u64)’ {aka ‘void (*)(long long unsigned int *, const char *, long long unsigned int)’} to ‘void (*)(struct sha512_state *, const u8 *, int)’ {aka ‘void (*)(struct sha512_state *, const unsigned char *, int)’} [-Wcast-function-type]
          (sha512_block_fn *)sha512_xform);
          ^
arch/x86/crypto/sha512_ssse3_glue.c: In function ‘sha512_finup’:
arch/x86/crypto/sha512_ssse3_glue.c:76:11: warning: cast between incompatible function types from ‘void (*)(u64 *, const char *, u64)’ {aka ‘void (*)(long long unsigned int *, const char *, long long unsigned int)’} to ‘void (*)(struct sha512_state *, const u8 *, int)’ {aka ‘void (*)(struct sha512_state *, const unsigned char *, int)’} [-Wcast-function-type]
           (sha512_block_fn *)sha512_xform);
           ^
arch/x86/crypto/sha512_ssse3_glue.c:77:32: warning: cast between incompatible function types from ‘void (*)(u64 *, const char *, u64)’ {aka ‘void (*)(long long unsigned int *, const char *, long long unsigned int)’} to ‘void (*)(struct sha512_state *, const u8 *, int)’ {aka ‘void (*)(struct sha512_state *, const unsigned char *, int)’} [-Wcast-function-type]
  sha512_base_do_finalize(desc, (sha512_block_fn *)sha512_xform);
                                ^
