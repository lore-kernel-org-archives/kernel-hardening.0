Reply-To: kernel-hardening@lists.openwall.com
References: <1450755641-7856-1-git-send-email-laura@labbott.name>
 <1450755641-7856-7-git-send-email-laura@labbott.name>
 <567964F3.2020402@intel.com>
 <alpine.DEB.2.20.1512221023550.2748@east.gentwo.org>
 <567986E7.50107@intel.com>
 <alpine.DEB.2.20.1512221124230.14335@east.gentwo.org>
 <56798851.60906@intel.com>
 <alpine.DEB.2.20.1512221207230.14406@east.gentwo.org>
 <5679943C.1050604@intel.com> <5679A0CB.3060707@labbott.name>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <5679A568.9000604@intel.com>
Date: Tue, 22 Dec 2015 11:32:56 -0800
MIME-Version: 1.0
In-Reply-To: <5679A0CB.3060707@labbott.name>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC][PATCH 6/7] mm: Add Kconfig option for
 slab sanitization
To: Laura Abbott <laura@labbott.name>, Christoph Lameter <cl@linux.com>
Cc: kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 12/22/2015 11:13 AM, Laura Abbott wrote:
>> 3. Zero at free, *don't* Zero at alloc (when __GFP_ZERO)
>>     (what I'm suggesting, possibly less perf impact vs. #2)
> 
> poisoning with non-zero memory makes it easier to determine that the error
> came from accessing the sanitized memory vs. some other case. I don't think
> the feature would be as strong if the memory was only zeroed vs. some other
> data value.

How does that scenario work?  Your patch description says:

> +	  Use-after-free bugs for structures containing
> +	  pointers can also be detected as dereferencing the sanitized pointer
> +	  will generate an access violation.

In the case that we wrote all zeros, we'd be accessing userspace at a
known place that we don't generally allow memory to be mapped anyway.
Could you elaborate on a scenario where zeros are weaker than a random
poison value?

In any case (if a poison value is superior to 0's), it's a balance
between performance vs. the likelihood of the poisoned value being
tripped over.

I think the performance impact of this feature is going to be *the*
major thing that keeps folks from using it in practice.  I'm trying to
suggest a way that you _might_ preserve some performance, and get more
folks to use it.

1. Keep information from leaking (doesn't matter which value we write)
2. Detect use-after-free bugs (0's are less likely to be detected???)
3. Preserve performance (0's are likely to preserve more performance)
