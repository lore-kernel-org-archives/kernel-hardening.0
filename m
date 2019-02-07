MIME-Version: 1.0
References: <20190131192533.34130-1-thgarnie@chromium.org> <20190131192533.34130-2-thgarnie@chromium.org>
 <20190207114850.GD2414@zn.tnic>
In-Reply-To: <20190207114850.GD2414@zn.tnic>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Thu, 7 Feb 2019 09:01:57 -0800
Message-ID: <CAJcbSZGzTZmkpCWC3VbLJ7ygkxiRSAfq+GNOkHUungUEjiURTw@mail.gmail.com>
Subject: Re: [PATCH v6 01/27] x86/crypto: Adapt assembly for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 7, 2019 at 3:49 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Jan 31, 2019 at 11:24:08AM -0800, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for the
> > kernel to be PIE compatible.
> >
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
>
> This sentence is auto-sprinkled in a bunch of commit messages. Sounds to
> me it should be rather somewhere in the 0/n message as a justification
> for the feature but not in every other commit message...?

I go into more details in the compose message but I wanted a small
sentence explaining why PIE changes are being made.

>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
