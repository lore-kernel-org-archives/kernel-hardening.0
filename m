Subject: Re: [PATCH 10/17] prmem: documentation
From: Igor Stoppa <igor.stoppa@huawei.com>
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
 <386C0CB1-C4B1-43E2-A754-DA8DBE4FB3CB@gmail.com>
 <CALCETrWWcfLK4W3mn0bavzejmMBVKMX29aAUA3+VPQ8m9vmfhw@mail.gmail.com>
 <9373ccf0-f51b-4bfa-2b16-e03ebf3c670d@huawei.com>
Message-ID: <2e52e103-15d0-0c26-275f-894dfd07e8ec@huawei.com>
Date: Tue, 13 Nov 2018 20:33:41 +0200
MIME-Version: 1.0
In-Reply-To: <9373ccf0-f51b-4bfa-2b16-e03ebf3c670d@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel
 Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

I forgot one sentence :-(

On 13/11/2018 20:31, Igor Stoppa wrote:
> On 13/11/2018 19:47, Andy Lutomirski wrote:
> 
>> For general rare-writish stuff, I don't think we want IRQs running
>> with them mapped anywhere for write.  For AVC and IMA, I'm less sure.
> 
> Why would these be less sensitive?
> 
> But I see a big difference between my initial implementation and this one.
> 
> In my case, by using a shared mapping, visible to all cores, freezing
> the core that is performing the write would have exposed the writable
> mapping to a potential attack run from another core.
> 
> If the mapping is private to the core performing the write, even if it
> is frozen, it's much harder to figure out what it had mapped and where,
> from another core.
> 
> To access that mapping, the attack should be performed from the ISR, I
> think.

Unless the secondary mapping is also available to other cores, through
the shared mm_struct ?

--
igor
