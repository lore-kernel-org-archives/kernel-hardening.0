MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+8MBb+H0FqciBw9nSO9L0fNQtiRvc_1TREitH9z89YxhtyFAQ@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzNQ8CZ8iNcPXrCfyk=1edMiRGDA0fY0rd87BsFKBxgAw@mail.gmail.com> <CA+8MBb+H0FqciBw9nSO9L0fNQtiRvc_1TREitH9z89YxhtyFAQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Jan 2018 10:51:53 -0800
Message-ID: <CA+55aFwUspY8DG3hRxZqQaf_n_0OZxGCd=pELc8ZVuBu+058cA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/19] prevent bounds-check bypass via speculative execution
To: Tony Luck <tony.luck@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan.cox@intel.com>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Solomon Peachy <pizza@shaftnet.org>, "H. Peter Anvin" <hpa@zytor.com>, Christian Lamparter <chunkeey@googlemail.com>, Elena Reshetova <elena.reshetova@intel.com>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Linux Media Mailing List <linux-media@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, qla2xxx-upstream@qlogic.com, Thomas Gleixner <tglx@linutronix.de>, Mauro Carvalho Chehab <mchehab@kernel.org>, Kalle Valo <kvalo@codeaurora.org>, Alan Cox <alan@linux.intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Greg KH <gregkh@linuxfoundation.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Network Development <netdev@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 12, 2018 at 4:15 PM, Tony Luck <tony.luck@gmail.com> wrote:
>
> Here there isn't any reason for speculation. The core has the
> value of 'x' in a register and the upper bound encoded into the
> "cmp" instruction.  Both are right there, no waiting, no speculation.

So this is an argument I haven't seen before (although it was brought
up in private long ago), but that is very relevant: the actual scope
and depth of speculation.

Your argument basically depends on just what gets speculated, and on
the _actual_ order of execution.

So your argument depends on "the uarch will actually run the code in
order if there are no events that block the pipeline".

Or at least it depends on a certain latency of the killing of any OoO
execution being low enough that the cache access doesn't even begin.

I realize that that is very much a particular microarchitectural
detail, but it's actually a *big* deal. Do we have a set of rules for
what is not a worry, simply because the speculated accesses get killed
early enough?

Apparently "test a register value against a constant" is good enough,
assuming that register is also needed for the address of the access.

            Linus
