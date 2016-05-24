Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 25 May 2016 01:40:21 +0200
MIME-Version: 1.0
Message-ID: <5744E665.28844.9DDA03D@pageexec.freemail.hu>
In-reply-to: <CAGXu5jJHenHARDZt=51m1XbSStTxpG90Dv=Fpkn79A6pZYtGOw@mail.gmail.com>
References: <20160524001405.3e6abd1d5a63a871cc366cff@gmail.com>, <20160524001529.0e69232eff0b1b5bc566a763@gmail.com>, <CAGXu5jJHenHARDZt=51m1XbSStTxpG90Dv=Fpkn79A6pZYtGOw@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH v1 1/3] Add the latent_entropy gcc plugin
To: Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, bart.vanassche@sandisk.com, "David S. Miller" <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 24 May 2016 at 10:32, Kees Cook wrote:

> On Mon, May 23, 2016 at 3:15 PM, Emese Revfy <re.emese@gmail.com> wrote:
> > This plugin mitigates the problem of the kernel having too little entropy during
> > and after boot for generating crypto keys.
> >
> I'm excited to see this! This looks like it'll help a lot with early
> entropy, which is something that'll be a problem for some
> architectures that are trying to do early randomish things (e.g. the
> heap layout randomization, various canaries, etc).
> 
> Do you have any good examples of a before/after case of early
> randomness being fixed by this?

unfortunately, i don't know of a way to quantify this kind of PRNG as the effective
algorithm is not something simple and well-structured for which we have theories and
tools to analyze already. of course this cuts both ways, an attacker faces the same
barrier of non-analyzability.

what can at most be observed is the state of the latent_entropy global variable after
init across many boots but that'd provide a rather low and useless lower estimate only
(e.g., up to 20 bits for a million reboots, or 30 bits for a billion reboots, etc).

to answer your question, i'd like to believe that there's enough latent entropy in
program state that can be harnessed to (re)seed the entropy pool but we'll probably
never know just how well we are doing it so accounting for it and claiming 'fixed'
will stay in the realm of wishful thinking i'm afraid.

cheers,
 PaX Team
