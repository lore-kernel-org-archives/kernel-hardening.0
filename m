Date: Fri, 24 Nov 2017 21:16:59 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171124101659.GE17858@eros>
References: <1511414131.12425.14.camel@gmail.com>
 <20171124055935.GB17858@eros>
 <CAPDLWs8+cXShyCt_AH3WgSnn6-cEgGRjJookfqWZ-Lq1Jt72_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDLWs8+cXShyCt_AH3WgSnn6-cEgGRjJookfqWZ-Lq1Jt72_Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] scripts: leaking_addresses: help screen updates
To: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 24, 2017 at 12:51:34PM +0530, Kaiwan N Billimoria wrote:
> On Fri, Nov 24, 2017 at 11:29 AM, Tobin C. Harding <me@tobin.cc> wrote:
> 
> > Neither of these patches applies to my tree. Are you editing the diff's
> > by hand? I noticed the patches don't end with the version signature, like this:
> >
> > ----
> > 2.7.4
> 
> I cloned your tree from here: https://github.com/tcharding/linux/tree/leaks
> is that right?

If that gets you the tree and the branch then great. I've never done it
that way but hey if it works it works.

> One thing i can think of: i have to copy across the script to a
> cloud-based 32-bit system, work on it there, copy it back to your tree
> on my laptop manually,

That sounds fine. I'd personally work on it locally, `scp` to the remote
host and then run it there.

> then i do the 'git diff -r' and basically
> copy-paste that. Is this causing issues?

There's your problem. I'm no git expert but the format produced by that
command is not able to be applied by `git apply` or `git am`. No doubt
there is a command to apply it but in ten minutes playing around I
couldn't find it.

Patches can easily be generated using

	git format-patch -X

where X is the number of commits to include in the patch. You can then
apply them to using `git am` or `git apply`. You can in this way verify
that your patches apply to the tree/branch of whichever maintainer you
are sending the patch to.

If you try to patch staging with patches that don't apply you get an
automated response saying so, I haven't got that sophisticated yet.

Hope this helps,
Tobin.
