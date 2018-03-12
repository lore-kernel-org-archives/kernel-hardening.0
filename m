Date: Mon, 12 Mar 2018 16:44:50 +1100
From: "Tobin C. Harding" <tobin@apporbit.com>
Subject: Re: VLA commit log
Message-ID: <20180312054450.GF8631@eros>
References: <20180312052639.GE8631@eros>
 <861efe7a-e51f-e004-5979-aef0ed9ff1fe@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861efe7a-e51f-e004-5979-aef0ed9ff1fe@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2018 at 12:38:04AM -0500, Gustavo A. R. Silva wrote:
> 
> 
> On 03/12/2018 12:26 AM, Tobin C. Harding wrote:
> >Hi,
> >
> >I got some push back on the commit log we have all started to use
> >(copying Kees' initial commit log).  If we are going to do hundreds of
> >these patches should we write a perfectly correct commit log that can be
> >included as the start of the 'why' of each VLA removal patch?  Here is
> >my attempt, I am quite bad at writing commit logs so would love someone
> >to fix it up.
> >
> 
> The same thing happened to me once and then I wrote this:

I had a feeling this had happened to you but I couldn't find the patch
that made me think that when writing this.

> In preparation to enabling -Wvla, remove VLA and replace it
> with a fixed-length array instead.

---

> From a security viewpoint, the use of Variable Length Arrays can be
> a vector for stack overflow attacks. Also, in general, as the code
> evolves it is easy to lose track of how big a VLA can get. Thus, we
> can end up having segfaults that are hard to debug.
>
> Also, fixed as part of the directive to remove all VLAs from
> the kernel: https://lkml.org/lkml/2018/3/7/621

---

Cool, I like this (between ---).  Kees can you ack this since I'm going
to cut and paste it about 300 times :)

> The maintainer lived happily ever after. :)

lol

> --
> Gustavo

thanks,
Tobin.
