Reply-To: kernel-hardening@lists.openwall.com
From: Andi Kleen <andi@firstfloor.org>
References: <20130410192422.GA17344@www.outflux.net>
	<20130411083634.GA11824@gmail.com>
Date: Thu, 11 Apr 2013 04:50:14 -0700
In-Reply-To: <20130411083634.GA11824@gmail.com> (Ingo Molnar's message of
	"Thu, 11 Apr 2013 10:36:34 +0200")
Message-ID: <m261ztxp55.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH v3] x86: use a read-only IDT alias on all CPUs
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Alexander Duyck <alexander.h.duyck@intel.com>, Alex Shi <alex.shi@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@google.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Frederic Weisbecker <fweisbec@gmail.com>, Dan Rosenberg <drosenberg@vsecurity.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
List-ID: <kernel-hardening.lists.openwall.com>

Ingo Molnar <mingo@kernel.org> writes:
>
> This looks very nice to me now. Peter, any objections?

it seems pointless without randomized main kernel text location, because
the IDT will be still at a known per kernel fixed writable location in
the direct mapping.

As long as such randomization is not there it just wastes a TLB entry.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
