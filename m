Date: Tue, 6 Jun 2017 09:21:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170606072136.GD26873@kroah.com>
References: <20170605153020.953645204@linuxfoundation.org>
 <20170605153021.008595891@linuxfoundation.org>
 <CAGXu5jKQ63WOrPMMCVfvRueV2D=YnXAgUGm7zWU+hBSkVDmVwQ@mail.gmail.com>
 <20170605200652.GB87699@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170605200652.GB87699@gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH 3.18 01/33] Revert
 "stackprotector: Increase the per-task stack canarys random range from 32
 bits to 64 bits on 64-bit platforms"
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, "# 3.4.x" <stable@vger.kernel.org>, Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>, Daniel Micay <danielmicay@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, Rik van Riel <riel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 05, 2017 at 01:06:52PM -0700, Eric Biggers wrote:
> On Mon, Jun 05, 2017 at 12:13:11PM -0700, Kees Cook wrote:
> > On Mon, Jun 5, 2017 at 9:16 AM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 3.18-stable review patch.  If anyone has any objections, please let me know.
> > >
> > > ------------------
> > >
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > >
> > > This reverts commit 609a3e81550b0b4ea87197b0f59455a7bcff975a which is
> > > commit 5ea30e4e58040cfd6434c2f33dc3ea76e2c15b05 upstream.
> > >
> > > It shouldn't have been backported to 3.18, as we do not have
> > > get_random_long() in that kernel tree.
> > 
> > It should be possible to trivially backport
> > ec9ee4acd97c0039a61c0ae4f12705767ae62153 to gain get_random_long().
> > 
> > -Kees
> 
> If that's done it may be a good idea to take
> b1132deac01c2332d234fa821a70022796b79182 as well, which fixed an alignment bug
> in get_random_long().

Good idea for both of these, I'll do that in the next round of releases.

thanks,

greg k-h
