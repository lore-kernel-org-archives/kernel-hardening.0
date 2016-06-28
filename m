Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 13:42:37 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160628134237.910997b2430dfdf4c55b05ee@gmail.com>
In-Reply-To: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc plugin
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 28 Jun 2016 13:34:07 +0200
Emese Revfy <re.emese@gmail.com> wrote:

>  * automatically discover init/exit functions and apply the __init or
>    __exit attributes on them

Hi,

I have a question about this. If a function is called by __init and __exit functions as well then
I move it to the __exit section. I think this is correct because such a function is available to
both __init and __exit functions as well at runtime.
However this generates a section mismatch (from scripts/mod/modpost.c) e.g.,

   WARNING: vmlinux.o(.init.text+0x196849): Section mismatch in reference from the function sctp_init() to the function .exit.text:sctp_v4_del_protocol()
   The function __init sctp_init() references
   a function __exit sctp_v4_del_protocol().
   This is often seen when error handling in the init function
   uses functionality in the exit path.
   The fix is often to remove the __exit annotation of
   sctp_v4_del_protocol() so it may be used outside an exit section.

This check was introduced by this commit (588ccd732ba2d):
kbuild: add verbose option to Section mismatch reporting in modpost

If this move doesn't cause a problem then I would like to keep it because there are a lot of functions that can become __exit and I would like to remove this warning.

Thanks
-- 
Emese
