Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 8 Nov 2015 09:15:22 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20151108171522.GA29613@kroah.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <20151107002508.GA2605@cloud>
 <20151107024612.GC19551@kroah.com>
 <20151107225810.b5f37120449d0957e3e29d72@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151107225810.b5f37120449d0957e3e29d72@gmail.com>
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Emese Revfy <re.emese@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Theodore Tso <tytso@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 07, 2015 at 10:58:10PM +0100, Emese Revfy wrote:
> > > Could the plugin operate in a mode where it emits warnings to add such
> > > annotations explicitly in the code, rather than just automatically
> > > moving the data?
> > 
> > That would be nice for the constanfy mode as well, especially as some
> > people aren't using gcc to build the kernel anymore, so it would be good
> > to mark these "for real" in the .c code wherever possible to allow other
> > compilers to take advantage of the plugin indirectly.
> 
> Yes, I can do it of course. There can be two kernel config options:
>  * warning (dry run) mode: the plugin just prints out the warnings 
>  * constify: do the constification automatically

That sounds wonderful, I would love to see this happen.

thanks,

greg k-h
