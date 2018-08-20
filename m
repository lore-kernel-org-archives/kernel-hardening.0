MIME-Version: 1.0
References: <20180820212556.GC2230@char.us.oracle.com> <CA+55aFxZCyVZc4ZpRyZ3uDyakRSOG_=2XvnwMo4oejpsieF9=A@mail.gmail.com>
 <1534801939.10027.24.camel@amazon.co.uk> <CA+55aFxyUdhYjnQdnmWAt8tTwn4HQ1xz3SAMZJiawkLpMiJ_+w@mail.gmail.com>
 <20180820223557.GC16961@cisco.cisco.com> <bd148fb6-e139-a065-1bf5-8054f932d30a@intel.com>
 <1534806880.10027.29.camel@infradead.org> <dd9657d2-f1c1-630d-4cce-7f1c67a968d6@intel.com>
In-Reply-To: <dd9657d2-f1c1-630d-4cce-7f1c67a968d6@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Aug 2018 16:38:31 -0700
Message-ID: <CA+55aFxGpX_W_B8aiV7dWFj5=wckTSiQ4nzVx-moonO5t3e6Lw@mail.gmail.com>
Subject: Re: Redoing eXclusive Page Frame Ownership (XPFO) with isolated CPUs
 in mind (for KVM to isolate its guests per CPU)
Content-Type: text/plain; charset="UTF-8"
To: Dave Hansen <dave.hansen@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Tycho Andersen <tycho@tycho.ws>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, juerg.haefliger@hpe.com, deepa.srinivasan@oracle.com, Jim Mattson <jmattson@google.com>, Andrew Cooper <andrew.cooper3@citrix.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>, joao.m.martins@oracle.com, pradeep.vincent@oracle.com, Andi Kleen <ak@linux.intel.com>, Khalid Aziz <khalid.aziz@oracle.com>, kanth.ghatraju@oracle.com, Liran Alon <liran.alon@oracle.com>, Kees Cook <keescook@google.com>, jsteckli@os.inf.tu-dresden.de, Kernel Hardening <kernel-hardening@lists.openwall.com>, chris.hyser@oracle.com, Tyler Hicks <tyhicks@canonical.com>, John Haxby <john.haxby@oracle.com>, Jon Masters <jcm@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 20, 2018 at 4:27 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> You're right that we could have a full physmap that we switch to for
> kmap()-like access to user pages.  But, the real problem is
> transitioning pages from kernel to user usage since it requires shooting
> down the old kernel mappings for those pages in some way.

You might decide that you simply don't care enough, and are willing to
leave possible stale TLB entries rather than shoot things down.

Then you'd still possibly see user pages in the kernel map, but only
for a fairly limited time, and only until the TLB entry gets re-used
for other reasons.

Even with kernel page table entries being marked global, their
lifetime in the TLB is likely not very long, and definitely not long
enough for some user that tries to scan for pages.

             Linus
