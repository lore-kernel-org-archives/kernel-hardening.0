Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <515F14B6.9090603@zytor.com>
Date: Fri, 05 Apr 2013 11:15:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-2-git-send-email-keescook@chromium.org> <20130405072405.GD26889@gmail.com> <20130405073621.GA27843@gmail.com>
In-Reply-To: <20130405073621.GA27843@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/3] x86: routines to choose random kernel base offset
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/05/2013 12:36 AM, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
>>
>> * Kees Cook <keescook@chromium.org> wrote:
>>
>>> This provides routines for selecting a randomized kernel base offset, 
>>> bounded by e820 details. It tries to use RDRAND and falls back to RDTSC. 
>>> If "noaslr" is on the kernel command line, no offset will be used.
>>
>> Would it make sense to also add three other sources of entropy:
> 
> In any case, would it be possible to also mix these bootup sources of 
> entropy into our regular random pool?
> 
> That would improve random pool entropy on all Linux systems, not just 
> those that choose to enable kernel-base-address randomization.
> 

I think we already do at least some of these, but at this point, for any
non-RDRAND-capable hardware we could almost certainly do better for any
definition of anything at all.

RDRAND is obviously the ultimate solution here.

	-hpa
