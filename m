Date: Wed, 16 Aug 2017 23:31:48 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170817033148.ownsmbdzk2vhupme@thunk.org>
References: <20170816231458.2299-1-labbott@redhat.com>
 <20170816231458.2299-3-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170816231458.2299-3-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCHv3 2/2] extract early boot entropy from the passed cmdline
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 16, 2017 at 04:14:58PM -0700, Laura Abbott wrote:
> From: Daniel Micay <danielmicay@gmail.com>
> 
> Existing Android bootloaders usually pass data useful as early entropy
> on the kernel command-line. It may also be the case on other embedded
> systems.....

May I suggest a slight adjustment to the beginning commit description?

   Feed the boot command-line as to the /dev/random entropy pool

   Existing Android bootloaders usually pass data which may not be
   known by an external attacker on the kernel command-line.  It may
   also be the case on other embedded systems.  Sample command-line
   from a Google Pixel running CopperheadOS....

The idea here is to if anything, err on the side of under-promising
the amount of security we can guarantee that this technique will
provide.  For example, how hard is it really for an attacker who has
an APK installed locally to get the device serial number?  Or the OS
version?  And how much variability is there in the bootloader stages
in milliseconds?

I think we should definitely do this.  So this is more of a request to
be very careful what we promise in the commit description, not an
objection to the change itself.

Cheers,

					- Ted
