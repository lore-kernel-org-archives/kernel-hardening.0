Date: Fri, 27 Jul 2018 15:05:43 -0700
From: Sandeep Patil <sspatil@google.com>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Message-ID: <20180727220543.GT190909@sspatil-desktop.mtv.corp.google.com>
References: <CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
 <20180727094730.3a448629@gandalf.local.home>
 <CAKwvOdmg4DSSwy9YBccYWzc+6ZU2yKSSFmfnj72wqbYDJU0gzw@mail.gmail.com>
 <20180727143141.4b53d554@gandalf.local.home>
 <CAMx4XWv3OazvURuN1XU2+5C5tNDzPuTniMn_T=XTA4P8_uwS_A@mail.gmail.com>
 <CAG48ez25zgjTQRux_rk1fn2DUVthtK31dRU9cxE+55pBGmYjXQ@mail.gmail.com>
 <CAG48ez1MdupASE1DMt0OWXv+rqZO-2GAbfDthEQcvNXrc2pTsQ@mail.gmail.com>
 <20180727195416.GF13922@thunk.org>
 <20180727161103.797f12b7@gandalf.local.home>
 <20180727202114.GH13922@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180727202114.GH13922@thunk.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>, Jann Horn <jannh@google.com>, salyzyn@google.com, Nick Desaulniers <ndesaulniers@google.com>, Golden_Miller83@protonmail.ch, Greg KH <greg@kroah.com>, Kees Cook <keescook@google.com>, salyzyn@android.com, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, kernel-team@android.com, stable@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jeffrey Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 27, 2018 at 04:21:14PM -0400, Theodore Y. Ts'o wrote:
> On Fri, Jul 27, 2018 at 04:11:03PM -0400, Steven Rostedt wrote:
> > That said, I would assume that
> > other Android utilities are using other debugfs files for system
> > status and such.

As of today, I think a lot of information in 'bugreports' is read
out of debugfs (including things like binder stats). We do have a plan
to change that.

> 
> Yeah, I know we probably have lost the "debugfs is only for debugging
> and has no place in a production system" battle, and we should just
> move on and assume we need to completely harden all of debugfs.  But
> it's worth at least *asking* whether or not the use of debugfs for
> Android can be avoided....

Indeed, I think it can. However, the problem is the last time I tried to
remove this a whole bunch of things just broke. So, it wasn't about losing
a functionality here and there. Agree, we need to clean up platform to not use
debugfs first. Then we can expect Apps or other native processes to not rely
on debugfs at all.

The work is in progress..[1]

- ssp

1] https://source.android.com/devices/architecture/kernel/modular-kernels#debugfs

> 
> 					- Ted
> 
> -- 
> You received this message because you are subscribed to the Google Groups "kernel-team" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
