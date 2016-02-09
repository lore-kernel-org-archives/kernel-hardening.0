Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 9 Feb 2016 12:45:54 -0800
From: Andi Kleen <ak@linux.intel.com>
Message-ID: <20160209204554.GD4875@tassilo.jf.intel.com>
References: <1454801964-50385-1-git-send-email-sbauer@eng.utah.edu>
 <1454801964-50385-3-git-send-email-sbauer@eng.utah.edu>
 <56B6E5C6.4090209@nextfour.com>
 <56B6FBE0.9060202@eng.utah.edu>
 <CALCETrW_ingsNEwBKKYbkugt5OsG8K6HUs22ZF+Lxc24iy8tTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW_ingsNEwBKKYbkugt5OsG8K6HUs22ZF+Lxc24iy8tTg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCHv2 2/2] x86: SROP mitigation: implement signal cookies
To: Andy Lutomirski <luto@amacapital.net>
Cc: Scotty Bauer <sbauer@eng.utah.edu>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

> Is this compatible with existing userspace?  CRIU and DOSEMU seem like
> things that are likely to blow up to me.

It should at least make it a sysctl.

> 
> We may need to make this type of mitigation be opt-in.  I'm already
> vaguely planning an opt-in mitigation framework for vsyscall runtime
> disablement, and this could use the same opt-in mechanism.

Generally asking people to rely on frame works that don't exist
is not good review feedback.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
