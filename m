Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 10 Jun 2016 01:33:43 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160610013343.bad451f3e132b76ba2458e39@gmail.com>
In-Reply-To: <CAGXu5jLS_NNFYPXgjaHfiF6Bfg4TbzogadOPkdTcxXG8nm7Y2A@mail.gmail.com>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
	<CAGXu5jLS_NNFYPXgjaHfiF6Bfg4TbzogadOPkdTcxXG8nm7Y2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 0/3] Introduce the latent_entropy gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 9 Jun 2016 14:18:08 -0700
Kees Cook <keescook@chromium.org> wrote:

> By the way, as you work on v3, can you also be sure to put your
> patches through scripts/checkpatch.pl? There are a lot of >80
> character lines, and other nits. I'd like to minimize the warnings.

I only split those lines where the split doesn't make the code worse.
I checked it again and I made some changes:
https://github.com/ephox-gcc-plugins/latent_entropy/commit/e8e7c885b49db16903ea5bd4d6318ce1246f85f3

-- 
Emese
