Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5165AF30.909@zytor.com>
Date: Wed, 10 Apr 2013 11:28:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20130408224328.GA17641@www.outflux.net> <51634935.9010905@zytor.com> <alpine.LFD.2.02.1304091122490.21884@ionos> <CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com> <51645D6F.7070705@zytor.com> <CAGXu5jKkHKw8efdPOmt-Zi99m+uMKVGKpc_DC72_ztwxnRbRRQ@mail.gmail.com> <51646054.3090509@zytor.com> <CAGXu5jJNG4o+_-kk=A2AfSRwyQE0pgaQh7YpSjnD_fB-s7U+wA@mail.gmail.com> <CAG7+5M3==rndLLak9cZBKKdgQMmJMpSP_jpQd8HOVGp6LhUAgw@mail.gmail.com> <5164B5BD.5050702@zytor.com> <5165502902000078000CC022@nat28.tlf.novell.com>
In-Reply-To: <5165502902000078000CC022@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [Xen-devel] Readonly GDT
To: Jan Beulich <JBeulich@suse.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Alex Shi <alex.shi@intel.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Frederic Weisbecker <fweisbec@gmail.com>, Dan Rosenberg <drosenberg@vsecurity.com>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>, Steven Rostedt <rostedt@goodmis.org>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/10/2013 02:42 AM, Jan Beulich wrote:
> 
>> However, the packing solution has the advantage of reducing address
>> space consumption which matters on 32 bits: even on i386 we can easily
>> burn a megabyte of address space for 4096 processors, but burning 16
>> megabytes starts to hurt.
> 
> Packing would have the additional benefit of Xen not needing to
> become a special case in yet another area (because pages
> containing live descriptor table entries need to be read-only for
> PV guests, and need to consist of only descriptor table entries).
> 

OK, so on 64 bits this sounds like a win all around, whereas it is not
feasible on 32 bits (which means we don't really need to worry about
burning address space.)

So, anyone interested in implementing this for 64 bits?

	-hpa
