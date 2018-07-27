Date: Fri, 27 Jul 2018 16:53:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Message-ID: <20180727165311.48b33a3f@gandalf.local.home>
In-Reply-To: <20180727202114.GH13922@thunk.org>
References: <753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
	<CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
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
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jann Horn <jannh@google.com>, salyzyn@google.com, Nick Desaulniers <ndesaulniers@google.com>, Golden_Miller83@protonmail.ch, Greg KH <greg@kroah.com>, Kees Cook <keescook@google.com>, salyzyn@android.com, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, kernel-team@android.com, stable@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jeffrey Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 27 Jul 2018 16:21:14 -0400
"Theodore Y. Ts'o" <tytso@mit.edu> wrote:

> On Fri, Jul 27, 2018 at 04:11:03PM -0400, Steven Rostedt wrote:
> > That said, I would assume that
> > other Android utilities are using other debugfs files for system
> > status and such.  
> 
> Yeah, I know we probably have lost the "debugfs is only for debugging
> and has no place in a production system" battle, and we should just
> move on and assume we need to completely harden all of debugfs.  But
> it's worth at least *asking* whether or not the use of debugfs for
> Android can be avoided....

Perhaps we should have a way to disable directories in debugfs at boot?
That way, people can only have what is needed. The reason I created
tracefs, is because I was asked to so that tracing utilities could be
enabled without bringing in all of debugfs itself. But now it appears
there's more there that makes it have to be mounted.

-- Steve
