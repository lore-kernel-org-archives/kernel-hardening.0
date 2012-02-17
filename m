Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 16 Feb 2012 19:32:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20120217033252.GB22823@kroah.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217010624.GA6541@outflux.net>
 <20120217014008.GA18763@kroah.com>
 <20120217021109.GC6541@outflux.net>
 <CAEXv5_iRj6zHcKWtV0mgA4i_2u=TB1iQQMYFJAK4r6Ca=pimDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXv5_iRj6zHcKWtV0mgA4i_2u=TB1iQQMYFJAK4r6Ca=pimDA@mail.gmail.com>
Subject: [kernel-hardening] Re: [ubuntu-hardened] Add overflow protection to kref
To: David Windsor <dwindsor@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, pageexec@freemail.hu, Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, spender@grsecurity.net, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2012 at 09:48:38PM -0500, David Windsor wrote:
> <snip>
> 
> >>
> >> I have yet to see a patch, so why are we arguing about this?  :)
> >>
> >> Again, I don't know of any kref overflows that have ever happened, so
> >> trying to "protect" this type of thing, seems odd to me.
> >
> > Well, I think the issue was to protect counting things (which seems to
> > be what PaX was after originally), and that kref seemed like the place
> > to put it. I'll let David take it further.
> >
> 
> Patches are forthcoming that will first introduce overflow protection
> to kref.  Once that's in place, I'll move a few refcount users from
> atomic_t to kref as a reference for other subsystems;

I'd like to see some more users first, as I don't see how the current
users could ever overflow an atomic_t, so any changes to prevent this
will be kind of pointless, right?

So feel free to send all of these changes together.

thanks,

greg k-h
