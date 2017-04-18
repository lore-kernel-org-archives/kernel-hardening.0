Date: Tue, 18 Apr 2017 14:40:57 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170418144057.1e9c2103@lxorguk.ukuu.org.uk>
In-Reply-To: <20170417065055.GA21022@kroah.com>
References: <20170417060706.28674-1-matt@nmatt.com>
	<20170417060706.28674-2-matt@nmatt.com>
	<20170417065055.GA21022@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/4] added SECURITY_TIOCSTI_RESTRICT kernel config
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matt Brown <matt@nmatt.com>, jmorris@namei.org, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

> Since tty sessions are usually separated by different users, how would
> they have the same one and yet need something like this?
> 
> Also, why not put this in the tty config section?

The normal attack use case people argue about is a rogue process on the
users machine sitting there waiting until the user has logged in to a
remote machine and is idle and then doing stuff.

Attackers of course don't bother doing that because it's easier to get
the user to run a different ssh client instead.

Alan
