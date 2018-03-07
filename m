Date: Wed, 7 Mar 2018 07:06:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 stable-4.4] x86/syscall: Sanitize syscall table
 de-references under speculation fix
Message-ID: <20180307150629.GI4109@kroah.com>
References: <0020b336-3cc4-a4b6-ef22-6def428a5e79@suse.cz>
 <20180307075623.12336-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307075623.12336-1-jslaby@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, alan@linux.intel.com, Jinpu Wang <jinpu.wang@profitbricks.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 07, 2018 at 08:56:23AM +0100, Jiri Slaby wrote:
> In 4.4.118, we have commit c8961332d6da (x86/syscall: Sanitize syscall
> table de-references under speculation), which is a backport of upstream
> commit 2fbd7af5af86. But it fixed only the C part of the upstream patch
> -- the IA32 sysentry. So it ommitted completely the assembly part -- the
> 64bit sysentry.
> 
> Fix that in this patch by explicit array_index_mask_nospec written in
> assembly. The same was used in lib/getuser.S.

<snip>

Thanks for the patch, now queued up.

greg k-h
