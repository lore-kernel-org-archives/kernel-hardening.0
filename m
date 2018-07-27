Date: Fri, 27 Jul 2018 16:11:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Message-ID: <20180727161103.797f12b7@gandalf.local.home>
In-Reply-To: <20180727195416.GF13922@thunk.org>
References: <CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
	<20180726181558.25a5c3b8@gandalf.local.home>
	<753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
	<CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
	<20180727094730.3a448629@gandalf.local.home>
	<CAKwvOdmg4DSSwy9YBccYWzc+6ZU2yKSSFmfnj72wqbYDJU0gzw@mail.gmail.com>
	<20180727143141.4b53d554@gandalf.local.home>
	<CAMx4XWv3OazvURuN1XU2+5C5tNDzPuTniMn_T=XTA4P8_uwS_A@mail.gmail.com>
	<CAG48ez25zgjTQRux_rk1fn2DUVthtK31dRU9cxE+55pBGmYjXQ@mail.gmail.com>
	<CAG48ez1MdupASE1DMt0OWXv+rqZO-2GAbfDthEQcvNXrc2pTsQ@mail.gmail.com>
	<20180727195416.GF13922@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jann Horn <jannh@google.com>, salyzyn@google.com, Nick Desaulniers <ndesaulniers@google.com>, Golden_Miller83@protonmail.ch, Greg KH <greg@kroah.com>, Kees Cook <keescook@google.com>, salyzyn@android.com, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, kernel-team@android.com, stable@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jeffrey Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 27 Jul 2018 15:54:16 -0400
"Theodore Y. Ts'o" <tytso@mit.edu> wrote:

> More generally, stupid question, but does Android *really* need to
> have debugfs mounted?  And if so, can we figure out what facilities
> that are needed and can we find some other way of meeting those
> requirements?

I do know that they have applications that use ftrace. But then again,
the ftrace files are under its own tracefs file system (that just
happens to be mounted when debugfs is). That said, I would assume that
other Android utilities are using other debugfs files for system
status and such.

-- Steve
