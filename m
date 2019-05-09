Date: Thu, 9 May 2019 12:27:53 -0700
From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509192753.GA233211@google.com>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
 <20190509153828.GA261205@google.com>
 <20190509175822.GB12602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509175822.GB12602@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Herbert Xu <herbert@gondor.apana.org.au>, Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 09, 2019 at 10:58:23AM -0700, Eric Biggers wrote:
> Is there any way to annotate assembly functions such that they work
> directly with CFI?

Not to my knowledge.

Sami
