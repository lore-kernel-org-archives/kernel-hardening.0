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
 <3BB9DE07-E0AE-43E2-99F1-E4AA774CD462@amacapital.net>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <5e10c8e4-aa71-1eea-b1ce-50d7d0a60e8c@gmail.com>
Date: Thu, 22 Nov 2018 21:27:02 +0200
MIME-Version: 1.0
In-Reply-To: <3BB9DE07-E0AE-43E2-99F1-E4AA774CD462@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 21/11/2018 20:15, Andy Lutomirski wrote:

>> On Nov 21, 2018, at 9:34 AM, Igor Stoppa <igor.stoppa@gmail.com> wrote:

[...]

>> There might be other reasons for replicating the mm_struct.
>>
>> If I understand correctly how the text patching works, it happens sequentially, because of the text_mutex used by arch_jump_label_transform
>>
>> Which might be fine for this specific case, but I think I shouldn't introduce a global mutex, when it comes to data.
>> Most likely, if two or more cores want to perform a write rare operation, there is no correlation between them, they could proceed in parallel. And if there really is, then the user of the API should introduce own locking, for that specific case.
> 
> Text patching uses the same VA for different physical addresses, so it need a mutex to avoid conflicts. I think that, for rare writes, you should just map each rare-writable address at a *different* VA.  You’ll still need a mutex (mmap_sem) to synchronize allocation and freeing of rare-writable ranges, but that shouldn’t have much contention.

I have studied the code involved with Nadav's patchset.
I am perplexed about these sentences you wrote.

More to the point (to the best of my understanding):

poking_init()
-------------
   1. it gets one random poking address and ensures to have at least 2
      consecutive PTEs from the same PMD
   2. it then proceeds to map/unmap an address from the first of the 2
      consecutive PTEs, so that, later on, there will be no need to
      allocate pages, which might fail, if poking from atomic context.
   3. at this point, the page tables are populated, for the address that
      was obtained at point 1, and this is ok, because the address is fixed

write_rare
----------
   4. it can happen on any available core / thread at any time, therefore
      each of them needs a different address
   5. CPUs support hotplug, but from what I have read, I might get away
      with having up to nr_cpus different addresses (determined at init)
      and I would follow the same technique used by Nadav, of forcing the
      mapping of 1 or 2 (1 could be enough, I have to loop anyway, at
      some point) pages at each address, to ensure the population of the
      page tables

so far, so good, but ...

   6. the addresses used by each CPU are fixed
   7. I do not understand the reference you make to
      "allocation and freeing of rare-writable ranges", because if I
      treat the range as such, then there is a risk that I need to
      populate more entries in the page table, which would have problems
      with the atomic context, unless write_rare from atomic is ruled
      out. If write_rare from atomic can be avoided, then I can also have
      one-use randomized addresses at each write-rare operation, instead
      of fixed ones, like in point 6.

and, apologies for being dense: the following is still not clear to me:

   8. you wrote:
      > You’ll still need a mutex (mmap_sem) to synchronize allocation
      > and freeing of rare-writable ranges, but that shouldn’t have much
      > contention.
      What causes the contention? It's the fact that the various cores
      are using the same mm, if I understood correctly.
      However, if there was one mm for each core, wouldn't that make it
      unnecessary to have any mutex?
      I feel there must be some obvious reason why multiple mms are not a
      good idea, yet I cannot grasp it :-(

      switch_mm_irqs_off() seems to have lots of references to
      "this_cpu_something"; if there is any optimization from having the
      same next across multiple cores, I'm missing it

[...]

> I would either refactor it or create a new function to handle the write. The main thing that Nadav is adding that I think you’ll want to use is the infrastructure for temporarily switching mms from a non-kernel-thread context.

yes

[...]


> You’ll still want Nadav’s code for setting up the mm in the first place, though.

yes

--
thanks, igor
