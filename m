References: <20170718223333.110371-1-thgarnie@google.com>
 <20170718223333.110371-21-thgarnie@google.com>
 <e499e745-e276-a4c9-2cd6-0977ca025448@zytor.com>
 <CAJcbSZE3fQ5vgUm4648kwExY_-p7a3d+QdNQ8K8tbhZVhOHFtA@mail.gmail.com>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <89b77a4a-ef77-f746-1ae5-79bfc0d12ab0@zytor.com>
Date: Wed, 19 Jul 2017 16:08:27 -0700
MIME-Version: 1.0
In-Reply-To: <CAJcbSZE3fQ5vgUm4648kwExY_-p7a3d+QdNQ8K8tbhZVhOHFtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC 20/22] x86/relocs: Add option to generate 64-bit relocations
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/19/17 15:47, Thomas Garnier wrote:
> On Wed, Jul 19, 2017 at 3:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 07/18/17 15:33, Thomas Garnier wrote:
>>> The x86 relocation tool generates a list of 32-bit signed integers. There
>>> was no need to use 64-bit integers because all addresses where above the 2G
>>> top of the memory.
>>>
>>> This change add a large-reloc option to generate 64-bit unsigned integers.
>>> It can be used when the kernel plan to go below the top 2G and 32-bit
>>> integers are not enough.
>>
>> Why on Earth?  This would only be necessary if the *kernel itself* was
>> more than 2G, which isn't going to happen for the forseeable future.
> 
> Because the relocation integer is an absolute address, not an offset
> in the binary. Next iteration, I can try using a 32-bit offset for
> everyone.

It is an absolute address *as the kernel was originally linked*, for
obvious reasons.

	-hpa
