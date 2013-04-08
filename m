Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <516348F6.1080902@zytor.com>
Date: Mon, 08 Apr 2013 15:47:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20130408224328.GA17641@www.outflux.net>
In-Reply-To: <20130408224328.GA17641@www.outflux.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] x86: make IDT read-only
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>, Borislav Petkov <borislav.petkov@amd.com>, Alexander Duyck <alexander.h.duyck@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org, kernel-hardening@lists.openwall.com, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Eric Northup <digitaleric@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/08/2013 03:43 PM, Kees Cook wrote:
> This makes the IDT unconditionally read-only. This primarily removes
> the IDT from being a target for arbitrary memory write attacks. It has
> an added benefit of also not leaking (via the "sidt" instruction) the
> kernel base offset, if it has been relocated.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Eric Northup <digitaleric@google.com>

This isn't quite what this patch does, though, right?  There is still a
writable IDT mapping at all times, which is different from a true
readonly IDT, no?

	-hpa
