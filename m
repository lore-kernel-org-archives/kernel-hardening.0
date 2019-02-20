MIME-Version: 1.0
References: <20190220005449.GA25243@beast> <20190220081451.GA2254@light.dominikbrodowski.net>
In-Reply-To: <20190220081451.GA2254@light.dominikbrodowski.net>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 09:01:27 -0800
Message-ID: <CAGXu5jKPtL4oSa_7QJEXVc++idNNH9GA1Y=z3tQrorRTs0fnsA@mail.gmail.com>
Subject: Re: [PATCH] x86/asm: Pin sensitive CR4 bits
Content-Type: text/plain; charset="UTF-8"
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 20, 2019 at 12:15 AM Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
>
> On Tue, Feb 19, 2019 at 04:54:49PM -0800, Kees Cook wrote:
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index cb28e98a0659..7e0ea4470f8e 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -312,10 +312,16 @@ static __init int setup_disable_smep(char *arg)
> >  }
> >  __setup("nosmep", setup_disable_smep);
> >
> > +volatile unsigned long cr4_pin __ro_after_init;
> > +EXPORT_SYMBOL_GPL(cr4_pin);
>
> Where is this export needed?

I use it in lkdtm (which I was going to land through the drivers tree,
but I haven't sent to Greg):

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/x86/cr4

-- 
Kees Cook
