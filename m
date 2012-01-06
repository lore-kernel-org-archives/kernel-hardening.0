Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Jan 2012 08:36:35 +0100
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20120106073635.GC14188@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
 <20120105091704.GB3249@elte.hu>
 <CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jJ=D1pKCZ8=1-WGkm0witNEH9Ux01+1BJyZKC_DAX00aA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> On Thu, Jan 5, 2012 at 1:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > * Kees Cook <keescook@chromium.org> wrote:
> >
> >> @@ -1495,6 +1496,15 @@ static struct ctl_table fs_table[] = {
> >>  #endif
> >>  #endif
> >>       {
> >> +             .procname       = "protected_sticky_symlinks",
> >> +             .data           = &protected_sticky_symlinks,
> >> +             .maxlen         = sizeof(int),
> >> +             .mode           = 0644,
> >> +             .proc_handler   = proc_dointvec_minmax,
> >> +             .extra1         = &zero,
> >> +             .extra2         = &one,
> >> +     },
> >
> > Small detail:
> >
> > Might make sense to change the .mode to 0600, to make it 
> > harder for unprivileged attack code to guess whether this 
> > protection (and the resulting audit warning to the 
> > administrator) is enabled on a system or not.
> 
> Sure, I have no problem with that. In addition to this change, 
> what's the best next step for this patch?

Al and Linus's call I guess. Maybe ask Andrew whether he'd put 
it into -mm?

Thanks,

	Ingo
