Subject: Re: [PATCH 10/17] prmem: documentation
References: <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org> <20181030182841.GE7343@cisco>
 <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
 <20181030213557.GE10491@bombadil.infradead.org>
 <CALCETrW1FcT88u0QY9k_PMOeZj0G8H6KNb5Bnreo-12NvmmCEQ@mail.gmail.com>
 <20181031100237.GN744@hirez.programming.kicks-ass.net>
 <659CFC78-22BF-492B-B2E4-B8E89AA08446@amacapital.net>
 <20181031210032.GA3159@hirez.programming.kicks-ass.net>
 <2E29C35B-3F98-473D-A874-0D9B9B15B399@amacapital.net>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <4124995b-4363-9b37-19b1-1879bf04978b@gmail.com>
Date: Thu, 1 Nov 2018 01:10:30 +0200
MIME-Version: 1.0
In-Reply-To: <2E29C35B-3F98-473D-A874-0D9B9B15B399@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>



On 01/11/2018 00:57, Andy Lutomirski wrote:
> 
> 
>> On Oct 31, 2018, at 2:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:



>> I _think_ the use-case for atomics is updating the reference counts of
>> objects that are in this write-rare domain. But I'm not entirely clear
>> on that myself either. I just really want to avoid duplicating that
>> stuff.
> 
> Sounds nuts. Doing a rare-write is many hundreds of cycles at best. Using that for a reference count sounds wacky.
> 
> Can we see a *real* use case before we over complicate the API?
> 


Does patch #14 of this set not qualify? ima_htable.len ?

https://www.openwall.com/lists/kernel-hardening/2018/10/23/20

--
igor
