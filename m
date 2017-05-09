Date: Mon, 8 May 2017 20:58:29 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170509015829.iycvxxbyblfgklsg@treble>
References: <1494271972-140319-1-git-send-email-keescook@chromium.org>
 <1494271972-140319-3-git-send-email-keescook@chromium.org>
 <20170508225308.a6uznrhdm7pgyhcg@treble>
 <CAGXu5j+J=o7hHceQn6pFtCmQcfUtSrtZ9uP8fLo0gkDWNdetAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5j+J=o7hHceQn6pFtCmQcfUtSrtZ9uP8fLo0gkDWNdetAA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 2/2] x86/refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 08, 2017 at 04:31:11PM -0700, Kees Cook wrote:
> On Mon, May 8, 2017 at 3:53 PM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > On Mon, May 08, 2017 at 12:32:52PM -0700, Kees Cook wrote:
> >> +#define REFCOUNT_EXCEPTION                           \
> >> +     "movl $0x7fffffff, %[counter]\n\t"              \
> >> +     "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
> >> +     "0:\n\t"                                        \
> >> +     _ASM_EXTABLE(0b, 0b)
> >
> > Despite the objtool warnings going away, this still uses the exception
> > table in a new way, which will confuse objtool.  I need to do some more
> > thinking about the best way to fix it, either as a change to your patch
> > or a change to objtool.
> 
> In that it's not a "true" exception?

Right.  And also that it doesn't need the "fixup" since it would return
to the same address anyway.

-- 
Josh
