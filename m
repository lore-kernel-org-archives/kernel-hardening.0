Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <6f60afc9-0fed-7f95-a11a-9a2eef33094c@gmail.com>
Date: Tue, 13 Nov 2018 16:25:08 +0200
MIME-Version: 1.0
In-Reply-To: <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Nadav Amit <nadav.amit@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

Hello,
I've been studying v4 of the patch-set [1] that Nadav has been working on.
Incidentally, I think it would be useful to cc also the 
security/hardening ml.
The patch-set seems to be close to final, so I am resuming this discussion.

On 30/10/2018 19:06, Andy Lutomirski wrote:

> I support the addition of a rare-write mechanism to the upstream kernel.  And I think that there is only one sane way to implement it: using an mm_struct. That mm_struct, just like any sane mm_struct, should only differ from init_mm in that it has extra mappings in the *user* region.

After reading the code, I see what you meant.
I think I can work with it.

But I have a couple of questions wrt the use of this mechanism, in the 
context of write rare.


1) mm_struct.

Iiuc, the purpose of the patchset is mostly (only?) to patch kernel code 
(live patch?), which seems to happen sequentially and in a relatively 
standardized way, like replacing the NOPs specifically placed in the 
functions that need patching.

This is a bit different from the more generic write-rare case, applied 
to data.

As example, I have in mind a system where both IMA and SELinux are in use.

In this system, a file is accessed for the first time.

That would trigger 2 things:
- evaluation of the SELinux rules and probably update of the AVC cache
- IMA measurement and update of the measurements

Both of them could be write protected, meaning that they would both have 
to be modified through the write rare mechanism.

While the events, for 1 specific file, would be sequential, it's not 
difficult to imagine that multiple files could be accessed at the same time.

If the update of the data structures in both IMA and SELinux must use 
the same mm_struct, that would have to be somehow regulated and it would 
introduce an unnecessary (imho) dependency.

How about having one mm_struct for each writer (core or thread)?



2) Iiuc, the purpose of the 2 pages being remapped is that the target of 
the patch might spill across the page boundary, however if I deal with 
the modification of generic data, I shouldn't (shouldn't I?) assume that 
the data will not span across multiple pages.

If the data spans across multiple pages, in unknown amount, I suppose 
that I should not keep interrupts disabled for an unknown time, as it 
would hurt preemption.

What I thought, in my initial patch-set, was to iterate over each page 
that must be written to, in a loop, re-enabling interrupts in-between 
iterations, to give pending interrupts a chance to be served.

This would mean that the data being written to would not be consistent, 
but it's a problem that would have to be addressed anyways, since it can 
be still read by other cores, while the write is ongoing.


Is this a valid concern/approach?


--
igor


[1] https://lkml.org/lkml/2018/11/11/110
