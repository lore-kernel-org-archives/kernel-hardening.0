Date: Thu, 8 Mar 2018 13:06:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/3] Remove accidental VLA usage
Message-ID: <20180308130633.0d819f44@vmware.local.home>
In-Reply-To: <20180308150236.5tysfbm3xdouii5n@treble>
References: <1520479847-39174-1-git-send-email-keescook@chromium.org>
	<20180308150236.5tysfbm3xdouii5n@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, corbet@lwn.net, gustavo@embeddedor.com, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S. Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, "Tobin C. Harding" <me@tobin.cc>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 8 Mar 2018 09:02:36 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Wed, Mar 07, 2018 at 07:30:44PM -0800, Kees Cook wrote:
> > This series adds SIMPLE_MAX() to be used in places where a stack array
> > is actually fixed, but the compiler still warns about VLA usage due to
> > confusion caused by the safety checks in the max() macro.
> > 
> > I'm sending these via -mm since that's where I've introduced SIMPLE_MAX(),
> > and they should all have no operational differences.  
> 
> What if we instead simplify the max() macro's type checking so that GCC
> can more easily fold the array size constants?  The below patch seems to
> work:

Nice. Have you tried to do a allmodconfig and build on various archs?

Of course pushing it to kernel.org will have the zero day bot do it for
you ;-)

-- Steve
