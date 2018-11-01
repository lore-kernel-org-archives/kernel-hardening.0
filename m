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
 <4124995b-4363-9b37-19b1-1879bf04978b@gmail.com>
 <CALCETrWCvAfyfBWgcmhy8TGByiX3ZXXSOkLtZFdM385fDqYJVw@mail.gmail.com>
 <8675e9d8-0ef0-7515-a894-097d4be25b73@gmail.com>
 <alpine.DEB.2.21.1811010909480.1642@nanos.tec.linutronix.de>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <f344a62a-07be-8424-d4cd-73afacc4da76@gmail.com>
Date: Thu, 1 Nov 2018 17:58:43 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1811010909480.1642@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <willy@infradead.org>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 01/11/2018 10:21, Thomas Gleixner wrote:
> On Thu, 1 Nov 2018, Igor Stoppa wrote:

>> The rework could be done afterward.
> 
> Please don't go there. The usual approach is to
> 
>    1) Rework existing code in a way that the new functionality can be added
>       with minimal effort afterwards and without creating API horrors.


Thanks a lot for the advice.
It makes things even easier for me, as I can start the rework, while the 
discussion on the actual write-rare mechanism continues.

--
igor
