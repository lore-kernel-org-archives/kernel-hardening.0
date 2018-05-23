Subject: Re: [PATCH v3 23/27] x86/modules: Adapt module loading for PIE
 support
References: <20180523195421.180248-1-thgarnie@google.com>
 <20180523195421.180248-24-thgarnie@google.com>
 <168ebedb-7c27-d1f3-c2f9-223d44186a52@infradead.org>
 <CAJcbSZHPc2w7g8Q4UZV3sx=s6LVL_+dsomro7to6RNhd-4F4Ag@mail.gmail.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b7bd7c41-80ac-d5e9-29bb-dfca9b60eda3@infradead.org>
Date: Wed, 23 May 2018 16:07:24 -0700
MIME-Version: 1.0
In-Reply-To: <CAJcbSZHPc2w7g8Q4UZV3sx=s6LVL_+dsomro7to6RNhd-4F4Ag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@siemens.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Cao jin <caoj.fnst@cn.fujitsu.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw@amazon.co.uk>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Jan Beulich <JBeulich@suse.com>, Matthias Kaehlcke <mka@chromium.org>, Baoquan He <bhe@redhat.com>, "=?UTF-8?Q?Jan_H_._Sch=c3=b6nherr?=" <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, virtualization@lists.linux-foundation.org, xen-devel <xen-devel@lists.xenproject.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 05/23/2018 03:01 PM, Thomas Garnier wrote:
> On Wed, May 23, 2018 at 2:27 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> Hi,
> 
>> (for several patches in this series:)
>> The commit message is confusing.  See below.
> 
> Thanks for the edits, I will change the different commit messages.
> 
> 
> 
>> On 05/23/2018 12:54 PM, Thomas Garnier wrote:
>>> Adapt module loading to support PIE relocations. Generate dynamic GOT if
>>> a symbol requires it but no entry exist in the kernel GOT.
> 
>>                                      exists
> 
>>>
>>> Position Independent Executable (PIE) support will allow to extended the
> 
>>                                                  will allow us to extend
> the
> 
>>> KASLR randomization range below the -2G memory limit.
> 
>> Does that say "below th negative 2G memory limit"?
>> I don't get it.
> 
> Yes, below 0xffffffff80000000 basically. I think I will just say that.

Yes, please, that's much better.

> 
> 
>>>
>>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>>> ---
>>>  arch/x86/Makefile               |   4 +
>>>  arch/x86/include/asm/module.h   |  11 ++
>>>  arch/x86/include/asm/sections.h |   4 +
>>>  arch/x86/kernel/module.c        | 181 +++++++++++++++++++++++++++++++-
>>>  arch/x86/kernel/module.lds      |   3 +
>>>  5 files changed, 198 insertions(+), 5 deletions(-)
>>>  create mode 100644 arch/x86/kernel/module.lds
> 
> 
>> Thanks,
>> --
>> ~Randy
> 
> 
> 


-- 
~Randy
