Date: Wed, 31 Oct 2018 11:02:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181031100237.GN744@hirez.programming.kicks-ass.net>
References: <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org>
 <20181030182841.GE7343@cisco>
 <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
 <20181030213557.GE10491@bombadil.infradead.org>
 <CALCETrW1FcT88u0QY9k_PMOeZj0G8H6KNb5Bnreo-12NvmmCEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW1FcT88u0QY9k_PMOeZj0G8H6KNb5Bnreo-12NvmmCEQ@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matthew Wilcox <willy@infradead.org>, Igor Stoppa <igor.stoppa@gmail.com>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 09:41:13PM -0700, Andy Lutomirski wrote:
> To clarify some of this thread, I think that the fact that rare_write
> uses an mm_struct and alias mappings under the hood should be
> completely invisible to users of the API.  No one should ever be
> handed a writable pointer to rare_write memory (except perhaps during
> bootup or when initializing a large complex data structure that will
> be rare_write but isn't yet, e.g. the policy db).

Being able to use pointers would make it far easier to do atomics and
other things though.

> For example, there could easily be architectures where having a
> writable alias is problematic.

Mostly we'd just have to be careful of cache aliases, alignment should
be able to sort that I think.

> If you have multiple pools and one mm_struct per pool, you'll need a
> way to find the mm_struct from a given allocation.

Or keep track of it externally. For example by context. If you modify
page-tables you pick the page-table pool, if you modify selinux state,
you pick the selinux pool.

> Regardless of how the mm_structs are set up, changing rare_write
> memory to normal memory or vice versa will require a global TLB flush
> (all ASIDs and global pages) on all CPUs, so having extra mm_structs
> doesn't seem to buy much.

The way I understand it, the point is that if you stick page-tables and
selinux state in different pools, a stray write in one will never affect
the other.
