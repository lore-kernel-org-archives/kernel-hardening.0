MIME-Version: 1.0
In-Reply-To: <CA+55aFy4ZMSEFO48nZsvBX-Ymy-Zw+LN5duKDna_6A1idg2XUQ@mail.gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com> <CA+55aFy4ZMSEFO48nZsvBX-Ymy-Zw+LN5duKDna_6A1idg2XUQ@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 25 Aug 2017 08:35:49 -0700
Message-ID: <CAJcbSZH6ZSmua4FqbxVox3yZ9O1KDdYJ4+WYreRq6RHiH0DbWg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: x86: PIE support and option to extend KASLR randomization
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 24, 2017 at 2:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Aug 24, 2017 at 2:13 PM, Thomas Garnier <thgarnie@google.com> wrote:
> >
> > My original performance testing was done with an Ubuntu generic
> > configuration. This configuration has the CONFIG_FUNCTION_TRACER
> > option which was incompatible with PIE. The tracer failed to replace
> > the __fentry__ call by a nop slide on each traceable function because
> > the instruction was not the one expected. If PIE is enabled, gcc
> > generates a difference call instruction based on the GOT without
> > checking the visibility options (basically call *__fentry__@GOTPCREL).
>
> Gah.
>
> Don't we actually have *more* address bits for randomization at the
> low end, rather than getting rid of -mcmodel=kernel?

We have but I think we use most of it for potential modules and the
fixmap but it is not that big. The increase in range from 1G to 3G is
just an example and a way to ensure PIE work as expected. The long
term goal is being able to put the kernel where we want in memory,
randomizing the position and the order of almost all memory sections.

That would be valuable against BTB attack [1] for example where
randomization on the low 32-bit is ineffective.

[1] https://github.com/felixwilhelm/mario_baslr

>
> Has anybody looked at just moving kernel text by smaller values than
> the page size? Yeah, yeah, the kernel has several sections that need
> page alignment, but I think we could relocate normal text by just the
> cacheline size, and that sounds like it would give several bits of
> randomness with little downside.

I didn't look into it. There is value in it depending on performance
impact. I think both PIE and lower grain randomization would be
useful.

>
> Or has somebody already looked at it and I just missed it?
>
>                Linus




-- 
Thomas
