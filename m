Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 15 Jun 2016 00:31:21 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160615003121.008b63c8152aa60c9c351530@gmail.com>
In-Reply-To: <CAGXu5j+-owKY_q-0Yow+OEsY3srdv0246H3ob-qRC6O3yg-qkg@mail.gmail.com>
References: <20160531013029.4c5db8b570d86527b0b53fe4@gmail.com>
	<20160531013145.612696c12f2ef744af739803@gmail.com>
	<CAGXu5jKuNiAq_Q_x2bTDvuQw2c=Zk9we8N9Fuh59kfFbyUcOBg@mail.gmail.com>
	<20160613234902.cbc2c0ccf90527ede8258843@gmail.com>
	<CAGXu5j+-owKY_q-0Yow+OEsY3srdv0246H3ob-qRC6O3yg-qkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/3] Add the latent_entropy gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 14 Jun 2016 11:27:00 -0700
Kees Cook <keescook@chromium.org> wrote:

> On Mon, Jun 13, 2016 at 2:49 PM, Emese Revfy <re.emese@gmail.com> wrote:
> > On Thu, 9 Jun 2016 14:51:45 -0700
> > Kees Cook <keescook@chromium.org> wrote:
>
> >> > + * gcc plugin to help generate a little bit of entropy from program state,
> >> > + * used throughout the uptime of the kernel
> >>
> >> I think this comment needs a lot of expanding. What are all the ways
> >> that this plugin makes changes to code? Things I think I see are:
> >> pre-filling data variables with randomness, creating a local_entropy
> >> variable (local to what?), mixing stack pointer (into what?), updating
> >> latent_entropy global.
> >
> > I demonstrated the details here:
> > https://github.com/ephox-gcc-plugins/latent_entropy/commit/049acd9f478d47ee6526d8e93ab8cfcc3ff91b13
> 
> That helps, thanks. Can you also mention how __latent_entropy changes
> non-functions? (i.e. initializes them with random data.)
> 
> Also, I think this isn't accurate:
> 
>  * local_entropy ^= get_random_long();
> 
> Looking at the disassembly, it seems that static random values (i.e.
> randomly chosen at gcc runtime) are added, rather than making calls to
> the kernel's get_random_long() function.

The plugin doesn't insert calls to the kernel's get_random_long().
That was just an example (the plugin instrumentation would look like this in the kernel).
I rewrote these calls to a random constant.

-- 
Emese
