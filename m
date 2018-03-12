Subject: Re: [PATCH 3.16 56/76] x86/syscall: Sanitize syscall table
 de-references under speculation
References: <lsq.1520823972.93871245@decadent.org.uk>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <2a1d3a0f-6227-39c6-0ed9-a07c22424d67@suse.cz>
Date: Mon, 12 Mar 2018 08:32:12 +0100
MIME-Version: 1.0
In-Reply-To: <lsq.1520823972.93871245@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jinpu Wang <jinpu.wang@profitbricks.com>, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jan Beulich <JBeulich@suse.com>, alan@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, gregkh@linuxfoundation.org, linux-arch@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 03/12/2018, 04:06 AM, Ben Hutchings wrote:
> In 3.16 the x86_32 syscall table lookup is also written in assembly.
> So I've taken Jiri's version and added similar masking in entry_32.S,
> using edx as the temporary.  edx is clobbered by SAVE_REGS and seems
> to be free at this point.

I don't know the state in 3.16, but in 3.12, I had to fix the 32bit
entry on 64bit in arch/x86/ia32/ia32entry.S (ia32_sysenter_target &
others) too.

thanks,
-- 
js
suse labs
