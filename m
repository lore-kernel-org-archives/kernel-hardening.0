Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 17 Mar 2017 08:34:37 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170317073437.GA14797@gmail.com>
References: <20170314170508.100882-1-thgarnie@google.com>
 <20170316081013.GB7815@gmail.com>
 <CAJcbSZEB09inR2KLF_puOnmAK7QUv-zJHcguiF0qucUYTtg1Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZEB09inR2KLF_puOnmAK7QUv-zJHcguiF0qucUYTtg1Pw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7 1/3] x86/mm: Adapt MODULES_END based on Fixmap section
 size
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Kees Cook <keescook@chromium.org>, Juergen Gross <jgross@suse.com>, Andy Lutomirski <luto@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, zijun_hu <zijun_hu@htc.com>, Chris Wilson <chris@chris-wilson.co.uk>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rusty Russell <rusty@rustcorp.com.au>, Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Frederic Weisbecker <fweisbec@gmail.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, kasan-dev <kasan-dev@googlegroups.com>, Linux-MM <linux-mm@kvack.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm list <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

> On Thu, Mar 16, 2017 at 1:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Note that asm/fixmap.h is an x86-ism that isn't present in many other
> > architectures, so this hunk will break the build.
> >
> > To make progress with these patches I've fixed it up with an ugly #ifdef
> > CONFIG_X86, but it needs a real solution instead before this can be pushed
> > upstream.
> 
> I also saw an error on x86 tip on special configuration. I found this
> new patch below to be a good solution to both.
> 
> Let me know what you think.
> 
> =====
> 
> This patch aligns MODULES_END to the beginning of the Fixmap section.
> It optimizes the space available for both sections. The address is
> pre-computed based on the number of pages required by the Fixmap
> section.
> 
> It will allow GDT remapping in the Fixmap section. The current
> MODULES_END static address does not provide enough space for the kernel
> to support a large number of processors.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20170308
> ---
>  Documentation/x86/x86_64/mm.txt         | 5 ++++-
>  arch/x86/include/asm/pgtable_64.h       | 1 +
>  arch/x86/include/asm/pgtable_64_types.h | 3 ++-
>  3 files changed, 7 insertions(+), 2 deletions(-)

The patch is heavily whitespace and line wrap damaged :-(

Please send a properly titled, changelogged delta patch against tip:master (or 
tip:x86/mm) to remove the CONFIG_X86 hack and fix the build bug.

Thanks,

	Ingo
