Date: Thu, 4 May 2017 09:03:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170504160356.GA16988@kroah.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
 <1493683745.2530.2.camel@redhat.com>
 <CABniQZPEfptcLgBtbd5_GO5n8P6SxxkJMpqTCFazM8RCB4qKZQ@mail.gmail.com>
 <CAGXu5jKqptmWwAgsDNtTRzN-r_JYBtVoNaPbpwN+_stfY4yrQA@mail.gmail.com>
 <CABniQZMoX6h0dQk5Xa_kwnbV5NSVpE3EDAD4+TU9CM4Hx9TjuA@mail.gmail.com>
 <CAGXu5jKpRafmuNaGMEn_N9jrvt2zkysB0TXOWs6pfCsDhYgkeA@mail.gmail.com>
 <CABniQZNYUzDTiEnd5AzJ6rJ=VPvT_ph0RK38sPS+u=BjXVQ+Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABniQZNYUzDTiEnd5AzJ6rJ=VPvT_ph0RK38sPS+u=BjXVQ+Jw@mail.gmail.com>
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Shawn <citypw@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Mathias Krause <minipli@googlemail.com>, Daniel =?utf-8?B?Q2VnaWXFgmth?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 04, 2017 at 10:11:04PM +0800, Shawn wrote:
> That announcement only represented the POV from a group of ppl. From
> my( and other ppl from HardenedLinux) perspective, Linux foundation is
> a commercial company and very good at PR but zero integrity to us.

A slight correction here please.  The LF is a non-profit organization[1]
set up to promote Linux and allow companies who want to see Linux
succeed, get together and do this.  The LF happens to sponsor a few
kernel developers (me and Linus), but they can not tell us what to do at
all.

They also are a place that companies have come together to help with the
state of security in the Linux and Open Source ecosystem, starting CII
which offers grants to anyone who wants to get paid to do security work
(new features, support, audits, etc.)  CII doesn't make any money, it
gives money away!  Of course it does press releases saying what projects
it funds in order to get other projects and people to submit project
proposals to continue this work.  I know of at least 2 new kernel
security projects that recently got funding because of this.

So there is no "integrity" that the LF can, or can not, have when it
comes to anyone here as the LF doesn't actually _do_ anything when it
comes to kernel development (again, other than funding 2 developers
directly).

> They don't respect individuals and the community.

That's a load of crap, really.  The LF has always had a kernel community
developer as a full board member, and sponsors conferences, travel
funding, hardware acquisition, intern programs, and lots of other stuff.
I don't know of any kernel community request that the LF has _not_
funded, do you?

The LF is all about making the whole community work well together, and
that includes both individual developers and companies as this is a
symbiotic relationship (companies use Linux, fund its development,
create new hardware for Linux to run on, etc.)  Without one part of the
group, Linux would not succeed at all, and they know that quite well.

If the LF didn't "individuals and the community", I know I wouldn't be
working for them.

So I don't know why anyone would be "upset" at the LF here, all they
have done is actually fund people to do kernel security work, including
members of the grsecurity team!  How is doing that somehow "bad"?  Do
you want to go back to 2+ years ago when they were not doing this
funding at all?

And does no one remember how things were before there was a LF?  Do you
really want to go back to those days?  Were they somehow better than
things are now?  As someone who remembers those times quite well, I can
assure you that they were not.

Sorry for the digression,

greg k-h

[1] Yes, it's structured as a trade organization, it has to be that way
    from a legal point of view in order for companies to be able to
    help Linux and work together.  Without it, companies would be
    violating anti-trust laws and would not be able to help the
    community out at all.  Think of the LF as the "Milk Advisory Board"
    for Linux.
