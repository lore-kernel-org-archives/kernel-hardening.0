Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Apr 2016 10:40:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <CAJcbSZED2hmEb9KvFcas6S05rN7vDYy+2tUhKRA6Z36Rj-GBfw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1604271039520.20042@east.gentwo.org>
References: <1461687670-47585-1-git-send-email-thgarnie@google.com> <20160426161743.f831225a4efb3eb04debe402@linux-foundation.org> <CAJcbSZED2hmEb9KvFcas6S05rN7vDYy+2tUhKRA6Z36Rj-GBfw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v4] mm: SLAB freelist randomization
To: Thomas Garnier <thgarnie@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kees Cook <keescook@chromium.org>, Greg Thelen <gthelen@google.com>, Laura Abbott <labbott@fedoraproject.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 26 Apr 2016, Thomas Garnier wrote:

> It was discussed a bit before. The intent is to have a similar feature
> for other kernel heap (I know it is possible for SLUB). That's why I
> think it make sense to have a similar config name used for all
> allocators.

Please use CONFIG_SLAB_FREELIST_RANDOM to signify that it is for all slab
allocators. Not SLAB specific.
