MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-3-thgarnie@chromium.org>
 <20190207121729.GE2414@zn.tnic> <CAJcbSZFe+Cn9+gEa4iv56sZE+WXXiHjeR8Mcte9s_HYr8QBrsw@mail.gmail.com>
 <20190207171145.GH2414@zn.tnic>
In-Reply-To: <20190207171145.GH2414@zn.tnic>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Thu, 7 Feb 2019 15:55:35 -0800
Message-ID: <CAJcbSZFTiHcRM8gy8LbVMQYM2b7H=Gngbsf6bMGKmkDo7mKbjg@mail.gmail.com>
Subject: Re: [PATCH v6 02/27] x86: Use symbol name in jump table for PIE support
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nadav Amit <namit@vmware.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 7, 2019 at 9:11 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Feb 07, 2019 at 09:04:45AM -0800, Thomas Garnier wrote:
> > I assume that's an optimisation done by gcc later.
>
> So why is that change even needed? Where does it break?
>
> > The P modifier in the documentation does state that it is used to
> > generate PIC code.
>
> The documentation says:
>
> "If used for a function, print the PLT suffix and generate PIC code. For
> example, emit foo@PLT instead of =E2=80=99foo=E2=80=99 for the function f=
oo()."
>
> when you use %P for a function. Which is not how it is used here.

I did more checks about that. I think Ard's patch to make jump label
relative actually fixed the issue I had with them.

Thanks for spotting this, I will do additional checks and look at
removing this change.

>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
