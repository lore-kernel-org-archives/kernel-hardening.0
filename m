Date: Thu, 19 Apr 2018 10:16:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 5/8] rslib: Split rs control struct
In-Reply-To: <CAGXu5j+rckvb94YhdqUhRhuG=RtjN+S9QArAhwVWPj8mbPom+w@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1804191014510.1788@nanos.tec.linutronix.de>
References: <20180328205138.301218351@linutronix.de> <20180328205554.666762229@linutronix.de> <20180404214007.31a5fbc6@bbrezillon> <CAGXu5j+rckvb94YhdqUhRhuG=RtjN+S9QArAhwVWPj8mbPom+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: Boris Brezillon <boris.brezillon@bootlin.com>, LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 18 Apr 2018, Kees Cook wrote:
> On Wed, Apr 4, 2018 at 12:40 PM, Boris Brezillon
> <boris.brezillon@bootlin.com> wrote:
> > Don't know how you want to get these patches merged, but the NAND
> > related changes will conflict with my nand/for-4.17 changes (NAND
> > code base has been moved to drivers/mtd/nand/raw).
> >
> > The rest looks good,
> >
> > Acked-by: Boris Brezillon <boris.brezillon@bootlin.com>
> 
> Hi, just checking in on this series. Thomas, what's your plan for
> merging this? I don't see it in -next yet.

Got distracted. Need to address the review comments and repost.

Thanks,

	tglx
