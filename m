Date: Fri, 13 Apr 2018 20:55:53 -0600
From: David Brown <david.brown@linaro.org>
Subject: Re: [PATCH] x86/xen: Remove use of VLAs
Message-ID: <20180414025553.GA32653@davidb.org>
References: <20180413221146.28476-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20180413221146.28476-1-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 13, 2018 at 03:11:46PM -0700, Laura Abbott wrote:

>There's an ongoing effort to remove VLAs[1] from the kernel to eventually
>turn on -Wvla. The few VLAs in use have an upper bound based on a size
>of 64K. This doesn't produce an excessively large stack so just switch
>the upper bound.
>
>[1] https://lkml.org/lkml/2018/3/7/621

This comment is more in regards to many of these patches, and not as
much this one specifically.

How confident are we in the upper bounds we're setting, and how
obvious is it in the resulting code so that something does later
change to overflow these bounds.

The danger here is that we're converting something a little easier to
detect (a stack overflow), with something harder to detect
(overflowing an array on the stack).

I guess the question is twofold: how did you determine that 64K was
the largest 'size' value, and how should reviewers verify this as
well.  Perhaps this should at least be in the commit text so someone
tracking down something with this code can find it later.

David
