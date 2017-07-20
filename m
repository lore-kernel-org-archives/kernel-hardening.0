From: "H. Peter Anvin" <hpa@zytor.com>
References: <20170718223333.110371-1-thgarnie@google.com>
 <20170718223333.110371-17-thgarnie@google.com>
 <CAMzpN2g5YkFZTY7yfvG03QUKc-=asKMZbqke9g4e2oT_pgg7Yw@mail.gmail.com>
 <CAJcbSZFXrDZikh9P5M81ztkiMv7EhO4x0bzBdYE8RYC=HMZgqg@mail.gmail.com>
 <25a2974a-fbb4-ea4b-d090-582d6d0de7fd@zytor.com>
Message-ID: <9b152d55-8a1a-75b5-58df-0fe33458107a@zytor.com>
Date: Wed, 19 Jul 2017 19:21:50 -0700
MIME-Version: 1.0
In-Reply-To: <25a2974a-fbb4-ea4b-d090-582d6d0de7fd@zytor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC 16/22] x86/percpu: Adapt percpu for PIE support
To: Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, linux-pm <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/19/17 16:33, H. Peter Anvin wrote:
>>
>> I agree that it is odd but that's how the compiler generates code. I
>> will re-explore PIC options with mcmodel=small or medium, as mentioned
>> on other threads.
> 
> Why should the way compiler generates code affect the way we do things
> in assembly?
> 
> That being said, the compiler now has support for generating this kind
> of code explicitly via the __seg_gs pointer modifier.  That should let
> us drop the __percpu_prefix and just use variables directly.  I suspect
> we want to declare percpu variables as "volatile __seg_gs" to account
> for the possibility of CPU switches.
> 
> Older compilers won't be able to work with this, of course, but I think
> that it is acceptable for those older compilers to not be able to
> support PIE.
> 

Grump.  It turns out that the compiler doesn't do the right thing for
symbols marked with the __seg_[fg]s markers.  __thread does the right
thing, but __thread a) has %fs: hard-coded, still, and b) I believe can
still cache %seg:0 arbitrarily long.

	-hpa
