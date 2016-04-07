Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1460045867.2818.67.camel@debian.org>
References: <1459971348-81477-1-git-send-email-thgarnie@google.com>
	<CAGXu5jLEENTFL_NYA5r4SqmUefkEwL68_Br6bX_RY2xNv95GVg@mail.gmail.com>
	<1460045867.2818.67.camel@debian.org>
Date: Thu, 7 Apr 2016 09:35:46 -0700
Message-ID: <CAJcbSZFx4rT6fXKvOF-wgHTSZBgqfQGw0qn=JqwAygNHDVUvNQ@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v1] mm: SLAB freelist randomization
To: Yves-Alexis Perez <corsac@debian.org>
Cc: kernel-hardening@lists.openwall.com, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

That's a use after free. The randomization of the freelist should not
have much effect on that. I was going to quote this exploit that is
applicable to SLAB as well:
https://jon.oberheide.org/blog/2010/09/10/linux-kernel-can-slub-overflow

Regards.
Thomas

On Thu, Apr 7, 2016 at 9:17 AM, Yves-Alexis Perez <corsac@debian.org> wrote:
> On mer., 2016-04-06 at 14:45 -0700, Kees Cook wrote:
>> > This security feature reduces the predictability of
>> > the kernel slab allocator against heap overflows.
>>
>> I would add "... rendering attacks much less stable." And if you can
>> find a specific example exploit that is foiled by this, I would refer
>> to it.
>
> One good example might (or might not) be the keyring issue from earlier this
> year (CVE-2016-0728):
>
> http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-ker
> nel-vulnerability-cve-2016-0728/
>
> Regards,
> --
> Yves-Alexis
>
