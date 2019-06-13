MIME-Version: 1.0
References: <cover.1560198181.git.luto@kernel.org> <d28856fff74a385f88c493dafb9d96d2c38d91a2.1560198181.git.luto@kernel.org>
 <201906101340.AE18F49@keescook>
In-Reply-To: <201906101340.AE18F49@keescook>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 13 Jun 2019 12:07:40 -0700
Message-ID: <CALCETrVOzGCN+pjgsdd+x3APsrSGJzngfGeSWvqWy=XTQj3EiA@mail.gmail.com>
Subject: Re: [PATCH 3/5] x86/vsyscall: Document odd #PF's error code for vsyscalls
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 10, 2019 at 1:40 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jun 10, 2019 at 01:25:29PM -0700, Andy Lutomirski wrote:
> >  tools/testing/selftests/x86/test_vsyscall.c | 9 ++++++++-
>
> Did this hunk end up in the wrong patch? (It's not mentioned in the
> commit log and the next patch has other selftest changes...)
>

It was intentional -- you can run the improved selftest and observe
the oddity for yourself :)  I'll improve the changelog.
