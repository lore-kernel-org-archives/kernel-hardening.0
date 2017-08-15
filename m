Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 15 Aug 2017 09:56:09 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170815075609.mmzbfwritjzvrpsn@gmail.com>
References: <20170810172615.51965-1-thgarnie@google.com>
 <20170811124127.kkb5pnkljz4umxuj@gmail.com>
 <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
Subject: [kernel-hardening] Re: x86: PIE support and option to extend KASLR randomization
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

> > Do these changes get us closer to being able to build the kernel as truly 
> > position independent, i.e. to place it anywhere in the valid x86-64 address 
> > space? Or any other advantages?
> 
> Yes, PIE allows us to put the kernel anywhere in memory. It will allow us to 
> have a full randomized address space where position and order of sections are 
> completely random. There is still some work to get there but being able to build 
> a PIE kernel is a significant step.

So I _really_ dislike the whole PIE approach, because of the huge slowdown:

+config RANDOMIZE_BASE_LARGE
+       bool "Increase the randomization range of the kernel image"
+       depends on X86_64 && RANDOMIZE_BASE
+       select X86_PIE
+       select X86_MODULE_PLTS if MODULES
+       default n
+       ---help---
+         Build the kernel as a Position Independent Executable (PIE) and
+         increase the available randomization range from 1GB to 3GB.
+
+         This option impacts performance on kernel CPU intensive workloads up
+         to 10% due to PIE generated code. Impact on user-mode processes and
+         typical usage would be significantly less (0.50% when you build the
+         kernel).
+
+         The kernel and modules will generate slightly more assembly (1 to 2%
+         increase on the .text sections). The vmlinux binary will be
+         significantly smaller due to less relocations.

To put 10% kernel overhead into perspective: enabling this option wipes out about 
5-10 years worth of painstaking optimizations we've done to keep the kernel fast 
... (!!)

I think the fundamental flaw is the assumption that we need a PIE executable to 
have a freely relocatable kernel on 64-bit CPUs.

Have you considered a kernel with -mcmodel=small (or medium) instead of -fpie 
-mcmodel=large? We can pick a random 2GB window in the (non-kernel) canonical 
x86-64 address space to randomize the location of kernel text. The location of 
modules can be further randomized within that 2GB window.

It should have far less performance impact than the register-losing and 
overhead-inducing -fpie / -mcmodel=large (for modules) execution models.

My quick guess is tha the performance impact might be close to zero in fact.

Thanks,

	Ingo
