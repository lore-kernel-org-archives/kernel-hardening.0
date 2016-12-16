Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Fri, 16 Dec 2016 23:17:04 +0100
MIME-Version: 1.0
Message-ID: <585467E0.27237.2C09B8C1@pageexec.freemail.hu>
In-reply-to: <20161216210659.GA85702@beast>
References: <20161216210659.GA85702@beast>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] latent_entropy: fix ARM build error on earlier gcc
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 16 Dec 2016 at 13:06, Kees Cook wrote:

> This fixes build errors seen on gcc-4.9.3 or gcc-5.3.1 for an ARM:
> 
> arm-soc/init/initramfs.c: In function 'error':
> arm-soc/init/initramfs.c:50:1: error: unrecognizable insn:
>  }
>  ^
> (insn 26 25 27 5 (set (reg:SI 111 [ local_entropy.243 ])
>         (rotatert:SI (reg:SI 116 [ local_entropy.243 ])
>             (const_int -30 [0xffffffffffffffe2]))) -1
>      (nil))
> 
> Patch from PaX Team <pageexec@freemail.hu>
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Brad Spengler <spender@grsecurity.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Cc: stable@vger.kernel.org perhaps?
