Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20171020152028.syq6woeet6it3z3h@gmail.com>
Date: Fri, 20 Oct 2017 18:27:24 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <1F0B8A18-092F-42AF-91B4-7A5D414ED83D@amacapital.net>
References: <20171011203027.11248-1-thgarnie@google.com> <20171011203027.11248-7-thgarnie@google.com> <20171020082646.bkxrps35sb3gq2nr@gmail.com> <CAJcbSZFScsqOORMGXFQdsqcN5xbfHWpzSHGdxQB=45zgSDryLw@mail.gmail.com> <20171020152028.syq6woeet6it3z3h@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v1 06/27] x86/entry/64: Adapt assembly for PIE support
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?utf-8?Q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, "=?utf-8?Q? Jan_H_._Sch=C3=B6nherr ?=" <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, virtualization@lists.linux-foundation.org, xen-devel <xen-devel@lists.xenproject.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



> On Oct 20, 2017, at 5:20 PM, Ingo Molnar <mingo@kernel.org> wrote:
>=20
>=20
> * Thomas Garnier <thgarnie@google.com> wrote:
>=20
>>>>       */
>>>> -     cmpq    $.Lentry_SYSCALL_64_after_fastpath_call, (%rsp)
>>>> +     leaq    .Lentry_SYSCALL_64_after_fastpath_call(%rip), %r11
>>>> +     cmpq    %r11, (%rsp)
>>>>      jne     1f
>=20
>>> This patch seems to add extra overhead to the syscall fast-path even whe=
n PIE is
>>> disabled, right?
>>=20
>> It does add extra instructions when one is not possible, I preferred
>> that over ifdefing but I can change it.
>=20
> So my problem is, this pattern repeats in many other places as well, but s=
prinking=20
> various pieces of assembly code with #ifdefs would be very bad as well.
>=20
> I have no good idea how to solve this.
>=20

How about:

.macro JMP_TO_LABEL ...


> Thanks,
>=20
>    Ingo
