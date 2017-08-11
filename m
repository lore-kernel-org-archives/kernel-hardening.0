MIME-Version: 1.0
In-Reply-To: <20170811123618.GC16126@amd>
References: <20170810172615.51965-1-thgarnie@google.com> <20170810172615.51965-14-thgarnie@google.com>
 <20170811123618.GC16126@amd>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 11 Aug 2017 08:09:41 -0700
Message-ID: <CAJcbSZEiuMQ9+VOFywyRhs4sEZs9AHSzYqpg1yDZFxQ8vvgcWw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC v2 13/23] x86/power/64: Adapt assembly for PIE support
To: Pavel Machek <pavel@ucw.cz>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 11, 2017 at 5:36 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2017-08-10 10:26:05, Thomas Garnier wrote:
>> Change the assembly code to use only relative references of symbols for the
>> kernel to be PIE compatible.
>>
>> Position Independent Executable (PIE) support will allow to extended the
>> KASLR randomization range below the -2G memory limit.
>>
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>
> Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks Pavel!

>
>> --- a/arch/x86/power/hibernate_asm_64.S
>> +++ b/arch/x86/power/hibernate_asm_64.S
>> @@ -24,7 +24,7 @@
>>  #include <asm/frame.h>
>>
>>  ENTRY(swsusp_arch_suspend)
>> -     movq    $saved_context, %rax
>> +     leaq    saved_context(%rip), %rax
>>       movq    %rsp, pt_regs_sp(%rax)
>>       movq    %rbp, pt_regs_bp(%rax)
>>       movq    %rsi, pt_regs_si(%rax)
>> @@ -115,7 +115,7 @@ ENTRY(restore_registers)
>>       movq    %rax, %cr4;  # turn PGE back on
>>
>>       /* We don't restore %rax, it must be 0 anyway */
>> -     movq    $saved_context, %rax
>> +     leaq    saved_context(%rip), %rax
>>       movq    pt_regs_sp(%rax), %rsp
>>       movq    pt_regs_bp(%rax), %rbp
>>       movq    pt_regs_si(%rax), %rsi
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Thomas
