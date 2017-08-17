Date: Thu, 17 Aug 2017 17:44:29 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170817214429.wt7zly2e3bmnlfyp@thunk.org>
References: <20170816231458.2299-1-labbott@redhat.com>
 <20170816231458.2299-3-labbott@redhat.com>
 <20170817033148.ownsmbdzk2vhupme@thunk.org>
 <1502943802.3986.38.camel@gmail.com>
 <1503003427.1514.6.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503003427.1514.6.camel@gmail.com>
Subject: [kernel-hardening] Re: [PATCHv3 2/2] extract early boot entropy from the passed cmdline
To: Daniel Micay <danielmicay@gmail.com>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 17, 2017 at 04:57:07PM -0400, Daniel Micay wrote:
> > I did say 'external attacker' but it could be made clearer.
> 
> Er, s/say/mean to imply/

Right, that's why I had suggested modifying the first few lines of the
commit description to read something like this:

  Feed the boot command-line as to the /dev/random entropy pool

  Existing Android bootloaders usually pass data which may not be known
  by an external attacker on the kernel command-line.  It may also be
  the case on other embedded systems.  Sample command-line from a Google
  Pixel running CopperheadOS:

(Or something like that.)

> I'll look into having the kernel stash some entropy in pstore soon since
> that seems like it could be a great improvement. I'm not sure how often
> / where it should hook into for regularly refreshing it though. Doing it
> only on powering down isn't ideal.

One thing we could do is to agree on a standard place where the
entropy would be stashed, and then have the kernel remove it from
being visible in /proc/cmdline.  That's not a perfect answer, since
the user might be able to look at the command line via other
mechanisms.  (For example, on x86, by looking at GRUB while the system
is booting.)

However, an attacker who is merely running code on the local system is
not likely to be gain access to that value --- so it's definitely an
improvement.

Refreshing the entry immediately after boot, and before a clean
shutdown would be ideal from a security perspective.  I don't know if
there are write endurance issues with updating the pstore that
frequently, though.

						- Ted
