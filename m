Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2016 20:59:44 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160726205944.GM4541@io.lakedaemon.net>
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
 <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
 <20160726200309.GJ4541@io.lakedaemon.net>
 <476DC76E7D1DF2438D32BFADF679FC560125F29C@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC560125F29C@ORSMSX103.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH] [RFC] Introduce mmap randomization
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "keescook@chromium.org" <keescook@chromium.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "nnk@google.com" <nnk@google.com>, "jeffv@google.com" <jeffv@google.com>, "salyzyn@android.com" <salyzyn@android.com>, "dcashman@android.com" <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi William,

On Tue, Jul 26, 2016 at 08:13:23PM +0000, Roberts, William C wrote:
> > > From: Jason Cooper [mailto:jason@lakedaemon.net]
> > > On Tue, Jul 26, 2016 at 11:22:26AM -0700, william.c.roberts@intel.com wrote:
> > > > Performance Measurements:
> > > > Using strace with -T option and filtering for mmap on the program ls
> > > > shows a slowdown of approximate 3.7%
> > >
> > > I think it would be helpful to show the effect on the resulting object code.
> > 
> > Do you mean the maps of the process? I have some captures for whoopsie on my
> > Ubuntu system I can share.

No, I mean changes to mm/mmap.o.

> > One thing I didn't make clear in my commit message is why this is good. Right
> > now, if you know An address within in a process, you know all offsets done with
> > mmap(). For instance, an offset To libX can yield libY by adding/subtracting an
> > offset. This is meant to make rops a bit harder, or In general any mapping offset
> > mmore difficult to find/guess.

Are you able to quantify how many bits of entropy you're imposing on the
attacker?  Is this a chair in the hallway or a significant increase in
the chances of crashing the program before finding the desired address?

thx,

Jason.
