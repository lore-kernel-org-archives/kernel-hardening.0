MIME-Version: 1.0
References: <20180625224014.134829-1-thgarnie@google.com> <20180625224014.134829-24-thgarnie@google.com>
 <c2c67217-e120-468b-b59a-05813a64c448@infradead.org>
In-Reply-To: <c2c67217-e120-468b-b59a-05813a64c448@infradead.org>
From: Thomas Garnier <thgarnie@google.com>
Date: Mon, 25 Jun 2018 16:53:11 -0700
Message-ID: <CAJcbSZGGtmMtYYM6DqM8byZDeucUE4G_uvK97BHd-JwLWZe_jw@mail.gmail.com>
Subject: Re: [PATCH v5 23/27] x86/modules: Adapt module loading for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Greg KH <gregkh@linuxfoundation.org>, Francis Deslauriers <francis.deslauriers@efficios.com>, "H . J . Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 25, 2018 at 4:51 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 06/25/18 15:39, Thomas Garnier wrote:
> > Adapt module loading to support PIE relocations. Generate dynamic GOT if
> > a symbol requires it but no entry exists in the kernel GOT.
>
> Hi,
>
> This patch description (and a few others with the same sentence) is a little
> confusing to me:
>
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range 0xffffffff80000000.
>
> Is there a word missing after "range"?  May "below"?
> As is, it seems to imply "range by 0xffffffff80000000."

Yes, below. I will fix this on all patch descriptions on next iteration. Thanks!

>
>
> thanks.
>
> >
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
> > ---
> >  arch/x86/Makefile               |   4 +
> >  arch/x86/include/asm/module.h   |  11 ++
> >  arch/x86/include/asm/sections.h |   4 +
> >  arch/x86/kernel/module.c        | 181 +++++++++++++++++++++++++++++++-
> >  arch/x86/kernel/module.lds      |   3 +
> >  5 files changed, 198 insertions(+), 5 deletions(-)
> >  create mode 100644 arch/x86/kernel/module.lds
>
>
> --
> ~Randy



-- 
Thomas
