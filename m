Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 8 Nov 2015 10:58:40 +0100
From: David Sterba <dave@jikos.cz>
Message-ID: <20151108095840.GN26112@twin.jikos.cz>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
 <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
 <20151107002508.GA2605@cloud>
 <20151107024612.GC19551@kroah.com>
 <20151107225810.b5f37120449d0957e3e29d72@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151107225810.b5f37120449d0957e3e29d72@gmail.com>
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection
 features
To: kernel-hardening@lists.openwall.com
Cc: Greg KH <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Theodore Tso <tytso@google.com>
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

It would be great if all the plugins can run in a verbose mode and
describe the changes or at least point to the file:line. It should help
to understand and review the resulting assembly code where applicable.
