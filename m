MIME-Version: 1.0
In-Reply-To: <0cdd02e1-8bf2-41cd-f085-c338c2fd8e25@zytor.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-7-thgarnie@google.com>
 <CAMzpN2gF7QxDbVG-6ad3Qarcn1N_JT5tit9CMvQL95LQGeZivA@mail.gmail.com>
 <CAJcbSZGqY=btU=+eWfgdhF0je0Yn_GxkymFHn+OV-1BuzgbRYw@mail.gmail.com> <0cdd02e1-8bf2-41cd-f085-c338c2fd8e25@zytor.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 19 Jul 2017 23:58:07 +0100
Message-ID: <CAKv+Gu_0o+PrMAWRSP5Y4R7QO87+zAYf=B=VDF1icqJvWL0PoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC 06/22] kvm: Adapt assembly for PIE support
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, linux-pm <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux-Sparse <linux-sparse@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 19 July 2017 at 23:27, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/19/17 08:40, Thomas Garnier wrote:
>>>
>>> This doesn't look right.  It's accessing a per-cpu variable.  The
>>> per-cpu section is an absolute, zero-based section and not subject to
>>> relocation.
>>
>> PIE does not respect the zero-based section, it tries to have
>> everything relative. Patch 16/22 also adapt per-cpu to work with PIE
>> (while keeping the zero absolute design by default).
>>
>
> This is silly.  The right thing is for PIE is to be explicitly absolute,
> without (%rip).  The use of (%rip) memory references for percpu is just
> an optimization.
>

Sadly, there is an issue in binutils that may prevent us from doing
this as cleanly as we would want.

For historical reasons, bfd.ld emits special symbols like
__GLOBAL_OFFSET_TABLE__ as absolute symbols with a section index of
SHN_ABS, even though it is quite obvious that they are relative like
any other symbol that points into the image. Unfortunately, this means
that binutils needs to emit R_X86_64_RELATIVE relocations even for
SHN_ABS symbols, which means we lose the ability to use both absolute
and relocatable symbols in the same PIE image (unless the reloc tool
can filter them out)

More info here:
https://sourceware.org/bugzilla/show_bug.cgi?id=19818
