Date: Thu, 24 May 2018 16:16:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 21/27] x86/ftrace: Adapt function tracing for PIE
 support
Message-ID: <20180524161622.4202319f@gandalf.local.home>
In-Reply-To: <20180524114024.pa67zjipy5qcg4tm@pathway.suse.cz>
References: <20180523195421.180248-1-thgarnie@google.com>
	<20180523195421.180248-22-thgarnie@google.com>
	<20180524114024.pa67zjipy5qcg4tm@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Petr Mladek <pmladek@suse.com>
Cc: Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H .
 Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Jan Kiszka <jan.kiszka@siemens.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Cao jin <caoj.fnst@cn.fujitsu.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw@amazon.co.uk>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Jan Beulich <JBeulich@suse.com>, Matthias Kaehlcke <mka@chromium.org>, Baoquan He <bhe@redhat.com>, "Jan H . =?UTF-8?B?U2No?=
 =?UTF-8?B?w7ZuaGVycg==?=" <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 24 May 2018 13:40:24 +0200
Petr Mladek <pmladek@suse.com> wrote:

> On Wed 2018-05-23 12:54:15, Thomas Garnier wrote:
> > When using -fPIE/PIC with function tracing, the compiler generates a
> > call through the GOT (call *__fentry__@GOTPCREL). This instruction
> > takes 6 bytes instead of 5 on the usual relative call.
> > 
> > If PIE is enabled, replace the 6th byte of the GOT call by a 1-byte nop
> > so ftrace can handle the previous 5-bytes as before.
> > 
> > Position Independent Executable (PIE) support will allow to extended the
> > KASLR randomization range below the -2G memory limit.
> > 
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
> > ---
> >  arch/x86/include/asm/ftrace.h   |  6 +++--
> >  arch/x86/include/asm/sections.h |  4 ++++
> >  arch/x86/kernel/ftrace.c        | 42 +++++++++++++++++++++++++++++++--
> >  3 files changed, 48 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index c18ed65287d5..8f2decce38d8 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -25,9 +25,11 @@ extern void __fentry__(void);
> >  static inline unsigned long ftrace_call_adjust(unsigned long addr)
> >  {
> >  	/*
> > -	 * addr is the address of the mcount call instruction.
> > -	 * recordmcount does the necessary offset calculation.
> > +	 * addr is the address of the mcount call instruction. PIE has always a
> > +	 * byte added to the start of the function.
> >  	 */
> > +	if (IS_ENABLED(CONFIG_X86_PIE))
> > +		addr -= 1;  
> 
> This seems to modify the address even for modules that are _not_ compiled with
> PIE, see below.

Can one load a module not compiled for PIE in a kernel with PIE?

> 
> >  	return addr;
> >  }
> >  
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index 01ebcb6f263e..73b3c30cb7a3 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -135,6 +135,44 @@ ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
> >  	return 0;
> >  }
> >  
> > +/* Bytes before call GOT offset */
> > +const unsigned char got_call_preinsn[] = { 0xff, 0x15 };
> > +
> > +static int
> > +ftrace_modify_initial_code(unsigned long ip, unsigned const char *old_code,
> > +			   unsigned const char *new_code)
> > +{
> > +	unsigned char replaced[MCOUNT_INSN_SIZE + 1];
> > +
> > +	ftrace_expected = old_code;
> > +
> > +	/*
> > +	 * If PIE is not enabled or no GOT call was found, default to the
> > +	 * original approach to code modification.
> > +	 */
> > +	if (!IS_ENABLED(CONFIG_X86_PIE) ||
> > +	    probe_kernel_read(replaced, (void *)ip, sizeof(replaced)) ||
> > +	    memcmp(replaced, got_call_preinsn, sizeof(got_call_preinsn)))
> > +		return ftrace_modify_code_direct(ip, old_code, new_code);  
> 
> And this looks like an attempt to handle modules compiled without
> PIE. Does it works with the right ip in that case?

I'm guessing the || is for the "or no GOT call was found", but it
doesn't explain why no GOT would be found.

> 
> I wonder if a better solution would be to update
> scripts/recordmcount.c to store the incremented location into the module.

If recordmcount.c can handle this, then I think that's the preferred
approach. Thanks!

-- Steve

> 
> IMPORTANT: I have only vague picture about how this all works. It is
> possible that I am completely wrong. The code might be correct,
> especially if you tested this situation.
> 
> Best Regards,
> Petr
