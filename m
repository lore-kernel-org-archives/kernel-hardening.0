MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Jan 2018 17:19:51 -0800
Message-ID: <CA+55aFzNQ8CZ8iNcPXrCfyk=1edMiRGDA0fY0rd87BsFKBxgAw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/19] prevent bounds-check bypass via speculative execution
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan.cox@intel.com>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Solomon Peachy <pizza@shaftnet.org>, "H. Peter Anvin" <hpa@zytor.com>, Christian Lamparter <chunkeey@googlemail.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Linux Media Mailing List <linux-media@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, Kees Cook <keescook@chromium.org>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, qla2xxx-upstream@qlogic.com, Thomas Gleixner <tglx@linutronix.de>, Mauro Carvalho Chehab <mchehab@kernel.org>, Kalle Valo <kvalo@codeaurora.org>, Alan Cox <alan@linux.intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Greg KH <gregkh@linuxfoundation.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Network Development <netdev@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 11, 2018 at 4:46 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> This series incorporates Mark Rutland's latest ARM changes and adds
> the x86 specific implementation of 'ifence_array_ptr'. That ifence
> based approach is provided as an opt-in fallback, but the default
> mitigation, '__array_ptr', uses a 'mask' approach that removes
> conditional branches instructions, and otherwise aims to redirect
> speculation to use a NULL pointer rather than a user controlled value.

Do you have any performance numbers and perhaps example code
generation? Is this noticeable? Are there any microbenchmarks showing
the difference between lfence use and the masking model?

Having both seems good for testing, but wouldn't we want to pick one in the end?

Also, I do think that there is one particular array load that would
seem to be pretty obvious: the system call function pointer array.

Yes, yes, the actual call is now behind a retpoline, but that protects
against a speculative BTB access, it's not obvious that it  protects
against the mispredict of the __NR_syscall_max comparison in
arch/x86/entry/entry_64.S.

The act of fetching code is a kind of read too. And retpoline protects
against BTB stuffing etc, but what if the _actual_ system call
function address is wrong (due to mis-prediction of the system call
index check)?

Should the array access in entry_SYSCALL_64_fastpath be made to use
the masking approach?

                Linus
