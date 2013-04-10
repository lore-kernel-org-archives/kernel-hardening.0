Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20130408224328.GA17641@www.outflux.net>
	<51634935.9010905@zytor.com> <877gkc596d.fsf@xmission.com>
	<20130410095716.GF24443@gmail.com>
Date: Wed, 10 Apr 2013 03:40:33 -0700
In-Reply-To: <20130410095716.GF24443@gmail.com> (Ingo Molnar's message of
	"Wed, 10 Apr 2013 11:57:16 +0200")
Message-ID: <87sj2yzn1a.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org, kernel-hardening@lists.openwall.com, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Ingo Molnar <mingo@kernel.org> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> "H. Peter Anvin" <hpa@zytor.com> writes:
>> 
>> > On 04/08/2013 03:43 PM, Kees Cook wrote:
>> >> This makes the IDT unconditionally read-only. This primarily removes
>> >> the IDT from being a target for arbitrary memory write attacks. It has
>> >> an added benefit of also not leaking (via the "sidt" instruction) the
>> >> kernel base offset, if it has been relocated.
>> >> 
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> Cc: Eric Northup <digitaleric@google.com>
>> >
>> > Also, tglx: does this interfere with your per-cpu IDT efforts?
>> 
>> Given that we don't change any IDT entries why would anyone want a
>> per-cpu IDT?  The cache lines should easily be shared accross all
>> processors.
>
> That's true iif they are cached.
>
> If not then it's a remote DRAM access cache miss for all CPUs except the node that 
> holds that memory.
>
>> Or are there some giant NUMA machines that trigger cache misses when accessing 
>> the IDT and the penalty for pulling the cache line across the NUMA fabric is 
>> prohibitive?
>
> IDT accesses for pure userspace execution are pretty rare. So we are not just 
> talking about huge NUMA machines here but about ordinary NUMA machines taking a 
> remote cache miss hit for the first IRQ or other IDT-accessing operation they do 
> after some cache-intense user-space processing.
>
> It's a small effect, but it exists and improving it would be
> legitimate.

If the effect is measurable I agree it is a legitimate optimization.  At
one point there was a suggestion to make the code in the IDT vectors
differ based on the which interrupt was registed.  While that can also
reduce cache misses that can get hairy very quickly, and of course that
would require read-write IDTs.

My only practical concern with duplicating the IDT tables per cpu is (a)
there are generic idt handlers that remain unduplicated reducing the
benefit and this is essentially the same optimization as making the
entire kernel text per cpu which last time it was examined was not an
optimization worth making.  So I wonder if just a subset of the
optimization is worth making.

Eric
