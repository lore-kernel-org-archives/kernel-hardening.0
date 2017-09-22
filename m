MIME-Version: 1.0
In-Reply-To: <20170922042444.GA235@x4>
References: <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com> <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
 <20170921155919.skpyt7dutod5ul4t@gmail.com> <CAKv+Gu8Uw18pW9nK8aVdBoyuybAV6_mhtagVrje_cBUHMGY4WA@mail.gmail.com>
 <CAJcbSZGAsXwMNWnZUs28-3f--ssUYh75XW+aoQztPFYe0j52yQ@mail.gmail.com> <20170922042444.GA235@x4>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 22 Sep 2017 07:38:30 -0700
Message-ID: <CAJcbSZEqDCwJyNFJkK-XSdKQNTdrvJCZO=vDPCqaORKyAM2QLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: x86: PIE support and option to extend KASLR randomization
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 21, 2017 at 9:24 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2017.09.21 at 14:21 -0700, Thomas Garnier wrote:
>> On Thu, Sep 21, 2017 at 9:10 AM, Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>> >
>> > On 21 September 2017 at 08:59, Ingo Molnar <mingo@kernel.org> wrote:
>> > >
>> > > ( Sorry about the delay in answering this. I could blame the delay on the merge
>> > >   window, but in reality I've been procrastinating this is due to the permanent,
>> > >   non-trivial impact PIE has on generated C code. )
>> > >
>> > > * Thomas Garnier <thgarnie@google.com> wrote:
>> > >
>> > >> 1) PIE sometime needs two instructions to represent a single
>> > >> instruction on mcmodel=kernel.
>> > >
>> > > What again is the typical frequency of this occurring in an x86-64 defconfig
>> > > kernel, with the very latest GCC?
>> > >
>> > > Also, to make sure: which unwinder did you use for your measurements,
>> > > frame-pointers or ORC? Please use ORC only for future numbers, as
>> > > frame-pointers is obsolete from a performance measurement POV.
>> > >
>> > >> 2) GCC does not optimize switches in PIE in order to reduce relocations:
>> > >
>> > > Hopefully this can either be fixed in GCC or at least influenced via a compiler
>> > > switch in the future.
>> > >
>> >
>> > There are somewhat related concerns in the ARM world, so it would be
>> > good if we could work with the GCC developers to get a more high level
>> > and arch neutral command line option (-mkernel-pie? sounds yummy!)
>> > that stops the compiler from making inferences that only hold for
>> > shared libraries and/or other hosted executables (GOT indirections,
>> > avoiding text relocations etc). That way, we will also be able to drop
>> > the 'hidden' visibility override at some point, which we currently
>> > need to prevent the compiler from redirecting all global symbol
>> > references via entries in the GOT.
>>
>> My plan was to add a -mtls-reg=<fs|gs> to switch the default segment
>> register for stack cookies but I can see great benefits in having a
>> more general kernel flag that would allow to get rid of the GOT and
>> PLT when you are building position independent code for the kernel. It
>> could also include optimizations like folding switch tables etc...
>>
>> Should we start a separate discussion on that? Anyone that would be
>> more experienced than I to push that to gcc & clang upstream?
>
> Just open a gcc bug. See
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81708 as an example.

Make sense, I will look into this. Thanks Andy for the stack cookie bug!

>
> --
> Markus



-- 
Thomas
