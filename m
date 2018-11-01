MIME-Version: 1.0
In-Reply-To: <20181031091048.GH744@hirez.programming.kicks-ass.net>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-17-igor.stoppa@huawei.com> <20181025001312.GA3159@worktop.c.hoisthospitality.com>
 <806bfff0-8d62-9918-480d-ec791b93841e@gmail.com> <20181030155841.GF8177@hirez.programming.kicks-ass.net>
 <20181030162815.GB20827@arm.com> <20181031091048.GH744@hirez.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 31 Oct 2018 20:28:33 -0700
Message-ID: <CAGXu5jKmhoSsOTqDJmr3ijwDAh57Bfq3KVE+AjrBdLXjPz83+g@mail.gmail.com>
Subject: Re: [PATCH 16/17] prmem: pratomic-long
Content-Type: text/plain; charset="UTF-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Boqun Feng <boqun.feng@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 31, 2018 at 2:10 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Oct 30, 2018 at 04:28:16PM +0000, Will Deacon wrote:
>> On Tue, Oct 30, 2018 at 04:58:41PM +0100, Peter Zijlstra wrote:
>> > Like mentioned elsewhere; if you do write_enable() + write_disable()
>> > thingies, it all becomes:
>> >
>> >     write_enable();
>> >     atomic_foo(&bar);
>> >     write_disable();
>> >
>> > No magic gunk infested duplication at all. Of course, ideally you'd then
>> > teach objtool about this (or a GCC plugin I suppose) to ensure any
>> > enable reached a disable.
>>
>> Isn't the issue here that we don't want to change the page tables for the
>> mapping of &bar, but instead want to create a temporary writable alias
>> at a random virtual address?
>>
>> So you'd want:
>>
>>       wbar = write_enable(&bar);
>>       atomic_foo(wbar);
>>       write_disable(wbar);
>>
>> which is probably better expressed as a map/unmap API. I suspect this
>> would also be the only way to do things for cmpxchg() loops, where you
>> want to create the mapping outside of the loop to minimise your time in
>> the critical section.
>
> Ah, so I was thikning that the altnerative mm would have stuff in the
> same location, just RW instead of RO.

I was hoping for the same location too. That allows use to use a gcc
plugin to mark, say, function pointer tables, as read-only, and
annotate their rare updates with write_rare() without any
recalculation.

-Kees

-- 
Kees Cook
