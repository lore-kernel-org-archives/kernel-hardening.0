Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 9 Nov 2015 19:02:24 +0000
From: Jason Cooper <kernel-hardening@lakedaemon.net>
Message-ID: <20151109190224.GD20491@io.lakedaemon.net>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <563F4A78.21151.23C6852D@pageexec.freemail.hu>
 <5640E0DD.6040107@labbott.name>
 <20151109182832.GB20491@io.lakedaemon.net>
 <13041.1447095477@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13041.1447095477@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com
Cc: Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hey Valdis,

On Mon, Nov 09, 2015 at 01:57:57PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 09 Nov 2015 18:28:32 +0000, Jason Cooper said:
> > I had a proposal a while back (can't find atm, sorry) to have the
> > bootloader load the random-seed into RAM ...
> 
> It's *easy* to come up with an API to hand the kernel 64 or 128 bits of
> random to kick things off.
> 
> The *hard* part is finding 64 or so bits of trustable random to hand to
> the kernel....

/var/lib/misc/random-seed has served that role for years, I'm only
advocating loading it earlier in the boot process.  It's *much* harder
to guess the state of random-seed than the dtb or mac address(es)...

thx,

Jason.
