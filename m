Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 5 Apr 2013 09:24:05 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130405072405.GD26889@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365106055-22939-2-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH 1/3] x86: routines to choose random kernel base offset
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> This provides routines for selecting a randomized kernel base offset, 
> bounded by e820 details. It tries to use RDRAND and falls back to RDTSC. 
> If "noaslr" is on the kernel command line, no offset will be used.

Would it make sense to also add three other sources of entropy:

---------

1)

  CMOS_READ(RTC_SECONDS);

The exact second the bootup occured might not be known to the attacker, so 
this could add a bit or two of entropy even in the worst case where the 
attacker has access to precise 'uptime' and system log information and 
there's no NTP active that fudges the offsets.

If the attacker is most restricted, in the sandboxed case, then this could 
add a fair amount of entropy.

2)

Another source of per system entropy would be to simply mix all e820 
entries into the random offset - we already parse them to place the kernel 
image.

The e820 info changes per system type, amount of RAM and devices 
installed.

Especially in a restricted remote environment the attacker might not know 
the hardware details and the e820 map.

3)

A build time random bit. This is essentially per system as well if the 
attacker does not know the precise kernel version, or if the kernel was 
custom built.

---------

In the worst case an attacker can guess all of these bits - but 
statistically it still improves entropy for the general Linux box that 
gets attacked.

Thanks,

	Ingo
