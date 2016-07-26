Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2016 21:44:53 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160726214453.GN4541@io.lakedaemon.net>
References: <1469557346-5534-1-git-send-email-william.c.roberts@intel.com>
 <1469557346-5534-2-git-send-email-william.c.roberts@intel.com>
 <20160726200309.GJ4541@io.lakedaemon.net>
 <476DC76E7D1DF2438D32BFADF679FC560125F29C@ORSMSX103.amr.corp.intel.com>
 <20160726205944.GM4541@io.lakedaemon.net>
 <476DC76E7D1DF2438D32BFADF679FC5601260068@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC5601260068@ORSMSX103.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH] [RFC] Introduce mmap randomization
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "keescook@chromium.org" <keescook@chromium.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "nnk@google.com" <nnk@google.com>, "jeffv@google.com" <jeffv@google.com>, "salyzyn@android.com" <salyzyn@android.com>, "dcashman@android.com" <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 26, 2016 at 09:06:30PM +0000, Roberts, William C wrote:
> > From: owner-linux-mm@kvack.org [mailto:owner-linux-mm@kvack.org] On
> > Behalf Of Jason Cooper
> > On Tue, Jul 26, 2016 at 08:13:23PM +0000, Roberts, William C wrote:
> > > > > From: Jason Cooper [mailto:jason@lakedaemon.net] On Tue, Jul 26,
> > > > > 2016 at 11:22:26AM -0700, william.c.roberts@intel.com wrote:
> > > > > > Performance Measurements:
> > > > > > Using strace with -T option and filtering for mmap on the
> > > > > > program ls shows a slowdown of approximate 3.7%
> > > > >
> > > > > I think it would be helpful to show the effect on the resulting object code.
> > > >
> > > > Do you mean the maps of the process? I have some captures for
> > > > whoopsie on my Ubuntu system I can share.
> > 
> > No, I mean changes to mm/mmap.o.
> 
> Sure I can post the objdump of that, do you just want a diff of old vs new?

Well, I'm partial to scripts/objdiff, but bloat-o-meter might be more
familiar to most of the folks who you'll be trying to convince to merge
this.

But that's the least of your worries atm. :-/  I was going to dig into
mmap.c to confirm my suspicions, but Nick answered it for me.
Fragmentation caused by this sort of feature is known to have caused
problems in the past.

I would highly recommend studying those prior use cases and answering
those concerns before progressing too much further.  As I've mentioned
elsewhere, you'll need to quantify the increased difficulty to the
attacker that your patch imposes.  Personally, I would assess that first
to see if it's worth the effort at all.

> > > > One thing I didn't make clear in my commit message is why this
> > > > is good. Right now, if you know An address within in a process,
> > > > you know all offsets done with mmap(). For instance, an offset
> > > > To libX can yield libY by adding/subtracting an offset. This is
> > > > meant to make rops a bit harder, or In general any mapping
> > > > offset mmore difficult to
> > find/guess.
> > 
> > Are you able to quantify how many bits of entropy you're imposing on
> > the attacker?  Is this a chair in the hallway or a significant
> > increase in the chances of crashing the program before finding the
> > desired address?
> 
> I'd likely need to take a small sample of programs and examine them,
> especially considering That as gaps are harder to find, it forces the
> randomization down and randomization can Be directly altered with
> length on mmap(), versus randomize_addr() which didn't have this
> restriction but OOM'd do to fragmented easier.

Right, after the Android feedback from Nick, I think you have a lot of
work on your hands.  Not just in design, but also in developing convincing
arguments derived from real use cases.

thx,

Jason.
