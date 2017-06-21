Message-ID: <1498070869.13083.22.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Wed, 21 Jun 2017 14:47:49 -0400
In-Reply-To: <1498066333.27465.8.camel@gmail.com>
References: <20170621055835.GA27467@beast>
	 <1498046876.13083.17.camel@redhat.com>
	 <CAGXu5j+LJ7241o9xoXrorc-Wt9Z7YWOvkPjkxSMuGn6TtCFkgQ@mail.gmail.com>
	 <1498066040.27465.7.camel@gmail.com>
	 <CAGXu5jJGD5md4YZXadcFnw2WogoXfKtBSQmMa=Mm+CNe309F6w@mail.gmail.com>
	 <1498066333.27465.8.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH] [RFC] binfmt_elf: Use
 ELF_ET_DYN_BASE only for PIE
To: Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Qualys Security Advisory <qsa@qualys.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Dmitry Safonov <dsafonov@virtuozzo.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-06-21 at 13:32 -0400, Daniel Micay wrote:
> On Wed, 2017-06-21 at 10:28 -0700, Kees Cook wrote:
> > > The stack rlimit calculation fix for space potentially lost to
> > > ASLR
> > > is
> > > probably still needed too, right?
> > 
> > Yes. Was that picked up by akpm already?
> > 
> > -Kees
> 
> I think it was dropped when the ET_DYN changes were dropped.

I can resend those.
