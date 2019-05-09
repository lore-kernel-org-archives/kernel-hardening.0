Date: Thu, 9 May 2019 08:38:28 -0700
From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509153828.GA261205@google.com>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509020439.GB693@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Herbert Xu <herbert@gondor.apana.org.au>, Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 08, 2019 at 07:04:40PM -0700, Eric Biggers wrote:
> And I also asked whether indirect calls to asm code are even allowed
> with CFI. IIRC, the AOSP kernels have been patched to remove them from
> arm64

At least with clang, indirect calls to stand-alone assembly functions
trip CFI checks, which is why Android kernels use static inline stubs
to convert these to direct calls instead.

Sami
