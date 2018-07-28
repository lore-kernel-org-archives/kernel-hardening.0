Date: Fri, 27 Jul 2018 20:04:28 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Message-ID: <20180728000428.GI13922@thunk.org>
References: <20180727094730.3a448629@gandalf.local.home>
 <CAKwvOdmg4DSSwy9YBccYWzc+6ZU2yKSSFmfnj72wqbYDJU0gzw@mail.gmail.com>
 <20180727143141.4b53d554@gandalf.local.home>
 <CAMx4XWv3OazvURuN1XU2+5C5tNDzPuTniMn_T=XTA4P8_uwS_A@mail.gmail.com>
 <CAG48ez25zgjTQRux_rk1fn2DUVthtK31dRU9cxE+55pBGmYjXQ@mail.gmail.com>
 <CAG48ez1MdupASE1DMt0OWXv+rqZO-2GAbfDthEQcvNXrc2pTsQ@mail.gmail.com>
 <20180727195416.GF13922@thunk.org>
 <20180727161103.797f12b7@gandalf.local.home>
 <20180727202114.GH13922@thunk.org>
 <20180727220543.GT190909@sspatil-desktop.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180727220543.GT190909@sspatil-desktop.mtv.corp.google.com>
To: Sandeep Patil <sspatil@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jann Horn <jannh@google.com>, salyzyn@google.com, Nick Desaulniers <ndesaulniers@google.com>, Golden_Miller83@protonmail.ch, Greg KH <greg@kroah.com>, Kees Cook <keescook@google.com>, salyzyn@android.com, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, kernel-team@android.com, stable@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jeffrey Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 27, 2018 at 03:05:43PM -0700, Sandeep Patil wrote:
> On Fri, Jul 27, 2018 at 04:21:14PM -0400, Theodore Y. Ts'o wrote:
> > On Fri, Jul 27, 2018 at 04:11:03PM -0400, Steven Rostedt wrote:
> > > That said, I would assume that
> > > other Android utilities are using other debugfs files for system
> > > status and such.
> 
> As of today, I think a lot of information in 'bugreports' is read
> out of debugfs (including things like binder stats). We do have a plan
> to change that.

Hmm, if it's only for bugreports, maybe it can be only mounted when
about root processes getting tricked into reading from debugfs.


> Indeed, I think it can. However, the problem is the last time I tried to
> remove this a whole bunch of things just broke. So, it wasn't about losing
> a functionality here and there. Agree, we need to clean up platform to not use
> debugfs first. Then we can expect Apps or other native processes to not rely
> on debugfs at all.

Is Android controlling access to debugfs files via SELinux?  If so,
then access to debugfs can be gradually cranked down as use cases are
removed.

						- Ted


   	   	       
