MIME-Version: 1.0
In-Reply-To: <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
References: <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com> <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
 <20170921155919.skpyt7dutod5ul4t@gmail.com> <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 21 Sep 2017 17:06:15 -0700
Message-ID: <CAJcbSZEuQqK-LNBC0psG-Md9JZiyb2+p0ikh2_C7Jgr2o_GVEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: x86: PIE support and option to extend KASLR randomization
To: Ingo Molnar <mingo@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 21, 2017 at 2:16 PM, Thomas Garnier <thgarnie@google.com> wrote:
>
> On Thu, Sep 21, 2017 at 8:59 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > ( Sorry about the delay in answering this. I could blame the delay on the merge
> >   window, but in reality I've been procrastinating this is due to the permanent,
> >   non-trivial impact PIE has on generated C code. )
> >
> > * Thomas Garnier <thgarnie@google.com> wrote:
> >
> >> 1) PIE sometime needs two instructions to represent a single
> >> instruction on mcmodel=kernel.
> >
> > What again is the typical frequency of this occurring in an x86-64 defconfig
> > kernel, with the very latest GCC?
>
> I am not sure what is the best way to measure that.

A very approximate approach would be to look at each instruction using
the signed trick with a _32S relocation. All _32S relocations won't be
translated to more instructions because some are just relocating part
of an absolute mov which would be actually smaller if relative.

Used this command to get a relative estimate:

objdump -dr ./baseline/vmlinux | egrep -A 2 '\-0x[0-9a-f]{8}' | grep
_32S | wc -l

Got 6130 places, if you assume each add at least 7 bytes. It adds at
least 42910 bytes on the .text section. The text section is 78599
bytes bigger from baseline to PIE. That's at least 54% of the size
difference. Assuming we found all of them and we can't factor the
impact on using an additional register.

Similar approach with the switch table but a bit more complex:

1) Find all constructs as with an lea (%rip) followed by a jmp
instruction inside a function (typical unfolded switch case).
2) Remove occurrences of less than 4 for the destination address

Result: 480 switch cases in 49 functions. Each case take at least 9
bytes and the switch itself takes 16 bytes (assuming one per
function).

That's 5104 bytes for easy to identify switches (less than 7% of the increase).

I am certainly missing a lot of differences. I checked if the percpu
changes impacted the size and it doesn't (only 3 bytes added on PIE).

I also tried different ways to compare the .text section like size of
symbols or number of bytes on full disassembly but the results are
really off from the whole .text size so I am not sure if it is the
right way to go about it.

>
> >
> > Also, to make sure: which unwinder did you use for your measurements,
> > frame-pointers or ORC? Please use ORC only for future numbers, as
> > frame-pointers is obsolete from a performance measurement POV.
>
> I used the default configuration which uses frame-pointer. I built all
> the different binaries with ORC and I see an improvement in size:
>
> On latest revision (just built and ran performance tests this week):
>
> With framepointer: PIE .text is 0.837324% than baseline
>
> With ORC: PIE .text is 0.814224% than baseline
>
> Comparing baselines only, ORC is -2.849832% than frame-pointers.
>
> >
> >> 2) GCC does not optimize switches in PIE in order to reduce relocations:
> >
> > Hopefully this can either be fixed in GCC or at least influenced via a compiler
> > switch in the future.
> >
> >> The switches are the biggest increase on small functions but I don't
> >> think they represent a large portion of the difference (number 1 is).
> >
> > Ok.
> >
> >> A side note, while testing gcc 7.2.0 on hackbench I have seen the PIE
> >> kernel being faster by 1% across multiple runs (comparing 50 runs done
> >> across 5 reboots twice). I don't think PIE is faster than a
> >> mcmodel=kernel but recent versions of gcc makes them fairly similar.
> >
> > So I think we are down to an overhead range where the inherent noise (both random
> > and systematic one) in 'hackbench' overwhelms the signal we are trying to measure.
> >
> > So I think it's the kernel .text size change that is the best noise-free proxy for
> > the overhead impact of PIE.
>
> I agree but it might be hard to measure the exact impact. What is
> acceptable and what is not?
>
> >
> > It doesn't hurt to double check actual real performance as well, just don't expect
> > there to be much of a signal for anything but fully cached microbenchmark
> > workloads.
>
> That's aligned with what I see in the latest performance testing.
> Performance is close enough that it is hard to get exact numbers (pie
> is just a bit slower than baseline on hackench (~1%)).
>
> >
> > Thanks,
> >
> >         Ingo
>
>
>
> --
> Thomas




-- 
Thomas
