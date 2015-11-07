Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 7 Nov 2015 22:58:10 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20151107225810.b5f37120449d0957e3e29d72@gmail.com>
In-Reply-To: <20151107024612.GC19551@kroah.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
	<20151107002508.GA2605@cloud>
	<20151107024612.GC19551@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Theodore Tso <tytso@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

> > Could the plugin operate in a mode where it emits warnings to add such
> > annotations explicitly in the code, rather than just automatically
> > moving the data?
> 
> That would be nice for the constanfy mode as well, especially as some
> people aren't using gcc to build the kernel anymore, so it would be good
> to mark these "for real" in the .c code wherever possible to allow other
> compilers to take advantage of the plugin indirectly.

Yes, I can do it of course. There can be two kernel config options:
 * warning (dry run) mode: the plugin just prints out the warnings 
 * constify: do the constification automatically

-- 
Emese
