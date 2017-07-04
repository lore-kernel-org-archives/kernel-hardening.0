Date: Tue, 4 Jul 2017 15:12:26 +0200
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20170704131225.GQ14722@dhcp22.suse.cz>
References: <20170621173201.GA114489@beast>
 <20170627144948.GD28078@dhcp22.suse.cz>
 <CAGXu5jKaGjuq6s8XF+mctaL1Ckr2HtKgCnty2p6rUFQSmc-xHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKaGjuq6s8XF+mctaL1Ckr2HtKgCnty2p6rUFQSmc-xHQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2] binfmt_elf: Use ELF_ET_DYN_BASE only for PIE
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Dmitry Safonov <dsafonov@virtuozzo.com>, Andy Lutomirski <luto@amacapital.net>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

[Sorry for a late reply]

On Tue 27-06-17 13:08:39, Kees Cook wrote:
> On Tue, Jun 27, 2017 at 7:49 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Wed 21-06-17 10:32:01, Kees Cook wrote:
> >> The ELF_ET_DYN_BASE position was originally intended to keep loaders
> >> away from ET_EXEC binaries. (For example, running "/lib/ld-linux.so.2
> >> /bin/cat" might cause the subsequent load of /bin/cat into where the
> >> loader had been loaded.) With the advent of PIE (ET_DYN binaries with
> >> an INTERP Program Header), ELF_ET_DYN_BASE continued to be used since
> >> the kernel was only looking at ET_DYN. However, since ELF_ET_DYN_BASE
> >> is traditionally set at the top 1/3rd of the TASK_SIZE, a substantial
> >> portion of the address space is unused.
> >>
> >> For 32-bit tasks when RLIMIT_STACK is set to RLIM_INFINITY, programs
> >> are loaded below the mmap region. This means they can be made to collide
> >> (CVE-2017-1000370) or nearly collide (CVE-2017-1000371) with pathological
> >> stack regions. Lowering ELF_ET_DYN_BASE solves both by moving programs
> >> above the mmap region in all cases, and will now additionally avoid
> >> programs falling back to the mmap region by enforcing MAP_FIXED for
> >> program loads (i.e. if it would have collided with the stack, now it
> >> will fail to load instead of falling back to the mmap region).
> >
> > I do not understand this part. MAP_FIXED will simply unmap whatever
> > was under the requested range, how it could help failing anything? So
> > what would happen if something was mapped in that region, or is this
> > impossible? Moreover MAP_FIXED close to stack will inhibit the stack gap
> > protection.
> 
> Hmm, well, that's my misunderstanding. Regardless, it should still use
> MAP_FIXED otherwise we end up with potentially unpredictable results.

Why that matters? The base is random, right? This is quite early in
the initialization so the address space should be pretty empty at this
stage.

> (Note that MAP_FIXED is already used all all remaining allocations, it
> was just missing on the first one.)

OK, so what happens when there was an existing mapping at the requested
address and we just punched it off? Will things work properly?
I can see some MAP_FIXED users in load_elf_binary but the function is
simply unparsable for me, unfortunatelly.
-- 
Michal Hocko
SUSE Labs
