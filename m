Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1381356861.2050.33.camel@joe-AO722>
From: Joe Perches <joe@perches.com>
Date: Wed, 09 Oct 2013 15:14:21 -0700
In-Reply-To: <5255D2FD.6050705@gmail.com>
References: <5255D023.2030907@gmail.com>
	 <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3] vsprintf: Check real user/group id for %pK
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com, Dan Rosenberg <dan.j.rosenberg@gmail.com>, Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, George Spelvin <linux@horizon.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2013-10-10 at 09:04 +1100, Ryan Mallon wrote:
> On 10/10/13 09:00, Joe Perches wrote:
[]
> > Move the interrupt tests and pK-error printk
> > into case 1:
> > 
> > It's the only case where CAP_SYSLOG needs to be
> > tested so it doesn't need to be above the switch.
> 
> Like I said, I think it is useful to do the pK-error check anyway. It is
> checking for internal kernel bugs, since if 'pK-error' ever gets
> printed, then some kernel code is doing the wrong thing.

I think you don't quite understand how kptr_restrict works.

If it's 0, then the ptr value is always emitted naturally.
if it's 2, then the ptr value is always emitted as 0.

> Therefore, I
> think it is useful to print it always (I would argue it even makes sense
> when kptr_restrict=0).

How?  Maybe it's me that doesn't quite understand.
