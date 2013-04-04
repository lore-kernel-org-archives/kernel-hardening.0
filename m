Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <515DE0C9.3030709@zytor.com>
Date: Thu, 04 Apr 2013 13:21:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1365106055-22939-4-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

I have to admit to being somewhat skeptical toward KASLR with only 8
bits of randomness.  There are at least two potential ways of
dramatically increasing the available randomness:

1. actually compose the kernel of multiple independently relocatable
   pieces (maybe chunk it on 2M boundaries or something.)

2. compile the kernel as one of the memory models which can be executed
   anywhere in the 64-bit address space.  The cost of this would have
   to be quantified, of course.

The latter is particularly something that should be considered for the
LPF JIT, to defend against JIT spray attacks.

	-hpa
