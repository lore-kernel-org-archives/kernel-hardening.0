Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20130408224328.GA17641@www.outflux.net>
	<51634935.9010905@zytor.com>
Date: Tue, 09 Apr 2013 02:45:46 -0700
In-Reply-To: <51634935.9010905@zytor.com> (H. Peter Anvin's message of "Mon,
	08 Apr 2013 15:48:21 -0700")
Message-ID: <877gkc596d.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org, kernel-hardening@lists.openwall.com, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 04/08/2013 03:43 PM, Kees Cook wrote:
>> This makes the IDT unconditionally read-only. This primarily removes
>> the IDT from being a target for arbitrary memory write attacks. It has
>> an added benefit of also not leaking (via the "sidt" instruction) the
>> kernel base offset, if it has been relocated.
>> 
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Eric Northup <digitaleric@google.com>
>
> Also, tglx: does this interfere with your per-cpu IDT efforts?

Given that we don't change any IDT entries why would anyone want a
per-cpu IDT?  The cache lines should easily be shared accross all
processors.

Or are there some giant NUMA machines that trigger cache misses when
accessing the IDT and the penalty for pulling the cache line across
the NUMA fabric is prohibitive?

Eric
