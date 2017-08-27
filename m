MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1708251036150.5830@nuc-kabylake>
References: <20170810172615.51965-1-thgarnie@google.com> <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com> <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com> <CAJcbSZFM_zpL1av1JVaow8NdsGeH+6oZKeDnMPdXR0PGfynzsg@mail.gmail.com>
 <20170817080920.5ljlkktngw2cisfg@gmail.com> <CAFUG7CdUEFYANSGRuNX0Xt1TJ0Z7f+M_ERgR03dUVxVqLENLpw@mail.gmail.com>
 <alpine.DEB.2.20.1708251036150.5830@nuc-kabylake>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Sun, 27 Aug 2017 18:39:51 -0400
Message-ID: <CAFUG7CekAa-CBEo=t0KRMRe0T8ZkRyg4c_stO8Bt4njwQeAH4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: x86: PIE support and option to extend
 KASLR randomization
To: Christopher Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 25, 2017 at 11:38 AM, Christopher Lameter <cl@linux.com> wrote:
>
>
> On Thu, 17 Aug 2017, Boris Lukashev wrote:
>
>> Is the expectation then to have security functions also decrease size
>> and operational latency? Seems a bit unrealistic if so.
>> 1-2% performance hit on systems which have become at least several
>> hundred % faster over recent years is not a significant performance
>> regression compared to the baseline before.
>
> Where do you get these fantastic numbers? Where can I buy a system like
> that? Commonly we see regressions with single threaded integer
> performance on most newer processor generations.
>
> These hundreds of percent improvement can only come from floating point
> performance using specialized instructions. There are only a very limited
> number of applications that can make use of it.
>

An example of these fantastic numbers can be seen in
https://www.cpubenchmark.net/cpu.php?cpu=Intel+Pentium+4+3.00GHz which
shows a 9 year old P4 compared to today's desktop chips. Point taken
on the specific types of maths being performed though. I personally
can't make an educated guess at how much of the "modern" functionality
compilers could leverage to optimize these code paths.
I am by no means a chip or compiler architect, but have built a fair
number of systems and service oriented architectures; and in the
business-end of planning and design, a deficit of security function
doesn't just slow down execution by several percent - it can halt the
project or scuttle it altogether as stakeholders do not wish to put
their posteriors on the line.
The intent of my original email was to point out that the balance
between performance and security isn't as clear-cut as "all bugs are
created equal and hackbench outputs tell the whole story," since
aspects of performance and security are often evaluated by separate
parties in different segments of the decision making process.
Providing as many avenues as possible to enhance security posture with
clearly labeled performance penalties may be the difference between
adoption/execution and another cycle of "wait and see." While
decisions around future development agility based on changes in these
optional configurations are definitely a major point to consider, the
decision between a performance penalty and an exposed attack surface
is likely a useful option to leave for the people building the final
systems.

-Boris
