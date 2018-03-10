Date: Fri, 9 Mar 2018 22:22:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3] tracing: Rewrite filter logic to be simpler and
 faster
Message-ID: <20180309222238.6761728e@vmware.local.home>
In-Reply-To: <20180309221523.1fce7118@vmware.local.home>
References: <20180309200536.GA5670@beast>
	<20180309160719.154a3158e2d8ee56e43a918f@linux-foundation.org>
	<CA+55aFw9hWz1-YFVoHEiXDjqb9q7dz=rQVXr7YLkMuVLvbwaOg@mail.gmail.com>
	<20180309163241.a421e216999bd0b1f43a64c2@linux-foundation.org>
	<CA+55aFwbO2vUsjWzAwB6SZ65RM4r3P0+2JvyMHn=ry0CgWCBgA@mail.gmail.com>
	<CAGXu5j+D=zs8AMb969dhH05GmKPuBxKPcAs89KfKzVf47faL1g@mail.gmail.com>
	<CAGXu5j+4_2vZF9uPy_agcGymbHbVqohSqApKZZxwcTz4OC_Skg@mail.gmail.com>
	<20180310023907.798690563@goodmis.org>
	<20180309221019.31c896a3@vmware.local.home>
	<20180309221523.1fce7118@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, "Tobin C. Harding" <me@tobin.cc>, Jonathan Corbet <corbet@lwn.net>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, "David S.
 Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 9 Mar 2018 22:15:23 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Sorry for the spam.

A little more spam ;-)

I know what happened, as I'm able to recreate it. For those that use
claws-mail, be careful.

I clicked on the email I wanted to reply to. Then I must have hit the
down arrow key, as it moved the selected email to the next email. I hit
"Reply All", and it showed the email I clicked on (as well as the
subject), but the Cc list belonged to the email that was selected by the
down arrow key.

That's a nasty subtle bug. I think I'll go report this to the claws
folks.

-- Steve
