Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 Jan 2017 11:30:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170118103031.GB15169@kroah.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] Re: [RFCv2 PATCH 00/18] refcount_t API + usage
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 11:11:29AM +0200, Elena Reshetova wrote:
> Changes since v1:
>  - kref INIT fixes are moved to a proper separate commit
>  - Peter's commits are now properly integrated into series 
>  - various small fixes are incorporated based on testing
>    results and feedback
> 
> This patch series is build on top of Peter's Zijlstra patches
> that provide refcount_t type and API definition.
> The rest of patches convert various places of kernel subsystems
> where atomic_t was used for reference counting to new refcount_t type and API.
> By doing this, we make sure that underflows and overflows
> cannot occur in these places and therefore no use-after-free situation
> can be created and misused by an attacker.

Your first 7 patches are fine, and most of them are already in the tip
tree and getting use in linux-next now.  I'd recommend submitting the
remaining one(s?) that are not there yet to be included, that will get
refcount_t into 4.11-rc1.

Then comes the real work :)

You will need to break up the remaining patches into "one-per-type" and
start submitting them to the various submaintainers for inclusion.  You
can do that once 4.11-rc1 is out.  That's going to be a lot of different
patches, and your patch-maintaince skills are going to be tested here...

With those submissions, lots of them will start to trickly into
linux-next and start to show up in 4.12-rc1.  You'll then need to
refresh your patchset, drop the ones that were accepted, and do it all
over again.  If some maintainers are just ignoring you, you'll have to
go through some other tree for them (I can take the driver ones through
my driver tree.)

It's going to be work, but is totally doable.  I recommend setting up a
separate git or quilt tree that can get included into linux-next and
kbuild for testing and refreshing as the patches start to flow upstream.

Kernel development isn't always a lot of coding, it's primarily dealing
with stuff like this, welcome to the club :)

hope this helps,

greg k-h
