Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 9 Jun 2016 14:18:08 -0700
Message-ID: <CAGXu5jLS_NNFYPXgjaHfiF6Bfg4TbzogadOPkdTcxXG8nm7Y2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 0/3] Introduce the latent_entropy gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 30, 2016 at 4:30 PM, Emese Revfy <re.emese@gmail.com> wrote:
> I would like to introduce the latent_entropy gcc plugin. This plugin mitigates
> the problem of the kernel having too little entropy during and after boot
> for generating crypto keys.
>
> This plugin mixes random values into the latent_entropy global variable
> in functions marked by the __latent_entropy attribute.
> The value of this global variable is added to the kernel entropy pool
> to increase the entropy.
>
> It is a CII project supported by the Linux Foundation.
>
> The latent_entropy plugin was ported from grsecurity/PaX originally written by
> the PaX Team. You can find more about the plugin here:
> https://grsecurity.net/pipermail/grsecurity/2012-July/001093.html
>
> The plugin supports all gcc version from 4.5 to 6.0.
>
> I do some changes above the PaX version. The important one is mixing
> the stack pointer into the global variable too.
> You can find more about the changes here:
> https://github.com/ephox-gcc-plugins/latent_entropy
>
> This patch set is based on the "Introduce GCC plugin infrastructure" patch set (v9 next-20160520).
>
> Emese Revfy (3):
>  Add the latent_entropy gcc plugin
>  Mark functions with the latent_entropy attribute
>  Add the extra_latent_entropy kernel parameter
>
>
> Changes from v1:
>   * Remove unnecessary ifdefs
>     (Suggested-by: Kees Cook <keescook@chromium.org>)
>   * Separate the two definitions of add_latent_entropy()
>     (Suggested-by: Kees Cook <keescook@chromium.org>)
>   * Removed unnecessary global variable (latent_entropy_plugin.c)
>   * About the latent_entropy gcc attribute (latent_entropy_plugin.c)
>   * Measure the boot time performance impact of the latent_entropy plugin (arch/Kconfig)

By the way, as you work on v3, can you also be sure to put your
patches through scripts/checkpatch.pl? There are a lot of >80
character lines, and other nits. I'd like to minimize the warnings.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
