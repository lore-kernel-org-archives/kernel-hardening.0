MIME-Version: 1.0
References: <20180807012257.20157-1-jannh@google.com> <C6369CAA-CBB8-420F-97DB-7A242D9650A8@amacapital.net>
In-Reply-To: <C6369CAA-CBB8-420F-97DB-7A242D9650A8@amacapital.net>
From: Jann Horn <jannh@google.com>
Date: Tue, 7 Aug 2018 23:17:37 +0200
Message-ID: <CAG48ez3nEszuPN9SZ9vV2=ubzv348bMpJjT9b5Q_wx6uxV2zXg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] x86: WARN() when uaccess helpers fault on kernel addresses
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 7, 2018 at 4:55 AM Andy Lutomirski <luto@amacapital.net> wrote:
> > On Aug 6, 2018, at 6:22 PM, Jann Horn <jannh@google.com> wrote:
> >
> > There have been multiple kernel vulnerabilities that permitted userspac=
e to
> > pass completely unchecked pointers through to userspace accessors:
> >
> > - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
> >  access_ok() checks")
> > - the sg/bsg read/write APIs
> > - the infiniband read/write APIs
> >
> > These don't happen all that often, but when they do happen, it is hard =
to
> > test for them properly; and it is probably also hard to discover them w=
ith
> > fuzzing. Even when an unmapped kernel address is supplied to such buggy
> > code, it just returns -EFAULT instead of doing a proper BUG() or at lea=
st
> > WARN().
> >
> > This patch attempts to make such misbehaving code a bit more visible by
> > WARN()ing in the pagefault handler code when a userspace accessor cause=
s
> > #PF on a kernel address and the current context isn't whitelisted.
>
> I like this a lot, and, in fact, I once wrote a patch to do something sim=
ilar. It was before the fancy extable code, though, so it was a mess.  Here=
 are some thoughts:
>
> - It should be three patches. One patch to add the _UA annotations, one t=
o improve the info passes to the handlers, and one to change behavior.
>
> - You should pass the vector, the error code, and the address to the hand=
ler.
>
> - The uaccess handler should IMO WARN if the vector is anything other tha=
n #PF (which mainly means warning if it=E2=80=99s #GP). I think it should p=
r_emerg() and return false if the vector is #PF and the address is too high=
.

What about #MC? do_machine_check() sometimes invokes fixup handlers.
It looks like fixup_exception() is basically reached for anything that
can't be restarted (either MCG_STATUS_RIPV isn't set or the worst
severity is MCE_AR_SEVERITY), but doesn't reach MCE_PANIC_SEVERITY? In
particular for "Action required: data load in error recoverable area
of kernel", if I'm reading the code correctly. It seems like the code
is intentionally preventing memory errors during user access from
being treated as kernel memory errors? So perhaps #MC in user access
should not WARN()?

> - Arguably most non-uaccess fixups should at least warn for anything othe=
r than #GP and #UD.
