MIME-Version: 1.0
In-Reply-To: <28C8CD2A-BDC0-49A5-854E-1E18968528B8@amacapital.net>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com> <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net> <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net> <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net> <20181030175814.GB10491@bombadil.infradead.org>
 <28C8CD2A-BDC0-49A5-854E-1E18968528B8@amacapital.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 30 Oct 2018 12:14:50 -0700
Message-ID: <CAGXu5jK583zi9NPP2hwm51z6FbF2kkr5Em61eSp3EnwYFnKZEw@mail.gmail.com>
Subject: Re: [PATCH 10/17] prmem: documentation
Content-Type: text/plain; charset="UTF-8"
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matthew Wilcox <willy@infradead.org>, Nadav Amit <nadav.amit@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 11:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
>
>> On Oct 30, 2018, at 10:58 AM, Matthew Wilcox <willy@infradead.org> wrote:
>>
>> On Tue, Oct 30, 2018 at 10:06:51AM -0700, Andy Lutomirski wrote:
>>>> On Oct 30, 2018, at 9:37 AM, Kees Cook <keescook@chromium.org> wrote:
>>> I support the addition of a rare-write mechanism to the upstream kernel.
>>> And I think that there is only one sane way to implement it: using an
>>> mm_struct. That mm_struct, just like any sane mm_struct, should only
>>> differ from init_mm in that it has extra mappings in the *user* region.
>>
>> I'd like to understand this approach a little better.  In a syscall path,
>> we run with the user task's mm.  What you're proposing is that when we
>> want to modify rare data, we switch to rare_mm which contains a
>> writable mapping to all the kernel data which is rare-write.
>>
>> So the API might look something like this:
>>
>>    void *p = rare_alloc(...);    /* writable pointer */
>>    p->a = x;
>>    q = rare_protect(p);        /* read-only pointer */
>>
>> To subsequently modify q,
>>
>>    p = rare_modify(q);
>>    q->a = y;
>>    rare_protect(p);
>
> How about:
>
> rare_write(&q->a, y);
>
> Or, for big writes:
>
> rare_write_copy(&q, local_q);
>
> This avoids a whole ton of issues.  In practice, actually running with a special mm requires preemption disabled as well as some other stuff, which Nadav carefully dealt with.

This is what I had before, yes:
https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/write-rarely&id=9ab0cb2618ebbc51f830ceaa06b7d2182fe1a52d

It just needs the switch_mm() backend.

-- 
Kees Cook
