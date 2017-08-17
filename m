Message-ID: <1502943802.3986.38.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 17 Aug 2017 00:23:22 -0400
In-Reply-To: <20170817033148.ownsmbdzk2vhupme@thunk.org>
References: <20170816231458.2299-1-labbott@redhat.com>
	 <20170816231458.2299-3-labbott@redhat.com>
	 <20170817033148.ownsmbdzk2vhupme@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv3 2/2] extract early boot entropy from the passed cmdline
To: Theodore Ts'o <tytso@mit.edu>, Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-08-16 at 23:31 -0400, Theodore Ts'o wrote:
> On Wed, Aug 16, 2017 at 04:14:58PM -0700, Laura Abbott wrote:
> > From: Daniel Micay <danielmicay@gmail.com>
> > 
> > Existing Android bootloaders usually pass data useful as early
> > entropy
> > on the kernel command-line. It may also be the case on other
> > embedded
> > systems.....
> 
> May I suggest a slight adjustment to the beginning commit description?
> 
>    Feed the boot command-line as to the /dev/random entropy pool
> 
>    Existing Android bootloaders usually pass data which may not be
>    known by an external attacker on the kernel command-line.  It may
>    also be the case on other embedded systems.  Sample command-line
>    from a Google Pixel running CopperheadOS....
> 
> The idea here is to if anything, err on the side of under-promising
> the amount of security we can guarantee that this technique will
> provide.  For example, how hard is it really for an attacker who has
> an APK installed locally to get the device serial number?  Or the OS
> version?  And how much variability is there in the bootloader stages
> in milliseconds?

The serial number is currently accessible to local apps up until Android
7.x so it doesn't have value if the adversary has local access. Access
to it without the READ_PHONE_STATE permission is being removed for apps
targeting Android 8.0 and will presumably be restructed for all apps at
some point in the future:

https://android-developers.googleblog.com/2017/04/changes-to-device-identifiers-in.html

Some bootloader stages vary a bit in time each boot. There's not much
variance or measurement precision so there's only a small amount of
entropy from this. The ones that consistently vary in timing do so
independently from each other so that helps a bit. Also worth noting
that before Android 8.0+, local apps can access the boot times since
it's written to a system property. After Android 8.0+, all that stuff is
inaccessible to them (no permission to get them) since there's a
whitelisting model for system property access.

> I think we should definitely do this.  So this is more of a request to
> be very careful what we promise in the commit description, not an
> objection to the change itself.

I did say 'external attacker' but it could be made clearer. It's
primarily aimed at getting a tiny bit of extra entropy for the kernel
stack canary and other probabilistic exploit mitigations set up in early
boot. On non-x86 archs, i.e. 99.9% of Android devices, the kernel stack
canary remains the same after it's set up in that early boot code.

Android devices almost all have a hardware RNG and Android init blocks
until a fair bit of data is read from it along with restoring entropy
that's regularly saved while running, but unfortunately that's not
available at this point in the boot process.

The kernel could save / restore entropy using pstore (which at least
Nexus / Pixel devices have - not sure about others). I don't know how
early that could feasibly be done. Ideally it would do that combined
with early usage of the hwrng.
