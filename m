Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1365555234.25498.91.camel@gandalf.local.home>
From: Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 09 Apr 2013 20:53:54 -0400
In-Reply-To: <5164B5BD.5050702@zytor.com>
References: <20130408224328.GA17641@www.outflux.net>
	 <51634935.9010905@zytor.com> <alpine.LFD.2.02.1304091122490.21884@ionos>
	 <CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com>
	 <51645D6F.7070705@zytor.com>
	 <CAGXu5jKkHKw8efdPOmt-Zi99m+uMKVGKpc_DC72_ztwxnRbRRQ@mail.gmail.com>
	 <51646054.3090509@zytor.com>
	 <CAGXu5jJNG4o+_-kk=A2AfSRwyQE0pgaQh7YpSjnD_fB-s7U+wA@mail.gmail.com>
	 <CAG7+5M3==rndLLak9cZBKKdgQMmJMpSP_jpQd8HOVGp6LhUAgw@mail.gmail.com>
	 <5164B5BD.5050702@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Readonly GDT
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Northup <digitaleric@google.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2013-04-09 at 17:43 -0700, H. Peter Anvin wrote:
> OK, thinking about the GDT here.
> 
> The GDT is quite small -- 256 bytes on i386, 128 bytes on x86-64.  As
> such, we probably don't want to allocate a full page to it for only
> that.  This means that in order to create a readonly mapping we have to
> pack GDTs from different CPUs together in the same pages, *or* we
> tolerate that other things on the same page gets reflected in the same
> mapping.

What about grouping via nodes?

> 
> However, the packing solution has the advantage of reducing address
> space consumption which matters on 32 bits: even on i386 we can easily
> burn a megabyte of address space for 4096 processors, but burning 16
> megabytes starts to hurt.

Having 4096 32 bit processors, you deserve what you get. ;-)

-- Steve

> 
> It would be important to measure the performance impact on task switch,
> though.
