Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <56798D8F.9090402@labbott.name>
References: <1450755641-7856-1-git-send-email-laura@labbott.name>
	<1450755641-7856-7-git-send-email-laura@labbott.name>
	<CA+rthh-X2jvGpptE72CCbOx2MdkukJSCu621+9ymMJ_pCQ9t+w@mail.gmail.com>
	<56798D8F.9090402@labbott.name>
Date: Tue, 22 Dec 2015 19:37:40 +0100
Message-ID: <CA+rthh_agt=YmHGUvBo_+-psOg06DYySqyvkvNNuPmrCKiBC2w@mail.gmail.com>
From: Mathias Krause <minipli@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC][PATCH 6/7] mm: Add Kconfig option for
 slab sanitization
To: Laura Abbott <laura@labbott.name>
Cc: kernel-hardening@lists.openwall.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 22 December 2015 at 18:51, Laura Abbott <laura@labbott.name> wrote:
>> [snip]
>>
>> Related to this, have you checked that the sanitization doesn't
>> interfere with the various slab handling schemes, namely RCU related
>> specialties? Not all caches are marked SLAB_DESTROY_BY_RCU, some use
>> call_rcu() instead, implicitly relying on the semantics RCU'ed slabs
>> permit, namely allowing a "use-after-free" access to be legitimate
>> within the RCU grace period. Scrubbing the object during that period
>> would break that assumption.
>
>
> I haven't looked into that. I was working off the assumption that
> if the regular SLAB debug poisoning worked so would the sanitization.
> The regular debug poisoning only checks for SLAB_DESTROY_BY_RCU so
> how does that work then?

Maybe it doesn't? ;)

How many systems, do you think, are running with enabled DEBUG_SLAB /
SLUB_DEBUG in production? Not so many, I'd guess. And the ones running
into issues probably just disable DEBUG_SLAB / SLUB_DEBUG.

Btw, SLUB not only looks for SLAB_DESTROY_BY_RCU but also excludes
"call_rcu slabs" via other mechanisms. As SLUB is the default SLAB
allocator for quite some time now, even with enabled SLUB_DEBUG one
wouldn't be able to trigger RCU related sanitization issues.

>> Speaking of RCU, do you have a plan to support RCU'ed slabs as well?
>>
>
> My only plan was to get the base support in. I didn't have a plan to
> support RCU slabs but that's certainly something to be done in the
> future.

"Base support", in my opinion, includes covering the buddy allocator
as well. Otherwise this feature is incomplete.

Regards,
Mathias
