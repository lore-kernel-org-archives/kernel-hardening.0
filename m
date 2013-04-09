Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <51645D6F.7070705@zytor.com>
References: <20130408224328.GA17641@www.outflux.net>
	<51634935.9010905@zytor.com>
	<alpine.LFD.2.02.1304091122490.21884@ionos>
	<CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com>
	<51645D6F.7070705@zytor.com>
Date: Tue, 9 Apr 2013 11:31:45 -0700
Message-ID: <CAGXu5jKkHKw8efdPOmt-Zi99m+uMKVGKpc_DC72_ztwxnRbRRQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 9, 2013 at 11:26 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/09/2013 11:22 AM, Kees Cook wrote:
>>
>> $ ./sgdt
>> ffff88001fc04000
>> # cat /sys/kernel/debug/kernel_page_tables
>> ...
>> ---[ Low Kernel Mapping ]---
>> ...
>> 0xffff880001e00000-0xffff88001fe00000         480M     RW         PSE GLB NX pmd
>>
>
> That is the 1:1 memory map area...

Meaning what?

-Kees

--
Kees Cook
Chrome OS Security
