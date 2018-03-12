Date: Sun, 11 Mar 2018 22:02:04 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] rbd: Remove VLA stack usage
Message-ID: <20180312050204.GC25480@zzz.localdomain>
References: <1520830180-25452-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520830180-25452-1-git-send-email-me@tobin.cc>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>, Alex Elder <elder@kernel.org>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 03:49:40PM +1100, Tobin C. Harding wrote:
> The kernel would like to have all stack VLA usage removed[1].

Can you please stop writing this?  The Linux kernel isn't sentient; it doesn't
"like" anything.  You need to explain why *you* (and other people) believe these
changes should be made.

Eric
