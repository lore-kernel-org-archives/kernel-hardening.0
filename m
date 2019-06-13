MIME-Version: 1.0
References: <cover.1560198181.git.luto@kernel.org> <25fd7036cefca16c68ecd990e05e05a8ad8fe8b2.1560198181.git.luto@kernel.org>
 <201906101344.018BE4C5C1@keescook>
In-Reply-To: <201906101344.018BE4C5C1@keescook>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 13 Jun 2019 12:14:50 -0700
Message-ID: <CALCETrUYNavL8pu4jQqJjoT=PdeRyjeoLDn=0r7h=2XsHDMezQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86/vsyscall: Change the default vsyscall mode to xonly
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 10, 2019 at 1:44 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jun 10, 2019 at 01:25:31PM -0700, Andy Lutomirski wrote:
> > The use case for full emulation over xonly is very esoteric.  Let's
> > change the default to the safer xonly mode.
>
> Perhaps describe the esoteric cases here (and maybe in the Kconfig help
> text)? That should a user determine if they actually need it. (What
> would the failure under xonly look like for someone needing emulate?)

I added it to the Kconfig text.

Right now, the failure will just be a segfault.  I could add some
logic so that it would log "invalid read to vsyscall page -- fix your
userspace or boot with vsyscall=emulate".  Do you think that's
important?

--Andy
