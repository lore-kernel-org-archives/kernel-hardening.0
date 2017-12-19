Date: Mon, 18 Dec 2017 22:37:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171218223738.49e563c0@vmware.local.home>
In-Reply-To: <20171219030011.GH19604@eros>
References: <1513554812-13014-1-git-send-email-me@tobin.cc>
	<1513554812-13014-4-git-send-email-me@tobin.cc>
	<20171218114947.2c11211a@gandalf.local.home>
	<20171218211614.GC19604@eros>
	<20171218185143.4046a71b@gandalf.local.home>
	<20171219030011.GH19604@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] trace: print address if symbol not found
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 19 Dec 2017 14:00:11 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> I ran through these as outlined here for the new version (v4). This hits
> the modified code but doesn't test symbol look up failure.

stacktrace shouldn't post non kernel values, unless there's a frame
pointer that isn't handled by kallsyms.

As for the other two, we could probably force a failure, like:

 # echo 'hist:keys=hrtimer.sym' > \
     events/timer/hrtimer_start/trigger
 # cat events/timer/hrtimer_start/hist

And then just add sym-offset too.

> 
> I also configured kernel with 'Perform a startup test on ftrace' for
> good luck.
> 
> Are you happy with this level of testing?

Can you try the above.

-- Steve
