Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 10 Apr 2013 11:52:12 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130410095212.GE24443@gmail.com>
References: <20130408224328.GA17641@www.outflux.net>
 <51634935.9010905@zytor.com>
 <alpine.LFD.2.02.1304091122490.21884@ionos>
 <CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com>
 <5164AC44.7030708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5164AC44.7030708@zytor.com>
Subject: Re: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 04/09/2013 11:22 AM, Kees Cook wrote:
> > 
> > Can we create a RO fixed per-cpu area?
> > 
> 
> "Fixed" and "percpu" are mutually exclusive...

There's a fixmap area that holds kmap_atomic() percpu mappings:

        FIX_KMAP_BEGIN, /* reserved pte's for temporary kernel mappings */
        FIX_KMAP_END = FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,

In a similar fashion we could use a per CPU high-mapped read-only alias as well 
(assuming it fits, memory is pretty tight there).

Thanks,

	Ingo
