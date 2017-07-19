MIME-Version: 1.0
In-Reply-To: <CAMzpN2j+Z27uudHXqqMhbk=s=pnk7LdA2FPkgmsdZzO3ysemsQ@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-22-thgarnie@google.com>
 <c0bc2d98-d6eb-e3db-3799-2e28e9919f3d@zytor.com> <CAMzpN2j+Z27uudHXqqMhbk=s=pnk7LdA2FPkgmsdZzO3ysemsQ@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 19 Jul 2017 08:58:32 -0700
Message-ID: <CAJcbSZFphkF8bcodkcwpK-oi3D7GTQXyTkOLPkmtWSPLPkvB0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC 21/22] x86/module: Add support for mcmodel large and PLTs
To: Brian Gerst <brgerst@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, linux-pm <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 18, 2017 at 8:59 PM, Brian Gerst <brgerst@gmail.com> wrote:
> On Tue, Jul 18, 2017 at 9:35 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/18/17 15:33, Thomas Garnier wrote:
>>> With PIE support and KASLR extended range, the modules may be further
>>> away from the kernel than before breaking mcmodel=kernel expectations.
>>>
>>> Add an option to build modules with mcmodel=large. The modules generated
>>> code will make no assumptions on placement in memory.
>>>
>>> Despite this option, modules still expect kernel functions to be within
>>> 2G and generate relative calls. To solve this issue, the PLT arm64 code
>>> was adapted for x86_64. When a relative relocation go outside its range,
>>> a dynamic PLT entry is used to correctly jump to the destination.
>>
>> Why large as opposed to medium or medium-PIC?
>
> Or for that matter, why not small-PIC?  We aren't changing the size of
> the kernel to be larger than 2G text or data.  Small-PIC would still
> allow it to be placed anywhere in the address space, and would
> generate far better code.

My understanding was that small=PIC and medium=PIC assume that the
module code is in the lower 2G of memory. I will do additional testing
on the modules to confirm that.

>
> --
> Brian Gerst



-- 
Thomas
