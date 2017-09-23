Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 23 Sep 2017 11:43:12 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170923094312.td3mrfos6konic6g@gmail.com>
References: <20170817080920.5ljlkktngw2cisfg@gmail.com>
 <CAJcbSZGbtc-i0X1NiBAvZA7cxpGkwSLKNB7oDNCsFxOCdhkR_g@mail.gmail.com>
 <CAJcbSZGhvwt=5ERtBHLJnwS=6AXBZLTMfrafzeUCqYy=-MKWDg@mail.gmail.com>
 <20170825080443.tvvr6wzs362cjcuu@gmail.com>
 <CAJcbSZFJQMKw21kLwr4QGoSM7DMgKRzzjWxkYBF2c1HciCzvGg@mail.gmail.com>
 <CAJcbSZH6hwaWKrvUZR33ExYaZaWKMSv4tJJA3yZkniLvLbTFMw@mail.gmail.com>
 <20170921155919.skpyt7dutod5ul4t@gmail.com>
 <CAJcbSZHOuxy5BVxD0xJUdQfB-OMgbvfiP-2CJzf52K-7JZAy-A@mail.gmail.com>
 <20170922163225.bfrd5myl6d7deiim@gmail.com>
 <CAJcbSZFbNACVrSQ7yFkDMs+4L56_4e73kvdesSdD5W4bdBoOpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZFbNACVrSQ7yFkDMs+4L56_4e73kvdesSdD5W4bdBoOpg@mail.gmail.com>
Subject: [kernel-hardening] Re: x86: PIE support and option to extend KASLR randomization
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>, kvm list <kvm@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

> >   2) we first implement the additional entropy bits that Linus suggested.
> >
> > does this work for you?
> 
> Sure, I can look at how feasible that is. If it is, can I send
> everything as part of the same patch set? The additional entropy would
> be enabled for all KASLR but PIE will be off-by-default of course.

Sure, can all be part of the same series.

Thanks,

	Ingo
