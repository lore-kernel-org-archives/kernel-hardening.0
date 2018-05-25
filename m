MIME-Version: 1.0
References: <20180523195421.180248-1-thgarnie@google.com> <20180523195421.180248-10-thgarnie@google.com>
 <20180524110306.GA20225@amd> <CAJcbSZFJ84+VC5xDQZGHctupdqwmMBgqzLzFRqCTBpi5t-2Gvw@mail.gmail.com>
 <20180525091447.GC9666@amd>
In-Reply-To: <20180525091447.GC9666@amd>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 25 May 2018 10:00:04 -0700
Message-ID: <CAJcbSZH17D01Stk4vRKKzjW6dxvK8x+S9sWL6vUopSP9=-x7Nw@mail.gmail.com>
Subject: Re: [PATCH v3 09/27] x86/acpi: Adapt assembly for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Pavel Machek <pavel@ucw.cz>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@siemens.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Cao jin <caoj.fnst@cn.fujitsu.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw@amazon.co.uk>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Jan Beulich <JBeulich@suse.com>, Matthias Kaehlcke <mka@chromium.org>, Baoquan He <bhe@redhat.com>, =?UTF-8?B?SmFuIEggLiBTY2jDtm5oZXJy?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, virtualization@lists.linux-foundation.org, xen-devel <xen-devel@lists.xenproject.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 25, 2018 at 2:14 AM Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2018-05-24 09:35:42, Thomas Garnier wrote:
> > On Thu, May 24, 2018 at 4:03 AM Pavel Machek <pavel@ucw.cz> wrote:
> >
> > > On Wed 2018-05-23 12:54:03, Thomas Garnier wrote:
> > > > Change the assembly code to use only relative references of symbols
for
> > the
> > > > kernel to be PIE compatible.
> > > >
> > > > Position Independent Executable (PIE) support will allow to
extended the
> > > > KASLR randomization range below the -2G memory limit.
> >
> > > What testing did this get?
> >
> > Tested boot, hibernation and performance on qemu and dedicated machine.

> Well, this is suspend, not hibernation code.

> So "sudo pm-suspend" or "echo mem > /sys/power/state" would be good
> way to test this.

Thanks, it worked. I added this to the testsuite I use for KASLR.


> Thanks,
>                                                          Pavel

> > > > diff --git a/arch/x86/kernel/acpi/wakeup_64.S
> > b/arch/x86/kernel/acpi/wakeup_64.S
> > > > index 50b8ed0317a3..472659c0f811 100644
> > > > --- a/arch/x86/kernel/acpi/wakeup_64.S
> > > > +++ b/arch/x86/kernel/acpi/wakeup_64.S
> > > > @@ -14,7 +14,7 @@
> > > >        * Hooray, we are in Long 64-bit mode (but still running in
low
> > memory)
> > > >        */
> > > >  ENTRY(wakeup_long64)
> > > > -     movq    saved_magic, %rax
> > > > +     movq    saved_magic(%rip), %rax
> > > >       movq    $0x123456789abcdef0, %rdx
> > > >       cmpq    %rdx, %rax
> > > >       jne     bogus_64_magic
> >
> > > Because, as comment says, this is rather tricky code.
> >
> > I agree, I think maintainers feedback is very important for this
patchset.


> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Thomas
