Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
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
 <2e52e103-15d0-0c26-275f-894dfd07e8ec@huawei.com>
 <CALCETrV0sPgf4ZgG1joF_5hM-ycPsWM9DWGO=diQ_LQKin4VuA@mail.gmail.com>
 <1166e55c-0c06-195c-a501-383b4055ea46@gmail.com>
 <03E199F6-FD90-4B88-838E-C3702F982F78@gmail.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <19a216e3-2f1a-32d5-ed22-99d9fdd93a59@gmail.com>
Date: Wed, 21 Nov 2018 20:01:34 +0200
MIME-Version: 1.0
In-Reply-To: <03E199F6-FD90-4B88-838E-C3702F982F78@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>



On 21/11/2018 19:36, Nadav Amit wrote:
>> On Nov 21, 2018, at 8:34 AM, Igor Stoppa <igor.stoppa@gmail.com> wrote:

[...]

>> There might be other reasons for replicating the mm_struct.
>>
>> If I understand correctly how the text patching works, it happens sequentially, because of the text_mutex used by arch_jump_label_transform
>>
>> Which might be fine for this specific case, but I think I shouldn't introduce a global mutex, when it comes to data.
>> Most likely, if two or more cores want to perform a write rare operation, there is no correlation between them, they could proceed in parallel. And if there really is, then the user of the API should introduce own locking, for that specific case.
> 
> I think that if you create per-CPU temporary mms as you proposed, you do not
> need a global lock. You would need to protect against module unloading,

yes, it's unlikely to happen and probably a bug in the module, if it 
tries to write while being unloaded, but I can do it

> and
> maybe refactor the code. Specifically, I’m not sure whether protection
> against IRQs is something that you need.

With the initial way I used to do write rare, which was done by creating 
a temporary mapping visible to every core, disabling IRQs was meant to 
prevent that the "writer" core would be frozen and then the mappings 
scrubbed for the page in writable state.

Without shared mapping of the page, the only way to attack it should be 
to generate an interrupt on the "writer" core, while the writing is 
ongoing, and to perform the attack from the interrupt itself, because it 
is on the same core that has the writable mapping.

Maybe it's possible, but it seems to have become quite a corner case.

> I’m also not familiar with this
> patch-set so I’m not sure what atomicity guarantees do you need.

At the very least, I think I need to ensure that pointers are updated 
atomically, like with WRITE_ONCE() And spinlocks.
Maybe atomic types can be left out.

>> A bit unrelated question, related to text patching: I see that each patching operation is validated, but wouldn't it be more robust to first validate  all of then, and only after they are all found to be compliant, to proceed with the actual modifications?
>>
>> And about the actual implementation of the write rare for the statically allocated variables, is it expected that I use Nadav's function?
> 
> It’s not “my” function. ;-)

:-P

ok, what I meant is that the signature of the __text_poke() function is 
quite specific to what it's meant to do.

I do not rule out that it might be eventually refactored as a special 
case of a more generic __write_rare() function, that would operate on 
different targets, but I'd rather do the refactoring after I have a 
clear understanding of how to alter write-protected data.

The refactoring could be the last patch of the write rare patchset.

> IMHO the code is in relatively good and stable state. The last couple of
> versions were due to me being afraid to add BUG_ONs as Peter asked me to.
> 
> The code is rather simple, but there are a couple of pitfalls that hopefully
> I avoided correctly.

Yes, I did not mean to question the quality of the code, but I'd prefer 
to not have to carry also this patchset, while it's not yet merged.

I actually hope it gets merged soon :-)
--
igor
