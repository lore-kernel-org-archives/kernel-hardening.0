Date: Mon, 6 Feb 2017 16:30:47 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170206153047.GA14434@kroah.com>
References: <CAEXv5_ivEPDJSaJwmx+oLiUYRZsAa9ZPWH6oWZy-Rkoa3ZHRZg@mail.gmail.com>
 <20170206151341.GA13383@kroah.com>
 <CAEXv5_g4zLSJCrfPWUe85UdyOo1WDGdw2LLXOkcjbf5kf4VnTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXv5_g4zLSJCrfPWUe85UdyOo1WDGdw2LLXOkcjbf5kf4VnTw@mail.gmail.com>
Subject: [kernel-hardening] Re: HARDENED_ATOMIC documentation
To: David Windsor <dwindsor@gmail.com>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 06, 2017 at 10:19:14AM -0500, David Windsor wrote:
> On Mon, Feb 6, 2017 at 10:13 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
>     On Mon, Feb 06, 2017 at 09:55:41AM -0500, David Windsor wrote:
>     > Hi,
>     >
>     > I've put together some preliminary documentation for HARDENED_ATOMIC. 
>     This
>     > will be in addition to the in-tree documentation earlier submitted for
>     review. 
>     > This documentation contains only an API definition and examples. 
>     Justification
>     > and background info for HARDENED_ATOMIC are included in the in-tree
>     > documentation, so I didn't recreate this info in the kernsec.org
>     > documentation.  Thoughts about this?
>     >
>     > You can find this documentation at http://kernsec.org/wiki/index.php/
>     > Kernel_Protections/HARDENED_ATOMIC. 
>     >
>     > Please take a look and let me know your comments.
> 
>     Please just send it as a patch so that we can comment on it, as well as
>     don't send html email because the mailing lists reject it!
> 
> 
> 
> Sorry, I might not have been clear: this is just a request to review the
> documentation I posted on kernsec.org for the HARDENED_ATOMIC portion of KSPP. 
> We're going to use kernsec.org as a place to host additional documentation for
> KSPP and its related sub-projects.  There isn't an in-tree portion of this, so
> I'm not sure what I could submit a patch against.  I probably shouldn't have
> directly CC'ed you on this; my apologies!

Why not put the documentation right into the kernel tree?  That way it
is always up to date with the code (well, hopefully), it will get built
and hosted all over the internet at different sites (including
kernel.org) and is much easier to search and people can modify easier.

And again, you are sending html email which the mailing list rejects so
no one on it is seeing your messages :(

thanks,

greg k-h
