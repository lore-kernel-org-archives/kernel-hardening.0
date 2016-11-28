Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 28 Nov 2016 18:18:31 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
Message-ID: <20161128091830.GB23034@linaro.org>
References: <95e7fd98-c477-0c8a-7195-932e04bba9bb@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95e7fd98-c477-0c8a-7195-932e04bba9bb@fau.de>
Subject: [kernel-hardening] Re: [PATCH v3] module: extend 'rodata=off' boot cmdline parameter to
 module mappings
To: Andreas Ziegler <andreas.ziegler@fau.de>, Rusty Russell <rusty@rustcorp.com.au>, Jessica Yu <jeyu@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 28, 2016 at 08:59:40AM +0100, Andreas Ziegler wrote:
> Hi Akashi,
> 
> your patch "module: extend 'rodata=off' boot cmdline parameter to module
> mappings" showed up in linux-next today, and I noticed a small error in it.
> 
> The first modified #ifdef is fine, the second one, however, has a spelling
> mistake in it: the CONFIG_ variable should be CONFIG_DEBUG_SET_MODULE_RONX
> instead of CONFIG_SET_MODULE_RONX (note the missing DEBUG).

Thank you for pointing this out.
(I didn't notice it because DEBUG_RODATA is always on on arm64.)

Rusty, Jessica, should I submit v4 to correct it?

-Takahiro AKASHI

> I noticed it by running 'scripts/checkkconfigsymbols -f --force -f
> next-20161124..next-20161128', which is essentialy diffing the last two
> linux-next releases and looks for undefined/unknown Kconfig symbols.
> You can also run the script on single commits with -c to test them.
> 
> Best regards,
> 
> Andreas
