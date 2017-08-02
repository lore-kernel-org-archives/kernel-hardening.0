MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAJcbSZF5-gVg=Q6yAV2ymHo+SC6Go=vQHXMR0UTdKH2Jbe-s-g@mail.gmail.com>
References: <20170718223333.110371-1-thgarnie@google.com> <20170718223333.110371-17-thgarnie@google.com>
 <CAMzpN2g5YkFZTY7yfvG03QUKc-=asKMZbqke9g4e2oT_pgg7Yw@mail.gmail.com>
 <CAJcbSZFXrDZikh9P5M81ztkiMv7EhO4x0bzBdYE8RYC=HMZgqg@mail.gmail.com>
 <25a2974a-fbb4-ea4b-d090-582d6d0de7fd@zytor.com> <CAJcbSZHuOhMHW6OTyt7-vZkPLS3XRQ48gpkF-TyohXpDW+825w@mail.gmail.com>
 <CAJcbSZF5-gVg=Q6yAV2ymHo+SC6Go=vQHXMR0UTdKH2Jbe-s-g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 2 Aug 2017 09:56:32 -0700
Message-ID: <CAGXu5jLhg5d0rxkfTGDjNxcsqd9BH8BSOPEOn=PBKx_dYeq8ow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC 16/22] x86/percpu: Adapt percpu for PIE support
To: Thomas Garnier <thgarnie@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xen-devel@lists.xenproject.org, kvm list <kvm@vger.kernel.org>, linux-pm <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-sparse@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 2, 2017 at 9:42 AM, Thomas Garnier <thgarnie@google.com> wrote:
> I noticed that not only we have the problem of gs:0x40 not being
> accessible. The compiler will default to the fs register if
> mcmodel=kernel is not set.
>
> On the next patch set, I am going to add support for
> -mstack-protector-guard=global so a global variable can be used
> instead of the segment register. Similar approach than ARM/ARM64.

While this is probably understood, I have to point out that this would
be a major regression for the stack protection on x86.

> Following this patch, I will work with gcc and llvm to add
> -mstack-protector-reg=<segment register> support similar to PowerPC.
> This way we can have gs used even without mcmodel=kernel. Once that's
> an option, I can setup the GDT as described in the previous email
> (similar to RFG).

It would be much nicer if we could teach gcc about the percpu area
instead. This would let us solve the global stack protector problem on
the other architectures:
http://www.openwall.com/lists/kernel-hardening/2017/06/27/6

-Kees

-- 
Kees Cook
Pixel Security
