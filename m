Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 10 Apr 2013 11:41:35 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130410094135.GD24443@gmail.com>
References: <20130408224328.GA17641@www.outflux.net>
 <51634935.9010905@zytor.com>
 <alpine.LFD.2.02.1304091122490.21884@ionos>
 <CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com>
 <51645D6F.7070705@zytor.com>
 <CAGXu5jKkHKw8efdPOmt-Zi99m+uMKVGKpc_DC72_ztwxnRbRRQ@mail.gmail.com>
 <51646054.3090509@zytor.com>
 <CAGXu5jJNG4o+_-kk=A2AfSRwyQE0pgaQh7YpSjnD_fB-s7U+wA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJNG4o+_-kk=A2AfSRwyQE0pgaQh7YpSjnD_fB-s7U+wA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> > That's the area in which we just map 1:1 to memory.  Anything allocated with 
> > e.g. kmalloc() ends up with those addresses.
> 
> Ah-ha! Yes, I see now when comparing the debug/kernel_page_tables reports. It's 
> just the High Kernel Mapping that we care about. Addresses outside that range 
> are less of a leak. Excellent, then GDT may not be a problem. Whew.

It's still an infoleak to worry about: any function pointers nearby matter, and 
the x86 GDT is obviously full of useful and highly privilege-relevant function 
pointers ...

I have no objections against read-only mapping the GDT as well.

Thanks,

	Ingo
