Date: Thu, 8 Mar 2018 12:33:33 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 3/3] btrfs: tree-checker: Avoid accidental stack VLA
Message-ID: <20180308113333.GM23693@suse.cz>
References: <1520479847-39174-1-git-send-email-keescook@chromium.org>
 <1520479847-39174-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520479847-39174-4-git-send-email-keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, gustavo@embeddedor.com, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, rostedt@goodmis.org, Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Thomas Gleixner <tglx@linutronix.de>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-hardening@lists.openwall.com, corbet@lwn.net, Ian Abbott <abbotti@mev.co.uk>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Josh Poimboeuf <jpoimboe@redhat.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Petr Mladek <pmladek@suse.com>, Borislav Petkov <bp@suse.de>, "Tobin C. Harding" <me@tobin.cc>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 07, 2018 at 07:30:47PM -0800, Kees Cook wrote:
> In the quest to remove all stack VLAs from the kernel[1], this refactors
> the stack array size calculation to avoid using max(), which makes the
> compiler think the size isn't fixed.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: David Sterba <dsterba@suse.com>

for whatever name you decide for the max macro.
