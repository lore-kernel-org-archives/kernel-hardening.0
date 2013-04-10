Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5164B5BD.5050702@zytor.com>
Date: Tue, 09 Apr 2013 17:43:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20130408224328.GA17641@www.outflux.net> <51634935.9010905@zytor.com> <alpine.LFD.2.02.1304091122490.21884@ionos> <CAGXu5jKo=11RrsvctcZjP6dusAj659O_GsaA2J2qFq-6mOeRwQ@mail.gmail.com> <51645D6F.7070705@zytor.com> <CAGXu5jKkHKw8efdPOmt-Zi99m+uMKVGKpc_DC72_ztwxnRbRRQ@mail.gmail.com> <51646054.3090509@zytor.com> <CAGXu5jJNG4o+_-kk=A2AfSRwyQE0pgaQh7YpSjnD_fB-s7U+wA@mail.gmail.com> <CAG7+5M3==rndLLak9cZBKKdgQMmJMpSP_jpQd8HOVGp6LhUAgw@mail.gmail.com>
In-Reply-To: <CAG7+5M3==rndLLak9cZBKKdgQMmJMpSP_jpQd8HOVGp6LhUAgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Readonly GDT
To: Eric Northup <digitaleric@google.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

OK, thinking about the GDT here.

The GDT is quite small -- 256 bytes on i386, 128 bytes on x86-64.  As
such, we probably don't want to allocate a full page to it for only
that.  This means that in order to create a readonly mapping we have to
pack GDTs from different CPUs together in the same pages, *or* we
tolerate that other things on the same page gets reflected in the same
mapping.

However, the packing solution has the advantage of reducing address
space consumption which matters on 32 bits: even on i386 we can easily
burn a megabyte of address space for 4096 processors, but burning 16
megabytes starts to hurt.

It would be important to measure the performance impact on task switch,
though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
