Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 25 Apr 2016 14:38:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20160425143850.b767ca9602fc1be9e13462a5@linux-foundation.org>
In-Reply-To: <CAJcbSZGCywmo_hUCE1DAcPjr0FHcMm0ewAVkCH9jRecmJZBtZQ@mail.gmail.com>
References: <1461616763-60246-1-git-send-email-thgarnie@google.com>
	<20160425141046.d14466272ea246dd0374ea43@linux-foundation.org>
	<CAJcbSZG4wcW=nKSjuzyZpkvTSwYn1eyAok0QtXsgDLyjARz=ig@mail.gmail.com>
	<CAJcbSZGCywmo_hUCE1DAcPjr0FHcMm0ewAVkCH9jRecmJZBtZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] mm: SLAB freelist randomization
To: Thomas Garnier <thgarnie@google.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kees Cook <keescook@chromium.org>, Greg Thelen <gthelen@google.com>, Laura Abbott <labbott@fedoraproject.org>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 25 Apr 2016 14:14:33 -0700 Thomas Garnier <thgarnie@google.com> wrote:

> >>> +     /* Get best entropy at this stage */
> >>> +     get_random_bytes_arch(&seed, sizeof(seed));
> >>
> >> See concerns in other email - isn't this a no-op if CONFIG_ARCH_RANDOM=n?
> >>
> 
> The arch_* functions will return 0 which will break the loop in
> get_random_bytes_arch and make it uses extract_entropy (as does
> get_random_bytes).
> (cf http://lxr.free-electrons.com/source/drivers/char/random.c#L1335)
> 

oop, sorry, I misread the code.

(and the get_random_bytes_arch() comment "This function will use the
architecture-specific hardware random number generator if it is
available" is misleading, so there)
