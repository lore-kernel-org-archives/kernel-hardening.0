Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 31 May 2016 00:39:55 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160531003955.032d11cad95c4439328b0128@gmail.com>
In-Reply-To: <CAGXu5jJ4iOHw+9khys3HVKAJH6q4Vu+8aSabycYWUCdK9GonKw@mail.gmail.com>
References: <20160524001405.3e6abd1d5a63a871cc366cff@gmail.com>
	<20160524001529.0e69232eff0b1b5bc566a763@gmail.com>
	<CAGXu5jJHenHARDZt=51m1XbSStTxpG90Dv=Fpkn79A6pZYtGOw@mail.gmail.com>
	<5744E665.28844.9DDA03D@pageexec.freemail.hu>
	<CAGXu5jJ4iOHw+9khys3HVKAJH6q4Vu+8aSabycYWUCdK9GonKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 1/3] Add the latent_entropy gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: PaX Team <pageexec@freemail.hu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 24 May 2016 19:55:17 -0700
Kees Cook <keescook@chromium.org> wrote:
 
> Yeah, answering "how random is this?" is not easy, but that's not what
> I meant. I'm more curious about specific build configs or hardware
> where calling get_random_int() early enough would always produce the
> same value (or the same value across all threads, etc), and in these
> cases, the new entropy should be visible when using the latent entropy
> plugin.

I booted minimal configs (not allnoconfig because it can't boot in qemu)
many times. I couldn't produce same values.

-- 
Emese
