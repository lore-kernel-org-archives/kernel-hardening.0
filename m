Date: Sun, 25 Feb 2018 18:59:07 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Pull Request for linux-next
Message-ID: <20180225075907.GB9456@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: sfr@canb.auug.org.au
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tycho@tycho.ws, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Stephen,

Would it be possible to get the development tree for
scripts/leaking_addresses.pl included in Linux-next please.

The tree is hosted on kernel.org

https://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git/

I have created a branch called linux-next.  This branch is not tagged or
signed.  I'm super new to kernel maintainer branch management, ATM the
tree mirrors GregKH's staging tree setup i.e 3 branches

	master
	leaks-testing
	leaks-next

Development done on leaks-testing.  Once patches have been rinsed
through LKML move them to leaks-next.  Any holes in that?


thanks,
Tobin.
