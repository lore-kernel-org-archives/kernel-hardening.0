Message-ID: <1498575296.1180.0.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 27 Jun 2017 10:54:56 -0400
In-Reply-To: <20170627144948.GD28078@dhcp22.suse.cz>
References: <20170621173201.GA114489@beast>
	 <20170627144948.GD28078@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] binfmt_elf: Use ELF_ET_DYN_BASE only for PIE
To: Michal Hocko <mhocko@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Qualys Security Advisory <qsa@qualys.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter
 Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dmitry Safonov <dsafonov@virtuozzo.com>, Andy Lutomirski <luto@amacapital.net>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-06-27 at 16:49 +0200, Michal Hocko wrote:
> On Wed 21-06-17 10:32:01, Kees Cook wrote:
> > The ELF_ET_DYN_BASE position was originally intended to keep loaders
> > away from ET_EXEC binaries. (For example, running "/lib/ld-
> > linux.so.2
> > /bin/cat" might cause the subsequent load of /bin/cat into where the
> > loader had been loaded.) With the advent of PIE (ET_DYN binaries
> > with
> > an INTERP Program Header), ELF_ET_DYN_BASE continued to be used
> > since
> > the kernel was only looking at ET_DYN. However, since
> > ELF_ET_DYN_BASE
> > is traditionally set at the top 1/3rd of the TASK_SIZE, a
> > substantial
> > portion of the address space is unused.
> > 
> > For 32-bit tasks when RLIMIT_STACK is set to RLIM_INFINITY, programs
> > are loaded below the mmap region. This means they can be made to
> > collide
> > (CVE-2017-1000370) or nearly collide (CVE-2017-1000371) with
> > pathological
> > stack regions. Lowering ELF_ET_DYN_BASE solves both by moving
> > programs
> > above the mmap region in all cases, and will now additionally avoid
> > programs falling back to the mmap region by enforcing MAP_FIXED for
> > program loads (i.e. if it would have collided with the stack, now it
> > will fail to load instead of falling back to the mmap region).
> 
> I do not understand this part. MAP_FIXED will simply unmap whatever
> was under the requested range, how it could help failing anything? So
> what would happen if something was mapped in that region, or is this
> impossible? Moreover MAP_FIXED close to stack will inhibit the stack
> gap
> protection.

I don't think there's a reason to use MAP_FIXED. PaX likely ignores the
address hint with RANDMMAP in that code, which would explain it there.
