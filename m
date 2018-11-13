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
 <6f60afc9-0fed-7f95-a11a-9a2eef33094c@gmail.com>
 <CALCETrXNckT9W288VXx-6inO5qYn-6dUPocKGcBT0GCO3xi3ZQ@mail.gmail.com>
 <17a007eb-43ea-e4da-b066-0d8c502f5f6e@huawei.com>
 <CALCETrVaPTbgycjzSB0fLUeGL=j1srUh-cL0qsKn6fw6UQgj7Q@mail.gmail.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <12b6232f-ac3d-c74c-5f9e-d84905c39f0a@huawei.com>
Date: Tue, 13 Nov 2018 21:01:43 +0200
MIME-Version: 1.0
In-Reply-To: <CALCETrVaPTbgycjzSB0fLUeGL=j1srUh-cL0qsKn6fw6UQgj7Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@amacapital.net>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Nadav Amit <nadav.amit@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>



On 13/11/2018 20:35, Andy Lutomirski wrote:
> On Tue, Nov 13, 2018 at 10:26 AM Igor Stoppa <igor.stoppa@huawei.com> wrote:

[...]

>> The high level API could be something like:
>>
>> wr_memcpy(void *src, void *dst, uint_t size)

[...]

> If you call a wr_memcpy() function with the signature you suggested,
> then you can overwrite any memory of this type.  Having a different
> mm_struct under the hood makes no difference.  As far as I'm
> concerned, for *dynamically allocated* rare-writable memory, you might
> as well allocate all the paging structures at the same time, so the
> mm_struct will always contain the mappings.  If there are serious bugs
> in wr_memcpy() that cause it to write to the wrong place, we have
> bigger problems.

Beside bugs, I'm also thinking about possible vulnerability.
It might be overthinking, though.

I do not think it's possible to really protect against control flow
attacks, unless there is some support from the HW and/or the compiler.

What is left, are data-based attacks. In this case, it would be an
attacker using one existing wr_ invocation with doctored parameters.

However, there is always the objection that it would be possible to come
up with a "writing kit" for plowing through the page tables and
unprotect anything that might be of value.

Ideally, that should be the only type of data-based attack left.

In practice, it might just be an excess of paranoia from my side.

> I can imagine that we'd want a *typed* wr_memcpy()-like API some day,
> but that can wait for v2.  And it still doesn't obviously need
> multiple mm_structs.

I left that out, for now, but yes, typing would play some role here.

[...]

> I think it's entirely reasonable for the API to internally break up
> very large memcpys.

The criteria for deciding if/how to break it down is not clear to me,
though. The single page was easy, but might be (probably is) too much.

--
igor
