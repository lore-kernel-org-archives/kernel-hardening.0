Reply-To: kernel-hardening@lists.openwall.com
In-Reply-To: <m261ztxp55.fsf@firstfloor.org>
References: <20130410192422.GA17344@www.outflux.net> <20130411083634.GA11824@gmail.com> <m261ztxp55.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 11 Apr 2013 06:03:50 -0700
Message-ID: <5f3869f6-f491-4092-bdc3-40790681f2b1@email.android.com>
Subject: [kernel-hardening] Re: [PATCH v3] x86: use a read-only IDT alias on all CPUs
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Alexander Duyck <alexander.h.duyck@intel.com>, Alex Shi <alex.shi@intel.com>, Jeremy Fitzhardinge <jeremy@goop.org>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@google.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Frederic Weisbecker <fweisbec@gmail.com>, Dan Rosenberg <drosenberg@vsecurity.com>, x86@kernel.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@redhat.com>, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees posted that one too.

Andi Kleen <andi@firstfloor.org> wrote:

>Ingo Molnar <mingo@kernel.org> writes:
>>
>> This looks very nice to me now. Peter, any objections?
>
>it seems pointless without randomized main kernel text location,
>because
>the IDT will be still at a known per kernel fixed writable location in
>the direct mapping.
>
>As long as such randomization is not there it just wastes a TLB entry.
>
>-Andi

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
