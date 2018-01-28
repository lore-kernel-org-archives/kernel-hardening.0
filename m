Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 10:29:14 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128092914.dabnzq7arv4bebhn@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703975137.26578.11230688940391207602.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151703975137.26578.11230688940391207602.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 07/12] x86: remove the syscall_64 fast-path
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


* Dan Williams <dan.j.williams@intel.com> wrote:

> Quoting Linus:
> 
>   "Honestly, I'd rather get rid of the fast-path entirely. Compared to
>    all the PTI mess, it's not even noticeable.
> 
>    And if we ever get CPU's that have this all fixed, we can re-visit
>    introducing the fastpath. But this is all very messy and it doesn't
>    seem worth it right now.
> 
>    If we get rid of the fastpath, we can lay out the slow path slightly
>    better, and get rid of some of those jump-overs. And we'd get rid of
>    the ptregs hooks entirely.
> 
>    So we can try to make the "slow" path better while at it, but I
>    really don't think it matters much now in the post-PTI era. Sadly."

Please fix the title to have the proper prefix and to reference the function that 
is actually modified by the patch, i.e. something like:

s/ x86: remove the syscall_64 fast-path
 / x86/entry/64: Remove the entry_SYSCALL_64() fast-path

With the title fixed:

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
